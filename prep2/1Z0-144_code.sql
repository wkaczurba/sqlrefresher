/* ***************************************************
* This file contains all of the PL/SQL from the 144  *
* Study Guide.  It is ###NOT### a script to be run   *
* as a single entity.  Most of the PL/SQL is in the  *
* form of anonymous blocks, so running them as a     *
* script won't do anything useful.  I created this   *
* file at the request of a user so that he could get *
* some more experience playing with the code and     *
* associated tables.  If you have not purchased the  *
* Oracle Certification Prep study guide then this    *
* file will be of limited use to you.  You are       *
* welcome to it, but the code means little outside   *
* the context of the book.
**************************************************** */

-- **** Identify the different types of PL/SQL blocks

DECLARE
  v_temp    NUMBER;
BEGIN
  v_temp := 1;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('This block will never create an exception');
    DBMS_OUTPUT.PUT_LINE('But if one occurred, this would trap it.');
END;


-- **** Output messages in PL/SQL

SET SERVEROUTPUT ON

DECLARE
  v_index   NUMBER;
BEGIN
  v_index := 1;
  DBMS_OUTPUT.PUT_LINE('Starting the loop');
  DBMS_OUTPUT.NEW_LINE;

  WHILE v_index < 6 LOOP
    DBMS_OUTPUT.PUT_LINE('v_index: ' || v_index);
    v_index := v_index + 1;
  END LOOP;

  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('Loop ended');
END;


-- **** Declaring PL/SQL Variables

DECLARE
  v_serial     NUMBER;        -- SQL data type
  v_part_name  VARCHAR2(20);  -- SQL data type
  v_in_stock   BOOLEAN;       -- PL/SQL-only data type
  v_price      NUMBER(6,2);   -- SQL data type
  v_part_desc  VARCHAR2(50);  -- SQL data type
  v_count      PLS_INTEGER  NOT NULL  := 0;   -- PL/SQL-only data type
BEGIN
  NULL;
END;
/


DECLARE
  v_limit    CONSTANT NUMBER  := 1000; -- SQL data type
  v_port     CONSTANT INTEGER := 1541; -- SQL data type
  v_open     CONSTANT BOOLEAN := TRUE; -- PL/SQL-only data type
BEGIN
  NULL;
END;
/

DECLARE
  v_reg_pay  NUMBER          := 37.50;
  v_ot_mod   CONSTANT NUMBER := 1.5;
  v_ot_pay   NUMBER          := v_reg_pay * v_ot_mod;
BEGIN
  NULL;
END;
/


-- **** Use bind variables

VARIABLE bv_return_val  VARCHAR2(20)
VARIABLE bv_return_code NUMBER

BEGIN
  SELECT emp_job 
  INTO   :bv_return_val
  FROM   employees
  WHERE  emp_id=18;

  :bv_return_code := 0;
EXCEPTION
  WHEN OTHERS THEN
    :bv_return_code := 1;
END;



-- **** List and describe various data types using the %TYPE attribute

DECLARE
  v_last_name  employees.emp_last%TYPE;
BEGIN
  SELECT emp_last
  INTO   v_last_name
  FROM   employees
  WHERE  emp_id = 9;    

  DBMS_OUTPUT.PUT_LINE('v_last_name = ' || v_last_name);
END;


DECLARE
  v_salary       NUMBER(6,2);
  v_commission   v_salary%TYPE;
  v_bonus        v_salary%TYPE;
BEGIN
  NULL;
END;

 
-- **** Comments

/* *********************************
   ****   Sample PL/SQL block   ****
   ****   showing comment use   ****
   ********************************* */
DECLARE
  v_count      NUMBER;
  v_total      NUMBER;
BEGIN
  -- Begin processing
  SELECT COUNT(*) 
  INTO   v_count
  FROM   employees
  WHERE  job_id = 'IT_PROG';   -- Find # of programmers

  v_total := v_count; 
END;
/


-- **** Whitespace Characters between Lexical Units

DECLARE
  x NUMBER := 10;
  y NUMBER := 5;
  z NUMBER;
BEGIN
  -- valid code but hard to read
  IF x>y THEN z:=x;ELSE z:=y;END IF; 

  -- Equivalent and easier to read:
  IF x > y THEN
    z := x;
  ELSE
    z := y;
  END IF;
END;
/


-- **** Use built-in SQL functions in PL/SQL and sequences in PL/SQL expressions

DECLARE
  v_chardate    VARCHAR2(20);
  v_datelength  NUMBER;
  v_mon         VARCHAR2(5);
BEGIN
  v_chardate   := TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS');
  v_datelength := LENGTH(v_chardate);
  v_mon        := SUBSTR(v_chardate, 4, 3);

  DBMS_OUTPUT.PUT_LINE('v_chardate:   ' || v_chardate);
  DBMS_OUTPUT.PUT_LINE('v_datelength: ' || v_datelength);
  DBMS_OUTPUT.PUT_LINE('v_mon:        ' || v_mon);

END;
/



-- **** Sequences in PL/SQL Expressions

CREATE SEQUENCE seq_ocp_temp;

DECLARE
  v_seqval   NUMBER;
BEGIN
  v_seqval := seq_ocp_temp.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('v_seqval: ' || v_seqval);

  v_seqval := seq_ocp_temp.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('v_seqval: ' || v_seqval);

  v_seqval := seq_ocp_temp.CURRVAL;
  DBMS_OUTPUT.PUT_LINE('v_seqval: ' || v_seqval);
END;
/



-- **** Implicit Data Conversion

DECLARE
  v_pls_integer     PLS_INTEGER  := 15;
  v_number          NUMBER       := 10;
  v_char_num        VARCHAR2(10) := '20';
  v_char_date       VARCHAR2(10) := '03-JAN-06';
  v_num_result      NUMBER;
  v_char_result     VARCHAR2(20);
BEGIN
  -- ** A PLS_INTEGER and a NUMBER have different internal representations,
  -- ** an implicit conversion is required for the following arithmetic:
  v_num_result := v_pls_integer + v_number;

  -- ** The result then gets converted into character data for the below:
  DBMS_OUTPUT.PUT_LINE('v_pls_integer + v_number is: ' || v_num_result);


  -- ** The VARCHAR2 value must be converted to NUMBER for this calculation:
  v_num_result := v_char_num + v_number;

  -- ** The result then gets converted into character data for the below:
  DBMS_OUTPUT.PUT_LINE('v_char_num + v_number is: ' || v_num_result);


  -- ** The VARCHAR2 value must be converted to a DATE to perform this query:
  SELECT last_name
  INTO   v_char_result
  FROM   hr.employees
  WHERE  hire_date = v_char_date;

  DBMS_OUTPUT.PUT_LINE('v_char_result is: ' || v_char_result);
END;


-- **** Explicit Data Conversion

DECLARE
  v_char_num        VARCHAR2(10) := '$2,436.34';
  v_char_date       VARCHAR2(20) := 'June 06, 2012';
  v_num_result      NUMBER;
  v_date_result     DATE;
BEGIN
  -- ** This implicit conversion will fail
  BEGIN
    v_num_result := v_char_num;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Implicit:  ' || SQLERRM);
  END;

  -- This explicit conversion will succeed
  v_num_result := TO_NUMBER(v_char_num, 'FML999G999G999G999G990D00');  
  DBMS_OUTPUT.PUT_LINE('Explicit:  v_num_result is: ' || v_num_result);

  DBMS_OUTPUT.PUT_LINE('============================================');

  -- ** This implicit conversion will fail
  BEGIN
    v_date_result := v_char_date;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Implicit:  ' || SQLERRM);
  END;

  -- This explicit conversion will succeed
  v_date_result := TO_DATE(v_char_date, 'Month, DD, YYYY');  
  DBMS_OUTPUT.PUT_LINE('Explicit:  v_date_result is: ' || v_date_result);
END;



-- ** Nested blocks

