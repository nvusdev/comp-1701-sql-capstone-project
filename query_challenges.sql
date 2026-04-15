-- Active: 1774622008260@@gondola.proxy.rlwy.net@30240@hr_block_sql_capstone_project
-- Table describing
DESC employees;
DESC departments;
DESC divisions;
DESC job_family_titles;
DESC unions;
DESC employee_jobs;
DESC jobs;
DESC levels;
DESC job_supervisors;
DESC job_metadata;
DESC employee_payments;
DESC change_types;

-- List all employees currently working in IT, along with their division and job title.

SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    dv.division_name,
    j.job_title
FROM employees e
JOIN employee_jobs ej 
    ON e.employee_id = ej.employee_id
JOIN jobs j 
    ON ej.job_id = j.job_id
JOIN job_metadata jm
    ON j.job_id = jm.job_id
JOIN departments d 
    ON jm.department_id = d.department_id
LEFT JOIN divisions dv 
    ON jm.division_id = dv.division_id
WHERE ej.end_date IS NULL
AND d.department_name = 'Information Technology'
ORDER BY employee_name;

-- Show the complete organizational structure of Finance – list each position and to whom it reports (if any).

SELECT j.job_title AS position,
    j.level_id as job_level_id,
    sj.job_title AS reports_to,
    sj.level_id as supervisor_level_id
FROM jobs j
JOIN job_metadata jm 
    ON j.job_id = jm.job_id 
    AND jm.department_id = (
    SELECT department_id
    FROM departments
    WHERE department_name = 'Finance'
)
JOIN job_supervisors js ON j.level_id = js.is_supervising
JOIN jobs sj ON js.supervisor_id = sj.level_id

-- check level hierarchy:
SELECT * FROM job_supervisors
WHERE is_supervising = 3;

-- Among all employees who have never changed position, find who has worked the longest.

SELECT e.employee_id,
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
e.hire_date
FROM employees e
LEFT JOIN employee_jobs ej ON e.employee_id = ej.employee_id
GROUP BY e.employee_id
HAVING COUNT(ej.job_id) = 1
ORDER BY e.hire_date ASC
LIMIT 1;


-- Calculate the current pay of 'Sarah Johnson', factoring in her years of service and the pay rules of her current position.

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    j.job_title,
    ej.pay_scale,
    ej.start_date,
    ej.end_date
FROM employees e
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
WHERE e.first_name = 'Isabelle' AND e.last_name = 'Fontaine';

-- Find all vacant positions (positions with no one assigned to them).

SELECT 
    j.job_id,
    j.job_title
FROM jobs j
LEFT JOIN employee_jobs ej ON j.job_id = ej.job_id AND ej.end_date IS NULL
WHERE ej.employee_job_id IS NULL
ORDER BY j.job_title;

-- List all employees who have been promoted at least twice (each time to a job that supervised their previous one).

SELECT
    e.first_name,
    e.last_name,
    COUNT(*) AS number_of_promotions
FROM employees e
JOIN employee_jobs ej
    ON e.employee_id = ej.employee_id
WHERE ej.change_type_id = (SELECT change_type_id FROM change_types WHERE change_type_name = 'Promotion')
GROUP BY e.employee_id
HAVING COUNT(*) >= 2;

-- List all employees that report (directly or indirectly) to 'Inderjeet Singh', the current Director of IT.

WITH RECURSIVE employee_tree AS (
SELECT
j.level_id
FROM employees e
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
WHERE j.job_title = "Director — IT"
AND ej.end_date IS NULL
UNION ALL
SELECT js.is_supervising
FROM job_supervisors js
JOIN employee_tree et
ON js.supervisor_id = et.level_id
)
SELECT DISTINCT
e.first_name,
e.last_name
FROM employees e
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
WHERE j.level_id IN (
SELECT level_id FROM employee_tree
)
AND ej.end_date IS NULL;

-- For Director of IT, list all his previous positions and the pay he was receiving on his last day in those positions.

SELECT
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
j.job_title,
ej.pay_scale,
ej.end_date
FROM employees e
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
WHERE e.employee_id = (
SELECT ej2.employee_id
FROM employee_jobs ej2
JOIN jobs j2 ON ej2.job_id = j2.job_id
WHERE j2.job_title LIKE '%Director%IT%'
    AND ej2.end_date IS NULL
)
AND ej.end_date IS NOT NULL
ORDER BY ej.start_date;

-- Group employees by their union (or lack thereof) and list the results in descending order of count.

SELECT 
    u.union_name,
    COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
LEFT JOIN unions u ON j.union_id = u.union_id
GROUP BY u.union_name
ORDER BY employee_count DESC;