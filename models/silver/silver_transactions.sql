{{
    config(
        materialized='table',
        docs={'description': 'Silver layer: Cleaned and validated transaction data with business rules applied'}
    )
}}

-- Silver layer: Cleaned and validated transaction data
select
    transaction_id,
    user_id,
    merchant_id,
    cast(amount as decimal(10,2)) as amount,
    upper(trim(currency)) as currency,
    cast(transaction_date as date) as transaction_date,
    cast(transaction_time as time) as transaction_time,
    cast(transaction_date || ' ' || transaction_time as timestamp) as transaction_timestamp,
    lower(trim(payment_method)) as payment_method,
    lower(trim(status)) as status,
    case 
        when amount < 10 then 'Small'
        when amount between 10 and 100 then 'Medium'
        when amount between 100 and 500 then 'Large'
        else 'Very Large'
    end as transaction_size,
    case 
        when extract(hour from cast(transaction_time as time)) between 6 and 11 then 'Morning'
        when extract(hour from cast(transaction_time as time)) between 12 and 17 then 'Afternoon'
        when extract(hour from cast(transaction_time as time)) between 18 and 21 then 'Evening'
        else 'Night'
    end as time_of_day,
    current_timestamp as _dbt_updated_at
from {{ ref('bronze_transactions') }}
where amount > 0
  and amount < 10000  -- Filter out potential data errors
  and status in ('completed', 'pending', 'failed')
  and currency is not null