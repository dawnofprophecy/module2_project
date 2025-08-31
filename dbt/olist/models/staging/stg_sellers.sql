{{ config(materialized='view') }}

select
  seller_id,
  cast(seller_zip_code_prefix as int64) as zip_prefix,
  seller_city as city,
  seller_state as state
from {{ source('bronze','sellers') }}
