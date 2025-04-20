/*
SELECT - specified the columns you want to work with
FROM → Identify the data source.
WHERE → Filter raw rows.
GROUP BY → Aggregate data.
HAVING → Filter aggregated groups.
SELECT → Choose columns to display.
ORDER BY → Sort the final output.
LIMIT → Trim results.
*/

-- Returning the top 10 job locations for data analyst

SELECT 
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' and salary_year_avg is NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;



SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist' and salary_year_avg IS NOT NULL 
    and job_location IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;


SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg BETWEEN 100000 AND 200000
ORDER BY
    salary_year_avg DESC
LIMIT 10;



SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM 
    job_postings_fact
WHERE 
    (job_location ILIKE '%houston%tx%' OR job_location ILIKE '%houston%texas%')  -- Grupo para ubicación
    AND job_title_short = 'Data Analyst'  -- Filtro adicional
    AND salary_year_avg IS NOT NULL       -- Filtro adicional
ORDER BY 
    salary_year_avg DESC
LIMIT 10;  -- Top 10 salarios más altos


-- Practice Problem 1 ---

-- Get job details for BOTH 'Data Analyst' or 'Business Analyst' positions
-- For Data analyst I want jobs only > $100k
-- For Business Analyst I want jobs only > 70k
-- Only include jobs located in either 'Boston, MA' or 'Anywhere'

SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM 
    job_postings_fact
WHERE
    job_location IN ('Boston', 'MA', 'Anywhere') AND
    (
    (job_title_short = 'Data Analyst' AND salary_year_avg > 100000) OR
    (job_title_short = 'Business Analyst' AND salary_year_avg > 70000)
    )
ORDER BY
    salary_year_avg DESC

---------------------------------------------------------------------
---------------------------------------------------------------------

--- WILD CARDS ---

SELECT 
    job_id,
    job_title,
    job_title_short,
    job_location
FROM 
    job_postings_fact
WHERE
    job_title LIKE '%Analyst' -- Running this only returns job titles with 
    -- Analyst on the end of the statements

---

SELECT 
    job_id,
    job_title,
    job_title_short,
    job_location
FROM 
    job_postings_fact
WHERE
    job_title LIKE '%Analyst%' -- Running this returns jobs where Analyst is either
    -- at the beginning or the end or anywhere in between



SELECT 
    job_id,
    job_title,
    job_title_short,
    job_location
FROM 
    job_postings_fact
WHERE
    job_title LIKE '%Entry%'

----------------------------------------------------
----------------------------------------------------

-- Practice Problem 2 --
-- Look for non-senior data analyst or business analyst
-- Get job title, location and average yearly salary

SELECT 
    job_title,
    job_location AS location,
    salary_year_avg AS yearly_salary
FROM
    job_postings_fact
WHERE
    (job_title LIKE '%Data Analyst%' OR job_title LIKE '%Business Analyst%')
    AND job_title NOT LIKE '%Senior%'
    AND job_title NOT LIKE '%Sr%'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- AGREGATION FUNCTIONS ---

-- SUM(): Adds together all values in a "specific column"
-- COUNT(): Counts the number of "rows" that match the specified criterion
-- AVG(): Calculates the average value of a numeric column
-- MAX(): Finds the maximum value in a set of values
-- MIN(): Finds the minimum value in a set of values

--- THESE ARE USED IN CONJUNCTION WITH GROUP BY and or HAVING

-- Example GROUP BY --

-- Group rows that share the same property so that aggregate functions can be applied

SELECT
    job_title_short,
    COUNT(*) AS jobs  -- Cuenta cuántos trabajos hay por cada job_title_short
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
GROUP BY
    job_title_short  -- Agrupa por la columna base, no por el COUNT
ORDER BY
    jobs DESC;  -- Opcional: ordena de mayor a menor cantidad

-- EXAMPLE using HAVING --

-- Filter groups based on the result of an aggregated function(unlike WHERE, which filters rows)



SELECT
    job_title_short,
    AVG(salary_year_avg) AS avg_salary,  -- Salario promedio
    COUNT(*) AS jobs
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL  -- Filtra valores nulos si es necesario
GROUP BY
    job_title_short
ORDER BY
    jobs DESC;

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

SELECT
    COALESCE(job_title_short, 'TOTAL') AS job_title_short,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    COUNT(*) AS jobs
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
GROUP BY
    ROLLUP(job_title_short)
ORDER BY
    CASE WHEN job_title_short IS NULL THEN 1 ELSE 0 END,
    jobs DESC;



-------------------------------------------------------------------
-------------------------------------------------------------------

-- EXAMPLE HAVING ---
-- NO podemos usar Alias creados en SELECT


SELECT
    job_title_short,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    COUNT(*) AS jobs
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL  -- Filtro de filas individuales
GROUP BY
    job_title_short
HAVING
    AVG(salary_year_avg) > 100000  -- Filtro de grupos basado en agregación
