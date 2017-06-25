/* ***************************************************
* The following code create the AIRPORT tables used  *
* by some of the procedures in this book             *
**************************************************** */

DROP TABLE prep071.AIRPORTS;
DROP TABLE prep071.AIRCRAFT_TYPES;
DROP TABLE prep071.AIRCRAFT_FLEET;
DROP TABLE prep071.employees;
DROP TABLE prep071.sort_example;
DROP TABLE prep071.nums;
DROP TABLE prep071.salary_ranges;
DROP TABLE prep071.table_setA;
DROP TABLE prep071.table_setB;

  CREATE TABLE prep071.AIRPORTS
   (	"APT_ID" NUMBER, 
	"APT_NAME" VARCHAR2(22), 
	"APT_ABBR" VARCHAR2(5)
   ) ;
/

  CREATE TABLE prep071.AIRCRAFT_TYPES
   (	"ACT_ID" NUMBER, 
	"ACT_NAME" VARCHAR2(12), 
	"ACT_BODY_STYLE" VARCHAR2(10), 
	"ACT_DECKS" VARCHAR2(10), 
	"ACT_SEATS" NUMBER
   ) ;
/

  CREATE TABLE prep071.AIRCRAFT_FLEET
   (	"AFL_ID" NUMBER, 
	"ACT_ID" NUMBER, 
	"APT_ID" NUMBER
   ) ;
/

Insert into prep071.AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (1,'Orlando, FL','MCO');
Insert into prep071.AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (2,'Atlanta, GA','ATL');
Insert into prep071.AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (3,'Miami, FL','MIA');
Insert into prep071.AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (4,'Jacksonville, FL','JAX');
Insert into prep071.AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (5,'Dallas/Fort Worth','DFW');
REM INSERTING into prep071.AIRCRAFT_TYPES
SET DEFINE OFF;
Insert into prep071.AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (1,'Boeing 747','Wide','Double',416);
Insert into prep071.AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (2,'Boeing 767','Wide','Single',350);
Insert into prep071.AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (3,'Boeing 737','Narrow','Single',200);
Insert into prep071.AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (4,'Boeing 757','Narrow','Single',240);
REM INSERTING into prep071.AIRCRAFT_FLEET
SET DEFINE OFF;
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (1,2,1);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (2,2,1);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (3,3,2);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (4,4,2);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (5,1,3);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (6,1,3);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (7,1,5);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (8,2,5);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (9,4,null);
Insert into prep071.AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (10,3,null);

  CREATE TABLE prep071.EMPLOYEES
   (	"EMP_ID" NUMBER, 
	"AFL_ID" NUMBER, 
	"EMP_FIRST" VARCHAR2(10), 
	"EMP_LAST" VARCHAR2(10) NOT NULL, 
	"EMP_JOB" VARCHAR2(10), 
	"EMP_SUPERVISOR" NUMBER, 
	"SALARY" NUMBER, 
	"START_DATE" DATE DEFAULT SYSDATE
   ) ;
/
ALTER TABLE prep071.EMPLOYEES ADD CONSTRAINT emp_id_pk PRIMARY KEY (emp_id);

