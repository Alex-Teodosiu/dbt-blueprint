{{
    config(
        materialized='table',
        docs={'description': 'Silver layer: Cleaned and validated user data'}
    )
}}

-- Silver layer: Cleaned and validated user data
select
    user_id,
    trim(upper(left(first_name, 1)) || lower(substring(first_name, 2))) as first_name,
    trim(upper(left(last_name, 1)) || lower(substring(last_name, 2))) as last_name,
    lower(trim(email)) as email,
    cast(registration_date as date) as registration_date,
    age,
    trim(upper(left(city, 1)) || lower(substring(city, 2))) as city,
    trim(upper(country)) as country,
    case 
        when age < 18 then 'Under 18'
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-34'
        when age between 35 and 44 then '35-44'
        when age between 45 and 54 then '45-54'
        when age >= 55 then '55+'
    end as age_group,
    current_timestamp as _dbt_updated_at
from {{ ref('bronze_users') }}
where email is not null
  and age > 0
  and age < 120