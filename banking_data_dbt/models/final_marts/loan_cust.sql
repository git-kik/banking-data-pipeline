{{ config(materialized='view') }}

with loan_cust as (
    select 
    foracid,
    (drwng_power) as loan_amount
    from {{ ref('stg_account') }} as a
    where a.product_schm_code in ('PDSC6','PDSC5')
)

select *
from loan_cust