{{ config(materialized='view') }}

select
  customer_id,
  customer_unique_id,
  cast(customer_zip_code_prefix as int64) as zip_prefix,
  customer_city as city,
  customer_state as state
from {{ source('bronze','customers') }}
