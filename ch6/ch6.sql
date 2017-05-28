-- p.278 Intro
-- Functions: AVG, MAX, MIN, COUNT, SUM
-- Clauses: GROUP BY, HAVING

-- p.279
-- SELECT group_function(column or expression)
-- FROM <table>
-- [GROUP BY]
-- [HAVING]
-- [ORDER BY]
--

SELECT count(*), department_id
  FROM employees
  GROUP BY department_id
  ORDER BY department_id;

SELECT department_id, 
  COUNT(DISTINCT employee_id), 
  COUNT(employee_id), 
  COUNT(DISTINCT first_name),
  COUNT(ALL first_name), -- by default it is 'ALL'.
  COUNT(*) - COUNT(DISTINCT first_name) number_of_repeating_names
  FROM employees
  GROUP BY department_id
  ORDER BY department_id;
  
SELECT first_name , COUNT(first_name) NUMBER_OF_OCCURANCES
  FROM employees
  GROUP BY first_name
  ORDER BY 2 DESC;

SELECT count(*), department_id
  FROM employees
  GROUP by department_id
  ORDER by department_id;

-- p.281 [SUM; null values are ignored]
--   SUM([DISTINCT | ALL] expr)
--   MAX([DISTINCT | ALL] expr)
--   MIN([DISTINCT | ALL] expr)
--   VARIANCE([DISTINCT|ALL] expr)
--   STDDEV([DISTINCT|ALL] expr)

SELECT COUNT(*) "All employees" FROM employees;
SELECT COUNT(commission_pct) "Employes with non-null COMMISSION_PCT" FROM employees;
SELECT COUNT(DISTINCT commission_pct) "Employees with distinct (and non-null) commission_pct" FROM employees;
SELECT COUNT(DISTINCT NVL(commission_pct, 0)) "Employees with distinct (and null) commission_pct" FROM employees;
  SELECT DISTINCT commission_pct "Employees with distinct commission_pct (includes null)" FROM employees;

SELECT COUNT(hire_date), count(manager_id) FROM employees;

-- p.285
SELECT COUNT(*),
       count(DISTINCT nvl(department_id, 0)),
       count(DISTINCT job_id)
FROM employees;

-- SUM
SELECT SUM(2) FROM EMPLOYEES; -- No rows in employyees table * 2
SELECT SUM(SALARY) FROM employees;
SELECT SUM(DISTINCT SALARY) FROM employees;
SELECT SUM(COMMISSION_PCT) FROM employees;

-- p.286
-- The (DATE1 - DATE2) returns a NUMBER, so it can be summed:
SELECT sum(TO_DATE('31-DEC-2015','DD-MON-YYYY')- hire_date) / 365.25
       "Years worked by end 2015"
FROM employees;

  -- This will be an error as you cannot sum dates.
  --SELECT SUM(hire_date) FROM employees;

-- p.286 SELECT AVG([DISTINCT|ALL] expr)
SELECT AVG(2) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT avg(DISTINCT salary) FROM employees;
SELECT avg(commission_pct) FROM employees;

SELECT last_name, job_id, 
    (TO_DATE('31-DEC-2015','DD-MON-YYYY') - hire_date) / 365.25
    "Years worked by End 2015 by IT"
FROM employees
WHERE job_id = 'IT_PROG';

SELECT min(commission_pct), max(commission_pct) FROM employees;
SELECT min(start_date), max(end_date) FROM job_history;
SELECT min(job_id), max(job_id) FROM employees;

SELECT min(hire_date), min(salary), max(hire_date), max(salary)
FROM employees
WHERE job_id = 'SA_REP';

-- p.289 Exercise 6.1
SELECT ROUND(AVG(LENGTH(COUNTRY_NAME))) FROM countries;

-- NESTED GROUP FUNCTIONS:
-- G1(group_item) = result      --> HERE: GROUP BY IS OPTIONAL
-- G1(G2(group_item)) = result  --> HERE: GROUP BY IS MANDATORY
-- G1(G2(G3())) IS NOT ALLOWED

-- p.291, fig 6-6
SELECT sum(commission_pct), nvl(department_id, 0)
FROM employees
WHERE nvl(department_id, 0) IN (40, 80, 0)
GROUP BY department_id;