DECLARE
  -- Declare nsp1 (forward declaration):
  PROCEDURE nsp1(p_input  VARCHAR2);

  -- Declare and define nsp2:
  PROCEDURE nsp2(p_input  VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Printing from nsp2:');
    DBMS_OUTPUT.PUT_LINE('----- ' || p_input);
    nsp1('Calling nsp1 from nsp2');
  END;

  -- Define nsp 1:
  PROCEDURE nsp1(p_input VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Printing from nsp1:');
    DBMS_OUTPUT.PUT_LINE('----- ' || p_input);
  END;

BEGIN
  nsp2('Calling nsp2 from main block');
END;

Printing from nsp2:
----- Calling nsp2 from main block
Printing from nsp1:
----- Calling nsp1 from nsp2


-- **** Qualifying variables with labels

-- Outer block:
DECLARE
  v_a VARCHAR2(1) := 'A';
  v_b VARCHAR2(1) := 'B';
BEGIN
  DECLARE
    v_a VARCHAR2(1) := 'a';
    v_c VARCHAR2(1) := 'c';
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner Block 1, variable v_a: ' || v_a);
    DBMS_OUTPUT.PUT_LINE('Inner Block 1, variable v_b: ' || v_b);
    DBMS_OUTPUT.PUT_LINE('Inner Block 1, variable v_c: ' || v_c);
  END;

  DECLARE
    v_d VARCHAR2(1) := 'd';
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner Block 2, variable v_a: ' || v_a);
    DBMS_OUTPUT.PUT_LINE('Inner Block 2, variable v_b: ' || v_b);
    DBMS_OUTPUT.PUT_LINE('Inner Block 2, variable v_d: ' || v_d);
  END;
END;
/



<<outer>>
DECLARE
  v_a VARCHAR2(1) := 'A';
BEGIN
  DECLARE
    v_a VARCHAR2(1) := 'a';
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner Block, variable v_a: ' || v_a);
    DBMS_OUTPUT.PUT_LINE('Inner Block, global variable outer.v_a: ' || outer.v_a);
  END;
END;



-- **** Indentation

DECLARE
  v_ndx1    NUMBER   := 1;
  v_ndx2    NUMBER   := 1;
  v_ndx3    NUMBER   := 5;
BEGIN
  WHILE v_ndx1 < 10 LOOP
    IF v_ndx2 > 5 THEN
      FOR v_Lp IN 1..v_ndx3 LOOP
        NULL;
      END LOOP;
    ELSE
      v_ndx2 := v_ndx2 + 1;
    END IF;
    v_ndx1 := v_ndx1 + 1;
  END LOOP;
END;

DECLARE
v_ndx1    NUMBER   := 1;
v_ndx2    NUMBER   := 1;
v_ndx3    NUMBER   := 5;
BEGIN
WHILE v_ndx1 < 10 LOOP
IF v_ndx2 > 5 THEN
FOR v_Lp IN 1..v_ndx3 LOOP
NULL;
END LOOP;
ELSE
v_ndx2 := v_ndx2 + 1;
END IF;
v_ndx1 := v_ndx1 + 1;
END LOOP;
END;


DECLARE
  v_apt_name   VARCHAR2(20);
  v_apt_abbr   VARCHAR2(5);
BEGIN
  SELECT apt_name, apt_abbr
  INTO   v_apt_name, v_apt_abbr
  FROM   airports apt
         INNER JOIN aircraft_fleet afl
         ON apt.apt_id = afl.apt_id
         INNER JOIN aircraft_types act
         ON act.act_id = afl.act_id
  WHERE  afl_id IN (SELECT afl_id 
                    FROM   employees
                    WHERE  emp_last IN ('Picard', 'McCoy', 'Aptop')
                   );
END;


DECLARE
v_apt_name VARCHAR2(20);
v_apt_abbr VARCHAR2(5);
BEGIN
SELECT apt_name, apt_abbr
INTO v_apt_name, v_apt_abbr
FROM airports apt
INNER JOIN aircraft_fleet afl
ON apt.apt_id = afl.apt_id
INNER JOIN aircraft_types act
ON act.act_id = afl.act_id
WHERE  afl_id IN 
(SELECT afl_id FROM employees
WHERE  emp_last IN ('Picard', 'McCoy', 'Aptop'));
END;

 

--  **** Interacting with the Oracle Database Server

-- UPDATE statement
DECLARE
  v_empid    NUMBER   := 105;
BEGIN
  UPDATE hr.employees
  SET    salary = 5000
  WHERE  employee_id = v_empid;
  COMMIT;
END;

-- DELETE statement
DECLARE
  v_empid    NUMBER   := 105;
BEGIN
  DELETE FROM hr.employees
  WHERE  employee_id = v_empid;
  ROLLBACK;
END;

-- INSERT statement
BEGIN
  INSERT INTO hr.departments
  VALUES (280, 'Complaints', NULL, 1700);
  COMMIT;
END;


-- **** Make use of the INTO clause to hold the values returned by a SQL statement

DECLARE
  v_bonus NUMBER;
BEGIN
  SELECT salary * 0.05 
  INTO   v_bonus
  FROM   hr.employees
  WHERE employee_id = 104;

  DBMS_OUTPUT.PUT_LINE('v_bonus :' || v_bonus);
END;


DECLARE
  v_max_sal NUMBER;
BEGIN
  SELECT MAX(salary) 
  INTO   v_max_sal
  FROM   hr.employees;

  DBMS_OUTPUT.PUT_LINE('v_max_sal :' || v_max_sal);
END;


DECLARE
  TYPE EmpRec IS RECORD (
    v_first  hr.employees.first_name%TYPE,
    v_last   hr.employees.last_name%TYPE,
    v_id     hr.employees.employee_id%TYPE);
  r_emprec EmpRec;
BEGIN
  SELECT first_name, last_name, employee_id 
  INTO   r_emprec
  FROM   hr.employees
  WHERE  employee_id = 122;
  
  DBMS_OUTPUT.PUT_LINE ('Employee #' || r_emprec.v_id || 
                               ' = ' || r_emprec.v_first ||
                                 ' ' || r_emprec.v_last);
END;

 
-- **** Writing Control Structures

DECLARE
  v_value    NUMBER  := 5;
BEGIN
  IF v_value < 6 THEN
    DBMS_OUTPUT.PUT_LINE('v_value is less than 6');
  END IF;
END;


DECLARE
  v_value    NUMBER  := 5;
BEGIN
  IF v_value < 6 THEN
    DBMS_OUTPUT.PUT_LINE('v_value is less than 6');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_value is >= 6');
  END IF;
END;


DECLARE
  v_value    NUMBER  := 5;
BEGIN
  IF v_value > 2 AND
     v_value < 4 THEN
    DBMS_OUTPUT.PUT_LINE('v_value is between 2 and 4');
  ELSIF v_value >= 4 AND
     v_value < 6 THEN
    DBMS_OUTPUT.PUT_LINE('v_value is between 4 and 6');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_value is >= 6');
  END IF;
END;


-- **** CASE statements

DECLARE
  v_value    NUMBER  := 5;
BEGIN
  CASE v_value
    WHEN 4 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 4');
    WHEN 5 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 5');
    WHEN 6 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 6');
  END CASE;
END;


DECLARE
  v_value    NUMBER  := 2;
BEGIN
  CASE v_value
    WHEN 4 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 4');
    WHEN 5 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 5');
    WHEN 6 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 6');
  END CASE;
END;



-- **** Searched CASE

DECLARE
  v_value    NUMBER  := 5;
BEGIN
  CASE 
    WHEN v_value = 4 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 4');
    WHEN v_value = 5 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 5');
    WHEN v_value =6 THEN
      DBMS_OUTPUT.PUT_LINE('v_value = 6');
  END CASE;
END;


-- **** Expressions

DECLARE
  v_numrslt    NUMBER;
  v_charrslt   VARCHAR2(10);
BEGIN
  v_numrslt := 3**2;
  DBMS_OUTPUT.PUT_LINE('3**2 = ' || v_numrslt);
  v_numrslt := -2 + 1;
  DBMS_OUTPUT.PUT_LINE('-2 + 1 = ' || v_numrslt);
  v_charrslt := 4 || 5;
  DBMS_OUTPUT.PUT_LINE('4 || 5 = ' || v_charrslt);
  v_numrslt := 2 + 1 / 3;
  DBMS_OUTPUT.PUT_LINE('2 + 1 / 3 = ' || v_numrslt);
  v_numrslt := (2 + 1) / 3;
  DBMS_OUTPUT.PUT_LINE('(2 + 1) / 3 = ' || v_numrslt);
END;


-- **** Construct and identify loop statements

DECLARE
  v_ndx   NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Inside loop: v_ndx = ' || TO_CHAR(v_ndx));
    v_ndx := v_ndx + 1;

    IF v_ndx > 3 THEN
      EXIT;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' Outside loop: v_ndx = ' || TO_CHAR(v_ndx));
END;


DECLARE
  v_ndx   NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Inside loop: v_ndx = ' || TO_CHAR(v_ndx));
    v_ndx := v_ndx + 1;

    EXIT WHEN v_ndx > 3;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' Outside loop: v_ndx = ' || TO_CHAR(v_ndx));
