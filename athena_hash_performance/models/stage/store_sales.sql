{{
  config(
    materialized='table'
  )
}}

-- Full Load
SELECT 
    *
    ,'2024-01-01' as extraction_timestamp
FROM {{ source('tpcds','store_sales') }}

UNION ALL

-- Duplicates
SELECT * FROM
  (SELECT 
      *
      ,'2024-01-01' as extraction_timestamp
  FROM {{ source('tpcds','store_sales') }}
  LIMIT 1000
  )

UNION ALL

-- Updates
SELECT * FROM
  (SELECT 
      *
      ,'2024-01-02' as extraction_timestamp
  FROM {{ source('tpcds','store_sales') }}
  LIMIT 1000
  )