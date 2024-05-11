{{
    config(
        alias= 'store_sales_hash_' + var('scale')
    )
}}

SELECT 
    *,
    {{ dbt_utils.generate_surrogate_key(["ss_item_sk", "ss_ticket_number"]) }} as hash
FROM {{ source('tpcds','store_sales') }}