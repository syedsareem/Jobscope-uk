# ETL Pipeline Overview

This document explains the complete ETL workflow used in the JobScope UK dashboard project.

---

## 🔄 Pipeline Summary
Adzuna API
↓
adzuna_fetch_jobs.py
↓
Amazon S3 (raw JSON files)
↓
Snowflake External Stage
↓
Snowflake SQL Models (raw → clean → insights)
↓
Tableau Dashboard (data extracts)

---

## Step-by-Step Breakdown

### 1. Data Ingestion
- Python script connects to Adzuna API
- Fetches 1000 job listings across 20 pages
- Saved as `adzuna_gb_full_<date>.json`

### 2. Storage in S3
- File manually uploaded to a private bucket under `/raw/`
- Simulates a data lake landing zone

### 3. Snowflake Integration
- IAM Role + `STORAGE_INTEGRATION` used to link Snowflake with S3
- External stage created to reference `s3://<bucket>/raw/`
- JSON file loaded into `RAW.JOBS_RAW` via `COPY INTO`

### 4. Data Transformation
- Used `LATERAL FLATTEN()` to unpack nested JSON
- Built a clean table `CLEAN.JOBS_FINAL`
- Deduplicated by job ID using `ROW_NUMBER()`
- Aggregated into `INSIGHTS.DASH_KPIS` view

### 5. Visualization in Tableau
- Extracts data from Snowflake
- Dashboard shows job counts, average salaries, and demand across regions

---

##Notes

- Manual upload due to Snowflake free trial limitations
- Future versions can be automated using Lambda + Snowpipe
- ETL design simulates scalable enterprise-grade data flow

---

> Part of the JobScope UK portfolio project.
