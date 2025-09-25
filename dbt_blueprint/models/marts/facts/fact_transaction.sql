select 
  transaction_uid
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
from {{ ref('int_transactions_sql') }}