# S3 Bucket Setup & Usage

This document outlines how Amazon S3 was used in the JobScope UK project to store raw data and serve as the input for Snowflake.

---

## Purpose of S3 in This Project

- Temporary staging layer for job data fetched from the Adzuna API
- Data lake input for Snowflake via external stage
- Part of a simulated enterprise-level ETL workflow

---

## Bucket Details

- **Bucket Name**: `<your-bucket-name>`
- **AWS Region**: `eu-west-2` (London)
- **Folder Structure**:
s3://<your-bucket-name>/
└ raw/
└ adzuna_gb_full_2025-05-16.json
└ adzuna_gb_full_2025-05-17.json

- **Public Access**: Blocked (private)
- **Lifecycle Rules**: Optional auto-delete after X days

---

## IAM Role & Permissions

- IAM Role used: `AmazonS3ReadOnlyAccess`
- Integrated with Snowflake via `STORAGE_INTEGRATION`
- IAM permissions used instead of S3 bucket policy

---

## File Upload Process

- Jobs pulled using [`adzuna_fetch_jobs.py`](../python/adzuna_fetch_jobs.py)
- Output: structured JSON (~1000 jobs)
- Uploaded manually to the S3 `/raw/` folder via AWS Console

---
