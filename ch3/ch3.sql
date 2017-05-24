-- Chapter 3

-- Implicit conversion TEXT -> NUMBER;
-- p.112;
SELECT last_name, salary
FROM employees
WHERE salary > '20000';

SELECT last_name, salary
FROM employees
WHERE salary > 20000;

SELECT last_name, salary
FROM employees
WHERE salary/10 = department_id * 10;

-- p.114 Character based conditions:
SELECT last_name
FROM employees
WHERE job_id = 'SA_REP';

-- p.115, fig 3-4.
SELECT first_name, last_name
FROM employees
WHERE first_name=last_name;

SELECT first_name, last_name
FROM employees
WHERE first_name>last_name;

-- p.116 fig 3-5; equivalence of conditional expressions:
SELECT employee_id, job_id, last_name
FROM employees
WHERE 'SA_REP'||'King' = job_id||last_name;

SELECT employee_id, job_id, last_name
FROM employees
WHERE job_id||last_name = 'SA_REP'||'King';

--P.117
SELECT employee_id
FROM job_history
WHERE start_date = end_date;

SELECT employee_id
FROM job_history
WHERE start_date = '01-JAN-2001';

SELECT employee_id
FROM job_history
WHERE start_date = '01-JAN-01';

SELECT employee_id
FROM job_history
WHERE start_date = '01-JAN-1999';

-- p.118 Arithmetics with dates; (fig 3.6)
SELECT start_date, employee_id
FROM job_history
WHERE start_date + 1 = '25-MAR-06';

-- p.121 (Equality and inequality)
SELECT last_name, salary
FROM employees
WHERE salary > 5000;

SELECT last_name, salary
FROM employees
WHERE salary < 3000;

-- Compopsite inequality operators:
-- <> and != are the same.!

SELECT last_name, salary
FROM employees
WHERE salary <> department_id;

SELECT last_name, salary
FROM employees
WHERE salary != department_id;

-- p. 122.
-- NLS setting (National Language Support) decides if character data is compared using binary or linguistic comparision method.
SELECT last_name
FROM employees
WHERE last_name < 'King';

SELECT 
  CASE 
    WHEN ('K ' < 'K') THEN 'SMALLER' 
    WHEN ('K ' > 'K') THEN 'GREATER'
    ELSE 'EQUAL'
  END FROM DUAL;

-- 
SELECT last_name, hire_date
FROM employees
WHERE hire_date < '01-DEC-2003';

-- p.124 Range comparision with the BETWEEN Operator **
SELECT last_name, salary
FROM employees
WHERE salary BETWEEN 3400 AND 4000;

SELECT last_name, salary
FROM employees
WHERE salary >= 3400 AND salary <= 4000;

SELECT first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '30-AUG-2004' AND '5-JAN-2005';

-- This will FAIL: Cant add 30 + LITERAL:
--SELECT first_name, hire_date
--FROM employees
--WHERE hire_date BETWEEN '30-AUG-2004' AND '5-JAN-2005' + 30;

SELECT first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '30-AUG-2004' AND TO_DATE('5-JAN-2005') + 30;

SELECT first_name, hire_date
FROM employees
WHERE '30-AUG-2004' BETWEEN hire_date + 30 AND TO_DATE('5-JAN-2005');

-- p.126 Set Comparision with the IN Operator

SELECT last_name, salary
FROM employees
WHERE salary IN (3000, 4000, 6000);

SELECT last_name, salary
FROM employees
WHERE salary = 30000
OR salary = 4000
OR salary = 6000;

SELECT last_name
FROM employees
WHERE last_name IN ('Ande', 'Banda', 'Urman');

SELECT last_name, hire_date
FROM employees
WHERE hire_date IN ('17-JUN-2003','05-FEB-2006');

----------------
-- P.127 Pattern comparision with the LIKE opeartor
--------------------
SELECT first_name
FROM employees
WHERE first_name LIKE 'A%';

SELECT first_name
FROM employees
WHERE first_name LIKE '%';

-- LIKE '%' will NOT return NULL values!!!
SELECT X FROM
  (SELECT NULL as "X" from DUAL)
WHERE X LIKE '%';

-- p.128. = and LIKE will behave in a similar fashion as long as no matcher (_ and %) characters.
SELECT last_name 
FROM employees
WHERE last_name LIKE 'King';

SELECT last_name 
FROM employees
WHERE last_name = 'King';

-- The one below cannot be replaced with equality (=) operator:
SELECT last_name
FROM employees
WHERE last_name LIKE 'K_ng';

