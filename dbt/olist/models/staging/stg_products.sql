{{ config(materialized='view') }}

select
  product_id,
  product_category_name,
  cast(product_weight_g as int64) as weight_g,
  cast(product_length_cm as int64) as length_cm,
  cast(product_height_cm as int64) as height_cm,
  cast(product_width_cm as int64) as width_cm
from {{ source('bronze','products') }}
