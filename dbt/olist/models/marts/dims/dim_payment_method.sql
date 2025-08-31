{{ config(materialized='table') }}

select distinct
  payment_type as payment_method_key,
  payment_type
from {{ ref('stg_payments') }}
where payment_type is not null
