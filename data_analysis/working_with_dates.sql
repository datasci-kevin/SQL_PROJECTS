
-- Running this query allows us to the top 10 values from the jos_posted_date column--
SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

-- ::DATE CASTING EXAMPLES

-- Convert a timestamp column into a date format
SELECT 
    timestamp_column::DATE AS date_column
FROM 
    table_name;

-- Notes:
-- :: is used for casting, which means converting a value from one data type to another
-- You can use it to convert various data types

SELECT 
    '2023-02-19'::DATE, 
    '123'::INTEGER, 
    'true'::BOOLEAN, 
    '3.14'::REAL;

-- ::DATE - converts the value into a date format
-- In this case, it converts a timestamp into a date format

-- Date Format: YYYY-MM-DD
-- Example:
SELECT '2024-02-06'::DATE;

-- Timestamp Format: YYYY-MM-DD HH:MM:SS
-- Example:
SELECT '2024-02-06 15:04:05'::TIMESTAMP;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

SELECT 
    job_title_short AS title, 
    job_location AS location,
    job_posted_date AS date -- This return the job_posted_date column as a timestamp
FROM
    job_postings_fact;

--- Let's say that we don't need that job_posted_date column as a timestamp we 
-- can change it to a date instead 


SELECT  
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;



/*

Timestamps with time Zone
 -- Stored as UTC, displayed per query's or system's time zone
 -- AT TIME ZONE coverts UTC to the specified time zoned correctly

*/

-- EXAMPLE --


SELECT 
    column_name AT TIME ZONE 'EST'
FROM table_name;



SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'AS date_time
FROM
    job_postings_fact
LIMIT 5;


---------------------------------------------------------------------
----------------------- EXTRACT -------------------------------------

/*
Used to extract things out of date such as year, month, day
*/


SELECT      
    EXTRACT(MONTH FROM column_name) AS column_month -- used like a fucntion
FROM 
    table_name;



SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;


------------------------------------------------------------------------
--------------- APPLYING THIS INTO SOMETHING USEFUL --------------------

-- Looking at how jobs are trending overtime _-- notice the COUNT function

SELECT
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
GROUP BY 
    month;

----------------------------------------------------------------------------

-- if you only care about data analyst roles ----


SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY
    job_posted_count DESC;


