-- p.491 Creating tables from subqueries:
-- CREATE TABLE hr.emp AS <subquery>

CREATE TABLE hr.emp AS SELECT * FROM employees;
SELECT * from hr.emp;

DROP table hr.emp;

CREATE TABLE emp_dept AS 
SELECT last_name ename, department_name dname, round(sys_date - hire_date) service FROM employees
NATURAL JOIN departments
ORDER BY dname, ename;

SELECT * FROM emp_dept WHERE rownum < 10;
DROP table emp_dept;

-- Create table with columns but no data:
CREATE TABLE emp_dept AS SELECT * FROM employees WHERE 1=2;
SELECT * FROM emp_dept;
DROP TABLE emp_dept;

-- **************************************************
-- p.492 ALTERING TABLE DEFINITION AFTER CREATION
-- **************************************************

-- ** ADDING COLUMN
-- ALTER TABLE <table_name> ADD <colname> <datat_type>
-- ** MODIFYING COLUMN
-- ALTER TABLE <table_name> MODIFY <colname> <data_type> [DEFAULT expr_or_value]
-- ** DROPPING COLUMN:
-- ALTER TABLE <table_name> DROP <colname>
-- ** MARKING AS UNUSED
-- ALTER TABLE <table_name> SET UNUSED COLUMN <colname>
-- ** RENAMING COLUMN
-- ALTER TABLE <table_name> RENAME COLUMN colname TO newname;
-- ** MARKING THE TABLE AS READ-ONLY:
-- ALTER TABLE <table_name> READ ONLY;
-- ** DROPPING UNUSED COLUMNS:
-- ALTER TABLE <table_name> DROP UNUSED COLUMNS;

CREATE TABLE tab (id NUMBER);
ALTER TABLE tab ADD ( first_name VARCHAR2(2) );
ALTER TABLE tab ADD ( last_name CHAR(40) ); -- Using CHAR is awkward as it will be padded to 40-bytes;
INSERT INTO tab ( id, first_name ) VALUES ( 1, 'Jo' );
-- (This will fail) INSERT INTO tab ( id, first_name ) VALUES ( (SELECT MAX(id) FROM tab), 'Johnaes' );
UPDATE tab SET last_name='Li' WHERE id=1;
SELECT LENGTH(first_name) "length of first_name varchar(2)", LENGTH(last_name) "length of last_name char(40)" FROM tab;
ALTER TABLE tab MODIFY first_name VARCHAR(40);
ALTER TABLE tab MODIFY last_name VARCHAR(40);
SELECT LENGTH(first_name) "length of first_name varchar(40)", LENGTH(last_name) "length of last_name varchar(40)" FROM tab;
SELECT q'<'>'||last_name||q'<'>' "'last_name'", length (last_name) FROM tab;
UPDATE tab SET last_name = trim(last_name);
SELECT q'<'>'||last_name||q'<'>', length (last_name) FROM tab;

ALTER TABLE tab ADD ( comments VARCHAR(4000),
                      sal NUMBER(20,2),
                      info VARCHAR(200) );
ALTER TABLE tab RENAME COLUMN sal TO salary;

--ALTER TABLE tab MODIFY info CHAR(2001);
UPDATE * SET salary = 10000;
ALTER TABLE tab DROP COLUMN salary;
--ALTER TABLE tab DROP COLUMN comments;
--ALTER TABLE tab DROP COLUMN info;
SELECT * FROM tab;



ALTER TABLE tab SET UNUSED COLUMN salary;
ALTER TABLE tab SET UNUSED COLUMN comments;
ALTER TABLE tab SET UNUSED COLUMN info;

ALTER TABLE tab READ ONLY;
-- This will fail as table is read only:
-- TRUNCATE TABLE tab; 

-- BUT THIS WILL WORK (STRANGE!):
ALTER TABLE tab DROP UNUSED COLUMNS;

ALTER TABLE tab READ WRITE;
TRUNCATE TABLE tab;

DROP TABLE tab;

-- ************************************
-- p.493:
-- ************************************
SELECT * FROM tito;

TRUNCATE table tito;
SELECT * FROM tito;

-- ************************************
-- p.494, Exercise 11-4
-- ************************************
-- GENERATED SQL:

