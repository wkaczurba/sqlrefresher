-- Ch9
-- Describe set operators
-- Use a set operator to combine multiple queries into a Single Query
-- Control the Order of Rows Returned

-- SET OPERATORS:
--   UNION     (sorting + unique)
--   UNION ALL (no sorting, non-unique)
--   INTERSECT (common a v b)
--   MINUS     (a - b)

-- p.400 Ex. 9-1
SELECT region_name
FROM regions
UNION
SELECT region_name
FROM regions;

SELECT region_name
FROM regions
UNION ALL
SELECT region_name
FROM regions;

SELECT region_name
FROM regions
MINUS
SELECT region_name
FROM regions;

SELECT region_name
FROM regions
INTERSECT
SELECT region_name
FROM regions;

DESC new_dept;

SAVEPOINT S1;

--declare
--   c int;
--begin
--   select count(*) into c from user_tables where table_name = upper('OLD_DEPT');
--   if c = 1 then
--      execute immediate 'drop table old_dept';
--   end if;
--end;


CLEAR SCREEN;

DROP TABLE OLD_DEPT;
CREATE TABLE OLD_DEPT 
     (DEPT_NO NUMBER(10),
      DNAME CHAR(20),
      DATED DATE);

INSERT ALL
  INTO OLD_DEPT (DEPT_NO, DNAME, DATED) VALUES (10, 'Accounts',TO_DATE('19-OCT-13 05.42.55','DD-MON-YY HH24.MI.SS'))
  INTO OLD_DEPT (DEPT_NO, DNAME, DATED) VALUES (20, 'Supports',TO_DATE('19-OCT-13 05.43.08','DD-MON-YY HH24.MI.SS'))
  SELECT * FROM DUAL;
  
SELECT * FROM OLD_DEPT;

DROP TABLE NEW_DEPT;
CREATE TABLE NEW_DEPT 
     (DEPT_NO NUMBER(38),
      DNAME VARCHAR2(14),
      STARTD TIMESTAMP(6));

INSERT ALL
  INTO NEW_DEPT VALUES (10, 'Accounts','19-OCT-13 05.43.51.757000')
  INTO NEW_DEPT VALUES (30, 'Admin','19-OCT-13 05.44.03.961000')
  SELECT * FROM DUAL;
  
SELECT * FROM OLD_DEPT;
SELECT * FROM NEW_DEPT;


SELECT * FROM OLD_DEPT
UNION ALL
SELECT * FROM NEW_DEPT;

-- p.403:
SELECT dept_no, trim(DNAME), trunc(dated) FROM OLD_DEPT
UNION
SELECT dept_no, trim(DNAME), trunc(startd) FROM NEW_DEPT;

-- Figure 9-4 p.404:
SELECT * 
FROM old_dept
INTERSECT
SELECT *
FROM new_dept;

SELECT dept_no, trim(dname), trunc(dated)
FROM old_dept
INTERSECT
SELECT dept_no, trim(dname), trunc(startd)
FROM new_dept;
  
SELECT * 
FROM old_dept
MINUS
SELECT *
FROM new_dept;

SELECT dept_no, trim(dname), trunc(startd)
FROM new_dept
MINUS
SELECT dept_no, trim(dname), trunc(dated)
FROM old_dept;

-- ******************************
-- p.405 -> MORE COMPLEX EXAMPLES
-- ******************************

-- ** Creating empty (null) columns to satisfy set. **:
--SELECT name, tail_length, NULL
--FROM cats
--UNION ALL
--SELECT name, NULL, wingspan
--FROM birds;

-- ** More than two queries
--SELECT name
--FROM permstaff
--WHERE location='Germany'
--UNION ALL
--SELECT name
--FROM consultants
--WHERE work_area='Western Europe'
--MINUS
--SELECT name
--FROM blacklist;

--
-- p.407, Exercise 9-2
--
SELECT department_id, COUNT(1)
FROM employees
WHERE department_id IN (20,30,40)
GROUP by department_id;

SELECT 20, count(1)
FROM employees
WHERE department_id = 20
UNION ALL
SELECT 30, count(1)
FROM employees
WHERE department_id IN (30)
UNION ALL
SELECT 40, count(1)
FROM employees
WHERE department_id IN (40);

