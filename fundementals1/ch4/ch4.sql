-- p.177 Operating on Character Data
SELECT lower('SQL') FROM DUAL;
SELECT upper('sql') FROM DUAL;
SELECT initcap('ala ma kota') FROM DUAL;
SELECT length('Some words here') FROM DUAL;

-- p.178
-- FAIL (TOO MANY ARGS):
-- SELECT CONCAT('first word,','second one,','third one here') FROM DUAL;
SELECT CONCAT('first,',CONCAT('second,','third')) FROM DUAL;
SELECT SUBSTR('12345678',2,3) FROM DUAL;
SELECT SUBSTR('ALA MA KOTA', 8, 4) FROM DUAL; -- KOTA
SELECT INSTR('ALA BELA CELA DELTA', 'ELA') FROM DUAL; -- 6
SELECT INSTR('ALA BELA CELA DELTA', 'ELA', 2) FROM DUAL; -- 6
SELECT INSTR('ALA BELA CELA DELTA', 'ELA', 6) FROM DUAL; -- 6
SELECT INSTR('ALA BELA CELA DELTA', 'ELA', 7) FROM DUAL; -- 11

SELECT q'<'>'||LPAD('123',5)||q'<'>', LENGTH(LPAD('123',5)) FROM DUAL;
SELECT q'[']'||RPAD('123',5)||q'(')', LENGTH(RPAD('123',5)) FROM DUAL;
SELECT LPAD('PLOTEK', 10, '#') FROM DUAL;
SELECT RPAD('PLOTEK', 10, '#') FROM DUAL;

SELECT TRIM(' JOZEK DAJ WOZEK     ') FROM DUAL;
-- INCORRECT:
-- SELECT TRIM('***SOME STARS***', '*') FROM DUAL;
SELECT TRIM('*' FROM '***SOME STARS***') FROM DUAL;

-- p.178, finished here:
SELECT REPLACE('#PASSWORD#','WORD','PORT') FROM DUAL;
SELECT REPLACE('AABBCCDDAABBCCDD','AA','XX') FROM DUAL; -- REPLACES ALL

-- p.179 Opearting on numeric data
SELECT ROUND(123.123, 1) FROM DUAL; -- Expect: 123.1
SELECT ROUND(123.445, 1) FROM DUAL; -- Expect: 123.4
SELECT ROUND(123.455, 1) FROM DUAL; -- Expect: 123.5
SELECT ROUND(123.455, 0) FROM DUAL; -- Expect: 123

SELECT TRUNC(123.456, 0) FROM DUAL; -- Expect: 123
SELECT TRUNC(12345, -1) FROM DUAL; -- Expect: 12340
SELECT TRUNC(-12345, -1) FROM DUAL; -- Expect: -12340

SELECT MOD(7, 2) FROM DUAL; -- Expect: 1
SELECT MOD(-1, 2) FROM DUAL; -- Expect: -1

-- PAGE 179: Operating on Date information:

SELECT MONTHS_BETWEEN('28-FEB-1983','01-JAN-1983') FROM DUAL; -- Expect 1.0 + 27/31

SELECT CASE 
  WHEN MONTHS_BETWEEN('28-FEB-1983','01-JAN-1983')=(1.0 + 27/31) THEN 'TRUE' 
  ELSE 'FALSE' 
END
FROM DUAL;

SELECT ADD_MONTHS('01-JAN-2008',1) FROM DUAL; -- 1 FEB
SELECT ADD_MONTHS('01-JAN-2008', 0.5) FROM DUAL; -- Returns: 1 JAN 08

SELECT LAST_DAY('22-MAY-2017') FROM DUAL; -- Returns 31-MAY-2017
SELECT NEXT_DAY('22-MAY-2017', 'SUN')  FROM DUAL;  -- Returns 28 May (SUNDAY)

SELECT SYSDATE FROM DUAL;
SELECT ROUND(TO_DATE('15-MAY-2017'), 'MONTH') FROM DUAL; -- Returns first of May
SELECT ROUND(TO_DATE('16-MAY-2017'), 'MONTH') FROM DUAL; -- Returns first of June 2017
SELECT ROUND(TO_DATE('15-FEB-2017'), 'MONTH') FROM DUAL; -- Returns first of FEb 2017!!!
SELECT ROUND(TO_DATE('01-JUN-2017'), 'YEAR') FROM DUAL; -- Returns 1 Jan of 2017
SELECT ROUND(TO_DATE('01-JULY-2017'), 'YEAR') FROM DUAL; -- Returns 1 Jan of 2018

-- This one :
SELECT TRUNC((ADD_MONTHS(SYSDATE, 1) - 1), 'MONTH') - 1 FROM DUAL;
-- Is the same as:
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- p.181
SELECT region_id, region_name, LENGTH(region_name) FROM regions;
-- 
-- Next functions to be looked into CH5: 
--   Functions: NVL, NVL2, NULLIF, COALESCE, CASE, DECODE

-- To get the last letter:
SELECT SUBSTR('12345678', LENGTH('12345678'), 1) FROM DUAL; 

SELECT region_id, region_name, LENGTH(region_name), substr(region_name, LENGTH(region_name), 1)
FROM regions
WHERE LENGTH(region_name) > 4
ORDER BY substr(region_name, LENGTH(region_name), 1);


-- p.183 Use character, number, and date functions in SELECT statements
SELECT lower(100) FROM DUAL;
SELECT lower(100+100) FROM DUAL;
SELECT lower('The sum'||100||' and '||100||' gives '|| (100 + 100)) FROM DUAL;
SELECT ('abc'||(100 + 100)) FROM DUAL;
SELECT lower(SYSDATE) FROM DUAL;
SELECT lower(SYSDATE+2) FROM DUAL;

SELECT first_name, last_name, lower(last_name)
FROM employees
WHERE lower(last_name) LIKE '%ur%';

-- Alternative (bad example):
  SELECT first_name, last_name, lower(last_name)
  FROM employees
  WHERE last_name LIKE '%ur%'
    OR last_name LIKE '%Ur%'
    OR last_name LIKE '%uR%'
    OR last_name LIKE '%UR%';

-- p.185 The UPPER Function
SELECT upper(1+2.14) FROM DUAL;
SELECT upper(SYSDATE) FROM DUAL;

SELECT * 
FROM COUNTRIES
WHERE upper(country_name) LIKE '%U%S%A%';

-- p.186 The INITCAP Function:
SELECT initcap(21/7) FROM DUAL;
SELECT initcap(SYSDATE) FROM DUAL;
SELECT initcap('init cap or init_cap or init%cap') FROM DUAL;

SELECT initcap(last_name||' works as a: '||job_id) "Job description"
FROM employees
WHERE initcap(last_name) LIKE 'H%';

SELECT initcap(last_name)||initcap(' works as a: ')||initcap(job_id) "Job description"
FROM employees
WHERE initcap(last_name) LIKE 'H%';

-- p.188 Using the case conversion Functions
SELECT first_name, last_name
FROM employees
WHERE LOWER(first_name) LIKE '%li%';

-- p.189 Character manipulation functions
--   CONCAT - similar but worse to ||
--   LENGTH 
--   INSTR
--   SUBSTR
--   REPLACE
--   RPAD, LPAD, TRIM
SELECT concat(1.2+4, ' appropriate pi') FROM DUAL;
SELECT concat('Today is: ', SYSDATE) FROM DUAL;
SELECT concat('Outer1 ', concat('Inner1','Inner2')) FROM DUAL;

SELECT concat(first_name, concat(' ', concat(last_name,concat(' earns ', salary)))) "Concat Function Example"
FROM employees
WHERE department_id = 100;

SELECT first_name||' '||last_name||' earns '||salary "Concat Operator Example"
FROM employees
WHERE department_id = 100;

-- p.192 The LENGTH function
-- LENGTH(string)
SELECT length(1+2.14 || ' approximates pi') FROM dual;
SELECT length(SYSDATE) FROM DUAL;
SELECT country_id, country_name, region_id, length(country_name) len
FROM countries
WHERE length(country_name) > 10;

-- P.192 The LPAD and RPAD functions
-- LPAD(string, length, [padstring])
-- RPAD(string, length, [padstring])

SELECT lpad(1000+200.55,14,'*') FROM DUAL;
SELECT rpad(1000+200.55,14,'*') FROM DUAL;
SELECT lpad(SYSDATE,14,'$#') FROM DUAL;
SELECT rpad(SYSDATE,4,'$#') FROM DUAL;


SELECT rpad(first_name||' '||last_name, 18 ) ||' earns '||lpad(salary,6,' ') "LPAD RPAD Example"
FROM employees
WHERE department_id = 100;

-- p.194 The TRIM Function
-- TRIM ([trailing|leading|both] trimstring FROM s);
--   e.g. 1. TRIM(TRAILING 'bc' FROM 'abc');
--        2. TRIM(leading ' ' FROM ' abc');
--        3. TRIM('*' FROM '*abc*'); 
--        4. TRIM(both '*' FROM '*abc*'); 
--   Where 3 and 4 are the same;

SELECT TRIM(TRAILING 'e' FROM 1+2.14 || ' is pie') FROM DUAL;
SELECT TRIM(BOTH '*' FROM '*******Hidden*******') FROM DUAL;
SELECT TRIM(1 from SYSDATE) FROM DUAL;

SELECT last_name, phone_number
FROM employees
WHERE trim(' '||last_name||'    ')='Smith';

SELECT TRIM(' ALA ') FROM DUAL;
SELECT TRIM(' ' FROM ' ALA ') FROM DUAL;
SELECT TRIM(BOTH ' ' FROM ' ALA ') FROM DUAL;
SELECT TRIM(LEADING '*' FROM '*ALA*') FROM DUAL;
SELECT TRIM(TRAILING '*' FROM '*ALA*') FROM DUAL;

-- The INSTR function (In-String)
--   INSTR(source_string, search_string, [search start pos], [n-th occurence)
-- 
SELECT instr(3+0.14,'.') FROM DUAL;
SELECT instr(sysdate, 'DEC') FROM DUAL;
SELECT instr('1#3#5#7#9#','#') FROM DUAL;
SELECT instr('1#3#5#7#9#','#', 5) FROM DUAL;
SELECT instr('1#3#5#7#9#','#', 3, 4) FROM DUAL;

SELECT * FROM departments
WHERE instr(department_name, 'on') = 2;

-- The SUBSTR function 
-- SUBSTR(source_string, start_pos, [number_of_characters_to_extract])
SELECT SUBSTR(10000-3, 3, 2) FROM dual;
SELECT SUBSTR(SYSDATE, 4, 3) FROM dual;
SELECT SUBSTR('1#3#5#7#9#', 1, 1) FROM DUAL; -- 1;
SELECT SUBSTR('1#3#5#7#9#', 3, 1) FROM DUAL; -- 3;
SELECT SUBSTR('1#3#5#7#9#', -2, 1) FROM DUAL; -- 9;
SELECT SUBSTR('1#3#5#7#9#', -2, 2) FROM DUAL; -- 9#;
SELECT SUBSTR('1#3#5#7#9#', -3, 2) FROM DUAL; -- #9#

-- Fig 4-11.
SELECT 'Advertising Team member: '||
  SUBSTR(first_name, 1, 1)|| '. '||
  last_name "Initial and Last name:"
FROM employees
WHERE substr(job_id, 1, 2) = 'AD';

--
-- The REPLACE function
-- REPLACE(source_string, search_item, [replacement term])
SELECT replace(10000-3,'9','85'), 10000-3 FROM dual;
SELECT replace(TO_DATE('10-DEC-1997'), 'DEC','NOV') FROM dual;
SELECT replace('1#3#5#7#9#','#','->') FROM DUAL;
SELECT replace('1#3#5#7#9#','#') FROM DUAL;
SELECT last_name, salary, REPLACE(salary, '0','000') "Dream salary", job_id
FROM employees
WHERE job_id = 'SA_MAN';

-- P. 202 Uaing the character manipulation functions.
SELECT first_name, last_name, SUBSTR(first_name, 1, 1) || ' ' || SUBSTR(last_name, 1, 14) formal_name
FROM employees
WHERE LENGTH(first_name) + LENGTH (last_name) > 15;

-- p.203 Using Numeric Functions
-- 
-- Numeric ROUND
--  ROUND(source_number, [decimal_precision])
--

SELECT round(1601.916718, 1) FROM dual; -- 1601.9
SELECT round(1601.916718, 2) FROM DUAL; -- 1601.92
SELECT round(1601.916718, 3) FROM DUAL; -- 1601.917
SELECT round(1601.916718, -3) FROM DUAL;-- 2000
SELECT round(1601.916718) FROM DUAL;    -- 1602

SELECT last_name, salary, SYSDATE-hire_date,
          round(SYSDATE-hire_date) Bonus,
          SYSDATE-hire_date 
FROM employees
WHERE job_id = 'SA_MAN';

-- p.205
-- TRUNC(source_number, [decimal precision])
SELECT trunc(1601.916718, 1) FROM DUAL; -- 1601.9
SELECT trunc(1601.916718, 2) FROM DUAL; -- 1601.91
SELECT trunc(1601.916718, -3) FROM DUAL; -- 1000
SELECT trunc(1601.916718) FROM DUAL; -- 1601

SELECT job_id, salary, salary*1.13123, trunc(salary*1.13123) "Proposed Salary Increment"
FROM employees
WHERE job_id LIKE 'FI%';

-- p.206 The MOD Function (Modulus)
--  MOD(dividend, divisor)
SELECT mod(6, 2) FROM DUAL; -- 0
SELECT mod(5, 3) FROM DUAL; -- 1
SELECT mod(5.2, 3) FROM DUAL;  -- 2.2

SELECT first_name, last_name, employee_id, mod(employee_id, 4) team#
FROM employees
WHERE employee_id BETWEEN 100 and 111
ORDER BY employee_id;

-- Working with DATES
-- ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, NEXT_DAY, ROUND, TRUNC
--

SELECT employee_id, start_date
FROM job_history;

-- NLS_DATE_FORMAT
-- DATE MASKS (p.210)

SELECT sysdate FROM dual;

-- P.211 Date arithmetic
-- Date1 - Date2 = Num1
-- Date1 - Num1 = Date2
-- Date1 = Date2 + Num1
-- Date1 = Date2 - Num1

SELECT TO_DATE('02-JUN-2008 12:10:00','dd-mon-yy hh24:mi:ss') - 2 "Less 2 days",
  TO_DATE('02-jun-2008 12:10:00','dd-mon-yy hh24:mi:ss') + 0.5 "Add half a day",
  TO_DATE('02-jun-2008 12:10:00','dd-mon-yy hh24:mi:ss') + 6/24 "Add six hours"
FROM dual;

SELECT last_name, hire_date, to_date('02-jun-2006 12:10','dd-mon-yyyy hh24:mi') - hire_date
FROM employees
WHERE department_id = 30;

-- p.213 Using date functions
-- MONTHS_BETWEEN(date1, date2)

SELECT months_between(SYSDATE+31, SYSDATE),
       months_between(SYSDATE+61, SYSDATE),
       months_between(SYSDATE+62, SYSDATE)
from DUAL;
SELECT months_between('29-mar-2008','28-feb-2008'), 1 + 1/31 FROM DUAL; -- 1 + 1/31;
SELECT months_between('29-mar-2008','28-feb-2008') * 31 FROM DUAL;

SELECT employee_id, end_date, start_date, months_between(end_date, start_date) duration
FROM job_history
ORDER BY duration DESC;

-- p.215 ADD_MONTHS
-- ADD_MONTHS(date, number_of_months)
SELECT add_months('7-APR-2008',1) FROM DUAL;
SELECT add_months('31-DEC-2008',2.5) FROM DUAL;
SELECT add_months('7-APR-2009',-12) FROM DUAL;
SELECT add_months('7-APR-2009', 0.5) FROM DUAL; -- Should be the same date.
-- Exercise 4-3: Using the Date functions
--   Obtain EMPLOYEE_ID, LAST_NAME, HIRE_DATE for employees
--   who have worked > 100 months between date they were hired and 1 JAN 2012;:
SELECT employee_id, last_name, hire_date
FROM employees
where MONTHS_BETWEEN( TO_DATE('01-JAN-2012','DD-MON-YYYY'), hire_date) > 100;

-- p.217 The NEXT_DAY function
-- NEXT_DAY(start_date, day of the week)

SELECT NEXT_DAY('23-MAY-2017','TUE'),
       NEXT_DAY('23-MAY-2017', 3) FROM DUAL;
       
SELECT NEXT_DAY('01-JAN-2009','FRI'),
       NEXT_DAY('01-JAN-2009','WEDNE'),
       NEXT_DAY('01-JAN-2009', 5) -- 5 = Thursday. (AWKWARD!)
FROM DUAL;

-- p.219 THE LAST_DAY function
-- LAST_DAY(date) - returns the date of the last day in the month a specified day belongs to.
SELECT last_day('01-jan-2009') FROM DUAL;

SELECT last_name, hire_date, last_day(hire_date),
       last_day(hire_date) - hire_date "Days worked in the first month"
FROM employees
WHERE job_id = 'IT_PROG';

-- p. 220 The DATE ROUND function
-- ROUND (source_date, [date prcesision format])
--     date precision format can be: century CC, year YYYY, quarter Q, month MM, week W, day DD, hour (HH),  minutes (MI)
--     a month is rounded up when day is greater than 16.
SELECT round(to_date('02-JUN-2009 13:00','DD-MON-YYYY HH24:MI')) DAY,
      round(to_date('02-JUN-2009','DD-MON-YYYY'), 'w') week,
      round(to_date('16-jun-2009','dd-mon-yyyy'), 'month') MONTH,
      round(to_date('12-jul-2009','DD-MON-YYYY'), 'year') YEAR
FROM dual;

-- p.222 The DATE TRUNC FUNCTION
--   TRUNC(source_date, [date_precision_format])
--

SELECT trunc(to_date('02-jun-2009 13:00','dd-mon-yyyy hh24:mi')) DAY,
  trunc(to_date('02-jun-2009','dd-mon-yyyy'),'w') week,
  trunc(to_date('16-jun-2009','dd-mon-yyyy'),'month') month,
  trunc(to_date('12-jul-2009','dd-mon-yyyy'),'year') YEAR
FROM dual;
