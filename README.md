**JobScope UK** is a cloud-native data analytics project that tracks regional job trends in the UK using live data from Adzuna. It was built to simulate a real-world market intelligence platform using modern tools like **AWS**, **Snowflake**, **Tableau**, and **Python**.

---

- Dashboard: https://public.tableau.com/app/profile/syed.sareem.ahmed/viz/JobscopeUKdashboard/Dashboard1
- Notion docs: https://www.notion.so/Jobscope-UK-1fae86b95d2080cdadced495c488e2c7?pvs=4

## Why This Project?

This started as a portfolio challenge to go beyond static datasets and demonstrate that I could work with **real APIs**, **cloud architecture**, and **enterprise tools**. While the data processing could have been simpler, I chose AWS and Snowflake to show I can think at scale.

---

## What It Shows

- **Job Density by Region**
- **Top Job Categories & Hiring Cities**
- **Average Salaries by Region & Role**
- **Demand Trends**
- **Interactive Filters & Region Drilldowns**

---

## Architecture
Adzuna API
↓
Python (API Pull)
↓
Amazon S3 (raw JSON)
↓
Snowflake (raw → clean → insights)
↓
Tableau (dashboards with extracts)

---

## Tech Stack

| Layer            | Tools Used                          |
|------------------|-------------------------------------|
| API & Ingestion  | Python, Requests                    |
| Storage          | Amazon S3                           |
| Data Warehouse   | Snowflake                           |
| Transformation   | SQL (Snowflake SQL, JSON flattening)|
| Visualization    | Tableau                             |
| Docs & Versioning| GitHub, Notion                      |

---

## Project Structure

- /docs/ → ETL, S3, and Snowflake docs
- /python/ → Adzuna fetch script
- /snowflake/ → SQL scripts and schema logic
- /tableau/ → Extracts, screenshots, exportable .twbx

---

## What This Proves

- I can integrate multiple data sources and cloud tools
- I can build full pipelines, not just isolated charts
- I know how to structure and communicate technical projects like a Business Analyst or Product Owner

---

## Limitations

- Snowflake free tier (manual loads instead of automated streaming)
- Static snapshot, not real-time pipeline
- Region mapping was manual for some locations

---

## What I’d Add If I Scaled This

- Snowpipe or Lambda for automated ingestion
- Multi-source data integration (education, immigration, hiring patterns)
- Real-time regional insights dashboards with CI/CD

---

> This is a portfolio project. I’m continuously learning — open to feedback and collaboration!
