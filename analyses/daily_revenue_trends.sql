-- Daily revenue trends with day-of-week analysis
select 
    transaction_date,
    day_name,
    daily_revenue,
    total_transactions,
    success_rate_percent,
    active_users,
    active_merchants
from {{ ref('gold_daily_metrics') }}
order by transaction_date;