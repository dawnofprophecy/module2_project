{{ config(materialized='table') }}

with base as (
  select
    p.product_id,
    coalesce(t.category_en, p.product_category_name) as category_en,
    p.weight_g, p.length_cm, p.height_cm, p.width_cm
  from {{ ref('stg_products') }} p
  left join {{ ref('stg_category_translation') }} t
    on p.product_category_name = t.category_pt
)
select
  {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
  *
from base
