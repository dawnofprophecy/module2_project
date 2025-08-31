{{ config(materialized='view') }}

select
  cast(geolocation_zip_code_prefix as int64) as zip_prefix,
  geolocation_city as city,
  geolocation_state as state,
  cast(geolocation_lat as float64) as latitude,
  cast(geolocation_lng as float64) as longitude
from {{ source('bronze','geolocation') }}
