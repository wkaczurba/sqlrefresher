-- p.367 Ex-8-1-2
SELECT sysdate TODAY,
  (SELECT count(*) FROM departments) Dept_count,
  (SELECT count(*) FROM employees) Emp_count
FROM dual;

DESC employees;

-- p.367/ Ex-8-1-3.
SELECT *
FROM employees
WHERE employee_id 
  IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL);

-- p.367 Ex-8-1-4:
DESC employees;
DESC departments;
DESC locations;

 -- ??: My version:
SELECT MAX(salary), country_id
FROM employees
JOIN departments USING (department_id)
JOIN locations USING (location_id)
JOIN countries USING (country_id)
GROUP BY country_id;

--SELECT * FROM Employees
--WHERE salary = 24000;
--SELECT * FROM departments
--WHERE department_id = 90;
--SELECT * FROM locations
--WHERE location_id = 1700;

-- Book's version:
SELECT max(salary), country_id
FROM (SELECT salary, country_id
  FROM employees
  NATURAL JOIN departments
  NATURAL JOIN locations)
GROUP BY country_id;

SELECT salary, country_id
FROM employees
NATURAL JOIN departments
NATURAL JOIN locations;

-- p.369
SELECT avg(salary)
FROM employees;

SELECT last_name
FROM employees
WHERE salary < (SELECT avg(SALARY) FROM employees);

-- FIG 8-2, p.370.
SELECT department_name
FROM departments
WHERE department_id IN
  (SELECT distinct (department_id) FROM employees);

SELECT department_name
FROM departments
JOIN employees
ON employees.department_id = departments.department_id
GROUP BY department_name;

-- p.371 (NOT EXISING DB-EXAMPLE)
--
--SELECT count(quantity_sold)
--FROM sales.s, products p, customers c, channels ch
--WHERE s.prod_id = c.cust_id
--AND s.cust_id = c.cust_id
--AND s.channel_id = ch.channel_id
--AND p.prod_name = 'Comic Book Heroes'
--AND c.cust_city = 'Oxford'
--AND ch.channel_desc = 'Internet';

--SELECT count(quantity_sold)
--FROM sales
--WHERE prod_in IN 
--  (SELECT prod_id FROM products WHERE prod_name='Comic Book Hereos')
--AND cust_id IN
--  (SELECT cust_id FROM customers WHERE cust_city='Oxford')
--AND channel_id IN
--  (SELECT channel_id FROM channels WHERE channel_desc='Internet');

-- *********************************************
-- p.373 average salary of staff in different countries:
-- Generate a table from which to SELECT
-- *********************************************
SELECT AVG(SALARY), country_id
FROM (SELECT salary FROM 
  employees
  JOIN departments USING (department_id)
  JOIN locations USING (location_id))
GROUP by COUNTRY_ID;

-- ****************************************8
-- p.373 GENERATE VALUES FOR PROJECTION
-- ****************************************8
SELECT (SELECT MAX(salary) FROM employees) *
      (SELECT max(commission_pct) FROM employees) / 100
FROM DUAL;

-- ********************************************
-- p.373 Generate Rows to be passed to a DML statement
-- ********************************************
--INSERT INTO sales_hist
--SELECT *
--FROM sales
--WHERE date > sysdate - 1;

-- WORKING EXAMPLE; BE CAREFUL TO ROLLBACK!;
--SAVEPOINT s1;
--SELECT DISTINCT salary
--FROM employees;
--UPDATE employees
--  SET salary = (SELECT avg(SALARY) FROM employees);
--SELECT DISTINCT salary
--FROM employees;
--ROLLBACK s1;

-- p.374
SELECT last_name 
FROM employees
WHERE department_id IN 
  (SELECT department_id 
   FROM departments
   WHERE location_id IN 
     (SELECT location_id 
      FROM locations 
      WHERE country_id IN 
        (SELECT country_id 
         FROM countries 
         WHERE upper(country_name) = 'UNITED KINGDOM')));

SELECT * FROM countries ORDER BY Country_id; -- UK
SELECT * FROM locations WHERE country_id='UK';
SELECT * FROM departments WHERE location_id IN (2400, 2500, 2600);

SELECT last_name FROM employees WHERE department_id IN (40, 80);

-- Identify all employees who earn more than the average and who work in any of the IT departments.
-- This will require two subqueries, not nested:
SELECT last_name FROM employees
WHERE department_id IN (
  SELECT department_id
  FROM departments
  WHERE department_name LIKE '%IT%')
AND salary > (SELECT AVG(SALARY) from Employees);

-- ****************************
-- p.376 List the types of subqueries:
-- ****************************
--  - single-row
--  - multiple-row
--  - correlated subqueries
--
-- TODO: Try the below:
--  -> OPERATORS FOR SINGLE-ROWS:   > < = != <> >= <=
--  -> OPERATORS FOR MULTIPLE-ROWS: IN, NOT IN, ALL, ANY

--
-- p.377 Correlated subqueries
--

-- This one is easy:
SELECT last_name
FROM employees
WHERE salary < (SELECT avg(salary) FROM employees);

-- This one is correlated:
SELECT p.last_name, p.department_id
FROM employees p
WHERE p.salary < (SELECT avg(s.salary) FROM employees s
  WHERE s.department_id = p.department_id );
  
-- Ex.8-3: Who earns more than Mr. Tobias:
SELECT last_name
FROM employees
WHERE salary > (
  SELECT salary FROM employees WHERE last_name='Tobias'
);

-- THERE IS MORE THAN ONE TAYLOR, SO NEED TO BE EXPLICIT!!!:
SELECT last_name
FROM employees
WHERE salary > (
  SELECT MAX(salary) FROM employees WHERE last_name='Taylor'
);

SELECT last_name
FROM employees
WHERE salary > ALL (
  SELECT salary FROM employees WHERE last_name='Taylor'
);

-- *****************************8
-- p.382 -> Write Single-Row and Multiple-Row subqueries.
-- *****************************8
SELECT last_name
FROM employees
WHERE manager_id IN (
  SELECT employee_id
  FROM employees
  WHERE department_id IN
    (SELECT department_id
     FROM departments 
     WHERE location_id IN (
       SELECT location_id
       FROM locations
       WHERE country_id = 'UK')));

-- Find the job with highest AVG salary
SELECT avg(salary), job_id FROM employees
GROUP BY job_id
HAVING AVG(SALARY) = (
  SELECT max(avg(salary))
  FROM employees
  GROUP BY job_id);
--ORDER BY avg(salary);

-- p.383 -> Alternative ways: "> ALL" would similar to "> (SELECT MAX(whatever) )"
SELECT last_name 
FROM employees
WHERE salary > ALL (
  SELECT salary
  FROM employees
  WHERE department_id = 80
);

SELECT last_name
FROM employees
WHERE salary > (
  SELECT max(salary)
  FROM employees
  WHERE department_id = 80
);

-- Exercise 8-4 p.383: 
--  p2. Design a query that will prompt for a department name and list the last name of every employee in that department
--UNDEFINE DEPT_NAME;

SELECT last_name, department_name
FROM employees
JOIN departments
USING (department_id)
WHERE department_id IN (
  SELECT department_id
  FROM departments
  WHERE upper(department_name) LIKE upper('%&DEPT_NAME%')
);

-- Alternatively: (JOIN ON)
SELECT last_name, department_name
FROM employees
JOIN departments
ON departments.department_id = employees.department_id
WHERE departments.department_id IN (
  SELECT department_id
  FROM departments
  WHERE upper(department_name) LIKE upper('%&DEPT_NAME%')
);

