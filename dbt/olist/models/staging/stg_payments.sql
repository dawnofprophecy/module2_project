{{ config(materialized='view') }}

with src as (
  select
    order_id,
    payment_sequential,
    lower(payment_type) as payment_type_raw,
    cast(payment_installments as int64) as payment_installments,
    cast(payment_value as numeric) as payment_value
  from {{ source('bronze','payments') }}
),
normalized as (
  select
    order_id,
    payment_sequential,
    case
      when payment_type_raw in ('credit_card','boleto','voucher','debit_card') then payment_type_raw
      when payment_type_raw is null then 'unknown'
      else 'other'
    end as payment_type,              -- <- normalized value used downstream
    payment_installments,
    payment_value
  from src
)
select * from normalized