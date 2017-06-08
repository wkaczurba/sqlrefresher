-- ****************************
-- CHAPTER 1
-- ****************************

CREATE TABLE SHIPS
(SHIP_ID NUMBER,
 SHIP_NAME VARCHAR2(20),
 CAPACITY NUMBER,
 LENGTH number);

-- SQL COmmands
-- 
 
DROP TABLE ships;


-- ****************************
-- CHAPTER 2
-- ****************************
CREATE TABLE work_schedule
 (work_schedule_id NUMBER,
  start_date DATE,
  end_date DATE);

DROP TABLE work_schedule;

CREATE TABLE cruises
(cruise_id NUMBER,
 cruise_type_id NUMBER,
 cruise_name VARCHAR2(20),
 captain_id NUMBER NOT NULL,
 start_date DATE,
 end_date DATE,
 status VARCHAR2(5) DEFAULT 'DOCK',
 CONSTRAINT cruise_pk PRIMARY KEY (cruise_id));

DROP TABLE cruises;

CREATE TABLE CRUISES_NOTES
  (CRUISES_NOTES_ID NUMBER,
   CRUISES_NOTES CLOB);

-- p.67 CONSTRAINTS
CREATE TABLE positions (
  position_id NUMBER,
  position VARCHAR2(20),
  exempt CHAR(1),
  CONSTRAINT position_ck PRIMARY KEY(position_id)
);
DROP TABLE positions;

-- ***********************************
-- INLINE CONSTRAINTS:
-- ***********************************
CREATE TABLE ports (
  PORT_ID number primary key,
  PORT_NAME VARCHAR2(20));
DROP table ports;

CREATE TABLE ports (
  port_id NUMBER CONSTRAINT port_id_pk PRIMARY KEY,
  port_name VARCHAR2(20));
DROP table ports;

CREATE TABLE VENDORS (
  VENDOR_ID number,
  VENDOR_NAME varchar2(20),
  STATUS number(1) NOT NULL,
  CATEGORY VARCHAR2(5),
  CONSTRAINT number_pk PRIMARY KEY (vendor_id)
);

DROP TABLE vendors;

CREATE TABLE vendors (
  VENDOR_ID number CONSTRAINT vendor_id_pk PRIMARY KEY,
  VENDOR_NAME varchar2(20),
  STATUS number(1) CONSTRAINT status_nn NOT NULL,
  CATEGORY VARCHAR2(5)
);

DROP TABLE vendors;

-- ***************************************
-- OUTLINE CONSTRAINTS:
-- ***************************************
CREATE TABLE ports
(port_id number,
 port_name varchar2(20),
 primary key (port_id)
);

DROP TABLE ports;

CREATE TABLE PORTS
(
 port_id number,
 port_name varchar2(20),
 constraint port_id_pk primary key (port_id)
);

DROP TABLE ports;

-- p.69
CREATE TABLE PORTS
(
 port_id number,
 port_name varchar2(20)
);
ALTER TABLE ports MODIFY port_id primary key;
ALTER TABLE ports DROP PRIMARY KEY;

--ALTER TABLE ports MODIFY port_id primary key;
ALTER TABLE ports ADD CONSTRAINT port_id_pk PRIMARY KEY (port_id);
ALTER TABLE ports ADD CONSTRAINT port_name_un UNIQUE (port_name);
  -- INVALID!:
  -- INVALID TABLE ports ADD CONSTRAINT port_name_nn NOT NULL (port_name);
ALTER TABLE ports MODIFY port_name NOT NULL;
DESC ports;
DROP table ports;

-- p.75-
-- COMPOSITE KEYs
CREATE TABLE HelpDesk
(
  HD_Category NUMBER,
  HD_Year NUMBER,
  HD_Ticket_No NUMBER,
  HD_Title VARCHAR2(30),
  CONSTRAINT HelpDesk_PK PRIMARY KEY (HD_Category, HD_Year, HD_Ticket_No)
);
DROP TABLE HelpDesk;

-- Foreign KEYS:
CREATE TABLE PORTS (
  PORT_ID number, 
  PORT_NAME VARCHAR2(20),
  COUNTRY VARCHAR2(40),
  CAPACITY number,
  constraint port_pk PRIMARY KEY (port_id)
);

CREATE TABLE ships (
  ship_id number primary key,
  home_port_id number,
  constraint home_port_id_pk foreign key (home_port_id) references ports(port_id)
);
drop table ships;

