# Snowflake Setup & Usage

This document details how Snowflake was used to warehouse, clean, and model job listing data for the JobScope UK dashboard project.

---

## Purpose

- Serve as the **cloud data warehouse** for Adzuna job listings
- Perform **data cleaning, deduplication, and aggregation**
- Simulate enterprise-scale analytics pipelines using modern architecture

---

## 🗃️ Database & Schema Structure
JSCOPE_DB/
├── RAW/
│ └ JOBS_RAW ← Raw JSON from Adzuna via S3
├── CLEAN/
│ └ JOBS_FINAL ← Flattened, structured job records
├── INSIGHTS/
└ DASH_KPIS ← Aggregated view for Tableau


---

## S3 Integration via External Stage

- Created a `STORAGE INTEGRATION` using IAM Role with read-only S3 access
- Defined an external `STAGE` pointing to `s3://<bucket-name>/raw/`
- Used `COPY INTO` command to load raw JSON into Snowflake

---

## Data Transformation Steps

1. **RAW Layer**  
   - Table: `JOBS_RAW`
   - Loaded directly from JSON file
   - Schema: `v VARIANT`, `load_ts TIMESTAMP`

2. **CLEAN Layer**  
   - Table: `JOBS_FINAL`
   - Used `LATERAL FLATTEN()` to extract nested job records
   - Added explicit typing to all fields
   - Included deduplication using `ROW_NUMBER()`

3. **INSIGHTS Layer**  
   - View: `DASH_KPIS`
   - Aggregates job count and average salary per city/region/category
   - Used in Tableau as the main data source

---

## Sample Queries

```sql
-- Count all records
SELECT COUNT(*) FROM CLEAN.JOBS_FINAL;

-- Sample aggregation
SELECT category, AVG((salary_min + salary_max)/2) AS avg_salary
FROM CLEAN.JOBS_FINAL
GROUP BY category;
