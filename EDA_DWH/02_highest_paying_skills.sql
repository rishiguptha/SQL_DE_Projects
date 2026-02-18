/*
    Question: What are the highest-paying skills for data engineers?
    - Calculate the median salary for each skill required in data engineer positions
    - Focus on remote positions with specified salaries
    - Narrowed down to united states
    - Include skill frequency to identify both salary and demand
    - Why? Helps identify which skills command the highest compensation while also showing 
        how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
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
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
    median_salary DESC
LIMIT 25;


/*
Here's the breakdown:
median_salary is the median salary across all job postings requiring that skill
demand_count is the total number of job postings for each skill

Terraform is the highest paying skill for Data Engineers in the United States with a median salary of $192,750
Kubernetes is the only skill that appears in both top 10 salary AND top 10 demand (960 postings), making it the most well-rounded skill

Key takeaways:
- Terraform is the standout top-paying skill, commanding $192,750 — infrastructure-as-code expertise is rare and highly compensated
- Spring (Java ecosystem) ranks #2 at $175,500 despite modest demand (172), showing backend framework specialization is well rewarded
- Kubernetes is the best risk-adjusted skill to learn — top 10 salary at $155,000 with nearly 1,000 job postings
- Most top-paying skills (graphql, mongo, golang, jupyter) are niche with low demand (<150 postings) — high ceiling but fewer doors
- Golang is the top-paying modern language in this list, reflecting strong market demand for performance-oriented backend engineers
- GDPR appearing in the top 10 highlights that data compliance and governance expertise is increasingly valued by employers


┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ terraform  │      192750.0 │          965 │
│ spring     │      175500.0 │          172 │
│ jupyter    │      156250.0 │          129 │
│ golang     │      156000.0 │          140 │
│ mongo      │      155527.0 │          111 │
│ graphql    │      155000.0 │          109 │
│ ruby       │      155000.0 │          206 │
│ bitbucket  │      155000.0 │          129 │
│ kubernetes │      155000.0 │          960 │
│ gdpr       │      155000.0 │          120 │
│ typescript │      155000.0 │          112 │
│ airflow    │      154000.0 │         2110 │
│ c          │      154000.0 │          159 │
│ ansible    │      153000.0 │          122 │
│ git        │      150500.0 │         1411 │
│ redis      │      150000.0 │          124 │
│ perl       │      148750.0 │          104 │
│ react      │      145750.0 │          138 │
│ looker     │      145000.0 │          426 │
│ dynamodb   │      141250.0 │          368 │
│ pyspark    │      140000.0 │         1361 │
│ word       │      140000.0 │          280 │
│ jenkins    │      140000.0 │          560 │
│ pandas     │      140000.0 │          422 │
│ aws        │      140000.0 │         5269 │
├────────────┴───────────────┴──────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘
*/