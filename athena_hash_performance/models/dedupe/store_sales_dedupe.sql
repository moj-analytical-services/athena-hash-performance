{{
  config(
    materialized='table'
  )
}}

{{
    deduplicate(
        ref('store_sales'),
        partition_by=["ss_item_sk", "ss_ticket_number","extraction_timestamp"]
    )
}}