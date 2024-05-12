SELECT 
    *
    ,{{ dbt_utils.generate_surrogate_key(["ss_item_sk", "ss_ticket_number", "extraction_timestamp"]) }} AS hash
FROM {{ ref('store_sales') }}