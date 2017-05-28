--
-- Inner joins
-- Fig 7.1

DESC REGIONS;
DESC COUNTRIES;

SELECT *
FROM regions
NATURAL JOIN countries
WHERE upper(region_name) LIKE 'AMERICAS';

SELECT *
FROM regions
NATURAL JOIN countries
WHERE country_name = 'Canada';

SELECT *
FROM regions
JOIN countries
USING (region_id)
WHERE country_name='Canada';

SELECT *
FROM countries
JOIN regions
ON (countries.region_id=regions.region_id)
WHERE region_name='Americas';

-- p.321 Fig 7-2 Cross join
SELECT count(*)
FROM countries;

SELECT count(*)
FROM regions;

SELECT count(*)
FROM regions
CROSS JOIN countries;

SELECT *
FROM regions
CROSS JOIN countries
WHERE country_id='CA';

--
-- Oracle Join Syntax
--
-- Inner join by oracle:
SELECT regions.region_name, countries.country_name
FROM regions, countries
WHERE regions.region_id = countries.region_id;

-- Oracle Join Syntax: right outer join;
SELECT last_name, department_name
FROM employees, departments
WHERE employees.department_id (+) = departments.department_id
ORDER BY last_name NULLS FIRST;

-- Oracle Join Syntax: left outer join:
SELECT last_name, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id (+)
ORDER BY departments.department_id NULLS FIRST;

-- Oracle cross Join:
SELECT * 
FROM regions, countries;

