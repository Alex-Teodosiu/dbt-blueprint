{{
    config(
        materialized='view',
        docs={'description': 'Bronze layer: Raw transaction data from source system'}
    )
}}

-- Bronze layer: Raw transaction data with minimal transformations
select
    transaction_id,
    user_id,
    merchant_id,
    amount,
    currency,
    transaction_date,
    transaction_time,
    payment_method,
    status,
    current_timestamp as _loaded_at
from {{ ref('raw_transactions') }}