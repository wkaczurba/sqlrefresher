-- EXECUTE AS SYSDBA.

-- Refer to https://stackoverflow.com/questions/18403125/how-to-create-a-new-schema-new-user-in-oracle-11g

--CREATE USER se
  --IDENTIFIED BY se;
-- DROP USER se;
  
CREATE tablespace se_tabspace
  DATAFILE 'se_tablespace.dat'
  SIZE 10M autoextend ON;
  
CREATE temporary tablespace se_temp
  TEMPFILE 'se_tablespace_temp.dat'
  SIZE 5M autoextend ON;

CREATE USER se
  IDENTIFIED by se
  DEFAULT TABLESPACE se_tabspace
  TEMPORARY TABLESPACE se_temp;

GRANT create session TO se;
GRANT CREATE table TO SE;
GRANT UNLIMITED TABLESPACE TO SE;
GRANT CREATE VIEW TO SE;
GRANT CREATE SEQUENCE to SE;

SELECT * FROM session_privs;



