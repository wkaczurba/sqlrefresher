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

