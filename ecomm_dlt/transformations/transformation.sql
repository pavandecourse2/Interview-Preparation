---------------------------------------------------
-- COMMAND ----------

CREATE OR REFRESH MATERIALIZED VIEW total_sales_customer AS 
SELECT 
    c.customer_id,
    c.customer_name,
    round(SUM(s.total_amount)) AS total_sales,
    SUM(s.discount_amount) AS total_discount
FROM training.dlt_demo.sales_silver s
JOIN training.dlt_demo.customer_silver_active c
    ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales DESC;

-- COMMAND ----------

CREATE OR REFRESH MATERIALIZED VIEW total_sales_category AS
SELECT 
    p.product_category,
    round(SUM(s.total_amount)) AS total_sales
FROM training.dlt_demo.sales_silver s
JOIN training.dlt_demo.product_silver p
    ON s.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_sales DESC;