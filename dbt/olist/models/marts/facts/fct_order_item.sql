{{ config(materialized='table') }}

with oi as ( select * from {{ ref('stg_order_items') }} ),
o  as ( select * from {{ ref('stg_orders') }} ),
cust as ( select customer_id, customer_key from {{ ref('dim_customer') }} ),
prod as ( select product_id, product_key from {{ ref('dim_product') }} ),
sell as ( select seller_id, seller_key from {{ ref('dim_seller') }} )

select
  {{ dbt_utils.generate_surrogate_key(['oi.order_id','oi.order_item_id']) }} as order_item_key,
  oi.order_id,
  oi.order_item_id,
  prod.product_key,
  sell.seller_key,
  cust.customer_key,
  oi.price,
  oi.freight_value,
  oi.price + oi.freight_value as item_total,
  o.purchase_ts,
  o.delivered_ts,
  o.promised_ts,
  case when o.order_status in ('canceled','unavailable') then 1 else 0 end as canceled_flag,
  case when o.delivered_ts is not null and o.promised_ts is not null and o.delivered_ts > o.promised_ts then 1 else 0 end as late_delivery_flag
from oi
join o using (order_id)
left join prod on oi.product_id = prod.product_id
left join sell on oi.seller_id  = sell.seller_id
left join cust on o.customer_id = cust.customer_id