CREATE TABLE EMPS
(
EMPNO NUMBER
,ENAME VARCHAR2(25)
,SALARY NUMBER
,DEPTNO NUMBER(4, 0)
);

INSERT INTO EMPS SELECT employee_id, last_name, salary, department_id FROM employees;
COMMIT;

-- *****************************************************************
-- p.496 How Constraints are created at the time of table creation
-- *****************************************************************

-- p.497 Types of constraints:
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY
-- FOREIGN KEY
-- CHECK

-- Unique constraints

-- P.499

-- p.501
CREATE TABLE dept (
  deptno NUMBER(2, 0) CONSTRAINT dept_deptno_pk PRIMARY KEY
  CONSTRAINT dept_deptno_ck CHECK (deptno BETWEEN 10 AND 90),
  dname VARCHAR2(20) CONSTRAINT dept_deptno_nn NOT NULL);

SELECT * FROM dept;

--CREATE TABLE emp (
--  empno NUMBER(4,0) CONSTRAINT emp_empno_pk PRIMARY KEY,
--  ename VARCHAR2(20) CONSTRAINT emp_ename_nn NOT NULL,
--  mgr NUMBER(4,0) CONSTRAINT emp_mgr_fk REFERENCES emp (empno),
--  dob DATE,
--  hiredate DATE,
--  deptno NUMBER(2,0) CONSTRAINT emp_deptno_fk REFERENCES dept(deptno) ON DELETE set NULL,
--  email VARCHAR2 (30) CONSTRAINT emp_email_uk UNIQUE,
--    CONSTRAINT emp_hiredate_ck CHECK(hiredate >= dob + 365*16),
--    CONSTRAINT emp_email_ck CHECK ((instr(email,'@') > 0) AND (instr(email,'.') > 0)));
  
--CREATE TABLE dept(
--  deptno NUMBER(2,0) CONSTRAINT dept_deptno_pk PRIMARY KEY
--  CONSTRAINT dept_deptno_ck CHECK (deptno BETWEEN 10 AND 90),
--  dname VARCHAR2(20) CONSTRAINT dept_dname_nn NOT NULL);
  
-- FAILS (501):
CREATE TABLE emp(
  empno NUMBER(4,0) CONSTRAINT emp_empno_pk PRIMARY KEY,
  ename VARCHAR2(20) CONSTRAINT emp_ename_nn NOT NULL,
  mgr NUMBER(4,0) CONSTRAINT emp_mgr_fk REFERENCES emp (empno),
  dob DATE,
  hiredate DATE,
  deptno NUMBER(2,0) CONSTRAINT emp_deptno_fk REFERENCES
  dept(deptno)
  ON DELETE SET NULL,
  email VARCHAR2(30) CONSTRAINT emp_email_uk UNIQUE,
  CONSTRAINT emp_hiredate_ck CHECK(hiredate>= dob + 365*16),
  CONSTRAINT emp_email_ck
  CHECK ((instr(email,'@') > 0) AND (instr(email,'.') > 0)));  

SELECT * FROM emp;

-- p.504 E11-5

-- p.2
DROP TABLE emp;
DROP TABLE dept;

CREATE TABLE EMP AS 
  SELECT employee_id empno, last_name ename, department_id deptno 
  FROM employees;
  
-- p.3
CREATE TABLE DEPT AS 
  SELECT department_id deptno, department_name dname 
  FROM departments;

-- p.4
DESCRIBE TABLE emp;
DESCRIBE dept;

-- p.5
ALTER TABLE emp 
  ADD CONSTRAINT emp_pk PRIMARY KEY (empno);
  
ALTER TABLE dept 
  ADD CONSTRAINT dept_pk PRIMARY KEY(deptno);
  
ALTER TABLE emp 
  ADD CONSTRAINT dept_fk FOREIGN KEY (deptno) REFERENCES dept ON DELETE SET NULL;
  
-- p.6.
SELECT * FROM dept WHERE deptno = 10;
-- This will fail (INSERT violates PRIMARY KEY)
  -- INSERT INTO dept (deptno, dname) VALUES (10, 'Whatever');

-- This will fail as parent key will not be found:
  -- INSERT INTO emp VALUES (9999,'New emp', 99);

-- Cannot delete dept table as emp refers to keys in dept;
  -- TRUNCATE TABLE dept;

-- p.7.
DROP TABLE emp;
DROP TABLE dept;