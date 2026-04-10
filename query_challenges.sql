-- Active: 1774622008260@@gondola.proxy.rlwy.net@30240@hr_block_sql_capstone_projectk_sql_capstone_project
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
JOIN employee_jobs ej ON e.employee_id = ej.employee_id
JOIN jobs j ON ej.job_id = j.job_id
JOIN job_metadata jm ON j.job_id = jm.job_id
JOIN departments d ON jm.department_id = d.department_id
LEFT JOIN divisions dv ON jm.division_id = dv.division_id
WHERE ej.end_date IS NULL
AND d.department_name = 'Information Technology'
ORDER BY employee_name;

-- Show the complete organizational structure of Finance – list each position and to whom it reports (if any).

SELECT j.job_title AS position,
s.supervisor_id AS reports_to
FROM jobs j
LEFT JOIN job_supervisors s ON j.job_id = s.supervisor_id
JOIN job_metadata jm ON j.job_id = jm.job_id
WHERE jm.department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance')
ORDER BY position;

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

-- Find all vacant positions (positions with no one assigned to them).

-- List all employees who have been promoted at least twice (each time to a job that supervised their previous one).

-- List all employees that report (directly or indirectly) to 'Inderjeet Singh', the current Director of IT.

-- For Inderjeet Singh, Director of IT, list all his previous positions and the pay he was receiving on his last day in those positions.

-- Group employees by their union (or lack thereof) and list the results in descending order of count.