-- P.77
CREATE TABLE ships (
  ship_id number primary key,
  home_port_id number,
  constraint home_port_id_fk foreign key (home_port_id) references ports(port_id)
);
drop table ships;

CREATE TABLE ships (
  SHIP_ID number,
  SHIP_NAME varchar2(20),
  HOME_PORT_ID number not null,
  constraint ships_port_fk FOREIGN KEY(home_port_id) references ports(port_id)
);
drop table ships;
drop table ports;

-- CHECKS (p.79)
CREATE TABLE vendors
(vendor_id number not null primary key,
 vendor_name varchar2(40),
 status number(1) check (status in (4, 5)),
 category varchar2(5)
);
DROP TABLE vendors;

-- *******************************
-- MULTIPLE CONSTRAINTS p. 79.
-- *******************************
CREATE TABLE VENDORS
(VENDOR_ID number constraint VENDOR_ID_PK primary key,
 vendor_name varchar2(20) not null,
 status number(1) constraint status_nn not null,
 category varchar2(20),
 constraint status_ck check(status in (4, 5)),
 constraint category_ck check(category in ('Active','Suspended','Inactive'))
);
 
DROP TABLE vendors;

--
-- from p.58 -> creating curises table:
CREATE TABLE cruises (
  cruise_id NUMBER,
  cruise_type_id NUMBER,
  cruise_name VARCHAR2(20),
  captain_id NUMBER NOT NULL,
  start_date DATE,
  end_date DATE,
  status VARCHAR2(5) DEFAULT 'DOCK',
  CONSTRAINT cruise_pk PRIMARY KEY (cruise_id));

INSERT INTO cruises(cruise_id, cruise_type_id, cruise_name, captain_id, start_date, end_date, status)
  VALUES (1, 1, 'Day at Sea', 101, '02-JAN-10','09-JAN-10', 'Sched');

SELECT * FROM cruises;

-- ********************************************
-- CREATE SEQUENCES (p.104)
CREATE SEQUENCE SEQ_CRUISE_ID;
SELECT SEQ_CRUISE_ID.NEXTVAL from dual;
SELECT SEQ_CRUISE_ID.CURRVAL from DUAL;

INSERT INTO CRUISES (cruise_id, cruise_name, captain_id) 
  VALUES (seq_cruise_id.nextval, 'Hawaii', 12);
  
SELECT * FROM cruises;

ALTER TABLE cruises MODIFY cruise_id DEFAULT seq_cruise_id.nextval;

INSERT INTO CRUISES (cruise_name, captain_id) 
  VALUES ('Zanago', 12);

select * from cruises;
drop sequence seq_cruise_id;
drop table cruises;
 
-- p.146 
CREATE TABLE cruises (
  cruise_id NUMBER,
  cruise_type_id NUMBER,
  cruise_name VARCHAR2(20),
  captain_id NUMBER NOT NULL,
  start_date DATE,
  end_date DATE,
  status VARCHAR2(5) DEFAULT 'DOCK',
  CONSTRAINT cruise_pk PRIMARY KEY (cruise_id));

INSERT into CRUISES (cruise_id, cruise_name, captain_id) VALUES ( 1,  'Hawaii', 1);

UPDATE CRUISES set CRUISE_NAME='Bahamas' WHERE captain_id = 1;

-- ************************
-- Expressions
-- ************************

CREATE TABLE compensation (
  employee_number number primary key,
  last_changed_date date not null,
  salary number(8, 2) not null,
  constraint salary_ck check (salary > 0)
);

INSERT INTO compensation (employee_number, last_changed_date, salary)
VALUES (83, SYSDATE - 10, 10000);

SELECT * FROM compensation;

UPDATE compensation 
  SET salary = salary * 1.03,
  LAST_CHANGED_DATE = SYSDATE
  WHERE employee_number = 83;

SELECT * FROM compensation;  

DROP TABLE compensation;

-- p.113
COMMIT;
COMMIT WORK; -- same as COMMIT;


-- p.117.

CREATE TABLE ports (
  port_id NUMBER CONSTRAINT port_id_pk PRIMARY KEY,
  port_name VARCHAR2(20));

COMMIT;
INSERT INTO ports(port_id, port_name) VALUES (701,'Chicago');
ROLLBACK;

UPDATE ships

DROP TABLE cruises;
DROP TABLE CRUISES_NOTES;
DROP table ports;

--

-- SELECT table_name FROM user_tables;

