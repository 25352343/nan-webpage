# C-Store Risk Monitoring Dashboard — Data Modelling

This document describes the data model and metric definitions used by the Tableau dashboards:
1) **Accountability Panel** (for ownership / responsibility drill-down)  
2) **Diagnostic Panel** (for driver analysis and structural risk watchlist)

---

## 1. Data grain and keys

- **Primary analysis grain:** `Store ID × Week`
- **Business key:** `Store ID`
- **Date field:** `Date` (weekly bucket recommended: `DATETRUNC('week', [Date])`)

> Note: the original raw performance table is at **daily** level and was extracted/aggregated to **weekly** level via SQL before building the dashboard.

---

## 2. Source tables

### 2.1 `Table1_Fact_Weekly` (Fact)

**Purpose:** weekly store performance on the delivery platform (orders, impressions, rating, GMV, marketing spend, etc.).

**Key fields**
- `Store ID` (primary key), `Platform Store ID`

**Location / business circle**
- `Province`, `City`, `Business Circle ID`, `Business Circle Ranking`

**Time**
- `Date`

**Metrics (raw fields, names match the Excel)**
- `Order Count`
- `Impressions`
- `Cancel/Refund Order Count`
- `Store Rating`
- `Avg Delivery Time (min)`
- `Negative Reviews`
- `Total Reviews`
- `GMV`
- `Ad Spend`
- `Free Drink & Coupon Spend`
- `ABC Class (Derived)` (A/B/C)

---

### 2.2 `Table2_Org_Mapping` (Dim)

**Purpose:** org ownership and responsibility chain for drill-down and accountability.

**Key fields**
- `Store ID`, `Province`, `City`, `Region ID`, `Division ID`, `Business Circle ID`, `Business Division`

**Roles**
- `Regional Manager`
- `Division Manager`
- `Delivery Operator` (Meituan delivery operations owner; one operator manages multiple stores)
- `Store Manager` (in-store daily management such as scheduling, hygiene, etc.; one store has one store manager)

**Org notes (business logic)**
- One `Region ID` maps to **one** `Regional Manager`.
- One region covers **multiple** `Business Division`.
- Each `Business Division` covers multiple cities and multiple `Delivery Operator`.

---

### 2.3 `Table3_Store_Info` (Dim)

**Purpose:** store attributes for segmentation and diagnostic analysis.

**Key fields**
- `Store ID`, `Province`, `City`

**Lifecycle & type**
- `Opening Date`, `Closing Date`
- `Store Lifecycle Status` (e.g., `new`, `mature`, `closed`)
- `Store Type` (e.g., `direct-operated`, `franchised`)

**Business circle type**
- `Business Circle Type` (e.g., office building / mall / residential / campus)

---

### 2.4 `Structural_C_Stores_8W` (Derived)

**Purpose:** identify structural-risk stores that are **C** for **≥ 8 consecutive weeks** (to reduce false alarms driven by short-term campaigns).

**Key fields (names match the Excel)**
- `Store ID`
- `Streak Start Week`, `Streak End Week`
- `Consecutive Weeks (C)`
- Responsibility fields: `Business Division`, `Division ID`, `Division Manager`, `Delivery Operator`, `Store Manager`
- Store attributes: `Store Lifecycle Status`, `Store Type`, `Business Circle Type`, `Opening Date`

> Note: this table is prepared in SQL because Tableau is not ideal for heavy historical streak computation.

---

## 3. Relationships (join logic)

- **Join key:** `Store ID` for all tables
- Recommended model (Tableau relationships):
  - `Table1_Fact_Weekly` as the main fact
  - `Table2_Org_Mapping` as a dimension (left)
  - `Table3_Store_Info` as a dimension (left)
  - `Structural_C_Stores_8W` used as:
    - a separate data source for the watchlist **or**
    - a left join to tag structural-risk stores

---

## 4. Calculated fields (Tableau)

> All formulas below are written in Tableau syntax. Base field names follow the Excel columns.

### 4.1 Time control

**Keep Latest Week (Boolean)**  
Use this to keep KPI cards on the most recent week (can coexist with a Week filter).

```tableau
DATETRUNC('week', [Date]) = { FIXED : MAX(DATETRUNC('week', [Date])) }
```

---

### 4.2 A/B/C classification

The weekly fact already contains `ABC Class (Derived)`.  

```sql
IF [Business Circle Ranking] >= 0.90 THEN "A"
ELSEIF [Business Circle Ranking] >= 0.65 THEN "B"
ELSE "C"
END
```
---

### 4.3 Store counts and ratios

