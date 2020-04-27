-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE Employees  (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);


SELECT * FROM departments;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);SELECT * FROM departments;


CREATE TABLE titles (
emp_no INT NOT NULL,
  	title VARCHAR NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

-----
SELECT * FROM dept_emp
SELECT * FROM salaries
SELECT * FROM titles
SELECT * FROM dept_manager

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'; 

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');SELECT * FROM employees;

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
SELECT * FROM retirement_info;


DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
	
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;	 

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date	
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--ORDER BY to_date DESC;

SELECT emp_no,
	first_name,
last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;

SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

SELECT * FROM current_emp

SELECT * FROM emp_info
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
--INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--retiring sales employees

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE de.dept_no = ('d007') 

--retiring sales and development employees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
--INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE de.dept_no IN ('d007','d005')


--- I JOIN EMPLOYEE NUMBER, FIRST NAME, LAST NAME, TITLE, FROM_DATE AND SALARY
--- TO HOMEWORK TABLE
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ti.title,
	de.to_date,
	s.salary
INTO temporary_data
FROM retirement_info AS ri
INNER JOIN salaries AS s
ON ri.emp_no = s.emp_no
INNER JOIN titles AS ti
ON ri.emp_no = ti.emp_no
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
ORDER BY ti.title;

SELECT * FROM temporary_data

---get rid of the duplicates
SELECT DISTINCT emp_no, first_name, last_name, to_date, salary
INTO homework_table
FROM temporary_data;

SELECT * FROM homework_table

SELECT ht.emp_no,
ht.first_name,
ht.last_name,
ti.title	
INTO temporary_data_2
FROM homework_table AS ht
INNER JOIN titles AS ti
ON (ht.emp_no = ti.emp_no)

SELECT * FROM temporary_data_2

SELECT DISTINCT emp_no, first_name, last_name, title
INTO homework_table_titled
FROM temporary_data_2;

SELECT * FROM homework_table_titled

--number of titles_retiring
SELECT COUNT (ht.emp_no), htt.title
INTO number_of_titles_retiring
FROM homework_table AS ht,homework_table_titled AS htt
GROUP BY htt.title;

--- COUTING OF NUMBER OF TITLES RETIRING STEP BY STEP---
SELECT * FROM current_emp
----all retiring employee
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO all_retiring_emp
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)

SELECT * FROM all_retiring_emp;

--adding title to all retiring employee table

SELECT arem.emp_no,
arem.first_name,
arem.last_name,
ti.title,
ti.from_date,
ti.to_date

INTO temporary_data_3
FROM all_retiring_emp AS arem
INNER JOIN titles AS ti
ON(arem.emp_no = ti.emp_no)

SELECT DISTINCT emp_no, first_name, last_name, title, from_date, to_date
INTO all_retiring_emp_titles
FROM temporary_data_3;

SELECT * FROM all_retiring_emp_titles;

---MENTORSHIP ELIGIBILITY

SELECT all_retiring_emp_titles.emp_no,
all_retiring_emp_titles.first_name,
all_retiring_emp_titles.last_name,
all_retiring_emp_titles.from_date,
all_retiring_emp_titles.to_date,
employees.birth_date
INTO mentorship_eligibility
FROM all_retiring_emp_titles
INNER JOIN employees
ON (all_retiring_emp_titles.emp_no = employees.emp_no) 
WHERE (employees.birth_date BETWEEN '1952-01-01' AND '1955-12-31');

SELECT * FROM mentorship_eligibility

-- NUMBER OF TITLE RETIRING 
SELECT COUNT (aremt.emp_no), aremt.title
INTO retiring_titles
FROM all_retiring_emp_titles AS aremt
GROUP BY aremt.title;


SELECT * FROM retiring_titles

--- NUMBER OF EMPLOYEES EACH TITLE---
SELECT COUNT (ti.emp_no), ti.title
INTO number_of_employees_each_title
FROM titles AS ti
GROUP BY ti.title;

SELECT * FROM number_of_employees_each_title

homework_table_titled
-- PARTITION THE DATA TO SHOW ONLY MOST RECENT TITLE PER EMPLOYEE
SELECT emp_no,
first_name,
last_name,
title,
to_date,
salary
INTO partition_data_table
FROM
 (SELECT ht.emp_no,
	htt.first_name,
	htt.last_name,
	htt.title,
	ht.to_date,
	ht.salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM homework_table AS ht,homework_table_titled AS htt
 ) tmp WHERE rn = 1
ORDER BY emp_no;
 
SELECT * FROM partition_data_table;