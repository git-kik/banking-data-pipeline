{{ config(materialized='view') }}

with customer as (
    select 
    cif_id,
    full_name,
    cust_type 
    from {{ ref('stg_customer') }}
),

account as (
    select 
    foracid,
    cif_id,
    acct_opn_date,
    account_status,
    product_schm_code,
    clr_bal_amt 
    from {{ ref('stg_account') }}
),

trans as (
    select 
    foracid,
    transaction_id,
    transaction_amount,
    timestamp,
    transaction_channel_type,
    p_tran_type
    from {{ ref('stg_transaction') }}
),

cust_acc as (
    select 
    c.cif_id,
    c.full_name,
    c.cust_type,
    a.foracid,
    a.acct_opn_date,
    a.account_status,
    a.product_schm_code,
    a.clr_bal_amt
    from customer as c
    inner join account as a
    on c.cif_id = a.cif_id
),

cust_acc_trans as (
    select 
    ca.*,
    t.transaction_id,
    t.transaction_amount,
    t.timestamp,
    t.transaction_channel_type,
    t.p_tran_type
    from cust_acc as ca
    inner join trans as t
    on ca.foracid = t.foracid
)

select *
from cust_acc_trans