{{ config(materialized='table') }}

select
  {{ dbt_utils.generate_surrogate_key(['review_id']) }} as review_key,
  review_id,
  order_id,
  review_score,
  review_creation_ts,
  review_answer_ts,
  date_diff(review_answer_ts, review_creation_ts, day) as review_response_days
from {{ ref('stg_reviews') }}