END;


DECLARE
 v_ndxo    PLS_INTEGER := 0;
 v_ndxi    PLS_INTEGER;
BEGIN
  <<outer_loop>>
  LOOP
    v_ndxi := 1;
    v_ndxo := v_ndxo + 1;
    <<inner_loop>>
    LOOP
      CONTINUE outer_loop WHEN (MOD(v_ndxo, 2) = 0);
      DBMS_OUTPUT.PUT_LINE('v_ndxo: ' || TO_CHAR(v_ndxo) || 
                 '  ---  v_ndxi: ' || TO_CHAR(v_ndxi));
      v_ndxi := v_ndxi + 1;
      EXIT inner_loop WHEN v_ndxi > 2;

    END LOOP inner_loop;
    EXIT WHEN v_ndxo > 6;
  END LOOP outer_loop;
END;


BEGIN
  DBMS_OUTPUT.PUT_LINE ('lower_bound < upper_bound');
  FOR v_Lp IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (v_lp);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('---------------------------');

  DBMS_OUTPUT.PUT_LINE ('lower_bound = upper_bound');
  FOR v_Lp IN 2..2 LOOP
    DBMS_OUTPUT.PUT_LINE (v_Lp);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('---------------------------');

  DBMS_OUTPUT.PUT_LINE ('lower_bound > upper_bound');
  FOR v_Lp IN 3..1 LOOP
    DBMS_OUTPUT.PUT_LINE (v_Lp);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('---------------------------');

  DBMS_OUTPUT.PUT_LINE ('lower_bound < upper_bound REVERSE');
  FOR i IN REVERSE 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (i);
  END LOOP;

END;


DECLARE
  v_assigned    BOOLEAN := FALSE;
BEGIN
  WHILE v_assigned LOOP
    DBMS_OUTPUT.PUT_LINE ('The assignment has been made.');
  END LOOP;

  WHILE NOT v_assigned LOOP
    DBMS_OUTPUT.PUT_LINE ('Unassigned.  Assigning now.');
    v_assigned := TRUE;
  END LOOP;
END;
/


DECLARE
  v_var1   NUMBER   := 1;  
  v_var2   NUMBER   := 2;
  v_bool   BOOLEAN;
BEGIN

  IF v_var1 > v_var2 THEN
    v_bool := TRUE;
  ELSE
    v_bool := FALSE;
  END IF;    

  IF v_bool = TRUE THEN
    NULL;
  END IF;
END;


DECLARE
  v_var1   NUMBER   := 1;  
  v_var2   NUMBER   := 2;
  v_bool   BOOLEAN;
BEGIN
  v_bool := v_var1 > v_var2;

  IF v_bool THEN
    NULL;
  END IF;
END;


DECLARE
  v_test    NUMBER    := 5;
BEGIN
  IF v_test = 1 THEN
    NULL;
  ELSIF v_test = 2 THEN
    NULL;
  ELSIF v_test = 3 THEN
    NULL;
  ELSIF v_test = 4 THEN
    NULL;
  ELSIF v_test = 5 THEN
    NULL;
  ELSIF v_test = 6 THEN
    NULL;
  END IF;
END;


DECLARE
  v_test    NUMBER    := 5;
BEGIN
  CASE v_test
    WHEN 1 THEN
      NULL;
    WHEN 2 THEN
      NULL;
    WHEN 3 THEN
      NULL;
    WHEN 4 THEN
      NULL;
    WHEN 5 THEN
      NULL;
    WHEN 6 THEN
      NULL;
  END CASE;
END;
 

-- **** Working with Composite Data Types

DECLARE
  TYPE r_emprectyp IS RECORD (
             emp_id    NUMBER,
             emp_first VARCHAR2(30),
             emp_last  VARCHAR2(30) 
            );

  r_emp_rec1    r_emprectyp;
  r_emp_rec2    r_emp_rec1%TYPE;
BEGIN
  r_emp_rec1.emp_id      := 103;
  r_emp_rec1.emp_first   := 'John';
  r_emp_rec1.emp_last    := 'Jones';

  r_emp_rec2.emp_id      := 104;
  r_emp_rec2.emp_first   := 'Fred';
  r_emp_rec2.emp_last    := 'Rogers';


  DBMS_OUTPUT.PUT_LINE('Employee Record 1:');
  DBMS_OUTPUT.PUT_LINE('------------------');
  DBMS_OUTPUT.PUT_LINE('emp_id:    ' || r_emp_rec1.emp_id);
  DBMS_OUTPUT.PUT_LINE('emp_first: ' || r_emp_rec1.emp_first);
  DBMS_OUTPUT.PUT_LINE('emp_last:  ' || r_emp_rec1.emp_last);
  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Employee Record 2:');
  DBMS_OUTPUT.PUT_LINE('------------------');
  DBMS_OUTPUT.PUT_LINE('emp_id:    ' || r_emp_rec2.emp_id);
  DBMS_OUTPUT.PUT_LINE('emp_first: ' || r_emp_rec2.emp_first);
  DBMS_OUTPUT.PUT_LINE('emp_last:  ' || r_emp_rec2.emp_last);

END;



-- **** Create a record with the %ROWTYPE attribute

DECLARE
  r_ctry_rec hr.countries%ROWTYPE;
BEGIN
  -- Assign values to fields:
  r_ctry_rec.country_id := 'US';
  r_ctry_rec.country_name := 'United States';
  r_ctry_rec.region_id := 2;

  -- Print fields:
  DBMS_OUTPUT.PUT_LINE('country_id:   ' || r_ctry_rec.country_id);
  DBMS_OUTPUT.PUT_LINE('country_name: ' || r_ctry_rec.country_name);
  DBMS_OUTPUT.PUT_LINE('region_id:    ' || r_ctry_rec.region_id);
END;


DECLARE
  CURSOR c_emp IS
    SELECT first_name, last_name, job_id
    FROM   hr.employees;

  r_emp_jobs c_emp%ROWTYPE;
BEGIN
  r_emp_jobs.first_name := 'Fred';
  r_emp_jobs.last_name  := 'Rogers';
  r_emp_jobs.job_id     := 'IT_PROG';

  DBMS_OUTPUT.PUT_LINE (r_emp_jobs.first_name);
  DBMS_OUTPUT.PUT_LINE (r_emp_jobs.last_name);
  DBMS_OUTPUT.PUT_LINE (r_emp_jobs.job_id);
END;


-- **** Create an INDEX BY table and INDEX BY table of records

DECLARE
  TYPE t_region IS TABLE OF VARCHAR2(20)
    INDEX BY PLS_INTEGER;

  t_reg_tab  t_region;
