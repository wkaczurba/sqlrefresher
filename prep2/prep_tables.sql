CREATE TABLE AIRPORTS (
  APT_ID NUMBER,
  APT_NAME VARCHAR2(20),
  APT_ABBR VARCHAR2 (5 BYTE),
  CONSTRAINT AIRPORTS_APT_ABBR_UN unique (apt_abbr),
  CONSTRAINT AIRPORTS_PK primary key (apt_id)
);

INSERT INTO AIRPORTS (apt_id, apt_name, apt_abbr)
  (SELECT 1, 'Orlandlo, FL', 'MCO' FROM DUAL
   UNION ALL
   SELECT 2, 'Atlanta, GA', 'ATL' FROM DUAL
   UNION ALL
   SELECT 3, 'Miami, LF', 'MIA' FROM DUAL
   UNION ALL
   SELECT 4, 'Jacksonville, FL', 'JAX' FROM DUAL
   UNION ALL
   SELECT 5, 'Dallas/Forth Worth', 'DFW' FROM DUAL);
DELETE FROM AIRPORTS;   

INSERT ALL
  INTO AIRPORTS (apt_id, apt_name, apt_abbr) values (1, 'Orlandlo, FL', 'MCO')
  INTO AIRPORTS (apt_id, apt_name, apt_abbr) values (2, 'Atlanta, GA', 'ATL')
  INTO AIRPORTS (apt_id, apt_name, apt_abbr) values (3, 'Miami, LF', 'MIA')
  INTO AIRPORTS (apt_id, apt_name, apt_abbr) values (4, 'Jacksonville, FL', 'JAX')
  INTO AIRPORTS (apt_id, apt_name, apt_abbr) values (5, 'Dallas/Forth Worth', 'DFW');

CREATE TABLE aircraft_types (
  act_id number constraint act_id_pk PRIMARY KEY,
  act_name varchar(20),
  act_body_style varchar(10),
  act_decks varchar2(10),
  act_seats number
);

CREATE TABLE aircraft_fleet (
  afl_id number constraint AIRCRAFT_FLEET_PK primary key,
  act_id number,
  apt_id number,
  constraint ACT_ID_FK FOREIGN KEY (act_id) REFERENCES AIRPORTS(APT_ID),
  constraint APT_ID_FK FOREIGN KEY (apt_id) REFERENCES AIRCRAFT_TYPES(ACT_ID)
);





