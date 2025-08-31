{{ config(materialized='table') }}

with dates as (
  select day as date
  from unnest(generate_date_array(date('2016-01-01'), date('2018-12-31'), interval 1 day)) as day
)
select
  date as date_day,
  extract(year from date) as year,
  extract(quarter from date) as quarter,
  extract(month from date) as month,
  format_date('%Y-%m', date) as yyyymm,
  extract(dayofweek from date) as dow,
  case when extract(dayofweek from date) in (1,7) then 1 else 0 end as is_weekend
from dates
