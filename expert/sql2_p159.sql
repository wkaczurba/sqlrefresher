--DROP TABLE ships;
--DROP TABLE ports;

-- p.159
CREATE TABLE PORTS (
  PORT_ID number, 
  PORT_NAME VARCHAR2(20),
  COUNTRY VARCHAR2(40),
  CAPACITY number,
  constraint port_pk PRIMARY KEY (port_id)
);

CREATE TABLE ships (
  SHIP_ID number,
  SHIP_NAME varchar2(20),
  HOME_PORT_ID number not null,
  constraint ships_port_fk FOREIGN KEY(home_port_id) references ports(port_id)
);

SAVEPOINT SP_1;
INSERT into PORTS (port_id, port_name) 
  values (1, 'Hawaii');
  
SAVEPOINT SP_2;
INSERT into PORTS (port_id, port_name) 
  values (2, 'New Zeland');
  
rollback to SP_2;
COMMIT WORK SP_2;

SELECT * FROM ports;


--INSERT INTO ships 


DROP TABLE ships;
DROP TABLE ports;
