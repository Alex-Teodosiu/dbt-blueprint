{{
    config(
        materialized='table',
        docs={'description': 'Silver layer: Cleaned and validated merchant data'}
    )
}}

-- Silver layer: Cleaned and validated merchant data
select
    merchant_id,
    trim(merchant_name) as merchant_name,
    trim(upper(left(category, 1)) || lower(substring(category, 2))) as category,
    trim(upper(left(city, 1)) || lower(substring(city, 2))) as city,
    trim(upper(country)) as country,
    founded_year,
    case 
        when founded_year >= extract(year from current_date) - 2 then 'New (0-2 years)'
        when founded_year >= extract(year from current_date) - 5 then 'Growing (3-5 years)'
        when founded_year >= extract(year from current_date) - 10 then 'Established (6-10 years)'
        else 'Mature (10+ years)'
    end as business_maturity,
    current_timestamp as _dbt_updated_at
from {{ ref('bronze_merchants') }}
where merchant_name is not null
  and founded_year > 1900
  and founded_year <= extract(year from current_date)