/*
QUESTION: How do different skills impact salary for Data Analysts?
- Compare average salaries for Data Analyst roles grouped by required skills
- Focuses on remote positions with specified salaries
- Why? Shows which skills correlate with higher pay, helping professionals 
  make informed decisions about skill investments
*/

SELECT 
    s.skills,
    COUNT(j.job_id) AS job_count,
    ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_work_from_home = TRUE AND
    j.salary_year_avg IS NOT NULL
GROUP BY
    s.skills
HAVING
    COUNT(j.job_id) > 1  -- Only show skills with multiple occurrences
ORDER BY
    avg_salary DESC
LIMIT 25;

