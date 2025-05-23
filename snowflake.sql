-- --------------------------------------------------
-- Snowflake Setup and Data Pipeline for JobScope UK
-- --------------------------------------------------

-- STEP 1: Create the main database
CREATE OR REPLACE DATABASE JSCOPE_DB;

-- STEP 2: Create layered schemas for modularity
CREATE OR REPLACE SCHEMA JSCOPE_DB.RAW;
CREATE OR REPLACE SCHEMA JSCOPE_DB.CLEAN;
CREATE OR REPLACE SCHEMA JSCOPE_DB.INSIGHTS;

SHOW SCHEMAS IN DATABASE JSCOPE_DB;

-- --------------------------------------------------
-- STEP 3: Connect Snowflake to AWS S3 via Storage Integration
-- --------------------------------------------------
CREATE STORAGE INTEGRATION snowflake_si
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<REDACTED>:role/SnowflakeSiRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucketname/raw/');

DESC INTEGRATION snowflake_si;

-- --------------------------------------------------
-- STEP 4: Set context and define external stage
-- --------------------------------------------------
USE DATABASE JSCOPE_DB;
USE SCHEMA RAW;

CREATE OR REPLACE STAGE raw_jobs_stage
  URL = 's3://mybucketname/raw/'
  STORAGE_INTEGRATION = snowflake_si;

-- Verify stage is connected properly
LIST @raw_jobs_stage;

-- --------------------------------------------------
-- STEP 5: Ingest data from S3 into RAW schema
-- --------------------------------------------------
CREATE OR REPLACE TABLE JOBS_RAW (
  v VARIANT,
  load_ts TIMESTAMP_LTZ
);

COPY INTO JOBS_RAW
FROM (
    SELECT $1, CURRENT_TIMESTAMP()
    FROM @raw_jobs_stage
)
FILES = ('adzuna_gb_p1_2025-05-16.json')
FILE_FORMAT = (TYPE = 'JSON');

-- Sample queries to inspect the data
SELECT COUNT(*) FROM JOBS_RAW;
SELECT v:title::string AS job_title FROM JOBS_RAW LIMIT 5;
SELECT v, load_ts FROM JOBS_RAW LIMIT 1;

-- Explore and flatten JSON
SELECT
    job.value:title::string AS job_title,
    job.value:company.display_name::string AS company,
    job.value:location.dsiplay_name::string AS city, -- typo to be corrected
    job.value:location.area[2]::string AS region,
    job.value:salary_min::float AS salary_min,
    job.value:salary_max::float AS salary_max,
    job.value:category.label::string AS category,
    job.value:contract_time::string AS contract_time,
    job.value:contract_type::string AS contract_type,
    job.value:created::timestamp_ntz AS posted_at,
    job.value:redirect_url::string AS apply_url
FROM JOBS_RAW,
LATERAL FLATTEN(input => v:results) AS job
LIMIT 10;

-- --------------------------------------------------
-- STEP 6: Clean and transform the data in CLEAN schema
-- --------------------------------------------------
USE DATABASE JSCOPE_DB;
USE SCHEMA CLEAN;

CREATE OR REPLACE TABLE JOBS_FINAL AS
SELECT
    job.value:title::string                AS job_title,
    job.value:company.display_name::string AS company,
    job.value:location.display_name::string AS city,
    job.value:location.area[2]::string     AS region,
    job.value:salary_min::float            AS salary_min,
    job.value:salary_max::float            AS salary_max,
    job.value:category.label::string       AS category,
    job.value:contract_time::string        AS contract_time,
    job.value:contract_type::string        AS contract_type,
    job.value:created::timestamp_ntz       AS posted_at,
    job.value:redirect_url::string         AS apply_url,
    CURRENT_TIMESTAMP()                    AS load_ts
FROM RAW.JOBS_RAW,
LATERAL FLATTEN(input => v:results) AS job;

SELECT * FROM JOBS_FINAL LIMIT 100;

-- --------------------------------------------------
-- STEP 7: Aggregate cleaned data in INSIGHTS schema
-- --------------------------------------------------
USE DATABASE JSCOPE_DB;
USE SCHEMA INSIGHTS;

CREATE OR REPLACE VIEW DASH_KPIS AS
SELECT
    city,
    region,
    category,
    COUNT(*) AS job_count,
    AVG((salary_min + salary_max)/2) AS avg_salary,
    MIN(posted_at) as earliest_posted,
    MAX(posted_at) as latest_posted
FROM CLEAN.JOBS_FINAL
GROUP BY city, region, category
ORDER BY job_count DESC;

SELECT * FROM DASH_KPIS LIMIT 10;

-- --------------------------------------------------
-- STEP 8: Reloading or Updating Data
-- --------------------------------------------------
-- Reload new raw data file
TRUNCATE TABLE RAW.JOBS_RAW;

COPY INTO RAW.JOBS_RAW
FROM (
  SELECT $1, CURRENT_TIMESTAMP()
  FROM @raw_jobs_stage
)
FILES = ('adzuna_gb_full_2025-05-17.json')
FILE_FORMAT = (TYPE = 'JSON');

-- Refresh cleaned data
TRUNCATE TABLE CLEAN.JOBS_FINAL;

-- Load deduplicated latest job records
INSERT INTO CLEAN.JOBS_FINAL
SELECT
  job.value:id::string                    AS job_id,
  job.value:title::string                 AS job_title,
  job.value:company.display_name::string AS company,
  job.value:location.display_name::string AS city,
  job.value:location.area[2]::string     AS region,
  job.value:salary_min::float            AS salary_min,
  job.value:salary_max::float            AS salary_max,
  job.value:category.label::string       AS category,
  job.value:contract_time::string        AS contract_time,
  job.value:contract_type::string        AS contract_type,
  job.value:created::timestamp_ntz       AS posted_at,
  job.value:redirect_url::string         AS apply_url,
  CURRENT_TIMESTAMP()                    AS load_ts
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY job.value:id::string ORDER BY job.value:created::timestamp_ntz DESC) AS row_num
  FROM RAW.JOBS_RAW,
       LATERAL FLATTEN(input => v:results) AS job
) deduped
WHERE row_num = 1;

-- End of JobScope UK Snowflake Pipeline Script