BEGIN
  t_reg_tab(1) := 'Southwest';
  t_reg_tab(2) := 'Northwest';
  t_reg_tab(3) := 'Southeast';
  t_reg_tab(4) := 'Northeast';

  FOR v_Lp IN 1..4 LOOP
    DBMS_OUTPUT.PUT_LINE('t_reg_tab(' || v_Lp || ') is: ' ||
          t_reg_tab(v_Lp));
  END LOOP;
END;


DECLARE
  TYPE r_emprectyp IS RECORD (
             emp_id    NUMBER,
             emp_first VARCHAR2(30),
             emp_last  VARCHAR2(30) 
            );

  r_emp_rec    r_emprectyp;

  TYPE t_emps IS TABLE OF r_emprectyp
  INDEX BY PLS_INTEGER;
  t_emp_tab    t_emps;
BEGIN
  r_emp_rec.emp_id      := 103;
  r_emp_rec.emp_first   := 'John';
  r_emp_rec.emp_last    := 'Jones';
  t_emp_tab(1)          := r_emp_rec;

  r_emp_rec.emp_id      := 104;
  r_emp_rec.emp_first   := 'Fred';
  r_emp_rec.emp_last    := 'Rogers';
  t_emp_tab(2)          := r_emp_rec;

  FOR v_Lp IN 1..2 LOOP
    DBMS_OUTPUT.PUT_LINE('Employee Record ' || v_Lp || ':');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('emp_id:    ' || t_emp_tab(v_Lp).emp_id);
    DBMS_OUTPUT.PUT_LINE('emp_first: ' || t_emp_tab(v_Lp).emp_first);
    DBMS_OUTPUT.PUT_LINE('emp_last:  ' || t_emp_tab(v_Lp).emp_last);
    DBMS_OUTPUT.PUT_LINE(' ');
  END LOOP;
END;


-- **** Use SQL cursor attributes

BEGIN
  UPDATE hr.employees
  SET    salary = salary * 1.1
  WHERE  job_id = 'IT_PROG';

  IF SQL%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Implicit cursor is open');
  END IF;
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Implicit cursor affected one or more rows');
  END IF;
  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('Implicit cursor affected no rows');
  END IF;
  DBMS_OUTPUT.PUT_LINE('SQL%ROWCOUNT: ' || SQL%ROWCOUNT);
  ROLLBACK;
END;


DECLARE
  CURSOR c_itp IS
    SELECT first_name, last_name
    FROM   hr.employees
    WHERE  job_id = 'IT_PROG'
    AND    salary = 4800;
BEGIN
  IF c_itp%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Explicit cursor is open before loop');
  END IF;
  
  FOR v_Lp IN c_itp LOOP
    IF c_itp%ISOPEN THEN
      DBMS_OUTPUT.PUT_LINE('Explicit cursor is open in loop');
    END IF;

    IF c_itp%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Explicit cursor affected one or more rows');
    END IF;

    IF c_itp%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('Explicit cursor affected no rows');
    END IF;

    DBMS_OUTPUT.PUT_LINE('c_itp%ROWCOUNT: ' || c_itp%ROWCOUNT);
  END LOOP;

  IF c_itp%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Explicit cursor is open after loop');
  END IF;
END;


-- **** Declare and control explicit cursors

DECLARE
  CURSOR c_emps IS
    SELECT first_name, last_name, salary 
    FROM   hr.employees
    WHERE  job_id = 'IT_PROG'
    ORDER BY last_name;

  v_firstname   hr.employees.first_name%TYPE;
  v_lastname    hr.employees.last_name%TYPE;
  v_salary      hr.employees.salary%TYPE;

BEGIN
  OPEN c_emps;
  LOOP
    FETCH c_emps 
    INTO  v_firstname, v_lastname, v_salary;
    EXIT WHEN c_emps%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE( v_lastname || ', ' || v_firstname || 
                          ' makes ' || v_salary );
  END LOOP;
  CLOSE c_emps;
END;



-- **** Use simple loops and cursor FOR loops to fetch data

DECLARE
  CURSOR c_depts IS
    SELECT * 
    FROM   hr.departments
    WHERE  manager_id > 200;

  v_depts  hr.departments%ROWTYPE;
BEGIN
  OPEN c_depts;
    LOOP
    FETCH c_depts 
    INTO  v_depts;
    EXIT WHEN c_depts%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE( v_depts.department_name || 
                          ' is at location ' ||
                          v_depts.location_id);
  END LOOP;
  CLOSE c_depts;
END;


DECLARE
  CURSOR c_depts IS
    SELECT * 
    FROM   hr.departments
    WHERE  manager_id > 200;

BEGIN
  FOR v_Lp IN c_depts LOOP
    DBMS_OUTPUT.PUT_LINE( v_Lp.department_name || 
                          ' is at location ' ||
                          v_Lp.location_id);
  END LOOP;
END;


-- **** Declare and use cursors with parameters

DECLARE
  CURSOR c_emps (p_job  VARCHAR2, p_years   NUMBER) IS
    SELECT *
    FROM   hr.employees
    WHERE  job_id = p_job
    AND    MONTHS_BETWEEN(SYSDATE, hire_date) > (p_years * 12);

  v_emps  hr.employees%ROWTYPE;
BEGIN
  OPEN c_emps('IT_PROG', 6);
    LOOP
    FETCH c_emps 
    INTO  v_emps;
    EXIT WHEN c_emps%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE( v_emps.first_name || ' ' || 
                          v_emps.last_name ||
                          ' was hired on ' || 
                          TO_CHAR(v_emps.hire_date, 'DD-MON-YY'));
  END LOOP;
  CLOSE c_emps;
  
  DBMS_OUTPUT.PUT_LINE('======================================');

  OPEN c_emps('FI_ACCOUNT', 5);
    LOOP
    FETCH c_emps 
    INTO  v_emps;
    EXIT WHEN c_emps%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE( v_emps.first_name || ' ' || v_emps.last_name ||
                          ' was hired on ' || 
                          TO_CHAR(v_emps.hire_date, 'DD-MON-YY'));
  END LOOP;
  CLOSE c_emps;
  
END;


-- **** Lock rows with the FOR UPDATE clause
DECLARE
  v_emp_id   hr.employees.employee_id%TYPE;
  v_job_id   hr.employees.job_id%TYPE;
  v_salary   hr.employees.salary%TYPE;

  CURSOR c_empsal IS
    SELECT employee_id, job_id, salary
    FROM   hr.employees FOR UPDATE;

BEGIN
  OPEN c_empsal;
  LOOP
    FETCH c_empsal 
    INTO  v_emp_id, v_job_id, v_salary;

    IF v_job_id = 'IT_PROG' THEN
      UPDATE hr.employees
      SET    salary = salary * 1.05
      WHERE  employee_id = v_emp_id;
    END IF;
    EXIT WHEN c_empsal%NOTFOUND;
  END LOOP;
  CLOSE c_empsal;
END;


-- **** Reference the current row with the WHERE CURRENT OF clause

DECLARE
  v_job_id   hr.employees.job_id%TYPE;
  v_salary   hr.employees.salary%TYPE;

  CURSOR c_empsal IS
    SELECT job_id, salary
    FROM   hr.employees FOR UPDATE;

BEGIN
  OPEN c_empsal;
  LOOP
    FETCH c_empsal 
    INTO  v_job_id, v_salary;

    IF v_job_id = 'IT_PROG' THEN
      UPDATE hr.employees
      SET    salary = salary * 1.05
      WHERE  CURRENT OF c_empsal;
    END IF;
    EXIT WHEN c_empsal%NOTFOUND;
  END LOOP;
  CLOSE c_empsal;
END;

 
-- **** Recognize unhandled exceptions

DECLARE
  v_empid   NUMBER;
BEGIN
  SELECT employee_id
  INTO   v_empid
  FROM   hr.employees;
END;

Error report:
ORA-01422: exact fetch returns more than requested number of rows
ORA-06512: at line 4
01422. 00000 -  "exact fetch returns more than requested number of rows"
*Cause:    The number specified in exact fetch is less than the rows returned.
*Action:   Rewrite the query or change number of rows requested


