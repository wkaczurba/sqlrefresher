-- p.367 Ex-8-1.
SELECT sysdate TODAY,
  (SELECT count(*) FROM departments) Dept_count,
  (SELECT count(*) FROM employees) Emp_count
FROM dual;

DESC employees;

SELECT *
FROM employees
WHERE employee_id 
  IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL);


