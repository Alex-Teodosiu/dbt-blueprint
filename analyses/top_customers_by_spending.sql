-- Sample analytical queries for the financial data pipeline

-- Top 5 customers by total spending
select 
    first_name || ' ' || last_name as customer_name,
    total_spent,
    customer_value_segment,
    unique_merchants_visited
from {{ ref('gold_user_analytics') }}
where total_spent > 0
order by total_spent desc
limit 5;