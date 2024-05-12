{{
  config(
    materialized='table'
  )
}}

{% set cols = dbt_utils.star(from=ref('store_sales'), except=["ss_item_sk", "ss_ticket_number"]) %}

select 
{{ cols }}
,cast(ss_item_sk AS varchar(20)) as ss_item_sk
,cast(ss_ticket_number AS varchar(20)) as ss_ticket_number
from {{ ref('store_sales') }}