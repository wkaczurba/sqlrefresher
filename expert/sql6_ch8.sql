-- p.216:
SELECT initcap('Naploon'), initcap('red o''brien'), initcap('mcdonald''s') FROM DUAL;

SELECT upper('zzz'), lower('Zzzz') FROM DUAL;
SELECT 'Hello ' || ' zzz', CONCAT('Hello ', CONCAT('from', CONCAT(' multiple', ' concats'))) FROM DUAL;

SELECT LPAD('Chapter One - I am born', 40, ' ') FROM DUAL;
SELECT RPAD('40', 40, '...') FROM DUAL;

-- p.218
CREATE TABLE book_contents (
  page_number number(20),
  chapter_title varchar2(20)
);
INSERT INTO book_contents (chapter_title, page_number) 
  VALUES ('Introduction', 1);
INSERT INTO book_contents (chapter_title, page_number) 
  VALUES ('Post introduction', 3);
INSERT INTO book_contents (chapter_title, page_number) 
  VALUES ('First chapter', 5);
INSERT INTO book_contents (chapter_title, page_number) 
  VALUES ('Ending',25 );

SELECT RPAD(CHAPTER_TITLE || ' ', 30, '.') || 
       LPAD(' ' || PAGE_NUMBER, 30, '.') "Table of Contents"
  FROM book_contents
ORDER BY PAGE_NUMBER;

DROP table book_contents;

-- p.219 LTRIM, RTRIM.

SELECT LTRIM('---------------ZZZ', '-') FROM DUAL;
SELECT RTRIM('----ZZ------', '-') FROM DUAL;
SELECT TRIM(trailing '-' from '-----adf------') from dual;
select trim(leading '0' from '0000asdfa0000') from dual;
select trim(both '0' from '0002312301230000') from dual;
select trim('0' from '00001231230000') from dual;
 -- INVALID!!!:
 -- select trim('----abc----','-') from dual;


