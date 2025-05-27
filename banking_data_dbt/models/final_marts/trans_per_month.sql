{{ config(materialized='view') }}

with trans_per_month as (
    select
    date_trunc('month',timestamp) as month_timestamp,
    round(sum(transaction_amount),3) as transaction_amount
    from {{ ref('stg_transaction') }}
    group by month_timestamp
    order by month_timestamp,transaction_amount
)

select *
from trans_per_month