{{ config(materialized='table') }}

select
  zip_prefix,
  any_value(city)  as city,
  any_value(state) as state,
  avg(latitude)    as lat,
  avg(longitude)   as lng
from {{ ref('stg_geolocation') }}
group by zip_prefix
