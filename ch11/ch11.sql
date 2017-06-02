-- p.478 -- List object types (HAVE TO BE logged in as: SYS as SYSDBA
--
--SELECT object_type, count(object_type)
--FROM dba_objects
--GROUP BY object_type
--ORDER BY object_type;

--OBJECT_TYPE                                  COUNT(OBJECT_TYPE)
------------------------- ---------------------------------------
--CLUSTER                                                      10
--CONSUMER GROUP                                               18
--CONTEXT                                                      18
--DATABASE LINK                                                 2
--DESTINATION                                                   2
--DIMENSION                                                     5
--DIRECTORY                                                    16
--EDITION                                                       1
--EVALUATION CONTEXT                                           15
--FUNCTION                                                    367
--INDEX                                                      2997
--INDEX PARTITION                                             380
--INDEXTYPE                                                    11
--JAVA CLASS                                                38201
--JAVA DATA                                                   418
--JAVA RESOURCE                                              1731
--JAVA SOURCE                                                   2
--JOB                                                          20
--JOB CLASS                                                    15
--LIBRARY                                                     236
--LOB                                                         734
--LOB PARTITION                                                28
--MATERIALIZED VIEW                                             2
--OPERATOR                                                     62
--PACKAGE                                                    1060
--PACKAGE BODY                                               1010
--PROCEDURE                                                   225
--PROGRAM                                                      11
--QUEUE                                                        29
--RESOURCE PLAN                                                11
--RULE                                                          1
--RULE SET                                                     23
--SCHEDULE                                                      4
--SCHEDULER GROUP                                               4
--SEQUENCE                                                    303
--SYNONYM                                                   12198
--TABLE                                                      2213
--TABLE PARTITION                                             358
--TABLE SUBPARTITION                                           32
--TRIGGER                                                     151
--TYPE                                                       2978
--TYPE BODY                                                   275
--UNDEFINED                                                    15
--UNIFIED AUDIT POLICY                                          9
--VIEW                                                       7024
--WINDOW                                                        9
--XML SCHEMA                                                   44

-- The most interesting ones are: TABLES, VIEWS, SYNONYMS, SEQUENCES, INDEXES
--SELECT object_type, count(1)
--FROM dba_objects WHERE upper(object_type) IN (
--  'TABLE','VIEW','SYNONYM','SEQUENCE','INDEX'
--) GROUP BY object_type;


-- Fig 11-1 p.480
CREATE TABLE "with space" ("-Hyphen" date);

INSERT INTO "with space" VALUES (sysdate);

SELECT * FROM "with space";

DROP TABLE "with space";

-- p.481
CREATE TABLE lower(c1 date);
SELECT * FROM lower;
--SELECT * FROM "lower"; -- Will fail
--DROP TABLE "lower"; -- will fail
DROP TABLE lower;

CREATE TABLE "lower"(c1 date);
-- SELECT * FROM lower;  -- will fail
SELECT * FROM "lower";
-- DROP TABLE lower; -- will fail
DROP TABLE "lower";

-- p.482 Exercise 11-1:

-- 11-1.2
SELECT object_type, count(*)
FROM user_objects
GROUP by object_type;

-- 11-1.3
SELECT object_type, count(*)
FROM all_objects
GROUP BY object_type;

-- 11-1.4
SELECT DISTINCT owner
FROM all_objects;

-- TABLE STRUCTURE - p.483 Exercise 11-2
-- IOT = index organized tables;
-- p.2 the names and types of tables that exist in the HR schema
SELECT table_name, cluster_name, iot_type FROM user_tables;

-- p.3 structure of a table:
DESCRIBE REGIONS;

-- structure of a table using data dictionary view:
SELECT column_name, data_type, nullable
FROM user_tab_columns
WHERE table_name = 'REGIONS';

--DESCRIBE user_tab_columns;


-- *****************************
-- p.484 Data types available for columns
-- *****************************
-- VARCHAR2 - 1000...4000 or 3276 if extended
-- NVARCHAR2 - ISO/UNICODE 1000.4000 or 32768 if extended
-- CHAR - 1 to 2000 (fixed length/padding)
-- RAW
-- NUMBER
-- FLOAT
-- RAW
-- NUMBER -> 1...38, scale -84...127
-- FLOAT -> 126 binary
-- INTEGER -> 1...38, scale = 0;
-- DATE
-- TIMESTAMP: date + up to 9 decimal spaces for seconds miliseconds
-- TIMESTAMP WITH TIMEZONE
-- TIMESTAMP WITH LOCAL TIMEZONE
-- INTERVAL YEAR TO MONTH -> period containing YEAR + MONTH between two dates/timestamps 
-- INTERVAL DAY TO SECOND -> period containing DAYS + SECONDS between two dates/timestamps
-- CLOB - CHARACTER
-- NCLOB - CHARACTER + UNICODE
-- BLOB
-- BFILE -> file locator on the sererver's side
-- LONG - like CLOB but old and to be avoided.
-- LONG RAW - like BLOB but old and to be avoided
-- ROWID - a value coded in 64-bit  pointer to the location of a row in table.

-- p.487, Fig 11-2

ALTER SESSION SET NLS_DATE_FORMAT = 'dd-mm-yyyy';
SELECT SYSDATE from DUAL;

CREATE TABLE typecast (
  "DATE" DATE,
  "NUMBER" NUMBER,
  "COMMENT" CHAR(10)
);

INSERT INTO typecast VALUES (to_date('23-11-2023'), to_number(1000), 'explicit ');
INSERT INTO typecast VALUES ('23-11-2023',1000, 'implicit ');

SELECT * FROM typecast;
DROP TABLE typecast;

-- p.488

DESCRIBE employee;
DESCRIBE departments;

SELECT column_name, data_type, nullable, data_length, data_precision, data_scale 
FROM user_tab_columns
WHERE table_name='EMPLOYEES';

-- ***************************
-- CREATE TABLE p.489
-- ***************************
-- CREATE TABLE [schema.]table [ORGANIZATION HEAP] 
--   (column datatype [DEFAULT expression],
--    [column dattype [DEFAULT expression]...]);

CREATE TABLE hr.emp
  (EMPNO NUMBER(4),
   ENAME VARCHAR2(10),
   HIREDATE DATE DEFAULT TRUNC(SYSDATE),
   SAL NUMBER(7, 2),
   COMM NUMBER(7, 2) DEFAULT 0.03);

INSERT INTO hr.emp (empno, ename, sal)
  VALUES (1000, 'John', 1000.789);
  
SELECT * FROM hr.emp;

drop table hr.emp;

-- THE STUFF BELOW IS exported to ch11_tables.sql

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