-- Note: the one below is not a good example for finding "SA_..." as "SAP" will also match
SELECT *
FROM jobs
WHERE job_id LIKE 'SA_%';

-- Escaping characters: The one below escaped _ character using preceding $.
SELECT job_id
FROM jobs
WHERE job_id LIKE 'SA$_%' ESCAPE '$';

SELECT job_id
FROM jobs
WHERE job_id LIKE 'SA\_%' ESCAPE '\';

-- Escaping % can be done the same way.
SELECT * FROM
  (SELECT '100% precent' AS percents FROM DUAL)
WHERE percents LIKE '100\% precent' ESCAPE '\';

-- p.131 Exercise 3-1:
DESC departments;

SELECT department_name
FROM DEPARTMENTS
WHERE department_name LIKE '%ing';

-- p.132 NULL comparision with the IS NULL;
--       using = will not return anything!!
SELECT last_name, commission_pct
FROM employees
WHERE commission_pct IS NULL;

-- The one below returns NO ROWS!; because incorrect operator used!
SELECT last_name, commission_pct
FROM employees
WHERE commission_pct = NULL;

-- P.134 The AND operator
--   ** NULL AND FALSE => FALSE
--   ** NULL AND TRUE => NULL
--   ** NULL AND NULL => NULL;
SELECT first_name, last_name, commission_pct
FROM employees
WHERE first_name LIKE 'J%'
AND commission_pct > 0.1;

SELECT first_name, last_name, commission_pct, hire_date
FROM employees
WHERE first_name LIKE 'J%'
AND commission_pct > 0.1
AND hire_date > '01-JUN-1996'
AND last_name LIKE '%o%';

-- p.136 The OR operator.
-- NULL OR FALSE => FALSE
-- NULL OR NULL => FALSE
-- NULL OR TRUE => TRUE
SELECT first_name, last_name, commission_pct
FROM employees
WHERE first_name LIKE 'B%'
OR commission_pct > 0.35;

SELECT first_name, last_name, commission_pct, hire_date
FROM employees
WHERE first_name LIKE 'B%'
OR commission_pct > 0.35;

-- In the one below for some commission_pct will equal to NULL;
-- The rows will still be returned as other clauses must return TRUE.
SELECT first_name, last_name, commission_pct, hire_date
FROM employees
WHERE first_name LIKE 'B%'
OR commission_pct > 0.35
OR hire_date > '01-MAR-2008'
OR last_name LIKE 'B%';


-- p.137 The NOT operator
-- NOT NULL -> NULL;
--
-- WHERE last_name='KING'
--   WHERE NOT (last_name='KING')
-- WHERE first_name LIKE 'R%'
--   WHERE NOT (first_name LIKE 'R%')
-- WHERE department_id IN (10, 20, 30)
--   WHERE department_id NOT IN (10, 20, 30)
-- WHERE salary BETWEEN 1 and 3000
--   WHERE salary NOT BETWEEN 1 AND 3000
-- WHERE commission IS NULL
--   WHERE commission IS NOT NULL;

SELECT first_name, last_name, commission_pct
FROM employees
WHERE first_name NOT LIKE 'B%'
OR NOT (commission_pct > 0.35);

-- p. 139 Precedence rules
SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%' AND salary > department_id * 200
OR
job_id IN ('MK_REP','MK_MAN') AND commission_pct IS NOT NULL;

SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 200;

SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 100
AND commission_pct IS NOT NULL
OR
job_id = 'MK_MAN';

-- p.141 Figure 3-16.
SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 200
OR job_id IN ('MK_REP','MK_MAN')
AND commission_pct IS NOT NULL;

SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 200;

SELECT last_name,salary,department_id,job_id,commission_pct
FROM employees
WHERE job_id IN ('MK_REP','MK_MAN')
AND commission_pct IS NOT NULL;

-- p.142 Figure 3-7
SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 100
AND commission_pct IS NOT NULL
OR job_id = 'MK_MAN';

SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE last_name LIKE '%a%'
AND salary > department_id * 100
AND commission_pct IS NOT NULL;

SELECT last_name, salary, department_id, job_id, commission_pct
FROM employees
WHERE job_id = 'MK_MAN';

-- p. 143 Sor tthe Rows Retrieved by a Query, OREDER BY
-- p. 144 Ascending and Descending Sorting

SELECT last_name, salary, commission_pct
FROM employees
WHERE job_id IN ('SA_MAN','MK_MAN') 
ORDER BY last_name;

-- This one uses alias "emp_value" that is later used for sorting.
SELECT last_name, salary,  hire_date, hire_date-(salary/10) emp_value
FROM employees
WHERE job_id IN ('SA_REP','MK_MAN')
ORDER BY emp_value;

