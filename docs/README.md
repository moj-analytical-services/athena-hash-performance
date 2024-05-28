# Composite primary keys - To hash or not to hash?

> [!NOTE]  
> Work in Progress

I've always assumed that hashing improves the performance of queries which joins or windows on multiple columns.

Following this [conversation](https://www.linkedin.com/feed/update/urn:li:activity:7194671376593571843?commentUrn=urn%3Ali%3Acomment%3A%28activity%3A7194671376593571843%2C7194744468422467586%29&dashCommentUrn=urn%3Ali%3Afsd_comment%3A%287194744468422467586%2Curn%3Ali%3Aactivity%3A7194671376593571843%29) with [Toby Mao](https://github.com/tobymao), I wanted to investigate the impact of hashing when using [Athena](https://aws.amazon.com/athena/).

This repo deduplicates the table the [TPC-DS](https://www.tpc.org/tpcds/) `store_sales` table using `ROW_NUMBER()` and partitioning on the primary keys, comparing the run time for different approaches. 
The results show that hashing does **not** speed up run-time, and in fact causes a small increase at the scales I've investigated.

## Results

Metrics obtained when using scale = 500

### Staging Tables:

| Model | Rows | Runtime | Notes | Execution Time | Data Scanned (GB)|
|-|-|-|-|-|-|
|store_sales| 1,439,979,468 |622.21s| Creates a table with some duplicates|Stage 0: 3,106s, Stage 1: 11,532s|57.34|
|store_sales_hash|-|-|Creates view with hash|-|-|
|store_sales_string_pk|1,439,979,468|658.04s|Converts integer PKs to string|Stage 0: 3,286s, Stage 1: 29,628s, Stage 2: 57,348s|48.1|
|store_sales_hash_precalculated |1,439,979,468 |750.95s|Creates table with hash|Stage 0: 3,744s, Stage 1: 45,936s, Stage 2: 81,504s|48.1|

### Deduping

| Model | Rows | Runtime | Notes | Execution Time | Data Scanned (GB)|
|-|-|-|-|-|-|
|store_sales_dedupe|1,439,978,468|736.26s|Deduplicates `store_sales` using primary keys|Stage 0: 3,672s, Stage 1: 43,488s, Stage 2: 1,406s, Stage 3: 80,064s|48.1|
|store_sales_dedupe_hash|1,439,978,468|863.91s|Deduplicates `store_sales` using dynamic hash|Stage 0: 4,320s, Stage 1: 66,348s, Stage 2: 31,293s, Stage 3: 47,448s|48.1|
|store_sales_dedupe_hash_precalculated|1,439,978,468|855.33s|Deduplicates `store_sales_hash_precalculated` using pre-calculated hash|Stage 0: 4,284s, Stage 1: 64,152s, Stage 2: 30,368s, Stage 3: 85,860s|75|
|store_sales_dedupe_string_pk|1,439,978,468|792.53s|Deduplicates `store_sales_string_pk` using string primary keys|Stage 0: 3,960s, Stage 1: 52,800s, Stage 2: 15,001s, Stage 3: 4,428s|48.1|

![dag](dag.png)

## Instructions

You will need to have a copy of the TPC-DS store_sales table. I used the [TPC-DS connector for AWS Glue](https://aws.amazon.com/marketplace/pp/prodview-xtty6azr4xgey) to generate the TPC-DS `store_sales` table at scale 1 and 500, but you can use any method to create your table at any scale that Athena can handle.

This repo uses [dbt-core](https://github.com/dbt-labs/dbt-core) and [dbt-athena](https://github.com/dbt-athena/dbt-athena) adapter to manage and run the sql queries. To run locally, you'll have to follow the [setup instructions](https://dbt-athena.github.io/docs/getting-started/installation) and update `profiles.yml` with your bucket settings. You might also need to update the `source.yaml` to match your database name.

To run against TPCDS scale=1:

```
dbt run 
```

To run against any other scale pass in the tpcds_scale variable:

```
dbt run --vars '{"tpcds_scale":"500"}'
```
