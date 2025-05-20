{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'transaction') }}
),

stg_trans as (
    select 
    cast(transaction_id as varchar)  as transaction_id,
    cast(transaction_key as varchar)  as transaction_key,
    cast(foracid as varchar)  as foracid,
    cast(transaction_amount as decimal)  as transaction_amount,
    cast(amount_left as decimal)  as amount_left,
    coalesce(p_tran_type::varchar,'C')  as p_tran_type,
    coalesce(digital_flag::varchar,'N')  as digital_flag,
    cast(transaction_channel_type as varchar)  as transaction_channel_type,
    coalesce(timestamp::timestamp,current_timestamp) as timestamp
    
    from source
)

select * 
from stg_trans

