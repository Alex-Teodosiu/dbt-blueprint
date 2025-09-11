-- Merchant performance analysis by category
select 
    category,
    count(*) as merchant_count,
    round(avg(total_revenue), 2) as avg_revenue_per_merchant,
    round(avg(success_rate_percent), 2) as avg_success_rate,
    sum(total_revenue) as total_category_revenue
from {{ ref('gold_merchant_analytics') }}
group by category
order by total_category_revenue desc;