{{ config(materialized='view') }}

with cust as (
    select *
    from {{ ref('stg_customer') }}
),

card_acc as (
    select 
    distinct account_number as foracid
    from {{ ref('stg_card') }}
),

cust_card as (
    select
    count(*) as total_customer,
    count(distinct c.cif_id) as card_customer
    from cust as c
    inner join {{ ref('stg_account') }} as a
    on a.cif_id = c.cif_id
    where a.foracid in (select foracid from card_acc)
)



select 
total_customer,
card_customer,
(total_customer - card_customer) as non_card_customer 
from cust_card
