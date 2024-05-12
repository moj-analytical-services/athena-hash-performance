{{
  config(
    materialized='table'
  )
}}

{{
    deduplicate(
        ref('store_sales_hash_precalculated'),
        partition_by=['hash']
    )
}}
