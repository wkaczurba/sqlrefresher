SELECT last_name
FROM employees
WHERE salary >
  (SELECT max(salary)
   FROM employees
   WHERE last_name='Taylor')
ORDER BY last_name;

SELECT last_name
FROM employees
WHERE salary > ALL
  (SELECT (salary)
   FROM employees
   WHERE last_name='Taylor')
ORDER BY last_name;

SELECT last_name
FROM employees
WHERE salary > ANY
  (SELECT (salary)
   FROM employees
   WHERE last_name='Taylor')
ORDER BY last_name;

SELECT last_name
FROM employees
WHERE salary > 
  (SELECT min(salary)
   FROM employees
   WHERE last_name='Taylor')
ORDER BY last_name;

--- One possible solution:
SELECT e.last_name, e.salary "Salary", t.first_name "Taylor's first_name", t.last_name "Taylor's last name", t.salary "Taylor's salary"
FROM employees e
JOIN employees t ON (e.salary > t.salary AND t.last_name='Taylor')
ORDER BY 1 ASC NULLS FIRST;
