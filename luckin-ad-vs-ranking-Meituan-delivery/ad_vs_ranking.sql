-- 00_store_week_spend_ranking.sql
-- Goal: store-week dataset (Jan–Feb) to study whether ad spend relates to ranking score.
-- Minimal DQ:
--   - Keep store-weeks that exist in ranking but not in spend (FULL OUTER JOIN).
--   - Treat missing spend as 0 (no ad spend record that week).

WITH
/* =========================
 (1) Weekly spend (from 01)
========================= */
spend_weekly AS (
  SELECT
    store_id,
    WEEKOFYEAR(TO_DATE(day)) AS week_of_year,
    SUM(ad_spend) AS weekly_spend_raw
  FROM ads_fact_daily
  WHERE YEAR(TO_DATE(day)) = 2023
    AND MONTH(TO_DATE(day)) IN (1, 2)
  GROUP BY store_id, WEEKOFYEAR(TO_DATE(day))
),

/* =========================
 (2) Weekly ranking (from 02)
   Note: ranking_fact_daily.day is a 'yyyymmdd' string, not a standard date.
========================= */
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
  COALESCE(s.store_id, r.store_id) AS store_id,
  COALESCE(s.week_of_year, r.week_of_year) AS week_of_year,
  COALESCE(s.weekly_spend_raw, 0) AS weekly_spend,
  r.ranking_score_weekly
FROM spend_weekly s
FULL OUTER JOIN ranking_weekly r
  ON s.store_id = r.store_id
 AND s.week_of_year = r.week_of_year;
