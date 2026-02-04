# Ad Spend vs Marketplace Ranking (Meituan) — Jan–Feb (Store-Week)

A short growth analytics case study on a simple question from ops:  
**If we spend more on promotion, do we actually get a better marketplace ranking score?**

This repo uses a **store-week** dataset (8 weeks, Jan–Feb 2023) and focuses on the direct relationship between weekly spend and the platform’s ranking score (0–1).

---

## What’s in the data
**Columns**
- `store_id`
- `week_of_year` (8 weeks)
- `weekly_spend`
- `ranking_score_weekly` (0–1, higher is better)

**How it’s built (schema-generalised)**
- `ads_fact_daily`: store-level daily ad spend (Meituan)
- `ranking_fact_daily`: store-level daily ranking score
- Aggregated to week and joined into one table

> Public repo uses anonymised/synthetic data due to confidentiality. The same code and workflow run on the original dataset.

---

## What I did
1) Built a clean **store-week** dataset from daily spend + daily ranking.  
2) Visualised the relationship in three ways:
   - **Scatter** (log(1+spend) vs ranking score)
   - **Spend buckets** (deciles) → average ranking
   - **Baseline segmentation** (low/mid/high based on *previous-week* ranking) → spend buckets within each cohort

---

## SQL (dataset build)
SQL scripts used to create the store-week table are in [`/sql`](sql/).  
(Queries are schema-generalised for confidentiality.)

---

## Results (from charts)
### 1) Spend and ranking move together, but there’s a lot of noise
The scatter shows a clear upward trend: higher spend generally aligns with higher ranking score.  
At the same time, the variance is big — stores with similar spend can land in very different ranking ranges, so spend is not the only driver.

![Scatter](01_scatter_log_spend_vs_ranking.png)

### 2) Ranking improves across spend deciles
When I bucket stores by weekly spend deciles (D1 → D10), average ranking increases steadily.
In this sample, the mean ranking goes from roughly **0.63 (D1)** to **0.79 (D10)**.

![Spend buckets](02_spend_buckets_mean_ranking.png)

### 3) Baseline matters: high baseline stays high, mid baseline looks most “responsive”
I split store-weeks into **low / mid / high baseline** cohorts using **previous-week ranking**.  
All three cohorts trend upward with spend, but the picture is different:
- **High baseline** stores start high and remain high; spend still helps, but the curve is flatter.
- **Mid baseline** stores show a strong lift as spend increases (especially in higher spend buckets).
- **Low baseline** stores do improve with spend, but they remain well below the other cohorts — suggesting fundamentals may be limiting.

![Baseline segmentation](03_baseline_cohort_spend_vs_ranking.png)

---

## What I’d do with this (practical takeaways)
- Treat spend as a lever, but **don’t expect it to explain everything** (scatter variance is large).
- For budget allocation, start with cohort logic:
  - **Mid baseline** stores are good candidates for incremental spend.
  - **Low baseline** stores may need ops/product fixes first (menu, reviews, delivery, etc.) before spend can translate into ranking.
  - **High baseline** stores are already strong; evaluate incremental spend against marginal gains.

---

## Limitations
This is observational over a short window (8 weeks). The relationship shown is correlational and could be affected by seasonality, promotions, store quality, local competition, and other factors not included here.


