/* This is to prevent from breaking tables into pieces; */
SET PAGESIZE 50000; 

SELECT DISTINCT job_id, department_id FROM job_history;

// p.73, Ex 2.2: How many unique departments have employees currently working in them?

SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;
// Result: 12 ROWS; ONLY 11 ROWS ARE NOT NULL
// What means that At least one employee has no department assigned to himself;

// p.74; Ex 2.3; How many countries are there in the Europe region?

SELECT * FROM REGIONS;

// So EUROPE IS REGION 1;
SELECT region_id, country_name FROM COUNTRIES;

// ANSWER1: Can count the above manually and there will be 8 countries with region_id = 1 (Europe)
// ANSWER2: The below will list the countries in EUROPE REGION:
SELECT * FROM COUNTRIES WHERE REGION_ID=1;
// ANSWER3: The below will give the count:
SELECT COUNT(*) FROM COUNTRIES WHERE REGION_ID=1;

// Listing countries in EUROPE region only:
SELECT * FROM COUNTRIES NATURAL JOIN REGIONS WHERE REGION_NAME='Europe' ORDER BY REGION_ID;

// p.77:
SELECT * FROM job_history;

SELECT employee_id, job_id, start_date, end_date,
  (end_date - start_date + 1) * 8 AS "Correct Hours Worked",
  end_date - start_date + 1 * 8 AS "Incorrect hours worked"
FROM hr.job_history;

// p.82, Aliasing with and without "AS"

SELECT employee_id AS "Employee ID", job_id AS "Occupation",
  job_id AS "Occupation",
  start_date, end_date,
  (end_date - start_date) + 1 "Days worked"
FROM job_history;

// p.82 Character concatenation
SELECT 'The '||region_name||' region is on Planet Earth' "Planetary Location",
  region_id * 100/5 + 20 / 10 - 5 "Meteor Shower Probability %",
  region_id "Region Id"
FROM regions;

SELECT 'The '||region_name||' region is on Planet Earth' "Planetary Location",
  region_id * 100/5 + 20 / (10-5) "Meteor shower probability",
  region_id "Region Id"
FROM regions;

// p.83 Literals and DUAL table

// Without DUAL - executes as many times as rows:
SELECT 'literal '||'processing using the REGIONS table' FROM regions;

SELECT 365.25 * 24 * 60 "Seconds in a year"
FROM DUAL;

SELECT * FROM DUAL;

// p.84 Two single quotes or the Alternative Quote operator
SELECT 'I am a character literal string' FROM DUAL; // ok

// Wrong:
//SELECT 'Plural's have one quotes too many' FROM DUAL;

SELECT 'Plural''s can be specified using two single quoutes' AS "2 single quotes" FROM dual;

SELECT 'Using ''too many quoutes'' like this one: '' causes a headache' FROM dual;

// Easier with q'X .... X'
SELECT q'XUsing 'many quoutes' like this onees: ''' is easier with delimiterX' FROM dual;
SELECT q'<Delimiters sorting out '''' problems can be any letter or () {} [] <> ''' >' FROM dual;

SELECT q'{ 'Escaped with curly brackets {} }' FROM dual;
SELECT q'( Escaped with ''round brackets'' () )' FROM dual;
SELECT q'< '' Escaped with angle brackets <> >' FROM dual;
SELECT q'[ '' Escaped with square brackets [] ]' FROM dual;

// p.87 Null concept

// p.89 (fig 2-15, 2-16)
// Null arithmetic -> division by null leads to a NULL result.
DESC employees;

SELECT first_name||' '||last_name "Full name", salary, commission_pct, manager_id
FROM employees;

SELECT first_name||NULL||last_name "Full name", 
  commission_pct,
  salary,
  commission_pct + salary + 10 "Null arithmetic",
  10/commission_pct "Division by null"
FROM employees;

// PK cannot be nullable but FK can be p.92 what can lead to troubles.
/* ***** EX 2-3 ******/
// p.92 -> for how many days the stuff worked?

// This should produce "HR"
SHOW USER;
SELECT * FROM user_tables;
DESCRIBE JOB_HISTORY;
SELECT * FROM JOB_HISTORY WHERE ROWNUM < 6; // Select first 5 rows;
SELECT employee_id,
  start_date,
  end_date,
  (end_date - start_date + 1) "Days worked",
  (end_date - start_date + 1)/365.25 "Years worked",
  job_id,
  department_id
FROM JOB_HISTORY;

// p.92 Ex 2.3 quuestion 2 Concatenate, so it is: The Job Id for the <job_title’s> job is: <job_id>.
DESC JOBS;
SELECT 
  JOB_ID, JOB_TITLE 
FROM JOBS
WHERE ROWNUM < 10;

SELECT 'The Job id for the '||JOB_TITLE||' job is '||JOB_ID FROM JOBS;
SELECT q'<The Job id for the '>' || JOB_TITLE || q'<' job is '>' || JOB_ID || q'<'>' FROM JOBS;
SELECT 'The job id for the '||JOB_TITLE||q'['s job is ]'||JOB_ID FROM JOBS;
SELECT 'The job id for the '||JOB_TITLE||'''s job is ]'||JOB_ID FROM JOBS;

  /*
  SELECT ''' ' FROM DUAL; // This will work
  //SELECT ''''' FROM DUAL; // This will FAIL
  SELECT '''''' FROM DUAL; // This will work
  */

// p.92 Ex 2.3 quuestion 3 Calculate the area of a cricle with radius 6,00 units, assumming PI is 22/7.
SELECT 22/7 * 6.00 * 6.00 FROM DUAL;
SELECT 22/7 * POWER(6.00, 2) FROM DUAL;
SELECT 3.14 * 6.00 * 6.00 FROM DUAL;
SELECT 3.14 * POWER(6.00, 2) FROM DUAL;
/* ***** END OF EX 2-3 ****** */
