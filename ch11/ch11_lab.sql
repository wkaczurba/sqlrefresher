-- Analysis of a billing system
-- ** SUSBCRIBER: SUBSCRIBER_NUMBER, 
-- ** NUMBERS: PHONE_NUMBER (7-digit), SUBSCRIBER_NUMBER (FK, NULLABLE), ACTIVE (CONSTRAINT CHECKER=> IF CUSTOMER_NUMBER NOT NULL)
-- ** PHONE_CALLS: CALL_ID(PK), CALLER_PHONE (FK, NUMBERS)), CALLED_PHONE(FK, NUMBERS), TIME_STARTED, TIME_FINISHED, 

-- CREATE WITH DEFAULTS.

CREATE TABLE subscriber (
  subscriber_id NUMBER CONSTRAINT subscriber_pk PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20)
);

ALTER TABLE subscriber MODIFY (first_name VARCHAR(20) NOT NULL);
ALTER TABLE subscriber MODIFY (last_name VARCHAR(20) NOT NULL);

CREATE TABLE phone_numbers (
  phone_number NUMBER(7,0) CONSTRAINT phone_number_pk PRIMARY KEY,
  subscriber_id NUMBER CONSTRAINT subscriber_fk REFERENCES subscriber(subscriber_id),
  active NUMBER(1, 0),
  activation_date DATE NOT NULL,
  CONSTRAINT active_ck CHECK (active IN (0, 1) AND (active=1 AND subscriber_id IS NOT NULL OR active=0 AND subscriber_id IS NULL));
  --CONSTRAINT phone_number_ck CHECK (LENGTH(TO_CHAR(phone_number)) = 7 AND TRUNC(phone_number, -6) IN (6000000, 7000000))
);

ALTER TABLE phone_numbers DROP CONSTRAINT active_ck;
-- In active_ck :: No need to say IN (0, 1) as the rest of the statement guarantees that:
ALTER TABLE phone_numbers ADD CONSTRAINT active_ck CHECK (active=1 AND subscriber_id IS NOT NULL OR active=0 AND subscriber_id IS NULL);

ALTER TABLE phone_numbers DROP CONSTRAINT phone_number_ck;
ALTER TABLE phone_numbers ADD CONSTRAINT phone_number_ck CHECK (LENGTH(TO_CHAR(phone_number)) = 7 AND TRUNC(phone_number, -6) IN (7000000, 8000000));

CREATE TABLE phone_calls (
  connection_id NUMBER CONSTRAINT connection_id_pk PRIMARY KEY,
  caller NUMBER NOT NULL CONSTRAINT caller_pk REFERENCES phone_numbers(phone_number),
  called NUMBER NOT NULL CONSTRAINT called_pk REFERENCES phone_numbers(phone_number),
  started DATE NOT NULL,
  finished DATE NOT NULL,
  CONSTRAINT time_ck CHECK (finished > started)
);
ALTER TABLE phone_calls ADD CONSTRAINT caller_called_ck CHECK (caller <> called);


INSERT INTO subscriber (subscriber_id, first_name, last_name) VALUES (1, 'John', 'Avery');
INSERT INTO subscriber (subscriber_id, first_name, last_name) VALUES (2, 'Eva', 'McLoughlin');
INSERT INTO subscriber (subscriber_id, first_name, last_name) VALUES (3, 'Martha', 'Steinhous');

-- This violates phone number (must start with 7 or 8 and have 7 digits:
--INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (1000000, NULL, 0, SYSDATE);

-- This violates check active_ck: it has to have subscriber assigned in order to be 1
  -- INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (7000003, NULL, 1, SYSDATE);

INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (7000000, NULL, 0, SYSDATE);
  -- This will violate subscriber id, GOOD:
  -- UPDATE phone_numbers SET subscriber_id = 4 WHERE phone_number = 7000000;

INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (7000001, 1, 1, SYSDATE);
INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (7000002, 2, 1, SYSDATE);
INSERT INTO phone_numbers (phone_number, subscriber_id, active, activation_date) VALUES (8000002, 3, 1, SYSDATE);

-- SHOW WHO HAS WHAT PHONE:
SELECT * 
FROM phone_numbers
NATURAL JOIN subscriber
WHERE phone_number LIKE '_0000%'; -- IMPLICIT CONVERSION

-- ADD CALLS:
INSERT INTO phone_calls (connection_id, caller, called, started, finished) VALUES (1, 8000002, 7000001, 
  TO_DATE('23-JAN-2007 09:15:34', 'DD-MON-YYYY HH24:MI:SS'), 
  TO_DATE('23-JAN-2007 9:17:23', 'DD-MON-YY HH24:MI:SS'));

-- CHANGE duration into something more useful.
SELECT connection_id, 
      caller caller_phone, 
      called called_phone, 
      started, 
      finished, 
      TO_CHAR(TRUNC((finished - started) * 24), '09') || ':' || -- DURATION HOURS
      TRIM(TO_CHAR(TRUNC(MOD((finished - started) * 24 * 60, 60)), '09')) || ':' || -- Duration MINUTES
      TRIM(TO_CHAR(TRUNC(MOD((finished - started) * 24 * 3600, 60)), '09')) duration, -- Duration SECONDS
      n1.subscriber_id FROM_SUBSCRIBER, 
      n2.subscriber_id TO_SUBSCRIBER
  FROM PHONE_CALLS c
  JOIN phone_numbers n1 ON (c.caller = n1.phone_number) -- IMPROVE QUERY BY ADDING JOINS, ETC.
  JOIN phone_numbers n2 ON (c.called = n2.phone_number)
  JOIN subscriber s1 ON (s1.phone_number = n1.phone_number)
  JOIN subscriber s2 ON (s2.phone_number = n2.phone_number);
  
--TODO: HERE join subsribers:
  --JOIN subscribers
  


DESC subscriber;
DESC phone_numbers;
DESC phone_calls;

DROP table phone_calls;
DROP table phone_numbers;
DROP table subscriber;

