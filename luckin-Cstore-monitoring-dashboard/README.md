
# Luckin C-Store Risk Monitoring Dashboard (Tableau)

A Tableau dashboard project for monitoring **C-class stores** and diagnosing operational drivers.  
It includes two dashboards:

- **Dashboard 1 — Accountability Panel:** KPI + trends + WoW changes + operator heatmap for responsibility drill-down  
- **Dashboard 2 — Diagnostic Panel:** driver analysis by store attributes and ops metrics, plus a **structural risk watchlist** (≥ 8 consecutive weeks as C)

---

## Live Dashboards (Tableau Public)

- **Dashboard 1 (Accountability Panel):** https://public.tableau.com/authoring/C_store_risk_monitor/Dashboard1#1  
- **Dashboard 2 (Diagnostic Panel):** https://public.tableau.com/authoring/C_store_risk_monitor/Dashboard2#1  

> If the links open in authoring mode, switch to *View* mode in the Tableau Public UI.

---

## Dashboard Previews

### Dashboard 1 — Accountability Panel
![](./Dashboard%201.png)

**What it answers**
- How large is the C-store risk (ratio / count), and how is it changing week over week?
- Which **Business Division / Delivery Operator** is contributing most to WoW increases?
- How does C-store GMV compare to overall performance (gap tracking)?

---

### Dashboard 2 — Diagnostic Panel
![](./Dashboard%202.png)

**What it answers**
- What are the likely drivers behind stores becoming C-class (business circle type, store type, lifecycle)?
- How do operational signals differ across A/B/C groups (ad spend, negative rate, delivery time)?
- Which stores are **structurally high risk** (C for ≥ 8 consecutive weeks) and need systematic actions?

---

## Repository Contents

- `README.md` — project overview + live links + preview images  
- `Dashboard 1.png` — preview image for Dashboard 1  
- `Dashboard 2.png` — preview image for Dashboard 2  
- `modelling.md` — data model & metric definitions (sources, joins, calculated fields, and dashboard mapping)

---

## Data & Metric Definitions

For detailed definitions (data grain, joins, calculated fields, and metric formulas), see **`modelling.md`**.

---

## Notes

- This repository is intended for portfolio/demo use.  
- For privacy and portability, raw datasets and Tableau workbook files (`.twb/.twbx`) are fake.
