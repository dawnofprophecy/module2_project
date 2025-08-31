{{ config(materialized='view') }}

with base as (
  select
    review_id,
    order_id,
    cast(review_score as int64) as review_score,
    cast(review_creation_date as timestamp) as review_creation_ts,
    cast(review_answer_timestamp as timestamp) as review_answer_ts
  from {{ source('bronze','reviews') }}
),
dedup as (
  select *
  from (
    select
      base.*,
      row_number() over (
        partition by review_id
        order by review_answer_ts desc, review_creation_ts desc
      ) as rn
    from base
  )
  where rn = 1
)
select * except(rn) from dedup