SELECT avg(sum(commission_pct))
FROM employees
WHERE nvl(department_id, 0) IN (40, 80, 0)
GROUP BY department_id;

-- fig 6-7 p. 293
SELECT count(DISTINCT(nvl(department_id, 0)))
  FROM employees;
  
SELECT distinct department_id
  FROM employees
  ORDER BY department_id;


-- p.292-294
-- GROUP BY clause:
--
-- SELECT column | expression | group_function(column | expression [alias]) ...,
-- FROM table
-- [WHERE condition]
-- [GROUP BY {col(s)|expr}
-- [ORDER BY {col(s)|expr|numeric_pos} [ASC|DESC] [NULLS FIRST | NULLS LAST]]

SELECT max(salary), count(*)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- fig 6-8 p295:
-- PROBLEM:
-- This will cause problems: count(*) groups and end_date is ungroupped (not mentioned in a GROUP BY clause)
  -- SELECT end_date, count(*)
  -- FROM job_history;
-- Solution:
SELECT end_date, count(*)
FROM job_history
GROUP BY end_date;

-- PROBLEM: AGAIN THIS WILL FAIL AS START_DATE is not in the GROUP BY clause.
  --SELECT end_date, start_date, count(*)
  --FROM job_history
  --GROUP BY end_date;
-- SOLUTION:
SELECT end_date, start_date, count(*)
FROM job_history
GROUP BY end_date, start_date;

SELECT to_char(end_date,'YYYY') "Year", 
  COUNT(*) "Number of employees"
FROM job_history
GROUP BY to_char(end_date,'YYYY')
ORDER BY count(*) DESC;

-- p.296 - Groupping by multiple columns
SELECT department_id, sum(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;

SELECT department_id, job_id, sum(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id, job_id;

-- p.297 fig. 6-9
SELECT department_id, sum(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id, job_id;

-- p.297 exercise 6-2.
--SELECT TABLE_NAME FROM USER_TABLES;
DESC job_history;

SELECT to_char(end_date,'YYYY') "Quitting year", job_id, COUNT(*) "Number of employees", 
FROM job_history
GROUP BY TO_CHAR(end_date,'YYYY'), job_id
ORDER BY COUNT(*) DESC;

--p.299
SELECT DISTINCT job_id FROM employees;

SELECT min(length(last_name)), max(length(last_name))
FROM employees 
WHERE job_id LIKE 'SA_REP';

SELECT COUNT(*), TO_CHAR(hire_date, 'YYYY'), job_id, salary
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY'), job_id, salary
ORDER BY TO_CHAR(hire_date, 'YYYY');


-- p.299 HAVING clause (include or exclude GROUPS using the CLAUSE form)
--   Restricts at GROUP level
-- HAVING CLAUSE:
--   SELECT ...
--   FROM ...
--   [WHERE ...]
--   [GROUP BY...]
--   [HAVING...]
--   [ORDER BY...]
-- "HAVING" is usually after GROUP BY, but can be before (less common)
SELECT department_id
FROM job_history
WHERE department_id IN (50,60 ,80, 110);

SELECT department_id, count(*)
FROM job_history
WHERE department_id IN (50,60 ,80, 110)
GROUP BY department_id;
--HAVING count(*) > 1;

SELECT department_id, count(*)
FROM job_history
WHERE department_id IN (50,60 ,80, 110)
GROUP BY department_id
HAVING count(*) > 1;

SELECT department_id, count(*)
FROM job_history
WHERE department_id IN (50,60 ,80, 110)
GROUP BY department_id
HAVING count(*) > 1 AND department_id > 70;

-- HAVING requires "GROUP BY" clause in the query
SELECT job_id, avg(salary), count(*)
FROM employees
GROUP BY job_id;

SELECT job_id, avg(salary), count(*)
FROM employees
GROUP BY job_id
HAVING avg(salary) > 10000;

SELECT job_id, avg(salary), count(*)
FROM employees
GROUP BY job_id
HAVING avg(salary)>10000 AND COUNT(*)>1;

-- p.304 Exercise 6-3;
SELECT TO_CHAR(hire_date,'DAY') hire_day, count(*)
FROM employees
GROUP BY TO_CHAR(hire_date,'DAY')
HAVING count(*) >= 18;
