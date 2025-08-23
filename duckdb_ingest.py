import duckdb
import os

# Path to your data folder
DATA_DIR = "olist_data"

# Map CSV filenames to table names
tables = {
    "olist_customers_dataset.csv": "customers",
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "olist_geolocation_dataset.csv": "geolocation",
    "product_category_name_translation.csv": "category_translation"
}

# Connect to (or create) a DuckDB database file
con = duckdb.connect("olist.duckdb")

for file, table in tables.items():
    file_path = os.path.join(DATA_DIR, file)

    print(f"Loading {file} into table {table}...")

    # Drop if table exists (so you can re-run script safely)
    con.execute(f"DROP TABLE IF EXISTS {table}")

    # Read CSV and create table
    con.execute(f"""
        CREATE TABLE {table} AS
        SELECT * FROM read_csv_auto('{file_path}', header=True);
    """)

print("\n✅ All CSVs loaded successfully into olist.duckdb!")

# Show tables
print("Tables in database:", con.execute("SHOW TABLES").fetchall())

# Sample query check
q = """
SELECT o.order_id, c.customer_unique_id, oi.product_id, oi.price, op.payment_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN order_payments op ON o.order_id = op.order_id
LIMIT 5
"""
print("\nSample joined rows:")
print(con.execute(q).df())
