{{ config(materialized='table') }}

with base as (
  select
    customer_id,
    customer_unique_id,
    zip_prefix,
    city,
    state
  from {{ ref('stg_customers') }}
),
first_order as (
  select customer_id, min(purchase_ts) as first_order_ts
  from {{ ref('stg_orders') }}
  group by 1
)
select
  {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
  b.customer_id,
  b.customer_unique_id,
  b.zip_prefix,
  b.city, b.state,
  first_order_ts
from base b
left join first_order f using (customer_id)
