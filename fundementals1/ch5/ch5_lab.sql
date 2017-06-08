DESC CUSTOMERS;

DEFINE A_DATE = '15-MAY';

SELECT CUST_FIRST_NAME, 
       CUST_LAST_NAME,
       DATE_OF_BIRTH, 
       TO_CHAR(DATE_OF_BIRTH,'DD-MON'),
       -- HELPERS:
       --TO_DATE(TO_CHAR(DATE_OF_BIRTH,'DD-MON')||'-2004') AS BIRTHDAY_2004,
       --TO_DATE('&A_DATE' || '-2004', 'DD-MON-YYYY') AS A_DATE_2004,
       --TO_DATE(TO_CHAR(SYSDATE,'DD-MON')||'-2004')-2 AS SYSDATE_MINUS_2_2004
FROM CUSTOMERS 
WHERE TO_DATE(TO_CHAR(DATE_OF_BIRTH,'DD-MON')||'-2004')  -- Using 2004 as it was leap year and dates being concerted can to the 29-FEB-2004.
  BETWEEN 
    (TO_DATE('&A_DATE' || '-2004', 'DD-MON-YYYY')) 
  AND (TO_DATE(TO_CHAR(SYSDATE,'DD-MON')||'-2004')-2)
ORDER BY DATE_OF_BIRTH;

-- CORRECT ANSWER:

DEFINE ref_date=to_date('1-Mar-2017');

SELECT cust_first_name,
       cust_last_name,
       cust_email,
       date_of_birth,
       CASE to_char(date_of_birth,'DDD') - to_char(&ref_date,'DDD')
         WHEN -2 THEN 'Day before yesterday'
         WHEN -1 THEN 'Yesterday'
         WHEN 0 THEN 'Today'
         WHEN 1 THEN 'Tomorrow'
         WHEN 2 THEN 'Day after tomorrow'
         ELSE 'Later this week'
      END as birthday
FROM customers
WHERE to_char(date_of_birth, 'DDD') - to_char(&ref_date, 'DDD') between -2 AND 7
AND 
ORDER BY to_char(date_of_birth,'MM-DD');

---------------------------------------------------
-- DEBUG BELOW
---------------------------------------------------
--SELECT DATE_OF_BIRTH
--FROM customers
--WHERE MOD(to_char(date_of_birth, 'YYYY'), 4)=0 AND to_char(date_of_birth, 'YYYY') <> 2000;
-- Shows that suggested solution does not work the way it should be!

DEFINE ref_date=to_date('26-Dec-2017');
SELECT cust_first_name,
       cust_last_name,
       cust_email,
       date_of_birth,
       CASE to_char(date_of_birth,'DDD') - to_char(&ref_date,'DDD')
         WHEN -2 THEN 'Day before yesterday'
         WHEN -1 THEN 'Yesterday'
         WHEN 0 THEN 'Today'
         WHEN 1 THEN 'Tomorrow'
         WHEN 2 THEN 'Day after tomorrow'
         ELSE 'Later this week'
      END as birthday
FROM customers
WHERE to_char(date_of_birth, 'DDD') - to_char(&ref_date, 'DDD') between -2 AND 7
AND MOD(to_char(date_of_birth, 'YYYY'), 4)=0 AND to_char(date_of_birth, 'YYYY') <> 2000
ORDER BY to_char(date_of_birth,'MM-DD');
