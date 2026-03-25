-- Cleaning before running the script
DROP DATABASE IF EXISTS hr_block_sql_capstone_project;
CREATE DATABASE IF NOT EXISTS hr_block_sql_capstone_project;
USE IF EXISTS hr_block_sql_capstone_project;

-- Create departments
CREATE TABLE IF NOT EXISTS departments(  
    department_id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100),
    department_description TEXT,
    category tinytext
);

-- Create divisions
CREATE TABLE IF NOT EXISTS divisions(  
    division_id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    division_name VARCHAR(100),
    division_description TEXT,
    department_id TINYINT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create job_family_titles
CREATE TABLE IF NOT EXISTS job_family_titles(  
    job_family_title_id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    job_family_title_name VARCHAR(50),
    job_family_title_description TEXT
);

-- Create unions
CREATE TABLE IF NOT EXISTS unions(  
    union_id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    union_name VARCHAR(100),
    union_description TEXT
);

-- Create levels
CREATE TABLE IF NOT EXISTS levels(  
    level_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    level_name VARCHAR(3),
    min_count TINYINT NULL
);

-- Create job_supervisors
CREATE TABLE IF NOT EXISTS job_supervisors(  
    supervisor_id INT NOT NULL,
    is_supervising int NOT NULL,
    FOREIGN KEY (supervisor_id) REFERENCES levels(level_id),
    FOREIGN KEY (is_supervising) REFERENCES levels(level_id)
);

-- Create jobs
CREATE TABLE IF NOT EXISTS jobs(  
    job_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(50),
    job_description TEXT,
    level_id INT,
    min_years TINYINT,
    union_id TINYINT,
    FOREIGN KEY (union_id) REFERENCES unions(union_id),
    FOREIGN KEY (level_id) REFERENCES levels(level_id)
);

-- Create job_metadata
CREATE TABLE IF NOT EXISTS job_metadata(  
    job_metadata_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    job_family_title_id TINYINT NOT NULL,
    department_id TINYINT NOT NULL,
    division_id TINYINT NOT NULL,
    min_pay_per_hour DECIMAL(10,2),
    max_pay_per_hour DECIMAL(10,2),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (job_family_title_id) REFERENCES job_family_titles(job_family_title_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (division_id) REFERENCES divisions(division_id)
);

-- Create employees
CREATE TABLE IF NOT EXISTS employees(  
    employee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hire_date DATE,
    phone_number VARCHAR(20),
    upn VARCHAR(50)
);

-- Create change_types
CREATE TABLE IF NOT EXISTS change_types(  
    change_type_id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    change_type_name TINYTEXT
);

-- Create employee_jobs
CREATE TABLE IF NOT EXISTS employee_jobs(  
    employee_job_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    job_id INT,
    pay_scale DECIMAL(10,2),
    change_type_id TINYINT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (change_type_id) REFERENCES change_types(change_type_id)
);

-- Create employee_payments
CREATE TABLE IF NOT EXISTS employee_payments(  
    employee_payment_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_job_id INT,
    transaction_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (employee_job_id) REFERENCES employee_jobs(employee_job_id)
);


