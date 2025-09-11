{{
    config(
        materialized='table',
        docs={'description': 'Gold layer: User spending analytics and behavioral insights'}
    )
}}

-- Gold layer: User spending analytics
select
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.age_group,
    u.country,
    count(t.transaction_id) as total_transactions,
    count(case when t.status = 'completed' then 1 end) as completed_transactions,
    count(case when t.status = 'failed' then 1 end) as failed_transactions,
    count(case when t.status = 'pending' then 1 end) as pending_transactions,
    round(sum(case when t.status = 'completed' then t.amount else 0 end), 2) as total_spent,
    round(avg(case when t.status = 'completed' then t.amount end), 2) as avg_transaction_amount,
    min(case when t.status = 'completed' then t.amount end) as min_transaction_amount,
    max(case when t.status = 'completed' then t.amount end) as max_transaction_amount,
    min(t.transaction_date) as first_transaction_date,
    max(t.transaction_date) as last_transaction_date,
    count(distinct t.merchant_id) as unique_merchants_visited,
    count(distinct case when t.time_of_day = 'Morning' then t.transaction_id end) as morning_transactions,
    count(distinct case when t.time_of_day = 'Afternoon' then t.transaction_id end) as afternoon_transactions,
    count(distinct case when t.time_of_day = 'Evening' then t.transaction_id end) as evening_transactions,
    count(distinct case when t.time_of_day = 'Night' then t.transaction_id end) as night_transactions,
    case
        when sum(case when t.status = 'completed' then t.amount else 0 end) > 1000 then 'High Value'
        when sum(case when t.status = 'completed' then t.amount else 0 end) > 500 then 'Medium Value'
        else 'Low Value'
    end as customer_value_segment,
    current_timestamp as _dbt_updated_at
from {{ ref('silver_users') }} u
left join {{ ref('silver_transactions') }} t on u.user_id = t.user_id
group by 
    u.user_id, u.first_name, u.last_name, u.email, u.age_group, u.country