REM INSERTING into EMPLOYEES
SET DEFINE OFF;
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (1,null,'Big','Boss','CEO',null,197500,to_date('10-APR-92','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (2,null,'Adam','Smith','CFO',1,157000,to_date('29-MAR-93','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (3,null,'Rick','Jameson','SVP',1,145200,to_date('30-JAN-95','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (4,null,'Rob','Stoner','SVP',1,149100,to_date('20-JUL-94','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (5,null,'Bill','Abong','VP',3,123500,to_date('17-MAY-92','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (6,null,'Janet','Jeckson','VP',4,127800,to_date('15-APR-02','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (18,null,'Guy','Newberry','Mgr',8,90000,null);
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (8,null,'Alf','Alien','SrDir',6,110500,to_date('05-AUG-97','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (9,null,'Norm','Storm','Mgr',8,101500,to_date('01-FEB-99','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (10,1,'John','Jones','Pilot',9,97500,to_date('10-APR-95','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (11,2,'Top','Gun','Pilot',9,91500,to_date('13-OCT-96','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (12,3,'Phil','McCoy','Pilot',9,105000,to_date('09-JUN-96','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (13,4,'James','Thomas','Pilot',9,98500,to_date('12-MAY-99','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (14,5,'John','Picard','Pilot',9,49500,to_date('11-NOV-01','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (15,6,'Luke','Skytalker','Pilot',9,90000,to_date('10-SEP-02','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (16,7,'Dell','Aptop','Pilot',9,87500,to_date('22-AUG-03','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (17,8,'Noh','Kia','Pilot',9,92250,to_date('07-JUL-04','DD-MON-RR'));
Insert into prep071.EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (7,null,'Fred','Stoneflint','SrDir',5,111500,to_date('07-APR-01','DD-MON-RR'));

create table prep071.sort_example (
  char_column varchar2(10),
  num_column number
);

insert into prep071.sort_example (char_column, num_column) values ('1', 1);
insert into prep071.sort_example (char_column, num_column) values ('2', 2);
insert into prep071.sort_example (char_column, num_column) values ('A', 10);
insert into prep071.sort_example (char_column, num_column) values ('B', 20);
insert into prep071.sort_example (char_column, num_column) values ('C', 30);
insert into prep071.sort_example (char_column, num_column) values ('100', 100);
insert into prep071.sort_example (char_column, num_column) values ('a', 200);
insert into prep071.sort_example (char_column, num_column) values ('b', 300);
insert into prep071.sort_example (char_column, num_column) values ('c', 400);

CREATE OR REPLACE VIEW prep071.aircraft_fleet_v
AS
SELECT apt_name, apt_abbr, act_name, act_body_style, act_decks, act_seats
FROM prep071.airports apt
  INNER JOIN prep071.aircraft_fleet afl
  ON apt.apt_id = afl.apt_id
  INNER JOIN prep071.aircraft_types act
  ON act.act_id = afl.act_id;

CREATE TABLE prep071.nums (
  x NUMBER
);

INSERT INTO prep071.nums VALUES (1);
INSERT INTO prep071.nums VALUES (2);
INSERT INTO prep071.nums VALUES (3);
INSERT INTO prep071.nums VALUES (4);
INSERT INTO prep071.nums VALUES (5);
INSERT INTO prep071.nums VALUES (6);
INSERT INTO prep071.nums VALUES (7);
INSERT INTO prep071.nums VALUES (8);
INSERT INTO prep071.nums VALUES (9);
INSERT INTO prep071.nums VALUES (10);

CREATE OR REPLACE VIEW prep071.nums_v
AS SELECT n1.x X, n2.x Y FROM prep071.nums n1 CROSS JOIN prep071.nums n2;

create table prep071.salary_ranges (
  salary_code varchar(3)
--    constraint salary_code_pk primary key
    constraint salary_code_ck CHECK (SUBSTR(salary_code, 1, 1) = 'S' AND TO_NUMBER(SUBSTR(salary_code, 2, 2), '00') > 0),
  slr_lowval number(10,2) constraint slr_lowval_ck CHECK (slr_lowval >= 0),
  slr_highval number(10,2) constraint slr_highval_ck CHECK (slr_highval > 0),
  constraint slr_ck check (slr_lowval <= slr_highval)
);
alter table prep071.salary_ranges rename column salary_code to slr_code;

insert all
  into prep071.salary_ranges (slr_code, slr_lowval, slr_highval) values ('S04', 0, 100000)
  into prep071.salary_ranges (slr_code, slr_lowval, slr_highval) values ('S05', 100000, 120000)
  into prep071.salary_ranges (slr_code, slr_lowval, slr_highval) values ('S06', 120000, 140000)
  into prep071.salary_ranges (slr_code, slr_lowval, slr_highval) values ('S07', 140000, 180000)
  into prep071.salary_ranges (slr_code, slr_lowval, slr_highval) values ('S09', 180000, 250000)
  select * from dual;

-- for p. 140:

CREATE TABLE prep071.table_setA (
  col1 varchar(1)
);

CREATE TABLE prep071.table_setB (
  col1 varchar(1)
);

INSERT INTO prep071.table_setA (col1) values('A');
INSERT INTO prep071.table_setA (col1) values('A');
INSERT INTO prep071.table_setA (col1) values('A');
INSERT INTO prep071.table_setA (col1) values('B');
INSERT INTO prep071.table_setA (col1) values('C');

INSERT INTO prep071.table_setB (col1) values('B');
INSERT INTO prep071.table_setB (col1) values('B');
INSERT INTO prep071.table_setB (col1) values('C');
INSERT INTO prep071.table_setB (col1) values('C');
INSERT INTO prep071.table_setB (col1) values('D');
INSERT INTO prep071.table_setB (col1) values('D');
INSERT INTO prep071.table_setB (col1) values('D');

commit;

