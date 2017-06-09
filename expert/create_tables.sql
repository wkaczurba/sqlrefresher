-- MAKE SURE YOU EXECUTE THIS SCRIPT AS "se/se@pdborcl"

-- This script creates all tables 

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
alter table ship_cabins add balcony_sq_ft number(6) constraint balcony_sq_ft_ck check (balcony_sq_ft IS NULL or balcony_sq_ft >= 0);

--CREATE table passengers (
--  first_name varchar(20),
--  last_name varchar(20),
--  room_number number,
--  constraint room_number_fk foreign key (room_number) references SHIP_CABINS(room_number)
--);


INSERT ALL 
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (1, 102, 'Suite', 'Standard', 'Ocean', 4, 533, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (3, 104, 'Suite', 'Standard', 'None', 4 , 533, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (5, 106, 'Suite', 'Standard', 'None', 6, 586, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (6, 107, 'Suite', 'Royal', 'Ocean', 5, 1524, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (10, 702, 'Suite', 'Presidential', 'None', 5, 1142, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (11, 703, 'Suite', 'Royal', 'Ocean', 5, 1745, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (12, 704, 'Suite', 'Skyloft', 'Ocean', 8, 722, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (2, 103, 'Stateroom', 'Standard', 'Ocean', 2, 160, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (4, 105, 'Stateroom', 'Standard', 'Ocean', 3, 205, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (7, 108, 'Stateroom', 'Large', 'None', 2, 211, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (8, 109, 'Stateroom', 'Standard', 'None', 2, 180, NULL)
  into ship_cabins (ship_cabin_id, room_number, room_style, room_type, window, guests, sq_ft, balcony_sq_ft) VALUES (9, 110, 'Stateroom', 'Large', 'None', 2, 225, NULL)
  SELECT * from dual;
  
alter table ship_cabins add SHIP_ID number default 1 not null;



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

CREATE TABLE employees (
  employee_id NUMBER PRIMARY KEY,
  ship_id NUMBER,
  first_name VARCHAR2(20),
  last_name varchar2(30),
  position_id number,
  ssn varchar2(11),
  dob date,
  primary_phone varchar2(20)
);

CREATE TABLE addresses (
  address_id NUMBER PRIMARY KEY,
  employee_id NUMBER,
  street_address VARCHAR2(40),
  city VARCHAR2(40),
  STATE VARCHAR2(2),
  ZIP VARCHAR2(5),
  ZIP_PLUS VARCHAR2(4),
  COUNTRY VARCHAR2(20),
  CONSTRAINT employee_id_pk FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

INSERT into employees (employee_id, ship_id, first_name, last_name, position_id, ssn, dob, primary_phone) 
  VALUES (1, 1, 'John', 'Kyle', 1, 12345678901, '12-JAN-74', '230-2323-232');
INSERT into addresses (address_id, employee_id, street_address, city, state, zip, zip_plus, country)
  VALUES (1, 1, '44 Foxfield', 'Limerick', '', 'ABCDE', '', 'Ireland');

--SELECT * FROM
COMMIT;

--SELECT * FROM employees;

CREATE TABLE scores (
  SCORE_ID number primary key,
  TEST_SCORE number not null check (test_score >= 0)
);
ALTER TABLE scores ADD CONSTRAINT score_id_ck CHECK (score_id between 0 AND 100);

CREATE TABLE grading (
  GRADING_ID number primary key,
  GRADE varchar(2) unique not null,
  SCORE_MIN number,
  SCORE_MAX number,
  CONSTRAINT grade_ck CHECK (LENGTH(GRADE) = 1 AND ASCII(GRADE) = 64 + GRADING_ID)
);
ALTER Table grading ADD CONSTRAINT score_min_ck CHECK (score_min >= 0);
ALTER TABLE grading ADD CONSTRAINT score_max_ck CHECK (score_max <= 100);
ALTER TABLE grading ADD CONSTRAINT score_min_le_max_ck CHECK (score_min <= score_max);

INSERT INTO scores (score_id, test_score) VALUES (1, 95);
INSERT INTO scores (score_id, test_score) VALUES (2, 55);
INSERT INTO scores (score_id, test_score) VALUES (3, 83);

INSERT INTO grading (grading_id, grade, score_min, score_max) VALUES (1, 'A', 90, 100);
INSERT INTO grading (grading_id, grade, score_min, score_max) VALUES (2, 'B', 80, 89);
INSERT INTO grading (grading_id, grade, score_min, score_max) VALUES (3, 'C', 70, 79);
INSERT INTO grading (grading_id, grade, score_min, score_max) VALUES (4, 'D', 60, 69);
INSERT INTO grading (grading_id, grade, score_min, score_max) VALUES (5, 'E', 50, 59);


CREATE TABLE positions (
  POSITION_ID NUMBER(4) primary key,
  POSITION VARCHAR2(20),
  REPORTS_TO NUMBER(4), 
  EXEMPT CHAR,
  MIN_SALARY NUMBER(10, 2),
  MAX_SALARY NUMBER(10, 2),
  CONSTRAINT report_to_fk FOREIGN KEY (reports_to) REFERENCES positions(position_id)
);

INSERT INTO positions (position_id, position, reports_to) VALUES (1, 'Capitain', null);
INSERT INTO positions (position_id, position, reports_to) VALUES (2, 'Director', 1);
INSERT INTO positions (position_id, position, reports_to) VALUES (3, 'Manager', 2);
INSERT INTO positions (position_id, position, reports_to) VALUES (4, 'Crew Chief', 3);
INSERT INTO positions (position_id, position, reports_to) VALUES (5, 'Crew', 4);


CREATE TABLE PAY_HISTORY (
  PAY_HISTORY_ID NUMBER PRIMARY KEY,
  EMPLOYEE_ID NUMBER,
  SALARY NUMBER(10, 2),
  START_DATE DATE,
  END_DATE DATE
);

CREATE TABLE INVOICES (
  INVOICE_ID NUMBER PRIMARY KEY,
  INVOICE_DATE DATE,
  ACCOUNT_NUMBER VARCHAR2(80),
  TERMS_OF_DISCOUNT VARCHAR2(20),
  VENDOR_ID NUMBER,
  TOTAL_PRICE NUMBER(8, 2),
  SHIPPING_DATE DATE
);

INSERT INTO PAY_HISTORY(PAY_HISTORY_ID, EMPLOYEE_ID, SALARY, START_DATE, END_DATE) VALUES (1, 1, 100000, TRUNC(SYSDATE - 7, 'DD'), TRUNC(SYSDATE, 'DD'));
INSERT INTO PAY_HISTORY(PAY_HISTORY_ID, EMPLOYEE_ID, SALARY, START_DATE, END_DATE) VALUES (2, 2, 100345, TRUNC(SYSDATE - 7, 'DD'), TRUNC(SYSDATE, 'DD'));
INSERT INTO PAY_HISTORY(PAY_HISTORY_ID, EMPLOYEE_ID, SALARY, START_DATE, END_DATE) VALUES (3, 3,  93233, TRUNC(SYSDATE - 7, 'DD'), TRUNC(SYSDATE, 'DD'));
INSERT INTO PAY_HISTORY(PAY_HISTORY_ID, EMPLOYEE_ID, SALARY, START_DATE, END_DATE) VALUES (4, 4,  83230, TRUNC(SYSDATE - 14, 'DD'), TRUNC(SYSDATE, 'DD'));
INSERT INTO PAY_HISTORY(PAY_HISTORY_ID, EMPLOYEE_ID, SALARY, START_DATE, END_DATE) VALUES (5, 5,  64430, TRUNC(SYSDATE - 7, 'DD'), TRUNC(SYSDATE, 'DD'));

INSERT INTO INVOICES(INVOICE_ID, INVOICE_DATE, TOTAL_PRICE) values (1, trunc(SYSDATE - 7), 100000);
INSERT INTO INVOICES(INVOICE_ID, INVOICE_DATE, TOTAL_PRICE) values (2, trunc(SYSDATE - 7), 100345);
INSERT INTO INVOICES(INVOICE_ID, INVOICE_DATE, TOTAL_PRICE) values (3, trunc(SYSDATE - 7), 93233);
INSERT INTO INVOICES(INVOICE_ID, INVOICE_DATE, TOTAL_PRICE) values (4, trunc(SYSDATE - 14), 83230);
INSERT INTO INVOICES(INVOICE_ID, INVOICE_DATE, TOTAL_PRICE) values (5, trunc(SYSDATE - 7), 64430);

-- DROPPING TABLES:
--DROP TABLE positions;
--DROP TABLE SHIP_CABINS;
--DROP TABLE ships;
--DROP TABLE ports;
--
--DROP TABLE ADDRESSES;
--DROP TABLE EMPLOYEES;
--
--drop table scores;
--drop table grading;
