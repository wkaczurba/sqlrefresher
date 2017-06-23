-- p.77
-- More here: https://oracle-base.com/articles/misc/analytic-functions
desc employees;

--clear breaks;
--break on job_id skip 1 duplicates;

SELECT EMPLOYEE_ID, 
       avg(salary) over (partition by job_id) average_per_job_id,
       round(avg(salary) over (), -2) average_of_all_jobs,
       sum(salary) over (partition by job_id) sum_of_all_same_job_ids,
       salary,  
       salary - avg(salary) over (partition by job_id) DIFFERENCE_FROM_AVG,
       job_id
       FROM employees
       ORDER BY job_id;


--break on department_id skip 1 duplicates;
--select employee_id, department_id, salary, avg(salary) over (partition by department_id) as avg_dept_sal from employees;

SELECT department_id, FIRST_VALUE(employee_id) OVER (partition by department_id order by employee_id) from employees;
SELECT employee_id, department_id, FIRST_VALUE(employee_id) OVER (partition by department_id order by employee_id),
       LAST_VALUE(department_id) OVER (order by department_id asc nulls first) from employees;
       
SELECT col1, sum(col1) OVER (ORDER BY COL1 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) sum_till_the_end,
  sum(col1) over (order by col1 rows between unbounded preceding and current row) sum_from_the_beginning

FROM (SELECT 1 COL1 FROM DUAL
UNION
SELECT 2 COL1 FROM DUAL
UNION
SELECT 3 COL1 FROM DUAL
UNION
SELECT 4 COL1 FROM DUAL
UNION
SELECT 5 COL1 FROM DUAL
UNION
SELECT 6 COL1 FROM DUAL);

