/*
QUESTION: What are the top data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and salary benchmarks for remote positions in this field.
- BONUS: Included skills required for these top-paying roles.
*/

SELECT 
    j.job_id,
    j.job_title_short,
    c.name AS company_name,
    j.job_location,
    j.job_schedule_type,
    j.salary_year_avg,
    j.job_posted_date::DATE AS posting_date,  
    STRING_AGG(s.skills, ', ') AS required_skills  
FROM
    job_postings_fact AS j
LEFT JOIN company_dim AS c
    ON j.company_id = c.company_id
LEFT JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
LEFT JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_work_from_home = TRUE AND 
    j.salary_year_avg IS NOT NULL
GROUP BY
    j.job_id,
    j.job_title_short,
    c.name,
    j.job_location,
    j.job_schedule_type,
    j.salary_year_avg,
    j.job_posted_date
ORDER BY
    j.salary_year_avg DESC
LIMIT 10;