-- Using conversion functions and conditional expressions.
--   TO_CHAR, TO_NUMBER, TO_DATE

SHOW USER;
--SELECT * FROM USER_TABLES;
--SELECT table_name FROM user_tables;

-- p.235 Implicit data type conversion
SELECT length(1234567890) FROM DUAL;
SELECT length(SYSDATE) FROM DUAL;

SELECT mod('11',2) FROM DUAL;
SELECT mod('11.123',2) FROM DUAL;
-- FAILS:
  -- SELECT mod('11.123.456',2) FROM DUAL; 
  -- SELECT mod('$11',2) FROM DUAL;

-- p.236, Table 5-1 Implicit conversion to dates.
SELECT ADD_MONTHS('24-JAN-09',1),
       ADD_MONTHS('1\january/08',1),
       MONTHS_BETWEEN('13*jan*8','13/feb/2008'),
       ADD_MONTHS('01$jan/998',1)
       ADD_MONTHS('24-January-09', 1) FROM DUAL;
FROM DUAL;
-- FAILS:
  -- SELECT ADD_MONTHS('24-JAN-09 10:07',1) FROM DUAL; -- ORA-01830: date format picture ends before converting entire input string
  -- SELECT ADD_MONTHS('24-Jana09', 1) FROM DUAL; -- Literals in the input must be the same length as literals in the format string (with the exception of leading whitespace).  If the "FX" modifier has been toggled on, the literal must match exactly, with no extra whitespace.

-- Getting day of week as string 'WEDNESDAY'
SELECT TO_CHAR(TO_DATE('23-JAN-2008','dd-mon-yyyy'),'DAY') from dual;

-- p.238 (NLS Mentioned but not much details with it)
ALTER SESSION SET nls_currency = 'USD';
DEFINE

--SELECT * FROM nls_session_parameters;
--SELECT SYS_CONTEXT ('USERENV', 'NLS_CURRENCY') FROM DUAL;
--SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL;
--SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL;

-- Converting Numbers to Characters Using the TO_CHAR function
--   TO_CHAR(number1, [format_mask], [nls_parameters])
--   TO_CHAR(date1,   [format_mask], [nls_parameters])
--   TO_NUMBER(char1, [format_mask], [nls_parameters])
--   TO_DATE(char1,   [format_mask], [nls_parameters])
SELECT * FROM nls_session_parameters;

-- p.239
SELECT TO_CHAR(00001)||' is a special number' FROM DUAL;
SELECT TO_CHAR(00001, '0999999')||' is a special number' FROM DUAL;

-- Table 5.3 p.239
SELECT TO_CHAR(12, '9999'),    -- 12
       TO_CHAR(12345, '9999'),  -- ####
       TO_CHAR(0012, '09999'),   -- 00012
       TO_CHAR(030.40, '09999.99'),
       TO_CHAR(030.405, '09999.999'),
       TO_CHAR(030.405, '09999D999'),
       TO_CHAR(030.405, '9.99'),
       TO_CHAR(1234567, '999,999,999'),
       TO_CHAR(1234567, '999G999G999'),
       TO_CHAR(1234567, '0,999,999,999'),
       TO_CHAR(1234567, '0G999G999G999')
FROM DUAL;

SELECT to_char(12345.6, '$999,999.99'),
       to_char(12345.6, 'L999,999.99'),
       to_char(-123, '9999MI'), -- Positions the minus
       to_char(-945, '999PR'), -- Wraps negative numbers into brackets
       to_char(99999999999999, '9999999999999999EEEE'), -- scientific notation
       -- (DOES NOT WORK) to_char(123123, U099999999), -- Dual currency thing
       to_char(12, '9999V99'), -- each 9 after n -> multiplies by 10x, so it will be 1200
       to_char(59, 'S9999') -- prefixed with "S" (e.g. +59)
       --to_char(945, '999WR') -- Wraps negative numbers into brackets      
       --to_char(12345.6, 'L999G999.99')
FROM dual;

SELECT job_title, max_salary, TO_CHAR(max_salary, '$99,999.99'),
   TO_CHAR(max_salary, '$9,999.99')
FROM jobs
WHERE upper(job_title) LIKE '%PRESIDENT%';

-- p.241 Converting  Dates to characters using TO_CHAR function
-- TO_CHAR(date, [formatting], [nls_parameters])
--         fm = fill mode format (trim all the spaces)

SELECT TO_CHAR(SYSDATE) || ' is today''s date' FROM dual;
SELECT TO_CHAR(SYSDATE, 'Month') || ' is a special time ' FROM dual; -- 'May     is a speical time'
SELECT TO_CHAR(SYSDATE, 'fmMonth') || ' is a special time ' FROM dual; -- 'May is a special time'

