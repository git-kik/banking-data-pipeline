{{ config(materialized='view') }}

with card_accno as (
    select 
    distinct account_number as foracid
    from {{ ref('stg_card') }}
),

acc_with_card as (
    select
    t.foracid,
    round(avg(transaction_amount),3) as avg_trans_amount,
    max(amount_left) as amount_left,
    date_trunc('month',timestamp) as month_timestamp
    from {{ ref('stg_transaction') }} as t
    where t.foracid in (select foracid from card_accno)
    group by t.foracid,month_timestamp
    order by t.foracid,month_timestamp
)

select *
from acc_with_card