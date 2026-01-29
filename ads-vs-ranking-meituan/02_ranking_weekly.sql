-- 02_ranking_weekly.sql
-- Purpose: Build store-week business-district ranking score dataset (Meituan)
-- Ranking score is a continuous value between 0 and 1 (higher is better).
-- Output columns: store_id, week_of_year, ranking_score_weekly
-- Notes: Schema-generalised for portfolio use. Replace table/column names as needed.

WITH ranking_weekly AS (
  SELECT
    store_id,
    WEEKOFYEAR(TO_DATE(day, 'yyyymmdd')) AS week_of_year,
    AVG(ranking_score) AS ranking_score_weekly
  FROM ranking_fact_daily
  WHERE SUBSTR(day, 1, 4) = '2023'
    AND SUBSTR(day, 5, 2) IN ('01', '02')
  GROUP BY store_id, WEEKOFYEAR(TO_DATE(day, 'yyyymmdd'))
)
SELECT * FROM ranking_weekly;