-- p.220 INSTR
SELECT INSTR('Missisipi', 'is', 2, 2) from dual; -- RETURNS 5
SELECT INSTR('Missisipi', 'is', 2, 20) from dual; -- RETURNS 0 (cannot find 20th occurance of 'is' starting at character 2.

SELECT SUBSTR('abcdefg', -1) FROM DUAL; --
SELECT SUBSTR('abcdefg', -1, 5) FROM DUAL;

-- p.222
SELECT SOUNDEX('Wilmingont') FROM DUAL;
SELECT SOUNDEX('Wayamagotn') FROM DUAL;

-- p.224 REMAINDER VS MOD:
SELECT REMAINDER(11, 3), MOD(11, 3) FROM DUAL;

-- p.226
SELECT SYSDATE, ROUND(SYSDATE, 'MM'), ROUND(sysdate, 'Year'), ROUND(SYSDATE, 'cc') from dual;
SELECT SYSDATE, ROUND(TO_DATE('16-FEB-00', 'dd-MON-rr'), 'mm'), --> 01 MARCH 
                ROUND(TO_DATE('15-FEB-00', 'dd-MON-rr'), 'mm') from dual; -- > 01 FEBRUARY 

SELECT SYSDATE, TRUNC(SYSDATE, 'MM'), trunc(sysdate,'yy') from dual;

select next_day(sysdate, 'Friday') FROM DUAL;
select next_day(sysdate, 'Thursday') from dual; -- > returns DAY


select last_day(sysdate) FROM DUAL; --> RETURNS DAY!

-- ***********************************************
SELECT MONTHS_BETWEEN('01-JAN-12', '01-FEB-12') from dual;
SELECT MONTHS_BETWEEN('29-FEB-12', '01-FEB-11') from dual;

-- 
select numtoyminterval(27, 'MONTH') from dual;
select numtodsinterval(3600*24 + 1, 'SECOND') from dual;
select numtodsinterval(36, 'HOUR') from dual;

-- THIS WILL WORK: (DATE + ds-interval) + numtoyminterval(27);
select sysdate + numtodsinterval(36, 'HOUR') + numtoyminterval(27, 'MONTH') from dual;

-- THIS WILL FAIL as it uses two different units (INTERVAL YEAR TO MONTH vs INTERVAL DAY TO SECOND)
  -- select numtodsinterval(36, 'HOUR') + numtoyminterval(27, 'MONTH') from dual;


SELECT nvl(null, 2) from dual;
select nvl('2', 2) from dual;
select nvl2(null, 1, 2) from dual; -- > 2
select nvl2(0, 1, 2) from dual; -- > 1

-- ******************************
-- decode p.271
-- ******************************
select decode ((SELECT 'A' from DUAL), 'A', 'Found A', 
                    'B', 'Found B',
                    'C', 'Found C',
                    'Not found') from dual;

select case 'option1'
  when 'option1' then 'found 1'
  when 'option2' then 'found 2'
  end as "Answer"
from dual;

select case
  when 1=1 then 'one'
  when 2=2 then 'two'
  when 3=3 then 'three'
  else 'not found'
end "result" from dual;

CREATE table ships (
  ship_name varchar2(20),
  capacity number);

INSERT INTO ships ("SHIP_NAME", "CAPACITY")
  VALUES  ('Abc', 3046);
INSERT INTO ships ("SHIP_NAME", "CAPACITY")
  VALUES  ('Def', 2052);
INSERT INTO ships ("SHIP_NAME", "CAPACITY")
  VALUES  ('GHI', 11000);
  
select ship_name, capacity,
  case capacity 
    when 2052 then '2052 is much' 
    when 3046 then '3046 is much more than 2052' 
    else 'no idea' 
  end "Comment" from ships;

drop table ships;

select NULLIF('a','b') from dual;

CREATE TABLE scores ( 
  student_id number primary key,
  test_score number NOT NULL constraint test_score_ck check (test_score >= 0),
  updated_test_score number,
  constraint updated_test_score_ck check (nvl(updated_test_score, 0) >= 0)
);

RENAME REVISION_ONLY TO scores;

INSERT into scores (student_id, test_score, updated_test_score) values (1, 95, 95);
INSERT into scores (student_id, test_score, updated_test_score) values (2, 55, 75);
INSERT into scores (student_id, test_score, updated_test_score) values (3, 95, 83);

UPDATE scores SET test_score=83, updated_test_score=83 WHERE student_id = 3;

select student_id, test_score, updated_test_score, nullif(updated_test_score, test_score) revision_only from scores;

DROP table revision_only;


-- p.246.
SELECT TABLE_NAME FROM USER_TABLES;
-- Even "ALL" in count will not count NULL values.
SELECT COUNT(EMPLOYEE_ID), COUNT(MANAGER_ID), COUNT(ALL MANAGER_ID) from EMPLOYEES;
SELECT COUNT(*), COUNT(ALL MANAGER_ID), COUNT(MANAger_ID), count(nvl(manager_id, 0)) from employees where MANAGER_ID is NULL;
DESC employees;


SELECT * FROM employees;


select max(salary) keep (dense_rank last order by employee_id),
       max(salary) keep (dense_rank first order by employee_id),
       max(salary), min(salary) from employees;
-- Similar to this one:       
select max(salary) from employees e2 where e2.employee_id = (select min(employee_id) from employees);
select max(salary) from employees e2 where e2.employee_id = (select max(employee_id) from employees);



-- ********************************************
-- SHIP CABINS STARTS HERE ********************
-- ********************************************

CREATE table SHIP_CABINS (
  ship_cabin_id number primary key,
  room_number number unique, -- not null,
  room_style varchar2(20) not null constraint room_style_ck check (room_style in ('Suite', 'Stateroom')),
  room_type varchar2(20) not null,  
  window varchar2(20) not null,
  guests integer default on null 1 check (guests > 0),
  sq_ft number(20),
  constraint room_type_ck check (room_type in ('Standard','Royal', 'Presidential')),
  constraint window_ck check (window in ('Ocean', 'None'))
);

alter table ship_cabins drop constraint room_type_ck;
alter table ship_cabins add constraint room_type_ck check (room_type in ('Standard','Royal', 'Presidential', 'Large', 'Skyloft'));

CREATE table passengers (
  first_name varchar(20),
  last_name varchar(20),
  room_number number,
  constraint room_number_fk foreign key (room_number) references SHIP_CABINS(room_number)
);


INSERT ALL 
  into ship_cabins VALUES (1, 102, 'Suite', 'Standard', 'Ocean', 4, 533)
  into ship_cabins VALUES (3, 104, 'Suite', 'Standard', 'None', 4 , 533)
  into ship_cabins VALUES (5, 106, 'Suite', 'Standard', 'None', 6, 586)
  into ship_cabins VALUES (6, 107, 'Suite', 'Royal', 'Ocean', 5, 1524)
  into ship_cabins VALUES (10, 702, 'Suite', 'Presidential', 'None', 5, 1142)
  into ship_cabins VALUES (11, 703, 'Suite', 'Royal', 'Ocean', 5, 1745)
  into ship_cabins VALUES (12, 704, 'Suite', 'Skyloft', 'Ocean', 8, 722)
  into ship_cabins VALUES (2, 103, 'Stateroom', 'Standard', 'Ocean', 2, 160)
  into ship_cabins VALUES (4, 105, 'Stateroom', 'Standard', 'Ocean', 3, 205)
  into ship_cabins VALUES (7, 108, 'Stateroom', 'Large', 'None', 2, 211)
  into ship_cabins VALUES (8, 109, 'Stateroom', 'Standard', 'None', 2, 180)
  into ship_cabins VALUES (9, 110, 'Stateroom', 'Large', 'None', 2, 225)
  SELECT * from dual;
  
alter table ship_cabins add SHIP_ID number default 1 not null;
select * from ship_cabins;
INSERT INTO ship_cabins values (13, NULL, 'Suite', 'Large', 'None', 8, 225, 1);
  
insert into passengers (first_name, last_name, room_number) values ('Raymond', 'Casdf', null);
insert into passengers (first_name, last_name, room_number) values ('Trembley', 'Jason', 704);

select first_name, last_name, room_number from passengers natural join ship_cabins;

-- JOIN WILL NOT WORK WHEN PARENT AND CHILDREN TABLE ARE NULL;...:
select first_name, last_name, passengers.room_number, sq_ft from passengers join ship_cabins on (passengers.room_number = ship_cabins.room_number);

-- TO JOIN BASED ON NULLS - YOU HAVE TO BE EXPLICIT:
select first_name, last_name, passengers.room_number, sq_ft from passengers join ship_cabins on (passengers.room_number = ship_cabins.room_number OR
  passengers.room_number IS NULL AND ship_cabins.room_number IS NULL);

DELETE FROM ship_cabins WHERE ship_id = 1 AND room_number IS NULL;

select room_style,
  round(avg(sq_ft), 2) "Average SQ FT",
  min(guests) "Minimum # of guests",
  count (ship_cabin_id) "Total # of cabins"
from ship_cabins
where ship_id = 1
group by room_style;

-- p.289
SELECT room_type,
  TO_CHAR(ROUND(AVG(SQ_FT), 2), '999,999.99') "Average SQ FT",
  MAX(guests) "Maximum # of Guests",
  COUNT(ship_cabin_id) "Total # of cabins"
FROM ship_cabins
WHERE ship_id = 1
GROUP BY room_type
ORDER BY 2 DESC;

-- p.291. [MULTIPLE COMLUMNS HERE].
SELECT room_style, 
       room_type,
       TO_CHAR(MIN(SQ_FT), '9,999') "Min",
       TO_CHAR(MAX(SQ_FT), '9,999') "Max",
       TO_CHAR(MAX(SQ_FT) - MIN(SQ_FT), '9,999') "Diff"
FROM ship_cabins
GROUP BY room_style, room_type
ORDER BY 3;
       
-- p.293 -> Example.
SELECT room_style, room_type, max(sq_ft)
FROM ship_cabins
WHERE ship_id = 1
GROUP BY room_style, room_type;

-- p.294
  -- This is illegal -> grous room_style, room_type are created, MAX(sq_ft) calculated for each of the groups.
  -- Then out of all groups average would be calculated AVG(MAX(sq_ft)) and all groups brought to one.
  --   BUT: room_style, room_type are not (and cannot be) groupped; therefore we get an error....
  --SELECT room_style, room_type, avg(max(sq_ft))
  --FROM ship_cabins
  --WHERE ship_id = 1
  --GROUP BY room_style, room_type;

SELECT avg(max(sq_ft))
FROM ship_cabins
WHERE ship_id = 1
GROUP BY room_style, room_type;
  
-- Another problem:
  -- SELECT COUNT(AVG(MAX(sq_ft))) FROM ship_cabins WHERE ship_id = 1 GROUP BY room_style;
  
-- p.297 (HAVING)
SELECT room_style, room_type, TO_CHAR(MIN(SQ_FT), '9,999') "Min"
FROM ship_cabins
WHERE ship_id = 1
GROUP BY room_style, room_type
HAVING room_type in ('Standard','Large') OR MIN(sq_ft) > 1200
ORDER BY 3;

-- ********************************************
-- SHIP CABINS ENDS HERE **********************
-- ********************************************

CREATE TABLE ports (
  port_id number,
  port_name varchar2(20),
  country varchar2(40),
  capacity NUMBER,
  constraint port_id_pk primary key (port_id)
);
ALTER TABLE ports MODIFY port_name varchar2(20) NOT NULL;
ALTER TABle ports MODIFY country varchar2(40) NOT NULL;
ALTER TABle ports ADD CONSTRAINT capacity_ck CHECK (capacity >= 0);

create table ships(
  ship_id NUMBER PRIMARY KEY,
  ship_name VARCHAR2(20),
  capacity NUMBER not null,
  length NUMBER not null check (length > 0),
  home_port_id number,
  constraint home_port_id_pk foreign key (home_port_id) references ports(port_id)
);

INSERT into PORTS (port_id, port_name, country, capacity) VALUES (1, 'Baltimore', 'USA', 100);
INSERT into PORTS (port_id, port_name, country, capacity) VALUES (2, 'Charleston', 'USA', 100);
INSERT into PORTS (port_id, port_name, country, capacity) VALUES (3, 'Tampa', 'USA', 100);
INSERT into PORTS (port_id, port_name, country, capacity) VALUES (4, 'Miami', 'USA', 100);

INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (1, 'Cood Crystal', 1000, 90, 1);
INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (2, 'Cood Elegance', 1000, 90, 3);
INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (3, 'Cood Champion', 1000, 90, NULL);
INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (4, 'Cood Victorious', 1000, 90, 3);
INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (5, 'Cood Grandeur', 1000, 90, 2);
INSERT INTO ships (ship_id, ship_name, capacity, length, home_port_id) VALUES (6, 'Cood Prince', 1000, 90, 2);

SELECT * FROM ports;
SELECT * FROM ships;

-- p.317
SELECT ship_id, ship_name, port_name
FROM ships INNER JOIN ports
ON home_port_id = port_id
ORDER BY ship_id;

-- Left outer join
SELECT ship_id, ship_name, port_name
FROM ships LEFT OUTER JOIN ports
ON home_port_id = port_id
ORDER BY ship_id;

SELECT ship_id, ship_name, port_name
FROM ships RIGHT OUTER JOIN ports
ON home_port_id = port_id
ORDER BY ship_id;

SELECT ship_id, ship_name, port_name FROM ships FULL OUTER JOIN ports
ON home_port_id = port_id
ORDER BY ship_id;

-- p.321 -> Using table aliases.
select employee_id
--DROP TABLE ships;
--DROP TABLE ports;
--drop table passengers;
--drop table ship_cabins;