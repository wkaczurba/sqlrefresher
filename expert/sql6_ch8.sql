SHOW USER;
-- It has to be "SE" user.

-- p.321 -> Using table aliases.
select employee_id, last_name, street_address
FROM employees inner join addresses
USING (employee_id);

DESC TABLE ports;
DESC TABLE ships;
DESC TABLE ship_cabins;

--DROP TABLE ships;
--DROP TABLE ports;
--drop table passengers;
--drop table ship_cabins;

-- p. 327 (JOIN ON)
SELECT * FROM grading;
SELECT * FROM scores;

SELECT s.score_id, s.test_score, g.grade FROM scores s
  JOIN grading g ON (s.test_score BETWEEN g.score_min AND g.score_max);



--
SELECT  p.position_id, p.position, p.reports_to, b.position
from positions p
JOIN positions b ON (p.reports_to = b.position_id);

-- The one below will include captain
SELECT  p.position_id, p.position, p.reports_to
from positions p
LEFT OUTER JOIN positions b ON (p.reports_to = b.position_id);


-- SELECT DUMMY FROM DUAL WHERE DUMMY LIKE (SELECT 'X' FROM DUAL) 

select * from ships;
select ship_name from ships where home_port_id = any (select home_port_id from ships where home_port_id between 2 and 3);
select * from ship_cabins;

select ship_cabin_id from ship_cabins where sq_ft > ALL (select sq_ft/2 from ship_cabins);
select ship_cabin_id from ship_cabins where sq_ft > (select max(sq_ft)/2 from ship_cabins);

select ship_cabin_id from ship_cabins where sq_ft < ANY (select sq_ft/8 from ship_cabins);
select ship_cabin_id from ship_cabins where sq_ft < (select max(sq_ft)/8 from ship_cabins);


-- Multiple-column subquery:
SELECT * FROM INVOICES where (TOTAL_PRICE, INVOICE_DATE) in 
  (SELECT SALARY, START_DATE FROM PAY_HISTORY where employee_id = 4);

SAVEPOINT S1;
--CREATE SEQUENCE employee_id_seq;
INSERT INTO EMPLOYEES (employee_id, ship_id)
  values (employee_id_seq.nextval, 
    (select ship_id from ships where ship_name = 'Cood Champion'));
    
SELECT * FROM EMPLOYEES;    
ROLLBACK S1;

-- P.361 Correlated query
SELECT A.SHIP_CABIN_ID, A.ROOM_STYLE, A.ROOM_NUMBER, A.SQ_FT
FROM SHIP_CABINS A
WHERE SQ_FT > (SELECT AVG(SQ_FT) FROM SHIP_CABINS WHERE A.ROOM_STYLE = ROOM_STYLE)
ORDER BY A.ROOM_NUMBER;

SELECT * FROM SHIPS
  WHERE EXISTS (SELECT * FROM DUAL WHERE DUMMY='X');

SELECT * FROM SHIPS
  WHERE NOT EXISTS (SELECT * FROM DUAL WHERE DUMMY='X');
  
  
desc employees;

CREATE VIEW VW_EMPLOYEES AS (
  SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, PRIMARY_PHONE FROM EMPLOYEES);

select * from vw_employees;

--CONNECT sys/Oracle_1 AS SYSDBA;
--  grant CREATE VIEW to se;
--disconnect;

-- FINISHED AT 394
