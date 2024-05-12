# athena-hash-performance

Use TPCDS scale=1:

```
dbt run 
```

To use any other scale pass in the tpcds_scale variable:

```
dbt run --vars '{"tpcds_scale":"500"}'
```

Results:

created sql table model athena_hash_performance.store_sales .......... [OK 1439979468 in 626.21s]
created sql table model athena_hash_performance.store_sales_dedupe ... [OK 1439978468 in 744.31s]
created sql table model athena_hash_performance.store_sales_hash_precalculated  [OK 1439979468 in 744.22s]
created sql table model athena_hash_performance.store_sales_dedupe_hash  [OK 1439978468 in 858.69s]
created sql table model athena_hash_performance.store_sales_dedupe_hash_precalculated  [OK 1439978468 in 865.41s]