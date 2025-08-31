{{ config(materialized='table') }}

select
  zip_prefix as zip_prefix_key,
  city,
  state,
  lat,
  lng
from {{ ref('int_zip_prefixes') }}
