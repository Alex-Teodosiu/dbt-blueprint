import pyspark.sql.functions as F
from pyspark.sql import DataFrame


def model(dbt, session):
    # setting configuration
    dbt.config(materialized="table")

    # Reference staging tables
    stg_p2b_captured: DataFrame = dbt.ref("stg_p2b_captured")
    stg_p2b_failed: DataFrame = dbt.ref("stg_p2b_failed")
    stg_p2p_captured: DataFrame = dbt.ref("stg_p2p_captured")
    stg_p2p_failed: DataFrame = dbt.ref("stg_p2p_failed")

    common_columns = [
        "transaction_event_id",
        "sender_user_id",
        "receiver_user_id",
        "merchant_id",
        "sender_payment_source_id",
        "receiver_payment_source_id",
        "country_code",
        "currency_code",
        "transaction_amount",
        "message",
        "event_time",
        "recorded_time",
    ]

    # Create p2b_captured DataFrame
    p2b_captured_df = stg_p2b_captured.select(
        F.lit("p2b").alias("event_domain"),
        F.lit("captured").alias("event_state"),
        *common_columns,
    )

    # Create p2b_failed DataFrame
    p2b_failed_df = stg_p2b_failed.select(
        F.lit("p2b").alias("event_domain"),
        F.lit("failed").alias("event_state"),
        *common_columns,
    )

    # Create p2p_captured DataFrame
    p2p_captured_df = stg_p2p_captured.select(
        F.lit("p2p").alias("event_domain"),
        F.lit("captured").alias("event_state"),
        *common_columns,
    )

    # Create p2p_failed DataFrame
    p2p_failed_df = stg_p2p_failed.select(
        F.lit("p2p").alias("event_domain"),
        F.lit("failed").alias("event_state"),
        *common_columns,
    )

    # Union all transaction DataFrames
    unioned_transactions = (
        p2b_captured_df.unionByName(p2b_failed_df)
        .unionByName(p2p_captured_df)
        .unionByName(p2p_failed_df)
    )

    unioned_transactions = unioned_transactions.withColumnRenamed(
        "transaction_event_id", "event_id_raw"
    )

    # Create final DataFrame with surrogate key
    final_df = unioned_transactions.select(
        F.md5(["event_domain", "event_id_raw"]).alias("transaction_uid"),
        "event_domain",
        "event_state",
        "event_id_raw",
        "sender_user_id",
        "receiver_user_id",
        "merchant_id",
        "sender_payment_source_id",
        "receiver_payment_source_id",
        "country_code",
        "currency_code",
        "transaction_amount",
        "message",
        "event_time",
        "recorded_time",
    )

    return final_df
