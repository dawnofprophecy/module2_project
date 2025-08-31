{{ config(materialized='view') }}

select
  order_id,
  customer_id,
  lower(order_status) as order_status,
  cast(order_purchase_timestamp as timestamp) as purchase_ts,
  cast(order_approved_at as timestamp) as approved_ts,
  cast(order_delivered_carrier_date as timestamp) as shipped_ts,
  cast(order_delivered_customer_date as timestamp) as delivered_ts,
  cast(order_estimated_delivery_date as timestamp) as promised_ts
from {{ source('bronze','orders') }}
where order_id is not null