**Active Store Count**  
Definition example: store is “active” if `GMV > 0` in the selected week.

```tableau
COUNTD( IF [GMV] > 0 THEN [Store ID] END )
```

**C Store Count**

```tableau
COUNTD( IF [Is C Store] THEN [Store ID] END )
```

**C Store Ratio**

```tableau
ZN([C Store Count]) / NULLIF([Active Store Count], 0)
```

---

### 4.4 GMV metrics

**Avg GMV (All Stores)**

```tableau
SUM([GMV]) / NULLIF([Active Store Count], 0)
```

**Avg GMV (C Stores)**

```tableau
SUM( IF [Is C Store] THEN [GMV] END ) / NULLIF([C Store Count], 0)
```

**GMV Gap (C vs All)**  
Definition: `(Avg GMV of C Stores / Avg GMV of All Stores) `

```tableau
([Avg GMV (C Stores)] / NULLIF([Avg GMV (All Stores)], 0)) 
```

---

### 4.5 Marketing and review metrics

**Avg Ad Spend per Store**

```tableau
SUM([Ad Spend]) / NULLIF([Active Store Count], 0)
```

**Negative Review Rate**  
Definition: `Negative Reviews / Total Reviews`

```tableau
SUM([Negative Reviews]) / NULLIF(SUM([Total Reviews]), 0)
```

---

### 4.6 WoW (week-over-week) and display helpers

> WoW fields are table calculations. Ensure the view is ordered by Week and `LOOKUP(..., -1)` refers to the previous week.

**WoW - C Store Count**

```tableau
[C Store Count] - LOOKUP([C Store Count], -1)
```

**WoW - C Store Ratio**

```tableau
[C Store Ratio] - LOOKUP([C Store Ratio], -1)
```

**WoW Count - Arrow Text**

```tableau
IF [WoW - C Store Count] > 0 THEN "▲"
ELSEIF [WoW - C Store Count] < 0 THEN "▼"
ELSE "–"
END
```

**WoW Count - Color**

```tableau
IF [WoW - C Store Count] > 0 THEN "up"
ELSEIF [WoW - C Store Count] < 0 THEN "down"
ELSE "flat"
END
```

**WoW Rank** (for operator heatmap / ranking)

```tableau
RANK_DENSE([WoW - C Store Count], 'desc')
```

---

## 5. Structural C-store definition (8-week streak)

A store is considered **structural C-store** if:

- `Consecutive Weeks (C) >= 8` in `Structural_C_Stores_8W`

This watchlist is used in the Diagnostic Panel to surface stores that require systematic actions (instead of short-term campaign effects).

---

## 6. Dashboard mapping (model → visuals)

### 6.1 Dashboard 1 — Accountability Panel

**Goal:** show overall risk KPI and drill down to `Division ID` / `Delivery Operator`.

**Filters**
- Week (optional), and/or `Keep Latest Week = TRUE`
- `Division ID` / `Business Division` (for drill-down)

**KPI cards**
- `C Store Ratio` + `WoW - C Store Ratio`
- `C Store Count` + `WoW - C Store Count`
- `Avg GMV (C Stores)`
- `GMV Gap (C vs All)`

**Trends**
- `C Store Ratio` by Week (overall and by division)
- `WoW - C Store Count` by Week (to see increase/decrease dynamics)

**Operator heatmap**
- Dimensions: `Division ID`, `Delivery Operator`
- Measures: `WoW - C Store Count` (or `WoW - C Store Ratio`)
- Ranking: `WoW Rank`

---

### 6.2 Dashboard 2 — Diagnostic Panel

**Goal:** explain why stores become C-class using store attributes and operational metrics, and provide the structural-risk watchlist.

**Segmentation**
- `Business Circle Type` → `C Store Ratio`(single-week slice)
- `Store Type` (direct-operated / franchised) share within C-stores (trend)
- `Store Lifecycle Status` share within C-stores (trend)

**Operational comparisons (by `ABC Class (Derived)`)**
- `Negative Review Rate` (trend)
- `Avg Delivery Time (min)` (single-week slice, e.g., boxplot)
- `Ad Spend` / `Avg Ad Spend per Store`  (trend)

**Watchlist**
- use `Structural_C_Stores_8W` to list structural-risk stores with responsibility fields for action follow-up

---

## 7. Data quality notes

1. Keep one consistent definition of **Active Store** (e.g., `GMV > 0` or `Order Count > 0`) across all metrics.
2. WoW table calculations depend on correct Week ordering and compute settings in Tableau.
3. Structural streak computation should be done upstream (SQL) for performance and auditability.
