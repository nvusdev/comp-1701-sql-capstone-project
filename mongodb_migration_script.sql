-- 51 Attributes
-- 12 Total Tables
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

SELECT * FROM job_metadata jm
JOIN jobs j ON jm.job_id = j.job_id
JOIN unions u ON j.union_id = u.union_id
JOIN levels l ON j.level_id = l.level_id
JOIN job_family_titles jft ON jm.job_family_title_id = jft.job_family_title_id
JOIN departments d ON jm.department_id = d.department_id
JOIN divisions dv ON jm.division_id = dv.division_id
INTO OUTFILE 'C:\\Users\\You\\Desktop\\job_metadata.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT js.*,
supervisor.level_name AS supervisor_level,
supervisor.min_count AS supervisor_min_count,
supervisee.level_name AS supervisee_level,
supervisee.min_count AS supervisee_min_count
FROM job_supervisors js
JOIN levels supervisor ON js.supervisor_id = supervisor.level_id
JOIN levels supervisee ON js.is_supervising = supervisee.level_id
INTO OUTFILE 'directory'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM employee_jobs ej
JOIN employees e ON ej.employee_id = e.employee_id
JOIN jobs j ON ej.job_id = j.job_id
JOIN unions u ON j.union_id = u.union_id
JOIN levels l ON j.level_id = l.level_id
JOIN change_types ct ON ej.change_type_id = ct.change_type_id
INTO OUTFILE 'directory'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT ep.* from employee_payments ep
JOIN employee_jobs ej ON ep.employee_job_id = ej.employee_job_id
INTO OUTFILE 'directory'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';