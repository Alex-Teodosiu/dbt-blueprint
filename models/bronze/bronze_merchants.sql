{{
    config(
        materialized='view',
        docs={'description': 'Bronze layer: Raw merchant data from source system'}
    )
}}

-- Bronze layer: Raw merchant data with minimal transformations
select
    merchant_id,
    merchant_name,
    category,
    city,
    country,
    founded_year,
    current_timestamp as _loaded_at
from {{ ref('raw_merchants') }}