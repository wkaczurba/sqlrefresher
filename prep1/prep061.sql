CREATE SEQUENCE act_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE aircraft_types (
  act_id NUMBER(*, 0) DEFAULT act_id_seq.NEXTVAL PRIMARY KEY,
  act_name VARCHAR(20) NOT NULL,
  act_body_style VARCHAR(20),
  act_decks VARCHAR(20),
  act_seats INTEGER,
  constraint act_body_style CHECK (act_body_style IN ('Wide','Narrow')),
  constraint act_decks_ck CHECK (act_decks IN ('Single','Double'))
);
ALTER TABLE aircraft_types ADD CONSTRAINT act_seats_ck CHECK (act_seats > 0);

INSERT INTO aircraft_types (act_name, act_body_style, act_decks, act_seats) VALUES ('Boeing 747', 'Wide', 'Double', 416);
INSERT INTO aircraft_types (act_name, act_body_style, act_decks, act_seats) VALUES ('Boeing 767', 'Wide', 'Single', 350);
INSERT INTO aircraft_types (act_name, act_body_style, act_decks, act_seats) VALUES ('Boeing 737', 'Narrow', 'Single', 200);
--INSERT INTO aircraft_types (act_name, act_body_style, act_decks, act_seats) VALUES ('Boeing 757', 'Narrow', 'Single', 240);
INSERT INTO (SELECT act_name, act_body_style, act_decks, act_seats FROM aircraft_types WHERE act_body_style='Narrow' WITH CHECK OPTION)
  VALUES ('Boeing 757', 'Narrow', 'Single', 240);
  
SELECT * FROM aircraft_types;

--SELECT * from aircraft_types;
SELECT act_name, act_body_style, act_decks FROM aircraft_types WHERE UPPER(act_name) LIKE UPPER('%&AIRCRAFT_NAME%');

DROP TABLE aircraft_types;
DROP SEQUENCE act_id_seq;

-- P.84
SELECT TO_CHAR('4235.34','FML9,999.99') "To_char_ex" FROM dual;

-- - p.85
SELECT TO_NUMBER('$4,235.34', 'FML9,999.99') "To number ex" FROM DUAL;

-- p.86
SELECT TO_DATE('February 23, 2012 2:23 P.M.', 'Month DD, YYYY HH:MI A.M.')  from DUAL;

SELECT CASE TO_CHAR((SELECT 'x' FROM DUAL))
  WHEN '1' THEN 'One'
  WHEN '2' THEN 'Two'
  ELSE 'Unknown'
END from dual;

SELECT CASE 
  WHEN TO_CHAR((SELECT 'x' FROM DUAL)) = '1' THEN 'One'
  WHEN TO_CHAR((SELECT 'x' FROM DUAL)) = '2' THEN 'Two'
  ELSE 'Unknown'
END from dual;

-- p.113:
CREATE TABLE table_A (
  col1 NUMBER, 
  col2 VARCHAR2(1)
);

CREATE TABLE table_B (
  col1 NUMBER,
  col2 VARCHAR2(1)
);

INSERT INTO table_A VALUES (1,'a');
INSERT INTO table_A VALUES (2,'b');
INSERT INTO table_A VALUES (3,'c');

INSERT INTO table_B VALUES (2, 'B');
INSERT INTO table_B VALUES (3, 'C');
INSERT INTO table_B VALUES (4, 'D');

SELECT a.col1 AS TA_COL1, a.col2 AS TA_col2,
       b.col1 AS TB_COL1, b.col2 AS TB_col2
FROM table_A a
  INNER JOIN table_B b
  ON a.col1 = b.col1;
  
SELECT a.col1 AS TA_COL1, a.col2 AS TA_col2,
       b.col1 AS TB_COL1, b.col2 AS TB_col2
FROM table_A a
  LEFT JOIN table_B b
  ON a.col1 = b.col1;
  
SELECT a.col1 AS TA_COL1, a.col2 AS TA_col2,
       b.col1 AS TB_COL1, b.col2 AS TB_col2
FROM table_A a
  RIGHT JOIN table_B b
  ON a.col1 = b.col1;
  
-- full outer join:
SELECT a.col1 AS TA_COL1, a.col2 AS TA_col2,
       b.col1 AS TB_COL1, b.col2 AS TB_col2
FROM table_A a
  FULL OUTER JOIN table_B b
  ON a.col1 = b.col1;
  
  
    
DROP TABLE table_a;
DROP TABLE table_b;


-- Dates etc.
SELECT * FROM V$NLS_PARAMETERS;
SELECT * FROM V$NLS_PARAMETERS WHERE PARAMETER='NLS_DATE_FORMAT';

--SELECT TO_DATE('10-MAY-2013') - TO_DATE('11-MAY-2013 11.23 AM') FROM dual;
--SELECT TO_DATE(TRUNC(TO_TIMESTAMP('11-MAY-2013 5.34.00 PM'))) FROM dual;

-------------------------------------------
-------------------------------------------
CREATE TABLE holiday_donations (
  EMP_ID NUMBER,
  ITEM VARCHAR2(40) DEFAULT 'EG NOG',
  RSPDATE DATE DEFAULT SYSDATE,
  QTY NUMBER DEFAULT '1',
  CMMENT VARCHAR2(500)
);
  
drop TABLE holiday_donations;


SELECT MAX(act_seats) from
(
  SELECT 'Boeing 747' ACT_NAME, 416 act_seats FROM DUAL
  UNION
  SELECT 'Boeing 767' ACT_NAME, 350 act_seats FROM DUAL
  UNION
  SELECT 'Boeing 737' ACT_NAME, 200 act_seats FROM DUAL
  UNION
  SELECT 'Boeing 757' ACT_NAME, 240 act_seats FROM DUAL
  UNION
  SELECT 'Boeing 777' ACT_NAME, 407 act_seats FROM DUAL
  UNION
  SELECT 'Boeing 787' ACT_NAME, 296 act_seats FROM DUAL
  UNION
  SELECT 'Boeing A320' ACT_NAME, 200 act_seats FROM DUAL
  UNION
  SELECT 'Boeing A380' ACT_NAME, 525 act_seats FROM DUAL
);

create table tba (
  dat LONG
);

insert into tba values ('sdfadf');
select * from tba;

alter table tba modify dat not null;
-- (ILLEGAL): alter table tba add constraint dat_pk unique (dat);

