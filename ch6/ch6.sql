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
  ORDER by department_id

-- p.281 [SUM; null values are ignored]
--   SUM(DISTINCT expr)
--   SUM(ALL expr)
--   SUM(expr)
--   MAX(DISTINCT expr), MIN(DISTINCT expr)-
--   MAX(ALL expr), MIN(ALL expr)
--   MAX(expr), MIN(expr)