-- **** Handle different types of exceptions

DECLARE
  v_empid   NUMBER;
BEGIN
  SELECT employee_id
  INTO   v_empid
  FROM   hr.employees;
  
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows returned by query');
END;


DECLARE
  x_snapshot_too_old    EXCEPTION;
  PRAGMA EXCEPTION_INIT(x_snapshot_too_old, -1555);
BEGIN
...
EXCEPTION
  WHEN x_snapshot_too_old THEN
...
END;


DECLARE
  v_empid   NUMBER;
BEGIN
  SELECT employee_id
  INTO   v_empid
  FROM   hr.employees;
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
END;


CREATE OR REPLACE PROCEDURE submit_timesheet (p_ts_date DATE)
IS
  x_weekend_date EXCEPTION;
BEGIN
  IF TO_CHAR(p_ts_date, 'DY') IN ('SAT', 'SUN') THEN
    RAISE x_weekend_date;
  END IF;

EXCEPTION
  WHEN x_weekend_date THEN
    DBMS_OUTPUT.PUT_LINE ('Cannot submit timesheet for weekend dates.');
END;

BEGIN
  submit_timesheet ('17-JUN-12');
END;



-- **** Propagate exceptions in nested blocks and call applications

BEGIN
  DBMS_OUTPUT.PUT_LINE('Starting Block 1');
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting Block 2');
    DECLARE
      v_empid   NUMBER;
    BEGIN
      SELECT employee_id
      INTO   v_empid
      FROM   hr.employees;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Too Many Rows');
    END;
    DBMS_OUTPUT.PUT_LINE('Ending Block 2');
  END;
  DBMS_OUTPUT.PUT_LINE('Ending Block 1');
END;


BEGIN
  DBMS_OUTPUT.PUT_LINE('Starting Block 1');
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting Block 2');
    DECLARE
      v_empid   NUMBER;
    BEGIN
      SELECT employee_id
      INTO   v_empid
      FROM   hr.employees;
    END;
    DBMS_OUTPUT.PUT_LINE('Ending Block 2');
  END;
  DBMS_OUTPUT.PUT_LINE('Ending Block 1');
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
  DBMS_OUTPUT.PUT_LINE('Too Many Rows');
END;


BEGIN
  DBMS_OUTPUT.PUT_LINE('Starting Block 1');
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting Block 2');
    DECLARE
      v_empid   NUMBER;
    BEGIN
      SELECT employee_id
      INTO   v_empid
      FROM   hr.employees;
    END;
    DBMS_OUTPUT.PUT_LINE('Ending Block 2');
  END;
  DBMS_OUTPUT.PUT_LINE('Ending Block 1');
END;


-- **** RAISE_APPLICATION_ERROR

CREATE OR REPLACE PROCEDURE submit_timesheet (p_ts_date DATE)
IS
BEGIN
  IF TO_CHAR(p_ts_date, 'DY') IN ('SAT', 'SUN') THEN
    RAISE_APPLICATION_ERROR(-20020, 'Cannot submit timesheet for weekend dates.');
  END IF;
END;

DECLARE
  x_weekend_date   EXCEPTION;
  PRAGMA EXCEPTION_INIT (x_weekend_date, -20020);
BEGIN
  submit_timesheet ('17-JUN-12');
EXCEPTION
  WHEN x_weekend_date THEN
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLERRM(-20020)));
END;


 

-- **** Create a simple procedure and invoke it from an anonymous block

CREATE PROCEDURE simple_procedure
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('I am but a simple procedure');
END;

<<anonymous>>
BEGIN
  simple_procedure;
END;



-- **** Work with procedures

CREATE OR REPLACE PROCEDURE age_in_dog_years(p_birthdate  DATE)
IS
  v_dog_years    NUMBER;
BEGIN
  v_dog_years := TRUNC((SYSDATE - p_birthdate) / (365 / 7), 1);
  DBMS_OUTPUT.PUT_LINE('You are ' || v_dog_years || 
                       ' dog years old.  Happy birthday');
END;

BEGIN
  age_in_dog_years('13-APR-1974');
END;

BEGIN
  age_in_dog_years(p_birthdate => '13-APR-1974');
END;

EXECUTE age_in_dog_years('13-APR-1974');

DROP PROCEDURE age_in_dog_years;



-- **** Work with functions

CREATE FUNCTION age_in_dog_years(p_birthdate  DATE)
RETURN NUMBER
IS
  v_retval    NUMBER;
BEGIN
  v_retval := TRUNC((SYSDATE - p_birthdate) / (365 / 7), 1);
  RETURN v_retval;
END;


DECLARE
  v_dog_years    NUMBER;
BEGIN
  v_dog_years := age_in_dog_years('13-APR-1974');

  DBMS_OUTPUT.PUT_LINE('You are ' || v_dog_years || 
                       ' dog years old.  Happy birthday');
END;

DROP FUNCTION age_in_dog_years;

 

-- **** Create a package specification and body

CREATE PACKAGE age_calc
AS
  g_human        NUMBER;
  FUNCTION years(p_birthdate  DATE,
                 p_species    VARCHAR2)
  RETURN NUMBER;

  PROCEDURE set_lifespan(p_species    VARCHAR2);

END age_calc;


CREATE PACKAGE BODY age_calc
AS
  l_human    CONSTANT NUMBER    := 70;
  l_animal   NUMBER;

  FUNCTION years(p_birthdate  DATE,
                 p_species    VARCHAR2)
  RETURN NUMBER
  IS
    v_retval   NUMBER;
  BEGIN
    set_lifespan(p_species);
    v_retval := TRUNC((SYSDATE - p_birthdate) / 
                      (365 / (NVL(g_human, l_human) / l_animal)), 1);
    RETURN v_retval;

  END years;


  PROCEDURE set_lifespan(p_species    VARCHAR2)
  IS
  BEGIN
    CASE p_species
      WHEN 'Galapagos tortoise' THEN
        l_animal := 200;
      WHEN 'Carp' THEN
        l_animal := 100;
      WHEN 'Gray Whale' THEN
        l_animal := 70;
      WHEN 'Alligator' THEN
        l_animal := 50;
      WHEN 'Elephant' THEN
        l_animal := 35;
      WHEN 'Dolphin' THEN
        l_animal := 30;
      WHEN 'Snake' THEN
        l_animal := 20;
      WHEN 'Black Bear' THEN
        l_animal := 18;
      WHEN 'Tiger' THEN
        l_animal := 16;
      ELSE
        l_animal := l_human;
    END CASE;
  END set_lifespan;

END age_calc;


-- **** Invoke package subprograms

DECLARE
  v_years    NUMBER;
  v_animal   VARCHAR2(20) := 'Alligator';
BEGIN
  v_years := age_calc.years('13-APR-1974', v_animal);

  DBMS_OUTPUT.PUT_LINE('You are ' || v_years || 
                       ' ' || v_animal || ' years old.  Happy birthday');
END;


DECLARE
  v_years    NUMBER;
  v_animal   VARCHAR2(20) := 'Alligator';
BEGIN
  age_calc.g_human = 80;
  v_years := age_calc.years('13-APR-1974', v_animal);

  DBMS_OUTPUT.PUT_LINE('You are ' || v_years || 
                       ' ' || v_animal || ' years old.  Happy birthday');
END;


DROP PACKAGE BODY age_calc;
DROP PACKAGE age_calc;

 
-- **** Overload package subprograms

CREATE PACKAGE oca
AS
  PROCEDURE difference (p_firstval   DATE,
                        p_secondval  DATE);

  PROCEDURE difference (p_firstval   NUMBER,
                        p_secondval  NUMBER);

  PROCEDURE calc;

END oca;


