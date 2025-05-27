{{ config(materialized='view') }}

with tran_type as (
    select
    foracid,
    date_trunc('year',timestamp) as year_timestamp,
    case 
        when digital_flag = 'Y' then 'digital'
        when digital_flag = 'N' then 'non-digital'
        else 'unknown'
        end as transaction_type,
    count(*) as transaction_count
    from {{ ref('stg_transaction') }}
    group by foracid,digital_flag,year_timestamp
)

select
foracid,
transaction_type,
transaction_count,
year_timestamp
from tran_type