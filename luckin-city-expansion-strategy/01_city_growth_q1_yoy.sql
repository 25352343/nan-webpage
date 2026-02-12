/*
Business Question:
    Which cities showed the fastest GMV YoY growth in 22Q1 vs 21Q1?

Business Value:
    - Compare Q1 vs Q1 to reduce seasonality effects
    - Support city expansion prioritization (growth + scale)
*/

WITH city_q1 AS (
    SELECT
        CASE 
            WHEN year = 2022 AND month < 4 THEN '22Q1'
            WHEN year = 2021 AND month < 4 THEN '21Q1'
        END AS quarter,
        city,
        SUM(gmv) AS city_gmv,
        COUNT(DISTINCT mendianid) AS store_count
    FROM data1.xxdd_all_huizong_month_dws
    WHERE ds > 1
      AND ((year = 2022 AND month < 4) OR (year = 2021 AND month < 4))
    GROUP BY 1, 2
),

q22 AS (SELECT * FROM city_q1 WHERE quarter = '22Q1'),
q21 AS (SELECT * FROM city_q1 WHERE quarter = '21Q1')

SELECT
    q22.city,
    q22.city_gmv AS gmv_22q1,
    q21.city_gmv AS gmv_21q1,
    (q22.city_gmv - COALESCE(q21.city_gmv, 0)) AS delta_gmv,
    CASE 
        WHEN COALESCE(q21.city_gmv, 0) > 0 THEN q22.city_gmv / q21.city_gmv - 1
        ELSE NULL
    END AS yoy_gmv_growth,
    q22.store_count AS store_count_22q1,
    q21.store_count AS store_count_21q1,
    (q22.store_count - COALESCE(q21.store_count, 0)) AS store_delta,
    CASE
        WHEN COALESCE(q21.store_count, 0) > 0 THEN q22.store_count * 1.0 / q21.store_count - 1
        ELSE NULL
    END AS yoy_store_growth
FROM q22
LEFT JOIN q21
  ON q22.city = q21.city
WHERE COALESCE(q21.city_gmv, 0) >= 10000
ORDER BY yoy_gmv_growth DESC;
