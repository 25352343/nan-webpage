-- 03_join_spend_ranking.sql
-- Purpose: Join weekly spend with weekly ranking score to build a store-week analysis dataset
-- Output columns: store_id, week_of_year, weekly_spend, ranking_score_weekly
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
),
ranking_weekly AS (
  SELECT
    store_id,
    WEEKOFYEAR(TO_DATE(day, 'yyyymmdd')) AS week_of_year,
    AVG(ranking_score) AS ranking_score_weekly
  FROM ranking_fact_daily
  WHERE SUBSTR(day, 1, 4) = '2023'
    AND SUBSTR(day, 5, 2) IN ('01', '02')
  GROUP BY store_id, WEEKOFYEAR(TO_DATE(day, 'yyyymmdd'))
)
SELECT
  a.store_id,
  a.week_of_year,
  a.weekly_spend,
  b.ranking_score_weekly
FROM spend_weekly a
LEFT JOIN ranking_weekly b
  ON a.store_id = b.store_id
 AND a.week_of_year = b.week_of_year;
