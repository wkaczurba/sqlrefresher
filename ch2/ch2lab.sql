--CONNECT oe/oe@pdborcl; 
-- SHOW USER

-- p.100 - Lab exercise:
-- q1. Structural info for PRODUCT_INFORMATION and ORDERS tables
DESC PRODUCT_INFORMATION;
DESC ORDERS;
  
SHOW USER;

-- q2. Select the unique SALES_REP_ID values from the ORDERS table.
--    How many different sales representatives have been assigned to orders in the ORDERS table?

-- This one will show 10 (including one NULL)
SELECT DISTINCT SALES_REP_ID FROM ORDERS;

-- Answer: 9.
SELECT COUNT(DISTINCT SALES_REP_ID) FROM ORDERS WHERE SALES_REP_ID IS NOT NULL;

-- q3. Create a results set based on the ORDERS table that includes the ORDER_ID, ORDER_
--DATE, and ORDER_TOTAL columns. Notice how the ORDER_DATE output is formatted
--differently from the START_DATE and END_DATE columns in the HR.JOB_HISTORY
--table.

SELECT ORDER_ID, ORDER_DATE, ORDER_TOTAL
FROM ORDERS;

-- Order date is TIMESTAMP(6) WITH LOCAL TIME ZONE and this is why formatting is diffeernt

-- q4. Extract product information in the format <PRODUCT_NAME> with code: <PRODUCT_
-- ID> has status of: <PRODUCT_STATUS>. Alias the expression as “Product.”

SELECT PRODUCT_NAME||' with code '||PRODUCT_ID||' has status of: '||PRODUCT_STATUS "Product",
  LIST_PRICE,
  MIN_PRICE,
  LIST_PRICE - MIN_PRICE "Max actual savings",
  (LIST_PRICE - MIN_PRICE)/LIST_PRICE * 100 "Max discount %"
FROM product_information;

--SELECT PRODUCT_NAME||' with code '||PRODUCT_ID||' has status of: '||PRODUCT_STATUS "Product",
--  LIST_PRICE,
--  MIN_PRICE,
--  LIST_PRICE - MIN_PRICE "Max actual savings",
--  ROUND((LIST_PRICE - MIN_PRICE)/LIST_PRICE * 100, 2) "Max discount %"
--FROM products

-- 4?r2, r = 3,958.759, ?=22/7

SELECT 4 * 22/7 * (3958.759 * 3958.759) FROM DUAL;
