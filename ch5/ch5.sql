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
