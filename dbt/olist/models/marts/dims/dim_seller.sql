{{ config(materialized='table') }}

select
  {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as seller_key,
  seller_id,
  zip_prefix,
  city,
  state
from {{ ref('stg_sellers') }}
