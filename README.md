# Olist E-commerce Data Pipeline

This project implements an **end-to-end data pipeline and analytics workflow** using the [Olist Brazilian E-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).  
It shows how raw CSVs (Bronze) are ingested into BigQuery, transformed with dbt into **Silver (staging)** and **Gold (dimensional/fact)** layers, and tested for quality.

---

## 📂 Project Structure

```
module2_project/
├── olist_data/                  # Original Olist CSV datasets (Bronze source)
├── Olist_Project_Ingestion.jpynb             # Jupyter notebooks/scripts for ingestion
├── dbt/
│   └── olist/
│       ├── dbt_project.yml
│       ├── models/
│       │   ├── staging/       # Silver: normalized views
│       │   ├── intermediate/  # Helper aggregations
│       │   └── marts/
│       │       ├── dims/      # Gold: dimension tables
│       │       └── facts/     # Gold: fact tables
│       └── macros/
└── README.md
```

---

## 🛠️ Tools Used

- **DuckDB** → local CSV exploration, Parquet conversion
- **BigQuery** → cloud data warehouse
- **Meltano (next phase)** → can orchestrate EL from CSV to BigQuery
- **dbt Core** → transformations & data modeling
- **dbt_utils / dbt_expectations** → macros & data quality tests
- **Python / Jupyter** → ingestion notebooks and ad-hoc analysis

---

## 🔄 Pipeline Design

### 1. Ingestion (Bronze Layer)
- **Source**: 9 CSV files from Olist Kaggle dataset:
  - orders, order_items, payments, reviews, customers, sellers, products, geolocation, product_category_translation
- **Steps**: Olist_Project_Ingestion.ipynb
  1. Load CSV into **DuckDB** for type-checking and quick validation
  2. Convert to **Parquet** for efficient columnar storage and store in GCS
  3. Upload Parquet files to **BigQuery** (`olist_bronze` dataset)
- Why Parquet?  
  - Compressed, efficient for analytics  
  - Schema preserved, faster to load into BigQuery  
  - Scales better than raw CSV

**Result:** `olist_bronze` dataset in BigQuery with 9 raw tables.

---

### 2. Silver (Staging Layer)
- 9 dbt **staging views** in `olist_silver`
- Cleaning steps:
  - Normalized column names & types
  - Deduplication (`stg_reviews`)
  - Payment normalization (`stg_payments` → bucket rare values to `other`/`unknown`)
- Provides a clean, consistent interface for downstream models.

---

### 3. Intermediate Layer
- Aggregations/transformations not exposed directly to analysts
- Example: `int_zip_prefixes` (aggregates geolocation ZIP codes to lat/lng)

---

### 4. Gold (Business Layer)
- **6 Dimensions**:  
  `dim_customer`, `dim_product`, `dim_seller`, `dim_zip_prefix`, `dim_date`, `dim_payment_method`
- **3 Facts**:  
  `fct_order_item`, `fct_payment`, `fct_review`
- Materialized as **tables** in `olist_gold`
- Star schema design supports BI dashboards & analytics

---

## ✅ Data Quality Testing

- **Unique** / **Not Null** tests on surrogate keys
- **Relationships** tests between facts and dimensions
- **dbt_expectations**:
  - Payment types constrained to allowed set
  - `late_delivery_flag` ∈ {0,1}, nulls ignored

---

## 📊 Analytics & Insights

With the Gold layer, you can answer:
- What are monthly order and revenue trends?
- Which products and sellers perform best?
- What is on-time vs late delivery performance?
- How do payment methods shift over time?
- What are review patterns (response times, average scores)?

---

## 🚀 How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/jz889/module2_project.git
   cd module2_project/dbt/olist
   ```

2. Install dbt packages:
   ```bash
   dbt deps
   ```

3. Configure profile in `~/.dbt/profiles.yml`:
   ```yaml
   olist_bigquery:
     target: prod
     outputs:
       prod:
         type: bigquery
         method: oauth
         project: your-gcp-project-id
         dataset: olist_silver
         location: US
         threads: 4
   ```

4. Build models:
   ```bash
   dbt build
   ```

5. Run tests:
   ```bash
   dbt test
   ```

6. Explore docs:
   ```bash
   dbt docs generate
   dbt docs serve
   ```

---

## 📈 Final State

- **Bronze:** 9 BigQuery tables  
- **Silver:** 9 staging views  
- **Intermediate:** 1 helper table  
- **Gold:** 6 dimension tables, 3 fact tables  
- **Tests:** Clean run with dbt + dbt_expectations  

---

## 🔮 Next Steps

- Add **snapshots** for customer/product history
- Automate ingestion with **Meltano**
- Orchestrate pipeline with **Dagster** or **Airflow**
- Deploy CI/CD (GitHub Actions running `dbt build`)
- Connect to **BI tool** (Looker Studio, Tableau, Metabase)

---
