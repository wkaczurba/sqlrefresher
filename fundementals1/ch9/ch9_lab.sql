--
desc job_history;


-- Q.1:
SELECT employee_id, last_name FROM employees
MINUS
SELECT employee_id, last_name FROM job_history
JOIN employees USING (employee_id);


-- Q2:
-- **  WRONG ANSWER: **
--SELECT employee_id, last_name, jh.job_id
--FROM employees e
--JOIN job_history jh USING (employee_id)
--WHERE employee_id IN (
--  SELECT employee_id FROM employees
--  INTERSECT
--  SELECT employee_id FROM job_history
--);

-- CORRECT:
(SELECT last_name, employee_id, job_title
FROM employees
JOIN jobs USING (job_id))
INTERSECT 
(SELECT last_name, employee_id, job_title
FROM job_history
JOIN jobs USING (job_id)
JOIN employees USING (employee_id));

-- CORRECT(2) and (even slightly better... as it gives more details):
SELECT employee_id, e.last_name, e.first_name, jh.job_id, j.job_title
FROM employees e
JOIN job_history jh USING (employee_id)
JOIN jobs j ON (j.job_id = jh.job_id)
WHERE employee_id IN (SELECT employee_id FROM (
  SELECT employee_id, job_id FROM employees
  INTERSECT
  SELECT employee_id, job_id FROM job_history
));

-- Q3 (3):
DEFINE emp_id = 101;

(SELECT employee_id, job_id, job_title
FROM employees
JOIN jobs USING (job_id)
WHERE employee_id = &&emp_id
UNION
SELECT employee_id, job_id, job_title
FROM job_history
JOIN jobs USING (job_id)
WHERE employee_id = &&emp_id);

SELECT job_title
FROM jobs
JOIN employees USING (job_id)
WHERE employee_id=&&Who
UNION
SELECT job_title
FROM jobs
JOIN job_history USING (job_id)
WHERE employee_id=&&Who;

