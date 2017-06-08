-- Data manipulation stuff.
  -- DML commands: SELECT, INSERT, UPDATE, DELETE, MERGE (a weird one)

  -- DDL commands: CREATE, DROP, TRUNCATE
  --
  
  --CREATE TABLE xx (
  --  id NUMBER,
  --  first_name VARCHAR2(30),
  --  last_name varchar2(30),
  --  dob DATE
  --);
  --DROP TABLE xx;

-- p.433 -> INESRT

CLEAR SCREEN;
CREATE TABLE regions_temp AS SELECT * FROM regions WHERE 1=2;
SELECT * FROM regions_temp;

INSERT into regions_temp VALUES (10, 'Great Britain');
INSERT into regions_temp (region_name, region_id) VALUES ('Australasia', 11);
INSERT into regions_temp (region_id) VALUES (12);
INSERT into regions_temp VALUES (13, null);
-- INSERT into regions_temp VALUES (13); (Will cause a problem.

SELECT * FROM regions_temp;
DROP TABLE regions_temp;


-- p.434
CREATE TABLE emp_copy AS SELECT * FROM employees;
INSERT INTO emp_copy(employee_id, last_name, hire_date, email, job_id)
             VALUES (1000, 'WATSON', TO_DATE('03-Nov-13', 'DD-MON-YY'), 'jwatson@hr.com', 'SA_REP');
DELETE FROM emp_copy WHERE employee_id = 1000;
INSERT INTO emp_copy(employee_id, last_name, hire_date, email, job_id)
            VALUES (1000, upper('watson'), to_date('03-Nov-13','DD-Mon-YY'),
            lower('jwastson@hr.com'),
            upper('sa_rep')
            );
DELETE FROM emp_copy WHERE employee_id = 1000;

INSERT INTO emp_copy(employee_id, last_name, hire_date, email, job_id)
       VALUES (1000+1, user, sysdate - 7, 'jwatson@hr.com', CONCAT('SA_','REP'));

DELETE FROM emp_copy WHERE employee_id = 1000;

SELECT * FROM emp_copy WHERE employee_id = 1000;
             
DROP TABLE emp_copy;

CREATE TABLE emp_copy AS SELECT * FROM employees WHERE 1=2;

SELECT COUNT(1) FROM emp_copy
UNION ALL
SELECT COUNT(1) FROM employees;


INSERT INTO emp_copy SELECT * FROM employees;
TRUNCATE TABLE emp_copy;
INSERT INTO emp_copy SELECT * FROM employees;

SELECT COUNT(1),'Emp_copy table' FROM emp_copy
UNION ALL
SELECT COUNT(1),'Employees' FROM employees;


SELECT table_name FROM user_tables;

CREATE TABLE department_salaries (
  department VARCHAR2(32),
  staff NUMBER,
  salaries NUMBER);
  
-- P.437
INSERT INTO department_salaries (department, staff, salaries)
SELECT
  coalesce(department_name, 'Unassigned'),
  count(employee_id),
  sum(coalesce(salary, 0))
FROM hr.employees e
FULL OUTER JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY department_name;

SELECT * FROM department_salaries;

DROP TABLE department_salaries;

-- p.439, Ex.10-1
CREATE TABLE regions_two AS SELECT * FROM regions WHERE 1=2;

INSERT INTO regions_two (region_id, region_name) VALUES (101, 'Great Britain');
DEFINE region_id = 103
DEFINE region_name = 'whatever island';
INSERT INTO regions_two (region_id, region_name) VALUES (&region_id, INITCAP('&region_name'));

INSERT INTO regions_two (region_id, region_name) VALUES ( (SELECT MAX(region_id)+1 FROM regions_two), 'Oceania');

SELECT * FROM regions_two;
COMMIT;
--ROLLBACK;
SELECT * FROM regions_two;

DROP table regions_two;

-- ****************************************************
-- p.441 Update rows in table.
-- Changes column values in one or more existing rows in a single table.
-- ****************************************************


-- p.441, ex. 10-4:
SAVEPOINT;

SELECT * FROM employees WHERE employee_id = 206;
UPDATE employees SET salary = 10000 WHERE employee_id = 206;
SELECT * FROM employees WHERE employee_id = 206;

UPDATE employees SET salary = salary * 1.1 WHERE last_name='Cambrault';
SELECT * FROM employees WHERE employee_id = 206 OR last_name = 'Cambrault';

-- ** FINISH THIS EXAMPLE ** --
--SELECT last_name, salary, d.department_name
--FROM departments d
--JOIN employees e ON (e.department_id = d.department_id AND d.department_name LIKE '%&&Which_department%');

UPDATE employees
SET salary = salary * 1.1
WHERE department_id IN
(SELECT department_id FROM departments
 WHERE department_name LIKE '%&&Which_department%');

--SELECT last_name, salary, d.department_name
--FROM departments d
--JOIN employees e ON (e.department_id = d.department_id AND d.department_name LIKE '%&&Which_department%');

UPDATE employees
SET department_id=80,
    commission_pct = (SELECT min(commission_pct) FROM employees WHERE department_id=80)
    WHERE employee_id = 206;

SELECT * FROM employees WHERE employee_id = 206 OR last_name = 'Cambrault';

ROLLBACK;
-- End of fig 10-4 (p.441)

-- **************************
-- p.444 Ex.10-2
-- Restoring table first.
  CREATE TABLE regions_two AS SELECT * FROM regions; -- WHERE 1=2;
  INSERT INTO regions_two (region_id, region_name) VALUES (101, 'Great Britain');
  INSERT INTO regions_two (region_id, region_name) VALUES (102, 'Australasia');
  INSERT INTO regions_two (region_id, region_name) VALUES ( (SELECT MAX(region_id) + 1 FROM regions_two), 'Oceania');
  SELECT * FROM regions;

-- p.444 Ex.10-2.2
UPDATE regions_two SET region_name = 'Scandinavia' WHERE region_id=101;
UPDATE regions_two SET region_name = 'Iberia' WHERE region_id > 100;

UPDATE regions_two SET region_id = (region_id + (SELECT MAX(region_id) FROM regions_two))
  WHERE region_id IN (SELECT region_id FROM regions_two WHERE region_id > 100);
  
SELECT * FROM regions_two;
  
DROP table regions_two;

-- ***************************
-- p.446 Delete rows from a table
-- ***************************
-- DELETE FROM table [WHERE expr]

CREATE TABLE employees_two AS SELECT * FROM employees;

SAVEPOINT S;
SELECT * FROM employees_two;
DEFINE Which_department = 999;
DELETE FROM employees_two WHERE employee_id = 206;
DELETE FROM employees_two WHERE department_id = &Which_department;
DELETE FROM employees_two WHERE department_id IS NULL;

ROLLBACK;

DROP TABLE employees_two;

-- ******************
-- p.447 Ex.10-3.
-- ******************
ROLLBACK;
SAVEPOINT s;

-- p.447 Ex.10-3

INSERT INTO regions (region_id, region_name) VALUES ( 204, 'Iberia' );
INSERT INTO regions (region_id, region_name) VALUES ( 205, 'Iberia' );
INSERT INTO regions (region_id, region_name) VALUES ( 206, 'Iberia' );

-- p.447 Ex.10-3.2
DELETE FROM REGIONS_TWO WHERE region_id=204;
-- p.447 Ex.10-3.3
DELETE FROM REGIONS;
-- p.447 Ex.10-3.4
DELETE FROM REGIONS where region_id IN (SELECT region_id FROM regions WHERE region_name='Iberia');
-- p.447 Ex.10-3.4
SELECT * FROM regions;

ROLLBACK S;


-- *********************************
-- p.449 Removing Rows with TRUNCATE
-- *********************************
-- TRUNCATE TABLE <table_name>

-- p.450 MERGE:
CREATE TABLE new_employees AS
  SELECT * FROM employees;
  
SELECT * FROM new_employees WHERE ROWNUM <= 3;
DELETE FROM new_employees WHERE employee_id = 101;
UPDATE new_employees SET salary = -1 WHERE employee_id = 100;

SELECT * FROM new_employees WHERE employee_id IN (100, 101);

CLEAR SCREEN;
-- **** THIS MERGE DOES NOT WORK ANYWAYS: ****
--MERGE INTO employees e
--USING new_employees n
--ON (e.employee_id = n.employee_id)
--WHEN MATCHED THEN
--  UPDATE SET e.salary=n.salary
--WHEN NOT MATCHED THEN
--  INSERT (employee_id, last_name, salary, email, job_id) 
--  VALUES (n.employee_id, n.last_name, n.salary, n.email, n.job_id);
--    
DROP TABLE new_employees;

-- ********************************
-- p.451 CONTROL TRANSACTIONS
-- ********************************
-- COMMIT, ROLLBACK, SAVEPOINT;
--
-- p.459: AUTOCOMMIT
--
-- SET AUTOCOMMIT ON;
-- SET AUTOCOMMIT OFF;
--

-- ******************
-- p.459: SELECT FOR UPDATE
-- ******************


-- SELECT FOR UPDATE -- 
SELECT table_name FROM user_tables;

SELECT * FROM NEW_DEPT;
INSERT INTO new_dept VALUES(1, 'One', SYSDATE - 10);
INSERT INTO new_dept VALUES(2, 'Two', SYSDATE - 10);
COMMIT;

-- Now connect other session here.
SELECT * FROM NEW_DEPT FOR UPDATE;
-- In the other session try to DELETE FROM NEW_DEPT; IT WILL HANG.
UPDATE new_dept SET dept_no = dept_no + 1 WHERE 1=1;
COMMIT;

ROLLBACK;

