{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'account') }}
),

stg_acct as (
    select 
    cast(acid as varchar) as acid,
    cast(foracid as varchar) as foracid,
    cast(cif_id as varchar) as cif_id,
    coalesce(cast(acct_opn_date as TIMESTAMP),CURRENT_TIMESTAMP) as acct_opn_date,
    cast(account_status as varchar) as account_status,
    coalesce(cast(lien_amt as decimal),0) as lien_amt,
    cast(product_schm_code as varchar) as product_schm_code,
    cast(schm_type as varchar) as schm_type,
    coalesce(cast(sanct_lim as decimal),0) as sanct_lim,
    coalesce(cast(acct_crncy_code as varchar),'NPR') as acct_crncy_code,
    coalesce(cast(del_flg as varchar),'N') as del_flg,
    cast(acct_cls_flg as varchar) as acct_cls_flg,
    coalesce(cast(drwng_power as decimal),0) as drwng_power,
    coalesce(cast(interest_rate as decimal),0) as interest_rate,
    coalesce(cast(accrued_interest as decimal),0) as accrued_interest,
    cast(limit_b2kid as varchar) as limit_b2kid,
    coalesce(cast(clr_bal_amt as decimal),0) as clr_bal_amt
    
    from source
)

select * 
from stg_acct