-- p.241 Table 5-4
--     Y  - last digit of year (5)
--    YY  - last two digits of year (75)
--   YYY  - last three digits of year (975)
--  YYYY  - four-digit year (1975)
--    RR  - two-digit year (75)
--  YEAR  - Case-sensitive English spelling of year (NINETEEN SEVENTY-FIVE)
--    MM  - Two-digit month (06)
--   MON  - Three-letter abbreviation of month (JUN)
-- MONTH  - Case-sensitive English spelling of month (JUNE); 'Month' will return June;
--     D  - Day of week (e.g. 2)
--    DD  - Two-digit day of month (02)
--   DDD  - Day of year (153)
--    DY  - Three letter abbreviation of day (MON)
--   DAY  - Case-sensitive English spelling of day (MONDAY); Day will return Monday;

-- Table 5-5 (Less commonly used date format masks)
--     W  - week of month
--    WW  - week of year
--     Q  - quarter of year
--    CC  - century of year
--   S preceding CC, YYYY or YEAR - if date is BC, a minus sign is prefixed (-232 instead of 232 B.C.)
-- IYYYY, IYYY, IY, I - ISO dates of 4, 3, 2, 1-digit
-- BC, AD, B.C. and A.D. -  
-- J      - Julian Day
-- IW     - ISO standard week
-- RM     - Roman numeral year
-- AM, PM, A.M., P.M. - Meridian indicators
-- HH, HH12 and HH24 - hours
-- MI - minute
-- SS - seconds
-- SSSS - seconds past midnight

-- p. 245, Figure 5-3:
SELECT 'Employee '||employee_id||' quit as '||job_id||' on '||
  TO_CHAR(end_date, 'fmDay "the "ddth "of" Month YYYY') "Quitting day"
FROM job_history
ORDER BY end_date;

SELECT TO_CHAR(SYSDATE, 'fm"Today is "ddth" of "Month YYYY "time:" HH24:MI:SS') FROM dual;

-- Ex. 5-1 P. 245 -- Converting dates into characters using the TO_CHAR function
SELECT first_name, last_name, TO_CHAR(hire_date, 'fmDay", the "ddth" of "Month, Year"') START_DATE --, HIRE_DATE
FROM employees
WHERE TO_CHAR(hire_date, 'fmDay') = 'Saturday';

-- p. 247
-- Converting Characters to Dates Using the TO_DATE function
-- TO_DATE(string1, [format], [nls_parameter])
--    fx parameter is in the TO_DATE, it forces "fixed" mode in which charaacters must match exactly the pattern
--    fxMM/DD/YYYY will fail with 1/14/2015 or 01/14/15
--    fxMM/DD/YYYY will pass with 01/14/2015 only
--    MM/DD/YYYY will pass with 1/14/2015 and 01/14/2015 and 01/14/15
SELECT to_date('25-DEC-2010') FROM dual;
SELECT to_date('25-DEC') FROM dual;
SELECT to_date('25-dec', 'dd-mon') FROM dual;
SELECT to_date('25-dec-2010 18:03:45', 'DD-MON-YYYY HH24:MI:SS') FROM dual;
SELECT to_date('25-DEC-2010', 'fxDD-MON-YYYY') FROM dual;

-- FIG 5-4: the day must be '01' to match fxMM
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > TO_DATE('01/14/2008','fxMM/DD/YYYY');

-- p.248 Converting characters to Numbers using TO_NUMBER Function
--   TO_NUMBER(string, [format], [nls_parameter])

  -- This fails:
  -- SELECT to_number('$1,000.34') FROM DUAL;
SELECT to_number('$1,000.34', '$999,999.99') FROM DUAL;

SELECT to_number('$0,001,000.34', '$0,999,999.99') FROM DUAL;  
  -- This also fails:
  --SELECT to_number('$1,000.34', '$0,999,999.99') FROM DUAL;
  
-- Scenarios, p. 248:
-- compare DD-MON only
SELECT CASE 
  WHEN TO_CHAR(SYSDATE, 'DD-MON') = TO_CHAR('24-MAY') THEN 'It is the 24th of May!!'
  ELSE 'It is not 24th of May'
  END
FROM DUAL;
  
-- Negative value in brackets:
SELECT TO_CHAR(-232, '$999999PR') FROM DUAL;

SELECT TO_CHAR(TO_DATE('2004', 'YYYY'), 'MM/DD/YYYY') FROM DUAL;

