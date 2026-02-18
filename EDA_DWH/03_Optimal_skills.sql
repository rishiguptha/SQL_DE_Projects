/*
    Question: What are the most optimal skills for data engineers—balancing both demand and salary?
    - Create a ranking column that combines demand count and median salary to identify the most valuable skills.
    - Focus only on remote Data Engineer positions with specified annual salaries.
    -Narrow down to united states
    - Why?
        - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
        - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000,2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE 
    AND jpf.job_country = 'United States'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
    optimal_score DESC
LIMIT 25;



/*

Here's the breakdown:
optimal_score is the normalized score combining median_salary and ln_demand_count (log of demand) to balance salary and frequency
ln_demand_count is the natural log of demand_count, smoothing out the exponential skew seen in the raw optimal score

Terraform ranks #1 in optimal score (0.96) driven by its commanding $192,750 salary despite lower demand (146 postings)
Python and SQL remain top 3 despite lower salaries, sustained by their massive demand (853 and 850 postings respectively)
Airflow breaks into the top 4 with a strong balance of solid salary ($154,000) and healthy demand (298 postings)

Key takeaways:
- Terraform is the #1 optimal skill — highest salary in the dataset rewards it even with modest demand
- Python and SQL hold top positions because sheer volume of demand keeps them competitive even with lower salaries
- Airflow and Spark are the best balanced big data/pipeline tools — solid salary AND meaningful demand
- Kubernetes and Git punch above their weight — lower demand but high enough salary to stay in top 10
- Tableau, SQL Server, and Power BI sit at the bottom — lower salaries drag their scores despite decent demand
- The log transformation reveals a much more competitive and nuanced landscape than the raw score suggested


┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      192750.0 │          146 │             5.0 │          0.96 │
│ python     │      135500.0 │          853 │             6.7 │          0.91 │
│ aws        │      140000.0 │          583 │             6.4 │          0.89 │
│ airflow    │      154000.0 │          298 │             5.7 │          0.88 │
│ sql        │      130000.0 │          850 │             6.7 │          0.88 │
│ spark      │      140000.0 │          369 │             5.9 │          0.83 │
│ snowflake  │      139500.0 │          352 │             5.9 │          0.82 │
│ git        │      150500.0 │          176 │             5.2 │          0.78 │
│ azure      │      130000.0 │          358 │             5.9 │          0.76 │
│ kafka      │      140000.0 │          189 │             5.2 │          0.73 │
│ scala      │      137500.0 │          185 │             5.2 │          0.72 │
│ kubernetes │      155000.0 │          101 │             4.6 │          0.72 │
│ databricks │      135500.0 │          202 │             5.3 │          0.72 │
│ java       │      130000.0 │          214 │             5.4 │           0.7 │
│ redshift   │      130000.0 │          198 │             5.3 │          0.69 │
│ pyspark    │      140000.0 │          120 │             4.8 │          0.67 │
│ hadoop     │      135000.0 │          144 │             5.0 │          0.67 │
│ nosql      │      135500.0 │          138 │             4.9 │          0.67 │
│ gcp        │      136000.0 │          119 │             4.8 │          0.65 │
│ r          │      135290.0 │          116 │             4.8 │          0.64 │
│ power bi   │      120070.0 │          111 │             4.7 │          0.57 │
│ sql server │      120000.0 │          116 │             4.8 │          0.57 │
│ tableau    │      115000.0 │          133 │             4.9 │          0.56 │
├────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 23 rows                                                           5 columns │
└─────────────────────────────────────────────────────────────────────────────┘
*/