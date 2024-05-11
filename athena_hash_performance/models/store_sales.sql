{{
    config(
        alias= 'store_sales_' + var('scale')
    )
}}

SELECT 
    *
FROM {{ source('tpcds','store_sales') }}