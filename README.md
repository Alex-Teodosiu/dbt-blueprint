# dbt Financial Data Pipeline Blueprint

This repository showcases a comprehensive dbt project implementing a **medallion architecture** for processing financial transaction data. It demonstrates best practices for data transformation, data quality testing, and analytics-ready data modeling using dbt with dummy financial data.

## 🏗️ Architecture Overview

The project implements a **medallion architecture** with three distinct layers:

### 🥉 Bronze Layer (Raw Data)
- **Purpose**: Raw data ingestion with minimal transformations
- **Models**: `bronze_users`, `bronze_merchants`, `bronze_transactions`
- **Materialization**: Views (for fast development and low storage)
- **Description**: Direct representation of source data with basic timestamp tracking

### 🥈 Silver Layer (Cleaned Data)
- **Purpose**: Cleaned, validated, and business-rule-applied data
- **Models**: `silver_users`, `silver_merchants`, `silver_transactions`
- **Materialization**: Tables (for performance and reliability)
- **Description**: Data quality rules, standardized formats, and derived fields

### 🥇 Gold Layer (Business Logic)
- **Purpose**: Business metrics, KPIs, and analytics-ready aggregations
- **Models**: `gold_user_analytics`, `gold_merchant_analytics`, `gold_daily_metrics`
- **Materialization**: Tables (for analytical performance)
- **Description**: Pre-calculated business metrics and customer insights

## 📊 Data Model

### Source Data (Seeds)
- **Users**: Customer demographics and registration information
- **Merchants**: Business information and categorization
- **Transactions**: Financial transaction records with multiple payment methods

### Key Business Metrics
- Customer spending analytics and segmentation
- Merchant performance and success rates
- Daily financial KPIs and trends
- Payment method analysis
- Geographic distribution insights

## 🧪 Data Quality & Testing

The project includes comprehensive data quality tests:
- **Uniqueness**: Primary key constraints across all layers
- **Referential Integrity**: Foreign key relationships
- **Data Validation**: Accepted values for categorical fields
- **Business Rules**: Custom data quality checks
- **Not Null**: Critical field validation

**Total Tests**: 53 data tests ensuring data reliability

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- dbt-core
- dbt-duckdb (for local development)

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dbt-blueprint
   ```

2. **Install dependencies**
   ```bash
   pip install dbt-core dbt-duckdb
   ```

3. **Load seed data**
   ```bash
   dbt seed
   ```

4. **Run all models**
   ```bash
   dbt run
   ```

5. **Execute data tests**
   ```bash
   dbt test
   ```

6. **Generate documentation**
   ```bash
   dbt docs generate
   dbt docs serve
   ```

## 📈 Analytics Examples

The project includes sample analyses in the `analyses/` folder:

- **Top Customers**: Identify highest-value customers by spending
- **Merchant Performance**: Category-wise performance analysis  
- **Daily Trends**: Revenue and transaction patterns over time

## 🏢 Production Deployment

This blueprint is designed for production deployment with:
- **Databricks**: Primary target for production workloads
- **Terraform**: Infrastructure as code (mentioned in original README)
- **Workflows**: Automated pipeline orchestration
- **Data Contracts**: Defined schemas and SLAs

## 📁 Project Structure

```
dbt-blueprint/
├── models/
│   ├── bronze/          # Raw data models
│   ├── silver/          # Cleaned data models
│   └── gold/            # Business logic models
├── seeds/               # Sample data files
├── tests/               # Custom data tests
├── analyses/            # Ad-hoc analysis queries
├── macros/              # Reusable SQL macros
└── docs/                # Documentation assets
```

## 🔍 Model Lineage

```
Seeds (Raw Data)
    ↓
Bronze Layer (Raw ingestion)
    ↓
Silver Layer (Data quality & cleaning)
    ↓
Gold Layer (Business metrics & KPIs)
```

## 🎯 Key Features

- ✅ Medallion architecture implementation
- ✅ Comprehensive data quality testing
- ✅ Business-ready analytics models
- ✅ Dummy financial data for demonstration
- ✅ Documentation and lineage
- ✅ Modular and scalable design
- ✅ Production-ready structure

## 📚 Learning Resources

This project demonstrates:
- dbt best practices and conventions
- Data modeling for financial analytics
- Medallion architecture patterns
- Data quality and testing strategies
- Documentation and metadata management

---

*This is a blueprint project using dummy data only. No real financial information is used or processed.*