create or replace
PACKAGE BODY oca
AS

  PROCEDURE difference (p_firstval   DATE,
                        p_secondval  DATE)
  IS
    v_retval    NUMBER;
  BEGIN
    v_retval := p_firstval - p_secondval;
    DBMS_OUTPUT.PUT_LINE('The date difference is: ' || 
                         v_retval || ' days');
  END difference;

  PROCEDURE difference (p_firstval   NUMBER,
                        p_secondval  NUMBER)
  IS
    v_retval    NUMBER;
  BEGIN
    v_retval := p_firstval - p_secondval;
    DBMS_OUTPUT.PUT_LINE('The numeric difference is: ' || v_retval);
  END difference;

  PROCEDURE calc
  IS
    v_date1   DATE;
    v_date2   DATE;

  BEGIN
    v_date1 := TO_DATE('21-JUN-12', 'DD-MON-YY');
    v_date2 := TO_DATE('21-MAY-12', 'DD-MON-YY');

    difference(v_date1, v_date2);
    difference(5, 3);
  END calc;
END oca;


BEGIN
  oca.calc;
END;


-- **** Use forward declarations

DECLARE
  v_verse   NUMBER   := 1;

  PROCEDURE tweedledum(p_param1    NUMBER);

  PROCEDURE tweedledee(p_param2    NUMBER) 
  IS
  BEGIN
    CASE v_verse
      WHEN 2 THEN
        DBMS_OUTPUT.PUT_LINE('Agreed to have a battle;');
        v_verse := 3;
      WHEN 4 THEN
        DBMS_OUTPUT.PUT_LINE('Had spoiled his nice new rattle.');
        v_verse := -99;
    END CASE;

    IF v_verse != -99 THEN
      tweedledum(v_verse);
    END IF;
  END;

  PROCEDURE tweedledum(p_param1    NUMBER)
  IS
  BEGIN
    CASE v_verse
      WHEN 1 THEN
        DBMS_OUTPUT.PUT_LINE('Tweedledum and Tweedledee');
        v_verse := 2;
      WHEN 3 THEN
        DBMS_OUTPUT.PUT_LINE('For Tweedledum said Tweedledee');
        v_verse := 4;
    END CASE;

    tweedledee (v_verse);
  END;

BEGIN
  tweedledum(v_verse);
END;


-- **** Create an initialization block in a package body

CREATE PACKAGE initpkg
AS
  PROCEDURE call;
END initpkg;


CREATE PACKAGE BODY initpkg
AS
  l_invoked_by   VARCHAR2(20);
  l_invoked_on   DATE;

  PROCEDURE call
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Package called by ' || l_invoked_by ||
                         ' on ' || TO_CHAR(l_invoked_on, 'DD-MON-YYYY'));
 
  END call;

BEGIN  -- initialization part starts here
  SELECT user, sysdate
  INTO   l_invoked_by, l_invoked_on
  FROM dual;

END initpkg;


BEGIN
  initpkg.call;
END;



-- **** Manage persistent package data states for the life of a session and use PL/SQL tables and records in packages

CREATE OR REPLACE PACKAGE emps
AS
  PROCEDURE show;
END emps;

CREATE OR REPLACE PACKAGE BODY emps
AS
    TYPE t_emps IS TABLE OF hr.employees%ROWTYPE
    INDEX BY PLS_INTEGER;
    t_emp_tab    t_emps;
  
  PROCEDURE show
  AS
    v_ndx    PLS_INTEGER   := 1;
  BEGIN
    FOR v_Lp IN (SELECT * FROM hr.employees) LOOP
      t_emp_tab(v_ndx) := v_Lp;
      v_ndx := v_ndx + 1;
    END LOOP;

    FOR v_Lp2 IN 5..7 LOOP
      DBMS_OUTPUT.PUT_LINE('employee_id:    ' || t_emp_tab(v_Lp2).employee_id);
      DBMS_OUTPUT.PUT_LINE('first_name:     ' || t_emp_tab(v_Lp2).first_name);
      DBMS_OUTPUT.PUT_LINE('last_name:      ' || t_emp_tab(v_Lp2).last_name);
      DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
  END show;
END emps;


BEGIN
  emps.show;
END;

 

-- **** Using Oracle-Supplied Packages in Application Development

DECLARE
  v_msg     VARCHAR2(40);
  v_status  PLS_INTEGER;

  PROCEDURE gv4
  AS
  BEGIN
    DBMS_OUTPUT.GET_LINE(v_msg, v_status);
    v_msg := REPLACE(v_msg, ' i', ' wen');
    DBMS_OUTPUT.PUT_LINE(v_msg);
  END gv4;

  PROCEDURE gv3
  AS
  BEGIN
    DBMS_OUTPUT.GET_LINE(v_msg, v_status);
    v_msg := REPLACE(v_msg, 'ear', 'er');
    DBMS_OUTPUT.PUT_LINE(v_msg);
    gv4;
  END gv3;

  PROCEDURE gv2
  AS
  BEGIN
    DBMS_OUTPUT.GET_LINE(v_msg, v_status);
    v_msg := REPLACE(v_msg, 'apev', 'eat w');
    DBMS_OUTPUT.PUT_LINE(v_msg);
    gv3;
  END gv2;

  PROCEDURE gv1
  AS
  BEGIN
    DBMS_OUTPUT.GET_LINE(v_msg, v_status);
    v_msg := REPLACE(v_msg, 'I', 'A');
    DBMS_OUTPUT.PUT_LINE(v_msg);
    gv2;
  END gv1;

BEGIN
  DBMS_OUTPUT.PUT_LINE('I heard it through the grapevine.');
  gv1;
END;



-- **** Use UTL_FILE to direct output to operating system files

DECLARE
  v_read_data VARCHAR2(32767);
  f_fh        UTL_FILE.FILE_TYPE;
BEGIN
  f_fh := UTL_FILE.FOPEN('C_TEMP', 'utl_file.tmp', 'W');
  UTL_FILE.PUT_LINE(f_fh, 'The quick brown fox jumped over the lazy dog.');
  UTL_FILE.FCLOSE(f_fh);

  f_fh := UTL_FILE.FOPEN('C_TEMP', 'utl_file.tmp', 'R');

  UTL_FILE.GET_LINE(f_fh, v_read_data, 32767);
  UTL_FILE.FCLOSE(f_fh);

  DBMS_OUTPUT.PUT_LINE(v_read_data);
END;




-- **** Use Native Dynamic SQL (NDS)

CREATE PROCEDURE get_employee(p_column   VARCHAR2,
                      p_value    VARCHAR2)
IS
  v_SQL    VARCHAR2(200);
  v_row    hr.employees%ROWTYPE;
