/*
QUESTION: Top-Paying Data Engineer Jobs by Company
- Identifies companies with the highest average salaries for Data Engineer roles
- Shows required skills for these high-paying positions
- Why? Helps professionals target companies and skill sets that offer top compensation
*/



WITH top_companies AS (
    SELECT 
        j.company_id,
        c.name AS company_name,
        ROUND(AVG(j.salary_year_avg), 0) AS avg_company_salary
    FROM 
        job_postings_fact AS j
    LEFT JOIN company_dim AS c 
        ON j.company_id = c.company_id
    WHERE 
        j.job_title_short = 'Data Engineer' 
        AND j.salary_year_avg IS NOT NULL
    GROUP BY 
        j.company_id, c.name
    ORDER BY 
        avg_company_salary DESC
    LIMIT 10
),

company_jobs AS (
    SELECT 
        j.job_id,
        j.company_id,
        tc.company_name,
        tc.avg_company_salary,  
        j.salary_year_avg AS individual_salary,
        j.job_location,
        j.job_work_from_home
    FROM 
        job_postings_fact AS j
    INNER JOIN top_companies AS tc 
        ON j.company_id = tc.company_id
    WHERE 
        j.salary_year_avg IS NOT NULL
)

SELECT 
    cj.company_name,
    cj.avg_company_salary,
    cj.job_location,
    cj.job_work_from_home,
    STRING_AGG(DISTINCT s.skills, ', ') AS required_skills,
    COUNT(DISTINCT cj.job_id) AS job_count
FROM 
    company_jobs AS cj
INNER JOIN skills_job_dim AS sj 
    ON cj.job_id = sj.job_id
INNER JOIN skills_dim AS s 
    ON sj.skill_id = s.skill_id
GROUP BY 
    cj.company_name, 
    cj.avg_company_salary, 
    cj.job_location, 
    cj.job_work_from_home
ORDER BY 
    cj.avg_company_salary DESC;