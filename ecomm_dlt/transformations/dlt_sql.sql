-- ============================================================
-- BRONZE LAYER: Raw ingestion via Auto Loader (read_files)
-- Each table streams CSV files from a UC volume, appending an
-- ingestion_date timestamp for audit tracing.
-- ============================================================

-- Customer data from CSV source (includes CDC columns: operation, sequenceNum)
CREATE OR REFRESH STREAMING TABLE customers
AS SELECT *, current_timestamp() AS ingestion_date FROM STREAM read_files(
  "/Volumes/training/my_schema/my_volume/autoloader/csv/customers/",
  format => "csv"
);

-- Product data from CSV source (includes CDC columns: operation, seqNum)
CREATE OR REFRESH STREAMING TABLE products
AS
 SELECT *, current_timestamp() AS ingestion_date FROM STREAM read_files(
  "/Volumes/training/my_schema/my_volume/autoloader/csv/products/",
  format => "csv"
);

-- Sales transaction data from CSV source
CREATE OR REFRESH STREAMING TABLE sales
AS SELECT *, current_timestamp() AS ingestion_date FROM STREAM read_files(
  "/Volumes/training/my_schema/my_volume/autoloader/csv/sales/",
  format => "csv"
);

-- ============================================================
-- SILVER LAYER: Cleaned and deduplicated data
-- ============================================================

-- Sales silver: streams from bronze sales table, drops rows
-- with null order_id via expectation constraint.
CREATE OR REFRESH STREAMING TABLE sales_silver
(
  CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT * FROM STREAM(LIVE.sales);

-- Customer silver: SCD Type 2 via Auto CDC — tracks full history
-- of customer changes. Adds __START_AT and __END_AT validity columns.
-- Deletes are applied when operation = "DELETE".
CREATE OR REFRESH STREAMING TABLE customer_silver;

APPLY CHANGES INTO
  customer_silver
FROM
  stream(LIVE.customers)
KEYS
  (customer_id)
APPLY AS DELETE WHEN
  operation = "DELETE"
SEQUENCE BY
  sequenceNum
COLUMNS * EXCEPT
  (operation,sequenceNum ,_rescued_data,ingestion_date
)
STORED AS
  SCD TYPE 2;

-- Product silver: SCD Type 1 via Auto CDC — keeps only the latest
-- state per product_id. Deletes applied when operation = "DELETE".
CREATE OR REFRESH STREAMING TABLE product_silver;

APPLY CHANGES INTO
  product_silver
FROM
  stream(LIVE.products)
KEYS
  (product_id)
APPLY AS DELETE WHEN
  operation = "DELETE"
SEQUENCE BY
  seqNum
COLUMNS * EXCEPT
  (operation,seqNum ,_rescued_data,ingestion_date
)
STORED AS
  SCD TYPE 1;

-- ============================================================
-- SILVER VIEWS: Active/current records for downstream consumption
-- ============================================================

-- Customer silver active: filters SCD Type 2 table to show only
-- the current version of each customer (where __END_AT IS NULL).
CREATE OR REFRESH MATERIALIZED VIEW customer_silver_active
AS SELECT * FROM customer_silver WHERE __END_AT IS NULL;
