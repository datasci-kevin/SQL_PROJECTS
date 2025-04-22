/*
FINAL ANALYSIS: Top 5 Skills by Job Category
- Shows only the most relevant skills for each role (top 5 by percentage)
- Filters out skills that appear in less than 5% of job postings
- Why? Provides focused, actionable insights without noise
*/

WITH job_category_counts AS (
    SELECT 
        job_title_short,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    WHERE 
        job_title_short IN ('Data Engineer', 'Data Analyst', 'Data Scientist')
    GROUP BY 
        job_title_short
),

skills_by_job AS (
    SELECT 
        j.job_title_short,
        s.skills,
        COUNT(*) AS skill_count,
        jc.total_jobs,
        ROUND((COUNT(*) * 100.0 / jc.total_jobs), 1) AS skill_percentage,
        ROW_NUMBER() OVER (
            PARTITION BY j.job_title_short 
            ORDER BY COUNT(*) DESC
        ) AS skill_rank
    FROM 
        job_postings_fact j
    INNER JOIN skills_job_dim sj ON j.job_id = sj.job_id
    INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
    INNER JOIN job_category_counts jc ON j.job_title_short = jc.job_title_short
    WHERE 
        j.job_title_short IN ('Data Engineer', 'Data Analyst', 'Data Scientist')
    GROUP BY 
        j.job_title_short, s.skills, jc.total_jobs
)

SELECT 
    job_title_short,
    skills,
    skill_count,
    total_jobs,
    skill_percentage
FROM 
    skills_by_job
WHERE 
    skill_rank <= 5
    AND skill_percentage >= 5  
ORDER BY 
    job_title_short,
    skill_percentage DESC;

    