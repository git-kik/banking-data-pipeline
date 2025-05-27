{{ config(materialized='view') }}

with tran_type as (
    select
    case 
        when transaction_channel_type = 'BY_DIGITAL' then 'mobile banking'
        when transaction_channel_type = 'BY_BRANCH' then 'physical banking'
        else 'card banking'
        end as transaction_channel_type,
    count(*) as transaction_count
    from {{ ref('stg_transaction') }}
    group by transaction_channel_type
)

select *
from tran_type