-- AFC Redgrave · dbt lab · write your answers in YOUR Snowflake account
-- Replace each <...> with your answer (keep the $$ on both sides), then Run All.
-- You can run this file again: it replaces your previous answers for this lab.

USE ROLE SYSADMIN;
USE WAREHOUSE REDGRAVE_WH;
CREATE SCHEMA IF NOT EXISTS REDGRAVE.LAB;
CREATE TABLE IF NOT EXISTS REDGRAVE.LAB.ANSWERS (
    lab VARCHAR, question VARCHAR, answer VARCHAR, submitted_at TIMESTAMP_TZ);

DELETE FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-201';

INSERT INTO REDGRAVE.LAB.ANSWERS VALUES
('RED-201', 'NAME', $$Adrien Lory$$, CURRENT_TIMESTAMP()),
('RED-201', 'Q1', $$Silver models are views: a view stores nothing and is recomputed at each read, so it is cheap to build and always reflects the latest bronze data. Gold models are tables: they store the result once per dbt run, so Power BI dashboards can read them all day quickly without recomputing the joins and aggregations. One line per folder in dbt_project.yml (+materialized: view / table) decides it.$$, CURRENT_TIMESTAMP()),
('RED-201', 'Q2', $$source() reads a table that dbt does not build itself (the raw BRONZE tables loaded by COPY INTO in the ingestion lab), declared in sources.yml. ref() reads another dbt model (e.g. silver_orders). Both create edges in the DAG: thanks to ref(), dbt knows the build order (silver_orders before silver_order_lines before gold) and resolves the right database/schema.$$, CURRENT_TIMESTAMP()),
('RED-201', 'Q3', $$accepted_values_silver_orders_status__paid__refunded failed (FAIL 1): order 999 had status 'PENDING' -> 'pending', which is not in [paid, refunded]. dbt build runs each model then its tests, and when a test fails it skips everything downstream (13 SKIP: silver_order_lines, the 3 gold tables and their tests), so gold was not rebuilt with bad data and the dashboard kept yesterday's correct numbers. The channel test did not fail because silver lower-cases 'Online' to 'online', an accepted value.$$, CURRENT_TIMESTAMP()),
('RED-201', 'Q4', $$dbt source freshness answered WARN for bronze.orders and bronze.order_items (products has no freshness rule): the max(_loaded_at) is 2026-10-22, about 5 days old. It WARNs when the last load is older than 24 hours (warn_after) and would ERROR only if older than 90 days (error_after). Reloading bronze (new COPY INTO) would make it PASS.$$, CURRENT_TIMESTAMP()),
('RED-201', 'Q5', $$Everything to the right of silver_orders in the lineage graph: silver_order_lines (ref('silver_orders')), and through it the three gold tables gold_revenue_by_channel, gold_daily_sales and gold_top_products, plus their tests (relationships test on silver_order_lines.order_id, assert_gold_matches_silver, unique/not_null on gold keys).$$, CURRENT_TIMESTAMP());

SELECT question, answer FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-201' ORDER BY question;