-- FAILS: (123.45 gets converted to '123.45' which is different than the mask.
  -- SELECT TO_NUMBER(123.45, '999.9') FROM DUAL;
SELECT TO_NUMBER(123.45, '999.99') FROM DUAL;
SELECT TO_CHAR(123.45, '999.9') FROM DUAL;
SELECT TO_CHAR(123.45, '999.99') FROM DUAL;

-- P. 250, Figure 5.5.
SELECT last_name, phone_number, 
  to_number(substr(phone_number, -8), '999.9999') * 10000 local_number
FROM employees
WHERE department_id = 30;

-- *
-- * Apply conditional Expressions in a SELECT Statement (p.250)
-- *

-- p. 252; General functions
--     NVL - provides an alternative function if the first argument is NULL
--     NVL2 - is strange; does not resemble NVL; NVL2(cond; if cond <> NULL; if cond == NULL)
--     COALESCE - like cascaded NVL; unlimited 
--     NULLIF( arg1, arg2 ) - returns null when arg1 = arg2; if uneven - returns ARG1.
--
-- NVL(original, ifnull)
    -- FAILS WHEN ONLY ONE PARAM:
    --SELECT NVL(123) FROM DUAL;
SELECT NVL(NULL, 123) FROM DUAL;
SELECT NVL(SUBSTR('ABC',4), 'No value specified') FROM DUAL; -- SUBSTR

-- fig 5.6
SELECT last_name, salary, commission_pct, (nvl(commission_pct, 0) * salary + 1000) monthly_commission
FROM employees
WHERE last_name LIKE 'E%';

SELECT last_name, salary, commission_pct, (commission_pct * salary + 1000) monthly_commission
FROM employees
WHERE last_name LIKE 'E%';

-- p.254: NVL2
-- NVL2(original, if_not_null, if_null)
SELECT NVL2(NULL, 'value was not null', 'the value was null') FROM DUAL;
  -- This one will fail as 1 is of different type than 'a string'
  -- SELECT NVL2(1234, 1 , 'a string') FROM dual;
SELECT NVL2(NULL,1234,5678) FROM dual; -- 5678

-- figure 5.7
SELECT last_name, salary, commission_pct, 
  nvl2(commission_pct, 'Commission Earner', 'Not a commission earner') employee_type
FROM employees
WHERE last_name LIKE 'G%';

-- NULLIF
--   NULLIF( arg1, arg2 ) -> returns NULL when arg1 = arg2'
SELECT NULLIF(1, 1) FROM DUAL; -- NULL
SELECT NULLIF('ab','ab') FROM DUAL; --NULL
SELECT NULLIF('abc','ab') FROM DUAL; -- 'abc'
SELECT NULLIF(NULLIF(1, 1), NULL) FROM DUAL;

-- p. 256
SELECT NULLIF(1234, 1234) FROM DUAL; -- NULL
SELECT NULLIF(1234, 1234+1) FROM dual; -- 1234
SELECT NULLIF('24-JUL-2019','24-JUL-19') FROM DUAL; -- 24-JUL-2019

SELECT first_name, last_name, email, 
  nvl2(
    nullif(substr(first_name, 1, 1) || upper(last_name), email), --  returns null when 'JSmith' == 'JSmith'
    'Email does not match pattern', -- When NOT NULL value returned by NULLILF (pattern not matching)
    'Match found') -- When NULL value returned by NULLIF (pattern matching)
    AS pattern;
FROM employees
WHERE length(first_name) = 4;


-- ******************
-- p.257 Using NULLIF and NVL2 for Simple Conditional Logic
-- ******************
SELECT first_name, last_name, NVL2(NULLIF(LENGTH(FIRST_NAME), LENGTH(LAST_NAME)), 'Different Length', 'Same Length') AS NAME_LENGTHS
FROM employees
WHERE department_id = 100;

-- p.258 COALESCE function
--   COALESCE(expr1, expr2, ..., exprn)
-- Similar to:
--   NVL(expr1, NVL(expr2, NVL(expr3, expr4)))
SELECT coalesce(null, null, null, 'a string') FROM dual; -- 'a string'
SELECT coalesce(null, null, null) FROM dual; -- null
SELECT coalesce(substr('abc',4), 'Not bc', 'No substring') FROM dual; -- Not bc
 
-- fig 5-9
SELECT COALESCE(state_province, postal_code, city), state_province, postal_code, city
FROM locations
WHERE country_id IN ('UK','IT','JP');


-- *********************************
-- Conditionial functions
--   DECODE, CASE
--    * DECODE is specific to Oracle
--    * CASE is ANSI SQL compliant
-- *********************************
-- DECODE[expr1, comp1, if_1_true, [comp2, if_2_true, [comp3, if_3_true]], ELSE_VALUE];

SELECT DECODE(1234, 123, '123 is a match') FROM dual; -- NULL;
SELECT DECODE(1234, 123, '123 is a match',' 123 is not a match') FROM DUAL; -- Not a match
SELECT DECODE('search','comp1','true1','comp2','true2','search','true3', 'no match' ) FROM DUAL; -- 'true3'
SELECT DECODE('search',
   'comp1','true1',
   'comp2','true2',
   'search','true3',
   substr('2search',2,6), 'true4',
   'no match'
) FROM DUAL; -- 'true3'

-- Fig 5.10 The decode function
SELECT DISTINCT country_id, decode(country_id, 
  'BR', 'Southern Hemisphere',
  'AU', 'Southern Hemisphere',
        'Northern Hemisphere') hemisphere
FROM locations
ORDER BY hemisphere;

SELECT DECODE(5, 
  1, '5=1',
  2, '5=2',
  3, '5=3',
  4, '5=4',
  5, '5=5',
  'not true') FROM DUAL;
SELECT DECODE(NULL, NULL, 'EQUALS', 'NOT EQUALS') FROM DUAL; -- Two NULLS do EQUALS in the DECODE function!

-- ********************************
-- p.262 The CASE expression
--   there are two variants of the CASE expression:
--   simple CASE (one value as a basis for comparision),
--   searched CASE (multiple conditions)
--
-- CASE takes at least 3 manadatory parameters (search_expr, comparision_expr, iftrue1)
--
-- CASE search_expr
--   WHEN comparision_expr1 THEN iftrue1
--   [WHEN comparision_expr2 THEN iftrue2
--   WHEN comparision_expr3 THEN iftrue3
--   ELSE iffalse]
-- END
-- ********************************
-- p.264
SELECT 
  CASE substr(1234, 1, 3)
    WHEN '134' THEN '134 is a match'
    WHEN '1235' THEN '1235 is a match'
    WHEN concat('1','23') THEN concat('1','23')||' is a match'
    ELSE 'no match'
  END
FROM dual;

-- 
-- Figure 5-11.
-- 
SELECT last_name, hire_date, department_id,
  trunc(months_between('01-JAN-2013',hire_date)) months,
  trunc(months_between('01-JAN-2013',hire_date)/24) "Months divided by 24",
  CASE trunc(months_between('01-JAN-2013', hire_date)/24)
    WHEN 1 THEN 'intern'
    WHEN 2 THEN 'junior'
    WHEN 3 THEN 'intermediate'
    WHEN 4 THEN 'senior'
    ELSE 'furniture'
  END loyalty
FROM employees
WHERE department_id NOT IN (50, 80, 90, 100, 110)
ORDER BY months;
-- 
-- p.265 Searched case
-- CASE
--   WHEN condition1 THEN iftrue1;
--   WHEN condition2 THEN iftrue2;
--   WHEN condition3 THEN iftrue3;
--   ELSE iffalse;
-- END
SELECT last_name, hire_date,
  trunc(months_between('01-JAN-2013',hire_date)) months,
  trunc(months_between('01-JAN-2013',hire_date)/24) "months divided by 24",
  CASE 
    WHEN trunc(months_between('01-JAN-2013',hire_date)/24) < 2 THEN 'Intern'
    WHEN trunc(months_between('01-JAN-2013',hire_date)/24) < 3 THEN 'Junior'
    WHEN trunc(months_between('01-JAN-2013',hire_date)/24) < 4 THEN 'Intermediate'
    WHEN trunc(months_between('01-JAN-2013',hire_date)/24) < 5 THEN 'Senior'
    ELSE 'Furniture'
  END loyalty
FROM employees
WHERE department_id NOT IN(50, 80, 90, 100, 110)
ORDER BY months;

-- p.268 Exercise 5.3 Using the DECODE function
SELECT state_province, 
  DECODE (UPPER(state_province),
    'WASHINGTON', 'Headquarters',
    'TEXAS', 'Oil wells',
    'CALIFORNIA', CITY,
    'NEW JERSEY', STREET_ADDRESS
  ) location_info
FROM locations
WHERE UPPER(country_id) LIKE 'US'
ORDER BY location_info;

SELECT state_province,
  CASE UPPER(state_province)
   WHEN 'WASHINGTON' THEN 'Headquarters'
   WHEN 'TEXAS' THEN 'Oil wells'
   WHEN 'CALIFORNIA' THEN city
   WHEN 'NEW JERSEY' THEN street_address
  END location_info
FROM locations
WHERE upper(country_id) LIKE 'US'
ORDER BY location_info;

SELECT state_province,
  CASE
    WHEN UPPER(state_province)='WASHINGTON' THEN 'Headquarters'
    WHEN UPPER(state_province)='TEXAS' THEN 'Oil wells'
    WHEN UPPER(state_province)='CALIFORNIA' THEN city
    WHEN UPPER(state_province)='NEW JERSEY' THEN street_address
  END location_info
FROM locations
WHERE upper(country_id) LIKE 'US'
ORDER BY location_info;
-- End of the exercise.

