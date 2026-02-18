/*
    Question: What are the most in-demand skills for data engineers?
    - Join job postings to inner join table similar to query 2
    - Identify the top 10 in-demand skills for data engineers
    - Focus on remote job postings
    - narrowing down in united states
    - Why? Retrieves the top 10 skills with the highest demand in the remote job market,
        providing insights into the most valuable skills for data engineers seeking remote work
    */


SELECT 
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE 
    AND jpf.job_country = 'United States'
GROUP BY 
    sd.skills
ORDER BY 
    demand_count DESC
LIMIT 10;

/*
Here's the breakdown:
demand_count is the total number of job posting for each skill
SQL, Python are the leading and most in-demand skills for data engineers in United States with 8665 and 8118 demand count respectively
Cloud platforms : AWS and Azure are the most in-demand cloud skills for Data Engineers
Apache Spark is at number 5 in-demand skill with 3766 demand count

Key takeaways:
- SQL and Python are the most fundamental and foundational skills for Data Engineers
- Cloud Platforms such as aws and azure are critical to companies for modern data engineering
- Big Data tools such as spark has the high value
- modern data warehousing tools and data pipeline tools (snowflake, databricks, airflow) are showing demand
- Java is at the bottom of top 10 in-demand skills


┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │         8665 │
│ python     │         8118 │
│ aws        │         5269 │
│ azure      │         4419 │
│ spark      │         3766 │
│ snowflake  │         2974 │
│ databricks │         2650 │
│ java       │         2507 │
│ airflow    │         2110 │
│ kafka      │         2018 │
├────────────┴──────────────┤
│ 10 rows         2 columns │
└───────────────────────────┘
*/


