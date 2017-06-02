-- ******************
-- CH10 LAB
-- ******************

DESC customers;
SAVEPOINT s1;

-- p.1
INSERT INTO customers (customer_id, cust_first_name, cust_last_name)
VALUES ( (SELECT MAX(customer_id)+1 FROM customers), 'John', 'Watson');

-- p.2:
UPDATE customers SET CREDIT_LIMIT=(SELECT AVG(credit_limit) FROM customers ) WHERE cust_first_name='John' AND cust_last_name='Watson';

-- p.3:
INSERT INTO customers (customer_id, cust_first_name, cust_last_name, credit_limit)
SELECT (SELECT MAX(customer_id)+1 FROM customers), cust_first_name, cust_last_name, credit_limit FROM customers WHERE cust_first_name='John' AND cust_last_name='Watson';

-- p.4:
UPDATE customers SET cust_last_name='Ramklass', cust_first_name='Roopesh' WHERE customer_id = (SELECT MAX(customer_id) FROM customers WHERE cust_last_name='Watson');

-- p.5 
COMMIT

-- p:6:
SELECT * FROM customers WHERE cust_last_name IN ('Watson', 'Ramklass') FOR UPDATE;

  --In the second session:
  --UPDATE customers
  --SET credit_limit=0
  --WHERE cust_last_name='Ramklass';

-- p.7
COMMIT;

-- p.7:
SELECT * FROM customers WHERE cust_last_name='Ramklass' OR cust_last_name='Watson';

-- p.8:
DELETE FROM customers WHERE cust_last_name='Watson' OR cust_last_name='Ramklass';

-- p.9:
-- TRUNCATE TABLE 

-- p.10:
COMMIT;

-- p.11:
SELECT max(customer_id) FROM customers;

--
