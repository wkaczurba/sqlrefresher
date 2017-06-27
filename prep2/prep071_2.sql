SELECT apt_name, apt_abbr, act_name, act_seats
FROM airports apt
  INNER JOIN aircraft_fleet afl
  ON apt.apt_id = afl.apt_id
  INNER JOIN aircraft_types act
  ON act.act_id = afl.act_id;

    SELECT apt_name, act_name, emp_first, emp_last
    FROM airports apt
    INNER JOIN aircraft_fleet afl
    ON apt.apt_id = afl.apt_id
    INNER JOIN aircraft_types act
    ON act.act_id = afl.act_id
    INNER JOIN employees emp
    ON afl.afl_id = emp.afl_id;
    
  SELECT apt_name, act_name, emp_first, emp_last
  FROM airports apt
  NATURAL JOIN aircraft_fleet afl
  NATURAL JOIN aircraft_types act
  NATURAL JOIN employees emp;
  
  WITH airport_cols AS
    (SELECT column_name from all_tab_cols where table_name='AIRPORTS'),
    aircraft_fleet_cols AS
    (SELECT column_name from all_tab_cols where table_name='AIRCRAFT_FLEET'),
    aircraft_cols AS
    (SELECT column_name from all_tab_cols where table_name='AIRCRAFT_TYPES'),
    employees_cols AS
    (SELECT column_name from all_tab_cols where table_name='EMPLOYEES'),
    all_cols AS (
      SELECT * FROM airport_cols 
      UNION 
      SELECT * FROM aircraft_fleet_cols
      UNION
      SELECT * FROM aircraft_cols
      UNION
      SELECT * FROM employees_cols
    )
  (SELECT * FROM airport_cols
   INTERSECT
   SELECT * FROM aircraft_fleet_cols)
  UNION
  (SELECT * FROM airport_cols
   UNION 
   SELECT * FROM aircraft_fleet_cols
   INTERSECT
   SELECT * FROM aircraft_cols)
  UNION
  (SELECT * FROM airport_cols
   UNION 
   SELECT * FROM aircraft_fleet_cols
   UNION
   SELECT * FROM aircraft_cols
   INTERSECT
   SELECT * FROM employees_cols
   );

  
  SELECT apt_name, act_name, emp_first, emp_last
  FROM airports apt
  NATURAL JOIN aircraft_fleet afl
  NATURAL JOIN aircraft_types act
  NATURAL JOIN employees emp;  
  
  desc employees;
  
  SELECT apt_name, act_name, emp_first, emp_last
  FROM airports apt
  JOIN aircraft_fleet afl USING (apt_id)
  JOIN aircraft_types act USING (act_id)
  JOIN employees emp USING (afl_id);  
    
SELECT emp.emp_first, emp.emp_last, salary, slr_code
FROM employees emp
  INNER JOIN salary_ranges slr
  ON emp.salary BETWEEN slr.slr_lowval AND slr.slr_highval
  ORDER BY slr_code DESC;    

CREATE TABLE table_A (
  col1 NUMBER,
  col2 VARCHAR2(1)
);

CREATE TABLE table_B (
  col1 NUMBER,
  col2 VARCHAR2(1)
);

INSERT INTO table_A values(1,'a');
INSERT INTO table_A values(2,'b');
INSERT INTO table_A values(3,'c');

INSERT INTO table_B values(2,'B');
INSERT INTO table_B values(3,'C');
INSERT INTO table_B values(4,'D');

SELECT a.col1 AS TA_COL1, a.col2 AS TA_col2,
       b.col1 AS TB_COL1, b.col2 AS TB_col2
FROM table_A a
  INNER JOIN table_B b
  ON a.col1 = b.col1;


  CREATE TABLE employees_copy
    AS SELECT emp_first, emp_last, emp_job, start_date
	     FROM employees
		 WHERE start_date > START_DATE - 365;
     
drop table employees_copy;

  SELECT * FROM hr.departments
    WHERE department_id < 70;
    
  CREATE TABLE aircraft_types2 (
    act_id NUMBER,
	act_name VARCHAR2(20),
	act_body_style VARCHAR2(10),
	act_decks NUMBER,
	act_seats NUMBER NOT NULL,
	  CONSTRAINT ac_type_pk PRIMARY KEY (act_id)
  );    
  
  DROP Table aircraft_types2 PURGE;
  
  CREATE TABLE aircraft_types2 (
    act_id NUMBER CONSTRAINT act_type_pk PRIMARY KEY,
	act_name VARCHAR2(20),
	act_body_style VARCHAR2(10),
	act_decks NUMBER,
	act_seats NUMBER NOT NULL
  );    
  
    
  select constraint_name, constraint_type, search_condition FROM user_constraints
  WHERE table_name = 'AIRCRAFT_TYPES2';
  
  
  create table constraint_test (
    col1 number,
    col2 number(8, 2)
  );
  alter table constraint_test drop (col2); -- OK
  alter table constraint_test add col2 number;  -- OK
  alter table constraint_test drop column col2; -- OK
  alter table constraint_test add (col2 number, col3 number); -- OK
  --alter table constraint_test drop column col2 number;
  -- fails:
    -- alter table constraint_test add column (col2 number);
    -- alter table constraint_test add column col2 number;
  drop table constraint_test purge;
  
  
  create table parent (
    parent_id number primary key,
    name varchar2(80)
  );
    
  create table child (
    child_id number primary key,
    parent_id number not null,
    constraint parent_id_fk foreign key (child_id) references parent(parent_id)
  );
  
  insert into parent (parent_id, name) values (1, 'John');
  insert into child (child_id, parent_id) values (1, 1);
  
  -- this one will fail:
    -- drop table parent;
  -- this one will work:
  drop table parent cascade constraints;
  
  -- This will fail ():
    -- alter table parent drop (parent_id);
  alter table parent drop (parent_id) cascade constraints; -- THIS WILL DELETE.
  
  drop table parent purge;
  drop table child purge;
  