-- p.145., fig 3-18
SELECT last_name, salary, commission_pct
FROM employees
WHERE job_id IN ('SA_MAN','MK_MAN')
ORDER BY commission_pct;

SELECT last_name, salary, commission_pct
FROM employees
WHERE job_id IN ('SA_MAN','MK_MAN')
ORDER BY commission_pct DESC;

SELECT last_name, salary, commission_pct
FROM employees
WHERE job_id IN ('SA_MAN','MK_MAN')
ORDER BY commission_pct DESC NULLS LAST;

SELECT commission_pct
FROM employees
ORDER BY commission_pct DESC NULLS FIRST;

-- p. 146 Positional sorting
SELECT last_name, hire_date, salary
FROM employees
WHERE job_id IN ('SA_REP','MK_MAN')
ORDER BY 2;

-- p. 146 Composite sorting
SELECT job_id, last_name, salary, commission_pct
FROM employees
WHERE job_id IN ('SA_REP', 'MK_MAN')
ORDER BY job_id DESC, last_name, 3 DESC;

SELECT job_id, last_name, salary, hire_date
FROM employees
WHERE job_id IN ('SA_REP','MK_MAN')
ORDER BY job_id DESC, last_name, 3 DESC;

-- p.148 Exercise 3-2
DESC jobs;

SELECT JOB_TITLE, MIN_SALARY, MAX_SALARY, MAX_SALARY - MIN_SALARY "Variance"
FROM jobs
WHERE JOB_TITLE LIKE '%President%' OR
JOB_TITLE LIKE '%Manager%'
ORDER BY "Variance" DESC, JOB_TITLE DESC;


-- p.150 Ampersand substituition.

-- Use KING, 100
/*SELECT employee_id, last_name, phone_number
FROM employees
WHERE last_name = '&LASTNAME'
OR employee_id = &EMPNO;

-- p.152, Double ampersand substitution:
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE '%&SEARCH%'
AND first_name LIKE '%&SEARCH%';
*/
/*
UNDEFINE s;
--DEFINE s=abc;
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE '%&&s%'
AND first_name LIKE '%&s%';

-- Substituting column names, p.154
UNDEFINE col;
DEFINE col="SALARY";
SELECT first_name, job_id, &&col
FROM employees
WHERE job_id IN ('MK_MAN','SA_MAN')
ORDER BY &col;

-- Substituting Expressions and Text
SELECT &rest_of_statement;
SELECT department_name FROM departments;

--UNDEFINE SELECT_CLAUSE
--UNDEFINE FROM_CLAUSE
--UNDEFINE WHERE_CLAUSE
--UNDEFINE ORDER_BY_CLAUSE;
--DEFINE SELECT_CLAUSE="*"
--DEFINE FROM_CLAUSE="regions"
--DEFINE WHERE_CLAUSE="1=1"
--DEFINE ORDER_BY_CLAUSE="region_name DESC";
SELECT &SELECT_CLAUSE
  FROM &FROM_CLAUSE
 WHERE &WHERE_CLAUSE 
 ORDER BY &ORDER_BY_CLAUSE;
*/

-- p. 158 Define and Undefine command;
DEFINE;
DEFINE x = 'zzz';
DEFINE y = "ZZZ";
UNDEFINE x;
UNDEFINE y;

-- p.161 The ampersand will be ignored when DEFINES are set OFF.
SET DEFINE OFF;
SELECT 'Soda & bacon' FROM DUAL;
SET DEFINE ON;
  -- Below you will be asked for a variable
  --SET DEFINE ON;
  --SELECT 'Soda & bacon' FROM DUAL;
  
 --SELECT CASE x=y WHEN TRUE FROM DUAL;
 
-- p.162 The verify command;

-- Verify is ON by default
UNDEFINE x;
SET VERIFY ON; 
SELECT &x FROM DUAL;

-- Setting it to off will make it stop displaying values stored;
SET VERIFY OFF;
SELECT * FROM DEPARTMENTS;

-- p. 163 Ex 3-3: Using ampersand substitution
DESC employees;
DEFINE EMPLOYEE_ID=100;
DEFINE TAX_RATE=0.22;
SELECT &&EMPLOYEE_ID EMPLOYEE_ID,
  first_name, 
  last_name, 
  &&TAX_RATE tax_rate,
  salary,
  salary * 12 "ANNUAL SALARY",
  (&tax_rate * salary * 12) AS "TAX",
  salary
FROM employees;
