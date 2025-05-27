{{ config(materialized='view') }}

with card_accno as (
    select
    distinct account_number as foracid,
    credit_limit
    from {{ ref('stg_card') }}
    where product_code = 'PDSC2'
),

cust_credit_limit as (
    select
    c.foracid,
    c.credit_limit,
    count(*) as transaction_count,
    round(avg(t.transaction_amount),3) as avg_transaction_amount,
    date_trunc('month',t.timestamp) as month_timestamp
    from card_accno as c
    inner join {{ ref('stg_transaction') }} as t
    on t.foracid = c.foracid
    group by c.foracid,c.credit_limit,month_timestamp
    order by c.credit_limit
)

select *
from cust_credit_limit
