{{
  config(
    materialized='table'
  )
}}

SELECT *
FROM {{ ref('store_sales_hash') }}