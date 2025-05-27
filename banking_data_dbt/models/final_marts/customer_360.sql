{{ config(materialized='view') }}

with cust_trans as (
    select *
    from {{ ref('customer_transaction') }}
),

cust_360 as (
    select 
        cif_id,
        full_name,
        min(acct_opn_date) as account_opn_date,
        count(foracid) as transaction_count,
        sum(clr_bal_amt) as total_balance,
        sum(transaction_amount) as total_trans_amount,
        avg(transaction_amount) as avg_trans_amount,
        max(timestamp) as first_trans_date,
        min(timestamp) as last_trans_date
    from cust_trans
    group by cif_id,full_name
)

select *
from cust_360
