{{ config(materialized='view') }}

with trans as (
    select *
    from {{ ref('stg_transaction') }}
),

acc_summary as (
    select
        foracid,
        count(*) as total_trans,
        sum(transaction_amount) as total_amount,
        avg(transaction_amount) as avg_trans_amount,
        min(timestamp) as first_trans_date,
        max(timestamp) as last_trans_date
    from trans
    group by foracid
)

select * 
from acc_summary
