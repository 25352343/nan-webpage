# Data Modeling & Processing Workflow

## 1. Project Background

This project builds a **weekly store risk monitoring analytical model** to:

- Identify underperforming stores using **relative MEITUAN delivery platform rankings**
- Avoid absolute metrics such as GMV or revenue, which are not directly comparable
- Support **multi-role responsibility attribution** (operations, regional, delivery roles)
- Enable drill-down analysis for operational decision-making

The model serves both **central strategy teams** and **regional execution teams**.

---

## 2. Data Sources Overview

### Table 1: MEITUAN Delivery Platform Business Circle Weekly Report (Fact Table)

Represents weekly relative performance of each store on the delivery platform.

**Core Fields**
- Store ID (primary key)
- Platform Store ID
- Province, City
- Business Circle Ranking (0–1)
- Date (yyyymmdd)

This table acts as the **only fact table**.

---

### Table 2: Store Mapping & Responsibility Table (Dimension)

Provides organizational ownership, operational roles, and store attributes.

**Core Fields**
- Store ID
- Province, City
- Store Type (direct-operated / franchised)
- Operations Manager
- Regional Manager
- Delivery Operator
- Store Manager
- Business Division

Operations Manager and Delivery Operator are **parallel roles** with no direct reporting relationship.

---

### Table 3: Store Lifecycle Information (Dimension)

Defines store lifecycle stage to adjust risk tolerance.

**Core Fields**
- Store ID
- Province, City
- Opening Date
- Closing Date
- Store Lifecycle Status (new / mature / closed)

---

## 3. Table Join Logic

All tables are joined using **Store ID** as the primary key, forming a unified
**weekly analytical wide table**.

---

## 4. Metrics & Derived Fields Design

### Time Standardization
- Convert yyyymmdd into Year and Week of Year
- Unified display format: `YYYY-WW`

### Store Performance Classification (ABC)
Stores are classified based on business circle ranking:
- A: ≥ 0.90
- B: 0.65 – 0.90
- C: < 0.65

This relative metric avoids scale and location bias and enables fair comparison.

### C-grade Store Ratio (Core Dashboard Metric)

**Definition**
Distinct count of C-grade stores /
Distinct count of all active stores

**Purpose**
Quantifies the proportion of structurally underperforming stores and enables
comparison across divisions, Delivery Operator and time.

### Week-over-Week Change & Improvement Ranking

- WoW Change measures week-over-week movement of C-grade Store Ratio
- Improvement Ranking orders delivery operators by WoW change within the same week

These metrics help distinguish short-term fluctuation from structural issues
and support operational prioritization.

### Drill-down Design

Drill-down views reuse the same metric definitions while changing grouping
dimensions (division, delivery operator, store), ensuring metric consistency
across overview and detail-level dashboards.

---

## 5. Data Filtering Rules

- Exclude closed stores
- Exclude stores without assigned delivery operator

Ensures all records are actionable.

---

## 6. Final Output Schema

**Time**
- Year, Week

**Store**
- Store ID, Platform Store ID
- Province, City

**Performance**
- Business Circle Ranking
- ABC Store Grade
- C-grade Store Ratio
- WoW Change

**Responsibility**
- Operations Manager
- Regional Manager
- Delivery Operator
- Store Manager
- Business Division

**Attributes**
- Store Type
- Lifecycle Status
- Opening Date
- Closing Date

---

## 7. Modeling Principles

- Prefer relative platform metrics over absolute financial values
- Design metrics driven by dashboard and decision needs
- Support matrix organizational structures
- Ensure metric consistency and delivery readiness
