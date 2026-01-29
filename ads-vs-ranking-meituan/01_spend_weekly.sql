-- 01_spend_weekly.sql
-- Purpose: Build store-week ad spend dataset (Meituan)
-- Output columns: store_id, week_of_year, weekly_spend
-- Notes: Schema-generalised for portfolio use. Replace table/column names as needed.

WITH spend_weekly AS (
  SELECT
    store_id,
    WEEKOFYEAR(TO_DATE(day)) AS week_of_year,
    SUM(ad_spend) AS weekly_spend
  FROM ads_fact_daily
  WHERE YEAR(TO_DATE(day)) = 2023
    AND MONTH(TO_DATE(day)) IN (1, 2)
  GROUP BY store_id, WEEKOFYEAR(TO_DATE(day))
)
SELECT * FROM spend_weekly;