-- p.408, ::4
SELECT manager_id
FROM employees
WHERE department_id = 20
INTERSECT
SELECT manager_id
FROM employees
WHERE department_id = 30
MINUS
SELECT manager_id
FROM employees
WHERE department_id = 40;

-- p.408 ::5
SELECT department_id, NULL, SUM(salary)
FROM employees
GROUP by department_id
UNION
SELECT null, manager_id, SUM(salary)
FROM employees
GROUP by manager_id
UNION ALL
SELECT null, null, SUM(salary)
FROM employees;

-- p.409, fig 9-5
SELECT department_id, count(1)
FROM employees
WHERE department_id IN (20, 30, 40)
GROUP BY department_id;

SELECT 20, COUNT(1)
FROM employees
WHERE department_id = 20
UNION ALL
SELECT 30, COUNT(1)
FROM employees
WHERE department_id = 30
UNION ALL
SELECT 40, COUNT(1)
FROM employees
WHERE department_id = 40;

SELECT manager_id
FROM employees
WHERE department_id = 20
INTERSECT
SELECT manager_id
FROM employees
WHERE department_id=30
MINUS
SELECT manager_id
FROM employees
WHERE department_id=40;

-- p.410, fig 9-6
SELECT department_id, null, sum(salary)
FROM employees
GROUP BY department_id
UNION ALL
SELECT NULL, manager_id, sum(salary)
FROM employees
GROUP BY manager_id
UNION ALL
SELECT NULL, NULL, sum(salary)
FROM employees
ORDER BY 1 NULLS LAST, 2 NULLS LAST, 3 NULLS LAST;

-- p.411 -> Control the Order of Rows Returned
-- p.411 Exercise 9-3
-- Control of the rows returned
(SELECT dept_no, trim(dname) name
FROM old_dept)
UNION
(SELECT dept_no, trim(dname)
FROM new_dept)
ORDER BY name;
-- THE ABOVE IS THE SAME AS:
SELECT dept_no, trim(dname) name
FROM old_dept
UNION
SELECT dept_no, trim(dname)
FROM new_dept
ORDER BY name;

  -- THIS IS WRONG!!!. CANT SORT IN COMPOUND QUERY.
--  (SELECT dept_no, trim(dname) name
--  FROM old_dept)
--  UNION
--  (SELECT dept_no, trim(dname)
--  FROM new_dept ORDER BY name);

-- Exercise 9.3
    --SELECT manager_id
    --FROM employees
    --WHERE department_id = 20
    --INTERSECT
    --SELECT manager_id
    --FROM employees
    --WHERE department_id=30
    --MINUS
    --SELECT manager_id
    --FROM employees
    --WHERE department_id=40
    --ORDER BY 

-- UNION_ALL does not sort the results!!!; It is a regular sum!!!
  SELECT department_id dept, NULL mgr, sum (salary)
  FROM employees
  GROUP BY department_id
UNION ALL
  SELECT NULL, manager_id, sum (salary)
  FROM employees
  GROUP BY manager_id
UNION ALL
  SELECT NULL, NULL, sum(salary)
  FROM employees
  
-- UNION Sorts the stuff!
SELECT department_id dept, NULL mgr, sum (salary)
  FROM employees
  GROUP BY department_id
UNION
  SELECT NULL, manager_id, sum (salary)
  FROM employees
  GROUP BY manager_id
UNION
  SELECT NULL, NULL, sum(salary)
  FROM employees;
  
-- Ex9-3 point 3: (p.414, Fig9-9)

SELECT NVL(department_id, 0) dept, 0 mgr, NVL(sum (salary), 0)
  FROM employees
  GROUP BY department_id
UNION
  SELECT 0, NVL(manager_id, 0), sum (salary)
  FROM employees
  GROUP BY manager_id
UNION
  SELECT 0, 0, NVL(sum(salary), 0)
  FROM employees;
  
  
-- Or the way book does it:
-- 'DEP: x', 'MAN: x', 
SELECT 'DEP: ' || TO_CHAR(nvl(department_id, 0)) dept, 
       'MAN: 0',
       SUM(salary)
FROM employees
GROUP BY department_id
UNION
SELECT 'DEP: 0', 
       'MAN: ' || to_char(nvl (manager_id, 0)),
       sum(salary)
FROM employees
GROUP BY manager_id
UNION
SELECT 'Overall',
       'Sum:',
      sum(salary)
FROM employees;