--
  DROP TABLE parent CASCADE CONSTRAINTS PURGE; -- PURGE has to be the last, after CASCADE CONSTRAINT.
  DROP TABLE child PURGE;

  create table parent (
    parent_id number primary key,
    name varchar2(80)
  );
  
  create table child (
    child_id number primary key,
    parent_id number not null,
    constraint parent_id_fk foreign key (child_id) references parent(parent_id)
  );

  -- This one will not work if there ar FK-references to the field:
    -- alter table parent set unused (parent_id);
  -- This one will work
    -- alter table parent set unused (parent_id) cascade constraint;
    
  
  select * from user_tab_columns where table_name='PARENT';
  alter table parent set unused column parent_id cascade constraints;  -- It will make parent_id disappear.
  select * from user_tab_columns where table_name='PARENT';
  select * from user_unused_col_tabs; -- It will display value of 1.
  desc parent;

create table drop_cols (
  col1 number,
  col2 number
);

alter table drop_cols set unused (col2);
alter table drop_cols drop unused columns;
alter table drop_cols add (col2 number);
alter table drop_cols set unused column col2;
alter table drop_cols drop unused columns;
 -- This will fail; you need to use ALTER TABLE xxx ADDD (col_name datatype);
   -- alter table drop_cols add column col2 number;
   -- alter table drop_cols add columns (col2 number);

CREATE DIRECTORY def_dir1 AS 'C:/app/OracleHomeUser1/oradata/orcl/org_external';
    
CREATE TABLE emp_xt
  (emp_number CHAR(5),
	 emp_dob CHAR(20),
	 emp_last_name CHAR(20),
	 emp_first_name CHAR(15),
	 emp_middle_name CHAR(15),
	 emp_hire_date DATE)
ORGANIZATION EXTERNAL
  (
    TYPE ORACLE_DATAPUMP
    DEFAULT DIRECTORY def_dir1
    LOCATION ('info.dat')
  );
  
INSERT INTO emp_xt (emp_number,
	 emp_dob,
	 emp_last_name,
	 emp_first_name,
	 emp_middle_name,
	 emp_hire_date) VALUES ('123', 'Jan1983', 'Osullivan', 'John', 'Ted', SYSDATE);

DROP TABLE inventories_xt PURGE;


CREATE TABLE emp_xt (
  -- DETAILS ABOUT THE TABLE
)
ORGANIZATION EXTERNAL
(
  -- ORGANIZATION EXTERNAL DETAILS:
)


  CREATE TABLE emp_load
  (emp_number CHAR(5),
	 emp_dob CHAR(20),
	 emp_last_name CHAR(20),
	 emp_first_name CHAR(15),
	 emp_middle_name CHAR(15),
	 emp_hire_date DATE)
  ORGANIZATION EXTERNAL
    (TYPE ORACLE_DATAPUMP
	 DEFAULT DIRECTORY def_dir1
	 ACCESS PARAMETERS
	  (RECORDS DELIMITED BY NEWLINE FIELDS
	    (emp_number CHAR(2),
		 emp_dob CHAR(20),
		 emp_last_name CHAR(18),
		 emp_first_name CHAR(11),
		 emp_middle_name CHAR(11),
		 emp_hire_date CHAR(10)
		 date_format DATE mask "mm/dd/yyyy"
		)
	  )
	LOCATION ('info.dat')
  );  
  
  insert into 
  
  select * from emp_load;
  
-- NON-SCHEMA OBJECTS: DBA_USERS, dictionary, dict_columns, global_name, nls_database_parameters, session_privs
  SELECT global_name FROM GLOBAL_NAME;
  SELECT table_name, comments FROM DICTIONARY;
  SELECT table_name, column_name, comments FROM dict_columns WHERE table_name='EMPLOYEES';
  -- Need SYS priviliages:
    --SELECT * FROM DBA_USERS;
    --SELECT account_status, count(*) FROM DBA_USERS GROUP BY account_status;
  SELECT * FROM NLS_DATABASE_PARAMETERS;
  SELECT * FROM SESSION_PRIVS; -- Session privilages;
  
-- Schema objects: 
  SELECT * FROM user_indexes;
  SELECT * FROM user_ind_columns;
  SELECT * FROM user_sequences;
  SELECT * FROM user_synonyms;
  SELECT * FROM user_tab_columns;
  SELECT * FROM user_tab_privs;
  SELECT * FROM user_tables;
  SELECT * FROM user_objects;

-- Dynamic performance views


