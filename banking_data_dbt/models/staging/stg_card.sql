{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'cards') }}
),

stg_card as (
    select 
    cast(account_number as varchar) as account_number,
    cast(card_number as varchar) as card_number,
    coalesce(aty_code::INT,1) as aty_code,
    cast(card_status as varchar) as card_status,
    cast(foracid as varchar) as foracid,
    cast(car_code as INT) as card_code,
    cast(product_code as varchar) as product_code,
    coalesce(credit_limit::decimal,0) as credit_limit,
    cast(car_create_date as timestamp) as card_create_date
    
    from source
)

select * 
from stg_card

