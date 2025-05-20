{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'product') }}
),

stg_prod as (
    select 
    cast(product_scheme_code as varchar) as product_scheme_code,
    cast(product_scheme_type as varchar) as product_scheme_type,
    cast(product_scheme_category as varchar) as product_scheme_category,
    cast(Product_scheme_sub_category as varchar) as product_scheme_sub_category
    
    from source
)

select * 
from stg_prod