-- p.323 Joins syntax (ANSI-C)
--
-- SELECT table1.col, table2.col
-- FROM table1
-- [NATURAL JOIN table2 |
--  JOIN table2 USING (common_column) |
--  JOIN table2 ON (table1.col_name1 == table2.col_name2) |
--  [LEFT|RIGHT|FULL OUTER JOIN table2 ON (table1.col == table2.col) |
--  CROSS JOIN table2];
--
-- ORACLE's:
--
-- SELECT table1.column, table2.column
-- FROM table1, table2
-- [WHERE (table1.column_name = table2.column_name) |
--  WHERE (table1.column_name (+) = table2.column_name) |
--  WHERE (table1.column_name = table2.column_name (+)]
--  If no joins or less than N-1 conditions specified on N tables -> it will end up a cross-join

DESC employees;
DESC departments;

SELECT emp.employee_id, department_id, emp.manager_id, departments.manager_id
FROM employees emp
JOIN departments
USING (department_id)
WHERE department_id > 80;

--
-- p.325 Natural join
--

DESC locations;
DESC countries;
DESC jobs;

-- COUNTRY_ID is the only common: (ANSI SQL)
SELECT * 
FROM locations
NATURAL JOIN countries;

-- Oracle SQL
SELECT * 
FROM locations, countries
where locations.country_id = countries.country_id;

-- There is no commmon columns between JOBS and COUNTRIES so the end result will be a cross-join:
SELECT *
FROM jobs
NATURAL JOIN countries;

-- CROSS-JOIN:
SELECT *
FROM jobs, countries;

-- p.326 fig 7-4 SHOWS EXAMPLE WHERE THERE ARE COLUMNS OF SAME NAME BUT DIFFERENT TYPES (NUMBER vs VARCHAR2)
-- thus making causing an error when trying to NATURAL-JOIN them.
--DESC countries;
--DESC regions;
--DESC sales_regions;
--
-- p.327 Exerices 7-1
DESC JOB_HISTORY;
DESC EMPLOYEES;
-- They share: EMPLOYEE_ID, JOB_ID, DEPARTMENT_ID
SELECT employee_id, job_id, department_id, emp.last_name, emp.hire_date, jh.end_date
FROM employees emp
NATURAL JOIN job_history jh;

-- p.329 JOIN USING clause
-- SELECT table.common_column, table.common_column
-- FROM table1
-- JOIN table2 
-- USING (common_column, common_column2, ...)

SELECT * 
FROM locations
JOIN countries
USING (country_id);

SELECT *
FROM locations, countries
WHERE locations.country_id = countries.country_id;

-- NOTICE: qualifier is used for emp.department_id, because department_id is a shared column
-- Since the shrae column is not JOINED - you need to explicitly name which one you want to print
-- in the select clause to avoid ambiguity, so:
--
-- THEREFORE: emp.department_id MUST be explicitly named "emp" as department_id is a common column, but not joined.
-- ON THE OTHER HAND: job_id is common so it mmust no be specified with a qualifier.

SELECT emp.last_name, emp.department_id, jh.end_date, job_id, employee_id
FROM job_history jh
JOIN employees emp
USING (job_id, employee_id);

-- ***********************
-- p.330 JOIN ON clause.
-- ***********************
-- SELECT table1.column, table2.column
-- FROM table1
-- JOIN table2 ON (table1.column = table2.column)
CLEAR SCREEN;
DESC departments;
DESC employees;

SELECT *
FROM departments d
JOIN employees e ON (d.manager_id = e.manager_id);

SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM employees;

SELECT *
FROM departments d
JOIN employees e ON (d.department_id = e.department_id);

SELECT *
FROM employees e, departments d
WHERE d.department_id = e.employee_id;

--- p.331 (JOIN ON (expr) )
CLEAR SCREEN;
DESC EMPLOYEES;
DESC JOB_HISTORY;

SELECT e.employee_id, e.last_name, j.start_date, e.hire_date, j.end_date,
  j.job_id previous_job, e.job_id current_job
FROM job_history j
JOIN employees e
ON (j.start_date = e.hire_date);

-- p.332 Exercise 7.2:
--SELECT first_name, last_name, d.manager_id MANAGERS
--FROM employees e
--JOIN departments d ON (d.manager_id = e.employee_id);

SELECT e.first_name || ' '|| e.last_name || ' is the manager of ' || d.department_name || ' department.' "Managers"
FROM employees e
JOIN departments d
ON (d.manager_id = e.employee_id);

--------------------------------------------
-- p.333 N-ways JOINS and Additional Join Conditions
-- p.334 (GOOD VS BAD JOINING:)
--------------------------------------------

    -- !!! THIS NATURAL JOIN IS WRONG!!! ---
    --SELECT r.region_name, c.country_name, l.city, d.department_name
    --FROM departments d
    --NATURAL JOIN locations l, countries c, regions r;
    -- WRONG WRONG WRONG ---

-- GOOD

SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments D
NATURAL JOIN locations l
NATURAL JOIN countries c
NATURAL JOIN regions r;

-- ** ** ** p.334 -> BOTTOM: --
SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments d
JOIN locations l ON (l.location_id = d.location_id)
JOIN countries c on (c.country_id = l.country_id)
JOIN regions r ON (r.region_id=c.region_id);

SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments d
JOIN locations l USING (location_id)
JOIN countries c USING (country_id)
JOIN regions r USING (region_id);

-- p.335
SELECT d.department_name
FROM departments d
JOIN locations l
ON (l.LOCATION_ID=d.LOCATION_ID)
WHERE (d.department_name LIKE 'P%');

-- JOIN table ON (expr) -> expr can take in various forms:
SELECT d.department_name
FROM departments d
JOIN locations l
ON (l.location_id = d.location_id 
AND d.department_name LIKE 'P%');

-- p.336 fig 7-7
SELECT r.region_name, c.country_name, l.city, d.department_name, e.last_name, e.salary
FROM employees e
JOIN departments d ON (d.department_id = e.department_id AND salary > 1000)
JOIN locations l ON (l.location_id = d.location_id)
JOIN countries c ON (c.country_id = l.country.id)
JOIN regions r ON (r.country_id = c.country_id);

-- ******************************
-- p.336 Nonequijoins
-- ******************************
-- SELECT table1.column, table2.column
-- FROM table1 
-- JOIN table2 ON (table1.column > table2.column)
-- JOIN table2 ON (table1.column >= table2.column)
-- JOIN table2 ON (table1.column BETWEEN table2.columnA, table2.columnB)

SELECT e.job_id current_job, 'The salary of '||last_name||' can be doubled by changing jobs to: '||
  j.job_id options, e.salary current_salary, j.max_salary potential_max_salary
FROM employees e
JOIN jobs j ON (2 * e.salary < j.max_salary)
WHERE e.salary > 10000
ORDER BY first_name;

--
-- p.338 SELF-JOIN
-- 
-- SELECT id, name, father_id
-- FROM family;
--
-- SELECT name
-- FROM family
-- WHERE id=&father_id;
--
-- SELECT f1.name DAD, f2.name CHILD
-- FROM family f1
-- JOIN family f2 ON (f1.id = f2.father_id)
-- 


-- p.340 Exercise 7.3
SELECT e.first_name, e.last_name as EMPLOYEE, e.employee_id, e.manager_id, e.department_id, m.last_name as MANAGER
FROM employees e
JOIN employees m ON (m.employee_id = e.manager_id AND e.department_id IN (10, 20, 30))
ORDER BY department_id;

SELECT e.first_name, e.last_name as EMPLOYEE, e.employee_id, e.manager_id, e.department_id, m.last_name as MANAGER
FROM employees e
JOIN employees m ON (m.employee_id = e.manager_id)
WHERE e.department_id IN (10, 20, 30)
ORDER BY department_id;

-- 
-- P.343 LEFT OUTER JOIN
--
--SELECT table1.column, table2.column
--FROM table1
--LEFT OUTER JOIN table2 ON 
--(table1.column = table2.column)
DESC departments;

SELECT e.employee_id, e.department_id EMP_DEPT_ID, d.department_id DEPT_DEPT_ID, d.department_name
FROM departments d
LEFT OUTER JOIN employees e ON (d.department_id = e.department_id)
WHERE d.department_name LIKE 'P%';

SELECT e.employee_id, e.department_id EMP_DEPT_ID, d.department_id DEPT_DEPT_ID, d.department_name
FROM departments d
LEFT OUTER JOIN employees e ON (d.department_id = e.department_id)
WHERE d.department_name LIKE 'P%';

SELECT e.employee_id, e.department_id EMP_DEPT_ID, d.department_id DEPT_DEPT_ID, d.department_name
FROM departments d
JOIN employees e ON (d.department_id = e.department_id)
WHERE d.department_name LIKE 'P%';

-- p.7-10
SELECT city, l.location_id "location_id", d.location_id "d.location_id"
FROM locations l
LEFT OUTER JOIN departments d
ON (l.location_id=d.location_id);l

--  p.345 RIGHT OUTER JOIN
SELECT e.last_name, d.department_name
FROM departments d
RIGHT OUTER JOIN employees e
ON (e.department_id = d.department_id)
WHERE e.last_name LIKE 'G%';

-- P.346 fig 7-11
SELECT DISTINCT jh.job_id "Jobs in JOB_HISTORY", e.job_id "Jobs in EMPOYEES"
FROM job_history jh
RIGHT OUTER JOIN employees e ON(jh.job_id = e.job_id)
ORDER BY jh.job_id;

-- p.346 Full outer join.
SELECT e.last_name, d.department_name
FROM departments d
FULL OUTER JOIN employees e
ON (e.department_id = d.department_id)
WHERE d.department_id IS NULL;

-- p.347 Ex.7-4

SELECT d.department_name, d.department_id -- , e.last_name,  (e.last_name is only for debug).
FROM employees e
RIGHT OUTER JOIN departments d ON (e.department_id = d.department_id)
WHERE e.department_id IS NULL;

SELECT d.department_name, d.department_id
FROM departments d
LEFT OUTER JOIN employees e ON (e.employee_id = d.department_id)
WHERE e.department_id IS NULL;

-- p.349 -> SCENARIOS (2nd)
-- divide employees into 4 groups:
--   employee_id, last_name and region_name for each employee by joining the EMPLOYEE_ID and REIGON_ID
-- columns in a round-robin manner?
SELECT e.employee_id, e.last_name, r.region_name, mod(employee_id, 4) "GROUP"
FROM regions r
JOIN employees e ON (mod(e.employee_id, 4)+1 = r.region_id)
ORDER BY "GROUP";

SELECT department_name, NVL(last_name,'NO Employees')
FROM departments d
LEFT OUTER JOIN employees e ON (e.department_id = d.department_id);


-- ***************************
-- p.350 Cartesian product
-- ***************************
--SELECT table1.column, table2.column
--FROM talbe1
--CROSS JOIN table2.\

SELECT *
FROM jobs j
CROSS JOIN job_history jh;

SELECT *
FROM jobs j
CROSS JOIN job_history jh
WHERE j.job_id='AD_PRES';

-- fig 7-3, N=2  tables and 0 joining conditions -> creates a cartesian product
-- It has to be N tables and at least N-1 joining conditions to create a NON-CARTESIAN join.
SELECT *
FROM regions r
CROSS JOIN countries c
WHERE r.region_id in (3, 4)
ORDER BY region_name, country_name;

-- ************************
-- Exercise 7-5
-- ************************
SELECT COUNT(*)
FROM employees;

SELECT count(*)
FROM departments;

SELECT 
  (SELECT COUNT(*) FROM employees) "Row count in employees table",
  (SELECT COUNT(*) FROM departments) "Row count in departments table", 
  (SELECT COUNT(*) FROM employees) * (SELECT COUNT(*) FROM departments) Multiplication,
  (SELECT COUNT(*) FROM departments CROSS JOIN employees) "Row count in departments+employees cross-join"
FROM DUAL;

--- TODO: p360, question 8.
