{{
  config(
    materialized='table'
  )
}}

{{
    deduplicate(
        ref('store_sales_hash'),
        partition_by=['hash']
    )
}}