with src as (
    select
        event_domain,
        event_id_raw,
        transaction_uid
    from {{ ref('int_transactions_sql') }}
)

select *
from src
where transaction_uid != {{ dbt_utils.generate_surrogate_key(['event_domain', 'event_id_raw']) }}