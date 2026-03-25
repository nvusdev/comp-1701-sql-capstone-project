CREATE TABLE divisions(  
    division_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    division_name VARCHAR(100),
    division_description TEXT,
    department_id TINYINT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);