{{ config(materialized='table') }}

with p2b_captured as (
  select
      'p2b' as event_domain
    , 'captured' as event_state
    , transaction_event_id as event_id_raw
    , sender_user_id
    , receiver_user_id
    , merchant_id
    , sender_payment_source_id
    , receiver_payment_source_id
    , country_code
    , currency_code
    , transaction_amount
    , message
    , event_time
    , recorded_time
  from {{ ref('stg_p2b_captured') }}
),

p2b_failed as (
  select
      'p2b' as event_domain
    , 'failed' as event_state
    , transaction_event_id as event_id_raw
    , sender_user_id
    , receiver_user_id
    , merchant_id
    , sender_payment_source_id
    , receiver_payment_source_id
    , country_code
    , currency_code
    , transaction_amount
    , message
    , event_time
    , recorded_time
  from {{ ref('stg_p2b_failed') }}
),

p2p_captured as (
  select
      'p2p' as event_domain
    , 'captured' as event_state
    , transaction_event_id as event_id_raw
    , sender_user_id
    , receiver_user_id
    , merchant_id
    , sender_payment_source_id
    , receiver_payment_source_id
    , country_code
    , currency_code
    , transaction_amount
    , message
    , event_time
    , recorded_time
  from {{ ref('stg_p2p_captured') }}
),

p2p_failed as (
  select
      'p2p' as event_domain
    , 'failed' as event_state
    , transaction_event_id as event_id_raw
    , sender_user_id
    , receiver_user_id
    , merchant_id
    , sender_payment_source_id
    , receiver_payment_source_id
    , country_code
    , currency_code
    , transaction_amount
    , message
    , event_time
    , recorded_time
  from {{ ref('stg_p2p_failed') }}
),

unioned_transactions as (
  select * from p2b_captured
  union all
  select * from p2b_failed
  union all
  select * from p2p_captured
  union all
  select * from p2p_failed
)

select
    -- Avoid id collisions across event domains
    {{ dbt_utils.generate_surrogate_key(['event_domain', 'event_id_raw']) }} as transaction_uid
  , event_domain
  , event_state
  , event_id_raw
  , sender_user_id
  , receiver_user_id
  , merchant_id
  , sender_payment_source_id
  , receiver_payment_source_id
  , country_code
  , currency_code
  , transaction_amount
  , message
  , event_time
  , recorded_time
from unioned_transactions