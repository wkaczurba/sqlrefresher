-- Use HR schema
SELECT ROWNUM, LAST_NAME, FIRST_NAME FROM employees;

-- This will make rownum unordered
SELECT ROWNUM, LAST_NAME, FIRST_NAME FROM employees ORDER BY first_name;


  -- This will not return desired values as rownum is applied before "ORDER BY":
    -- SELECT ROWNUM, LAST_NAME, FIRST_NAME FROM employees WHERE rownum < 5 ORDER BY first_name;

-- This will return desired values:
SELECT last_name, first_name
  FROM (SELECT last_name, first_name FROM employees ORDER by first_name)
  WHERE rownum < 5;
  
-- Compare: -> intersection bad selection + good selection.
SELECT last_name, first_name
  FROM (SELECT ROWNUM, LAST_NAME, FIRST_NAME FROM employees WHERE rownum < 5 ORDER BY first_name)
INTERSECT
(SELECT last_name, first_name
  FROM (SELECT last_name, first_name FROM employees ORDER by first_name)
  WHERE rownum < 5);



