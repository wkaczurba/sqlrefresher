create role prep071role not identified;
grant create session to prep071role;
grant alter session to prep071role;
grant create table to prep071role;
grant delete any table to prep071role;

create user prep071 identified by prep071role
  default tablespace users
  profile default account unlock;

alter user prep071 identified by prep071; -- change password.

alter user prep071 quota 20m on users;
grant prep071role to prep071;

GRANT CREATE SESSION TO prep071role;
GRANT CREATE VIEW to prep071role;
GRANT CREATE ANY TRIGGER to prep071role;
GRANT CREATE SEQUENCE to prep071role;
GRANT CREATE ANY TABLE TO prep071role;
GRANT CREATE ANY INDEX TO prep071role;
GRANT CREATE ANY SEQUENCE TO prep071role;
--REVOKE CREATE ANY SEQUENCE FROM prep071role;


