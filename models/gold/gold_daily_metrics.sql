{{
    config(
        materialized='table',
        docs={'description': 'Gold layer: Daily financial metrics and KPIs for business reporting'}
    )
}}

-- Gold layer: Daily financial metrics and KPIs
select
    t.transaction_date,
    count(t.transaction_id) as total_transactions,
    count(case when t.status = 'completed' then 1 end) as completed_transactions,
    count(case when t.status = 'failed' then 1 end) as failed_transactions,
    count(case when t.status = 'pending' then 1 end) as pending_transactions,
    round(sum(case when t.status = 'completed' then t.amount else 0 end), 2) as daily_revenue,
    round(avg(case when t.status = 'completed' then t.amount end), 2) as avg_transaction_amount,
    count(distinct t.user_id) as active_users,
    count(distinct t.merchant_id) as active_merchants,
    count(distinct case when t.payment_method = 'credit_card' then t.transaction_id end) as credit_card_count,
    count(distinct case when t.payment_method = 'debit_card' then t.transaction_id end) as debit_card_count,
    count(distinct case when t.payment_method = 'cash' then t.transaction_id end) as cash_count,
    count(case when t.transaction_size = 'Small' then 1 end) as small_transactions,
    count(case when t.transaction_size = 'Medium' then 1 end) as medium_transactions,
    count(case when t.transaction_size = 'Large' then 1 end) as large_transactions,
    count(case when t.transaction_size = 'Very Large' then 1 end) as very_large_transactions,
    round(
        case when count(t.transaction_id) > 0 
        then cast(count(case when t.status = 'completed' then 1 end) as float) / count(t.transaction_id) * 100
        else 0 end, 2
    ) as success_rate_percent,
    extract(dow from t.transaction_date) as day_of_week,
    case extract(dow from t.transaction_date)
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
    end as day_name,
    current_timestamp as _dbt_updated_at
from {{ ref('silver_transactions') }} t
group by t.transaction_date
order by t.transaction_date