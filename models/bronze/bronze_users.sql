{{
    config(
        materialized='view',
        docs={'description': 'Bronze layer: Raw user data from source system'}
    )
}}

-- Bronze layer: Raw user data with minimal transformations
select
    user_id,
    first_name,
    last_name,
    email,
    registration_date,
    age,
    city,
    country,
    current_timestamp as _loaded_at
from {{ ref('raw_users') }}