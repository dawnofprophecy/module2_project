{{ config(materialized='table') }}

with p as ( select * from {{ ref('stg_payments') }} ),
pm as ( select payment_method_key, payment_type from {{ ref('dim_payment_method') }} )

select
  {{ dbt_utils.generate_surrogate_key(['p.order_id','cast(p.payment_sequential as string)']) }} as payment_row_key,
  p.order_id,
  p.payment_sequential,
  pm.payment_method_key,
  p.payment_installments,
  p.payment_value
from p
left join pm on p.payment_type = pm.payment_type