BEGIN
  v_SQL := 'SELECT * FROM hr.employees WHERE ' ||
           p_column || ' = ''' || p_value || '''';

  EXECUTE IMMEDIATE v_SQL INTO v_row;

  DBMS_OUTPUT.PUT_LINE('Employee is ' || v_row.first_name ||
                       ' ' || v_row.last_name);
END;

BEGIN
  get_employee('employee_id', '101');
  get_employee('last_name', 'Ernst');
  get_employee('phone_number', '515.124.4369');
END;


DECLARE
  TYPE t_emp_tab IS TABLE OF hr.employees%ROWTYPE;

  t_tab     t_emp_tab;
BEGIN
  EXECUTE IMMEDIATE 'SELECT * FROM hr.employees'
  BULK COLLECT INTO t_tab;

  DBMS_OUTPUT.PUT_LINE('First row: ' || t_tab(1).first_name || 
                       ' ' || t_tab(1).last_name);
  DBMS_OUTPUT.PUT_LINE('Second row: ' || t_tab(2).first_name || 
                       ' ' || t_tab(2).last_name);
  DBMS_OUTPUT.PUT_LINE('Third row: ' || t_tab(3).first_name || 
                       ' ' || t_tab(3).last_name);
END;


DECLARE
  TYPE t_emp_tab IS TABLE OF hr.employees%ROWTYPE;

  t_tab     t_emp_tab;
  c_emps    SYS_REFCURSOR;
BEGIN
  OPEN  c_emps FOR 'SELECT * FROM hr.employees';
  FETCH c_emps
  BULK COLLECT INTO t_tab;
  CLOSE c_emps; 

  DBMS_OUTPUT.PUT_LINE('First row: ' || t_tab(1).first_name || 
                       ' ' || t_tab(1).last_name);
  DBMS_OUTPUT.PUT_LINE('Second row: ' || t_tab(2).first_name || 
                       ' ' || t_tab(2).last_name);
  DBMS_OUTPUT.PUT_LINE('Third row: ' || t_tab(3).first_name || 
                       ' ' || t_tab(3).last_name);
END;



-- **** Use the DBMS_SQL package

CREATE PROCEDURE emps_ds(p_empid hr.employees.employee_id%TYPE)
AS

  v_cursor     PLS_INTEGER;
  v_emp_first  VARCHAR2(20);
  v_emp_last   VARCHAR2(20);
  v_rows       PLS_INTEGER;
BEGIN
  v_cursor := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor, 'SELECT first_name, last_name ' ||
                           'FROM   hr.employees ' ||
                           'WHERE  employee_id < :x', DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(v_cursor, ':x', p_empid);
  DBMS_SQL.DEFINE_COLUMN(v_cursor, 1, v_emp_first, 20);
  DBMS_SQL.DEFINE_COLUMN(v_cursor, 2, v_emp_last, 20);
  v_rows := DBMS_SQL.EXECUTE(v_cursor);

  LOOP
    IF DBMS_SQL.FETCH_ROWS(v_cursor) = 0 then
       EXIT;
    END IF;
    DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_emp_first);
    DBMS_SQL.COLUMN_VALUE(v_cursor, 2, v_emp_last);
    DBMS_OUTPUT.PUT_LINE('Employee name: ' || v_emp_first || ' ' ||
                                              v_emp_last);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
EXCEPTION
  WHEN OTHERS THEN
       DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;


 
-- **** Design Considerations for PL/SQL Code

CREATE PACKAGE std_names
AS
  c_domain       CONSTANT  VARCHAR2(100) := 'thiscompany.com';
  c_serverip     CONSTANT  VARCHAR2(20)  := '10.10.10.10';
  c_smtp_server  CONSTANT  VARCHAR2(20)  := '10.10.10.11';
  c_err_notice   CONSTANT  VARCHAR2(100) := 'dba@thiscompany.com';

  x_snapshot_too_old    EXCEPTION;
  PRAGMA EXCEPTION_INIT(x_snapshot_too_old, -1555);

END std_names;



-- **** Write and call local subprograms

CREATE PROCEDURE emp_years(p_emp_id   NUMBER)
AS
  v_row    hr.employees%ROWTYPE;

  FUNCTION yrs_employed(p_hiredate   DATE)
  RETURN NUMBER
  AS
  BEGIN
    RETURN TRUNC((SYSDATE - p_hiredate)/365);
  END yrs_employed;
BEGIN
  SELECT *
  INTO   v_row
  FROM   hr.employees
  WHERE  employee_id = p_emp_id;

  DBMS_OUTPUT.PUT_LINE(v_row.first_name || ' ' ||
                       v_row.last_name || ': ' ||
                       yrs_employed(v_row.hire_date) || 
                       ' years.');
END emp_years;

BEGIN
  emp_years(106);
END;



-- **** Perform autonomous transactions

CREATE PROCEDURE eoy_bonus (p_emp_id   NUMBER, 
                            p_amount   NUMBER)
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE hr.employees
  SET    salary = salary + p_amount
  WHERE  employee_id = p_emp_id;
  COMMIT;
END eoy_bonus;


-- **** Use bulk binding and the RETURNING clause with DML

DECLARE
  TYPE t_firstTyp IS TABLE OF hr.employees.first_name%TYPE;
  TYPE t_lastTyp IS TABLE OF hr.employees.last_name%TYPE;

  t_first     t_firstTyp;
  t_last      t_lastTyp;
BEGIN
  SELECT first_name, last_name
  BULK COLLECT INTO t_first, t_last
  FROM  hr.employees
  ORDER BY employee_id;

  FOR v_Lp IN 1 .. 3 LOOP
    DBMS_OUTPUT.PUT_LINE (t_first(v_Lp) || ' ' || t_last(v_Lp));
  END LOOP;
END;


-- **** FORALL Statement

DROP TABLE temp_emp;
CREATE TABLE temp_emp AS SELECT * FROM hr.employees;

DECLARE
  TYPE     t_JobArray IS VARRAY(20) OF VARCHAR2(10);
  v_jobs   t_JobArray := t_JobArray('MK_MAN', 'MK_REP', 
                         'PR_REP', 'SA_MAN', 'SA_REP');
BEGIN
  FOR v_Lp IN v_jobs.FIRST..v_jobs.LAST LOOP
    DELETE FROM temp_emp
    WHERE  job_id = v_jobs(v_Lp);
  END LOOP;
END;


DROP TABLE temp_emp;
CREATE TABLE temp_emp AS SELECT * FROM hr.employees;

DECLARE
  TYPE     t_JobArray IS VARRAY(20) OF VARCHAR2(10);
  v_jobs   t_JobArray := t_JobArray('MK_MAN', 'MK_REP', 
                         'PR_REP', 'SA_MAN', 'SA_REP');
BEGIN
  FORALL v_Lp IN v_jobs.FIRST..v_jobs.LAST
    DELETE FROM temp_emp
    WHERE  job_id = v_jobs(v_Lp);
END;


-- **** RETURNING INTO

DECLARE
  TYPE t_firstTyp IS TABLE OF hr.employees.first_name%TYPE;
  TYPE t_lastTyp IS TABLE OF hr.employees.last_name%TYPE;
  TYPE t_salTyp IS TABLE OF hr.employees.salary%TYPE;

  t_first     t_firstTyp;
  t_last      t_lastTyp;
  t_sal       t_salTyp;
BEGIN

  UPDATE hr.employees
  SET    salary = salary * .95
  WHERE  job_id = 'PU_CLERK'
  RETURNING first_name, last_name, salary
  BULK COLLECT INTO t_first, t_last, t_sal;

  DBMS_OUTPUT.PUT_LINE ('Updated ' || SQL%ROWCOUNT || ' rows:');

  FOR v_Lp IN t_first.FIRST .. t_first.LAST LOOP
    DBMS_OUTPUT.PUT_LINE (t_first(v_Lp) || ' ' || 
                          t_last(v_Lp) || ' salary ' ||
                          t_sal(v_Lp));
  END LOOP;
END;


 
-- **** Creating Triggers

CREATE OR REPLACE TRIGGER hr.tr_employee_test
  BEFORE
    INSERT OR
    UPDATE OF job_id OR
    DELETE
  ON hr.employees
  FOR EACH ROW
BEGIN
  CASE
    WHEN INSERTING THEN
      DBMS_OUTPUT.PUT_LINE('Row inserted into employees');
    WHEN UPDATING('JOB_ID') THEN
      DBMS_OUTPUT.PUT_LINE('Updating ' || :OLD.job_id || ' to ' ||
         :NEW.job_id || ' for employee #: ' || :OLD.employee_id);
    WHEN DELETING THEN
      DBMS_OUTPUT.PUT_LINE('Deleting employee #: ' || :OLD.employee_id);
  END CASE;
END tr_employee_test;



CREATE OR REPLACE TRIGGER hr.tr_employee_test
  BEFORE
    UPDATE OF job_id
  ON hr.employees
  FOR EACH ROW
    WHEN (NEW.job_id = 'AD_VP')
BEGIN
  DBMS_OUTPUT.PUT_LINE('Too many chiefs.  Not enough indians.');
END tr_employee_test;

UPDATE hr.employees
SET    job_id = 'AD_VP'
WHERE employee_id = 120;


CREATE PROCEDURE hr.job_change(p_old_job     VARCHAR2,
                               p_new_job     VARCHAR2)
AS
BEGIN
  IF p_old_job = 'IT_PROG' AND
     p_new_job = 'AD_VP' THEN
    DBMS_OUTPUT.PUT_LINE('What kind of programmer becomes a VP voluntarily?');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Too many chiefs.  Not enough indians.');
  END IF;
END job_change;


CREATE OR REPLACE TRIGGER hr.tr_employee_test
  BEFORE
    UPDATE OF job_id
  ON hr.employees
  FOR EACH ROW
    WHEN (NEW.job_id = 'AD_VP')
CALL job_change(:OLD.job_id, :NEW.job_id)

UPDATE hr.employees
SET    job_id='AD_VP'
WHERE  employee_id = 103;


-- **** Compound Triggers

CREATE OR REPLACE TRIGGER hr.tr_compound_example
  FOR UPDATE OF salary ON hr.employees
    COMPOUND TRIGGER

    v_oldsal    NUMBER;
    v_newsal    NUMBER;
    v_emp       VARCHAR2(40);

BEFORE STATEMENT
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Beginning statement');
END BEFORE STATEMENT;

BEFORE EACH ROW
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Before updating row');
END BEFORE EACH ROW;

AFTER EACH ROW 
IS
BEGIN
  v_oldsal := :OLD.salary;
  v_newsal := :NEW.salary;
  v_emp    := :OLD.first_name || ' ' || :OLD.last_name;
  DBMS_OUTPUT.PUT_LINE('UPDATING salary for ' || v_emp || ' from ' ||
                        v_oldsal || ' to ' || v_newsal);
  DBMS_OUTPUT.PUT_LINE('Finished updating row');
  DBMS_OUTPUT.PUT_LINE('---------------------');
END AFTER EACH ROW;

AFTER STATEMENT 
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Ending statement');
END AFTER STATEMENT;

END tr_compound_example;



-- **** Create triggers on DDL statements

CREATE TABLE please_changeme (
col1     NUMBER);

CREATE OR REPLACE TRIGGER tr_hr_noalter
BEFORE ALTER ON hr.SCHEMA
BEGIN
  RAISE_APPLICATION_ERROR (
    num => -20001,
    msg => 'HR Cannot alter objects');
END;

ALTER TABLE please_changeme ADD (col2 NUMBER);
table PLEASE_CHANGEME altered.


DROP TRIGGER tr_hr_noalter;
CREATE OR REPLACE TRIGGER tr_ocpguru_noalter
BEFORE ALTER ON ocpguru.SCHEMA
BEGIN
  RAISE_APPLICATION_ERROR (
    num => -20001,
    msg => 'OCPGuru Cannot alter objects');
END;

ALTER TABLE please_changeme ADD (col3 NUMBER);
ORA-20001: OCPGuru Cannot alter objects


-- **** Create triggers on system events

CREATE OR REPLACE TRIGGER tr_nota_number
AFTER SERVERERROR ON DATABASE
BEGIN
  IF (IS_SERVERERROR (1722)) THEN
    DBMS_OUTPUT.PUT_LINE('Someone doesn''t know what a number is again');
  END IF;
END;

INSERT INTO hr.departments 
VALUES (400, 'New Department', 'A14', '5345');


CREATE OR REPLACE TRIGGER tr_logon
AFTER LOGON ON DATABASE
BEGIN
  INSERT INTO audit_users
  VALUES (USER, SYSDATE);
END;




/* ***************************************************
* The following code create the AIRPORT tables used  *
* by some of the procedures in this book             *
**************************************************** */


DROP TABLE "AIRPORTS";
DROP TABLE "AIRCRAFT_TYPES";
DROP TABLE "AIRCRAFT_FLEET";

  CREATE TABLE "AIRPORTS" 
   (	"APT_ID" NUMBER, 
	"APT_NAME" VARCHAR2(22), 
	"APT_ABBR" VARCHAR2(5)
   ) ;
/

  CREATE TABLE "AIRCRAFT_TYPES" 
   (	"ACT_ID" NUMBER, 
	"ACT_NAME" VARCHAR2(12), 
	"ACT_BODY_STYLE" VARCHAR2(10), 
	"ACT_DECKS" VARCHAR2(10), 
	"ACT_SEATS" NUMBER
   ) ;
/

  CREATE TABLE "AIRCRAFT_FLEET" 
   (	"AFL_ID" NUMBER, 
	"ACT_ID" NUMBER, 
	"APT_ID" NUMBER
   ) ;
/

Insert into AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (1,'Orlando, FL','MCO');
Insert into AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (2,'Atlanta, GA','ATL');
Insert into AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (3,'Miami, FL','MIA');
Insert into AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (4,'Jacksonville, FL','JAX');
Insert into AIRPORTS (APT_ID,APT_NAME,APT_ABBR) values (5,'Dallas/Fort Worth','DFW');
REM INSERTING into AIRCRAFT_TYPES
SET DEFINE OFF;
Insert into AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (1,'Boeing 747','Wide','Double',416);
Insert into AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (2,'Boeing 767','Wide','Single',350);
Insert into AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (3,'Boeing 737','Narrow','Single',200);
Insert into AIRCRAFT_TYPES (ACT_ID,ACT_NAME,ACT_BODY_STYLE,ACT_DECKS,ACT_SEATS) values (4,'Boeing 757','Narrow','Single',240);
REM INSERTING into AIRCRAFT_FLEET
SET DEFINE OFF;
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (1,2,1);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (2,2,1);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (3,3,2);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (4,4,2);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (5,1,3);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (6,1,3);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (7,1,5);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (8,2,5);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (9,4,null);
Insert into AIRCRAFT_FLEET (AFL_ID,ACT_ID,APT_ID) values (10,3,null);

  CREATE TABLE "EMPLOYEES" 
   (	"EMP_ID" NUMBER, 
	"AFL_ID" NUMBER, 
	"EMP_FIRST" VARCHAR2(10), 
	"EMP_LAST" VARCHAR2(10), 
	"EMP_JOB" VARCHAR2(10), 
	"EMP_SUPERVISOR" NUMBER, 
	"SALARY" NUMBER, 
	"START_DATE" DATE DEFAULT SYSDATE
   ) ;
/

REM INSERTING into EMPLOYEES
SET DEFINE OFF;
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (1,null,'Big','Boss','CEO',null,197500,to_date('10-APR-92','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (2,null,'Adam','Smith','CFO',1,157000,to_date('29-MAR-93','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (3,null,'Rick','Jameson','SVP',1,145200,to_date('30-JAN-95','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (4,null,'Rob','Stoner','SVP',1,149100,to_date('20-JUL-94','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (5,null,'Bill','Abong','VP',3,123500,to_date('17-MAY-92','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (6,null,'Janet','Jeckson','VP',4,127800,to_date('15-APR-02','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (18,null,'Guy','Newberry','Mgr',8,90000,null);
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (8,null,'Alf','Alien','SrDir',6,110500,to_date('05-AUG-97','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (9,null,'Norm','Storm','Mgr',8,101500,to_date('01-FEB-99','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (10,1,'John','Jones','Pilot',9,97500,to_date('10-APR-95','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (11,2,'Top','Gun','Pilot',9,91500,to_date('13-OCT-96','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (12,3,'Phil','McCoy','Pilot',9,105000,to_date('09-JUN-96','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (13,4,'James','Thomas','Pilot',9,98500,to_date('12-MAY-99','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (14,5,'John','Picard','Pilot',9,49500,to_date('11-NOV-01','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (15,6,'Luke','Skytalker','Pilot',9,90000,to_date('10-SEP-02','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (16,7,'Dell','Aptop','Pilot',9,87500,to_date('22-AUG-03','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (17,8,'Noh','Kia','Pilot',9,92250,to_date('07-JUL-04','DD-MON-RR'));
Insert into EMPLOYEES (EMP_ID,AFL_ID,EMP_FIRST,EMP_LAST,EMP_JOB,EMP_SUPERVISOR,SALARY,START_DATE) values (7,null,'Fred','Stoneflint','SrDir',5,111500,to_date('07-APR-01','DD-MON-RR'));
