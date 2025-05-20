{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'customer') }}
),

stg_cust as (
    select 
    cast(cif_id as varchar) as cif_id,
    cast(cust_first_name as varchar) as cust_first_name,
    cast(cust_middle_name as varchar) as cust_middle_name,
    cast(cust_last_name as varchar) as cust_last_name,
    cast(full_name as varchar) as full_name,
    cast(cust_type as varchar) as cust_type,
    cast(cust_dob as timestamp)::timestamp as cust_dob,
    cast(gender as varchar) as gender,
    cast(address_line as varchar) as address_line,
    cast(employment_status as varchar) as employment_status,
    cast(salary_per_month as DECIMAL)as salary_per_month,
    cast(riskrating as varchar) as riskrating,
    cast(marital_status as varchar) as marital_status,
    cast(occupation as varchar) as occupation,
    coalesce(blacklisted,'N') as blacklisted,
    cast(pan as varchar) as pan,
    cast(email as varchar) as email,
    cast(cust_community as varchar) as cust_community,
    cast(rating as varchar) as rating,
    cast(constitution_code as varchar) as constitution_code,
    cast(constitution_code_desc as varchar) as constitution_code_desc,
    cast(mobile_number as varchar) as mobile_number,
    coalesce(account_relationship_date::timestamp,current_timestamp) as account_relationship_date
    
    from source
)

select * 
from stg_cust

