-- STEP 4: Creating Skills Mart

DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHEMA skills_mart;

SELECT '=== Loading Skills Mart ===' AS info;

SELECT '=== Creating dim_skills ===' AS info;
CREATE TABLE skills_mart.dim_skills(
    skill_id    INTEGER PRIMARY KEY,
    skills      VARCHAR,
    type        VARCHAR
);

INSERT INTO skills_mart.dim_skills(skill_id, skills, type)
SELECT  
    skill_id,
    skills,
    type
FROM skills_dim;

SELECT '=== Creating dim_date_month ===' AS info;
CREATE TABLE skills_mart.dim_date_month(
    month_start_date DATE   PRIMARY KEY,
    year             INTEGER,
    month            INTEGER,
    quarter          INTEGER, 
    quarter_name     VARCHAR,
    year_quarter     VARCHAR
);


INSERT INTO skills_mart.dim_date_month(month_start_date, year, month, quarter, quarter_name, year_quarter)
SELECT DISTINCT
    DATE_TRUNC('month' , job_posted_date) AS month_start_date,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(QUARTER FROM job_posted_date) AS quarter,
    'Q' || EXTRACT(QUARTER FROM job_posted_date) :: VARCHAR AS quarter_name,
    EXTRACT(YEAR FROM job_posted_date) :: VARCHAR || '-Q' || 
    EXTRACT(QUARTER FROM job_posted_date) :: VARCHAR
FROM job_postings_fact
ORDER BY month_start_date;


SELECT '=== Creating fact_skill_demand_monthly ===' AS info;
CREATE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id                        INTEGER,
    month_start_date                DATE,
    job_title_short                 VARCHAR,
    postings_count                  INTEGER,
    remote_postings_count           INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_mention_count         INTEGER,

    PRIMARY KEY (skill_id,month_start_date,job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);


INSERT INTO skills_mart.fact_skill_demand_monthly(
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_mention_count
)
WITH job_posting_prep AS (
SELECT 
    sjd.skill_id,
    DATE_TRUNC('month' , job_posted_date) AS month_start_date,
    jpf.job_title_short,
    --convert boolean flags (0 or 1)
    CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
    CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
    CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mentioned
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id)
SELECT 
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,    
    SUM(is_remote) AS remote_postings_count,
    SUM(has_health_insurance) AS health_insurance_postings_count,
    SUM(no_degree_mentioned) AS no_degree_mentioned_postings_count
FROM job_posting_prep
GROUP BY ALL
ORDER BY skill_id,month_start_date,job_title_short;


-- ============================================
-- DATA VALIDATION
-- ============================================

-- Verifying the table record counts
SELECT 'Skills Mart - Dim Skills' AS table_name, COUNT(*) AS record_count FROM skills_mart.dim_skills
UNION ALL
SELECT 'Skills Mart - Dim Date Month', COUNT(*) FROM skills_mart.dim_date_month
UNION ALL
SELECT 'Skills Mart - Fact Skill Demand Monthly', COUNT(*) FROM skills_mart.fact_skill_demand_monthly;

-- Show sample data
SELECT '=== Dim Skills Sample ===' AS info;
SELECT * FROM skills_mart.dim_skills LIMIT 5;

SELECT '=== Dim Date Month Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month LIMIT 5;

SELECT '=== Fact Skill Demand Monthly Sample ===' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 5;