ORDER BY
    jobs DESC;

--------------------------------------------------
--------------------------------------------------

SELECT
    ROUND(SUM(salary_year_avg), 0),
    COUNT(*) AS count_rows
FROM
    job_postings_fact;


--------------------------------------------
---- USING COUNT WITH DISTINCT -------------


SELECT
    COUNT(DISTINCT job_title_short) total_num_jobs
FROM
    job_postings_fact

----------------------------------------------
----------------------------------------------

SELECT
    ROUND(AVG(salary_year_avg), 0) AS salary_avg,
    MIN(salary_year_avg) AS salary_min,
    MAX(salary_year_avg) AS salary_max
FROM
    job_postings_fact
WHERE job_title_short = 'Data Analyst';


----------------------------------------------
----------------------------------------------

-- USING GROUO BY job_location ---

-- Group By - grouos rows that have the same values into groups

/*
╔═══════════╦════════════════════════════╦═════════════════════════════════╗
║ Cláusula  ║ ¿Puedo usar alias del SELECT? ║ ¿Por qué?                     ║
╠═══════════╬════════════════════════════╬═════════════════════════════════╣
║ SELECT    ║ N/A (aquí se crean)         ║ -                               ║
║ FROM      ║ No                          ║ No existen aún                  ║
║ WHERE     ║ No                          ║ Se ejecuta antes que SELECT     ║
║ GROUP BY  ║ No                          ║ Se ejecuta antes que SELECT     ║
║ HAVING    ║ No                          ║ Se ejecuta antes que SELECT     ║
║ ORDER BY  ║ Sí                          ║ Es la última cláusula en        ║
║           ║                             ║ ejecutarse                      ║
╚═══════════╩════════════════════════════╩═════════════════════════════════╝
*/

------------------------------------------------
SELECT
    job_title_short AS jobs,
    ROUND(AVG(salary_year_avg), 0) AS salary_avg,
    MIN(salary_year_avg) AS salary_min,
    MAX(salary_year_avg) AS salary_max
FROM
    job_postings_fact
GROUP BY
    job_title_short
ORDER BY 
    salary_avg DESC;

-----------------------------------------------

SELECT
    job_title_short AS jobs,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg), 0) AS salary_avg,
    MIN(salary_year_avg) AS salary_min,
    MAX(salary_year_avg) AS salary_max
FROM
    job_postings_fact
GROUP BY
    job_title_short
HAVING
    ROUND(AVG(salary_year_avg), 0) > 100000
ORDER BY 
    salary_avg DESC;

----------------------------------------------------




-------------------- PRACTICE PROBLEMS -------------

/*
#2
return the total number of jobs that offer health insurance using
the job_health_insurance column

*/

SELECT
    job_title_short,
    COUNT(*) as jobs_with_insurance
FROM
    job_postings_fact
WHERE
    job_health_insurance = true
GROUP BY 
    job_title_short
ORDER BY 
    jobs_with_insurance DESC;

-----
    
SELECT *
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 100;

---- 

/*

5. Agrupación por País

Muestra el número de trabajos y el salario promedio anual por país (job_country). 
Ordena los resultados por el número de trabajos de mayor a menor.

*/

-- Problema 5 ---

SELECT 
    job_country,
    COUNT(*) as country,
    ROUND(AVG(salary_year_avg), 0) as average_salary
FROM
    job_postings_fact
GROUP BY
    job_country;


--------------------------------

/*

6. Filtrado con LIKE

Encuentra todos los trabajos donde job_title contenga la 
palabra "Engineer" (pista: usa LIKE).

*/

SELECT
    job_title,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title LIKE '%Engineer%' AND salary_year_avg IS NOT NULL;


-- preguntas -- esta bien lo que hice?? 


/*

7. Trabajos Remotos

Muestra todos los trabajos donde job_work_from_home 
sea verdadero (1). Incluye solo las columnas job_title, 
job_location, y salary_year_avg.

*/

SELECT
    job_title,
    job_location,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_work_from_home = true
ORDER BY 
    salary_year_avg;

--  Preguntas en ves de 1 oh 0 use true esta bien eso oh tengo que aprender a usar 1 y 0--


/*

8. Salarios por Tipo de Trabajo

Calcula el salario mínimo, máximo y promedio para cada 
job_title_short (por ejemplo, "Data Analyst", "Data Scientist", etc.). 
Ordena los resultados por salario promedio de mayor a menor.
*/

SELECT
    job_title_short,
    COUNT(*) AS jobs,
    ROUND(AVG(salary_year_avg), 0) AS average_salary,
    ROUND(MAX(salary_year_avg), 0) AS maximum_salary,
    ROUND(MIN(salary_year_avg), 0) AS minimum_salary
FROM
    job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    average_salary DESC;


-- Pregunta esta bien lo que hice?? 


--------------------------------------------------------------
--------------------------------------------------------------

--------------------- SQL JOINS ------------------------------

------ The most popular join is the left join ------


