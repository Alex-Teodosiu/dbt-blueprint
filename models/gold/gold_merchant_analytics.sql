{{
    config(
        materialized='table',
        docs={'description': 'Gold layer: Merchant performance analytics and business insights'}
    )
}}

-- Gold layer: Merchant performance analytics
select
    m.merchant_id,
    m.merchant_name,
    m.category,
    m.city,
    m.country,
    m.business_maturity,
    count(t.transaction_id) as total_transactions,
    count(case when t.status = 'completed' then 1 end) as completed_transactions,
    count(case when t.status = 'failed' then 1 end) as failed_transactions,
    count(case when t.status = 'pending' then 1 end) as pending_transactions,
    round(
        case when count(t.transaction_id) > 0 
        then cast(count(case when t.status = 'completed' then 1 end) as float) / count(t.transaction_id) * 100
        else 0 end, 2
    ) as success_rate_percent,
    round(sum(case when t.status = 'completed' then t.amount else 0 end), 2) as total_revenue,
    round(avg(case when t.status = 'completed' then t.amount end), 2) as avg_transaction_amount,
    min(case when t.status = 'completed' then t.amount end) as min_transaction_amount,
    max(case when t.status = 'completed' then t.amount end) as max_transaction_amount,
    count(distinct t.user_id) as unique_customers,
    min(t.transaction_date) as first_transaction_date,
    max(t.transaction_date) as last_transaction_date,
    count(case when t.payment_method = 'credit_card' then 1 end) as credit_card_transactions,
    count(case when t.payment_method = 'debit_card' then 1 end) as debit_card_transactions,
    count(case when t.payment_method = 'cash' then 1 end) as cash_transactions,
    case
        when sum(case when t.status = 'completed' then t.amount else 0 end) > 2000 then 'Top Performer'
        when sum(case when t.status = 'completed' then t.amount else 0 end) > 1000 then 'Good Performer'
        when sum(case when t.status = 'completed' then t.amount else 0 end) > 500 then 'Average Performer'
        else 'Underperformer'
    end as performance_tier,
    current_timestamp as _dbt_updated_at
from {{ ref('silver_merchants') }} m
left join {{ ref('silver_transactions') }} t on m.merchant_id = t.merchant_id
group by 
    m.merchant_id, m.merchant_name, m.category, m.city, m.country, m.business_maturity