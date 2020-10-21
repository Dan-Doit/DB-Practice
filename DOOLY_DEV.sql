CREATE USER DOUNER
IDENTIFIED BY "0000";
GRANT RESOURCE, CONNECT TO DOUNER;

CREATE USER GILDONG
IDENTIFIED BY "0000";
GRANT RESOURCE, CONNECT TO GILDONG;

CREATE USER DOOLY
IDENTIFIED BY "0000";
GRANT RESOURCE, CONNECT TO DOOLY;

CREATE USER HEEDONG
IDENTIFIED BY "1234";
GRANT RESOURCE, CONNECT TO HEEDONG;


-------------------------------------------------------------------------------- STORES TABLE(ST)
CREATE TABLE STORES(
 ST_CODE    NCHAR(4),
 ST_NAME    NVARCHAR2(100) NOT NULL,
 ST_ADDR    NVARCHAR2(100)
)TABLESPACE USERS;

-- CONSRINT
ALTER TABLE STORES
ADD CONSTRAINT ST_CODE_PK  PRIMARY KEY(ST_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM ST FOR COMEIN.STORES;

-- GRANT 
GRANT SELECT ON ST TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON ST TO GILDONG; 


  
-------------------------------------------------------------------------------- GOODS TABLE(GO)
CREATE TABLE GOODS(
GO_CODE NCHAR(4),
GO_NAME NVARCHAR2(50),
GO_PRICE NUMBER(6,0),
GO_COMMENTS NVARCHAR2(100)
) TABLESPACE USERS;

 -- PROPERTY
ALTER TABLE GOODS
MODIFY GO_CODE NOT NULL
MODIFY GO_NAME NOT NULL
MODIFY GO_PRICE DEFAULT 0;

 -- CONSTRAINTS 
ALTER TABLE GOODS
ADD CONSTRAINT GO_CODE_PK PRIMARY KEY(GO_CODE);


 -- SYNONYM
CREATE PUBLIC SYNONYM GO FOR COMEIN.GOODS;

 -- GRANT 
GRANT SELECT ON GO TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON GO TO DOOLY; 



-------------------------------------------------------------------------------- CUSTOMER TABLE(CM)
CREATE TABLE CUSTOMER(
CM_CODE NCHAR(5),
CM_NAME NVARCHAR2(5),
CM_PHONE NCHAR(11)
) TABLESPACE USERS;

 -- PROPERTY
 ALTER TABLE CUSTOMER
 MODIFY CM_CODE NOT NULL;
 
 -- CONSTRAINTS 
 ALTER TABLE CUSTOMER
 ADD CONSTRAINT CM_CODE_PK PRIMARY KEY(CM_CODE);
 
 -- SYNONYM
 CREATE PUBLIC SYNONYM CM FOR COMEIN.CUSTOMER;
 
 -- GRANT
GRANT SELECT ON CM TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON CM TO HEEDONG; 


-------------------------------------------------------------------------------- EMPLOYEES TABLE(EM)
-- TABLE CREATE
CREATE TABLE EMPLOYEES(
EM_STCODE NCHAR(4),
EM_CODE NCHAR(4),
EM_PWD NVARCHAR2(10),
EM_NAME NVARCHAR2(5)
)TABLESPACE USERS;

-- PROPERTY
ALTER TABLE EMPLOYEES
MODIFY EM_STCODE NOT NULL
MODIFY EM_CODE NOT NULL
MODIFY EM_PWD NOT NULL
MODIFY EM_NAME NOT NULL;

-- CONSTRINT
ALTER TABLE EMPLOYEES
ADD CONSTRAINT EM_STCODE_CODE_PK PRIMARY KEY (EM_STCODE, EM_CODE);
ALTER TABLE EMPLOYEES
ADD CONSTRAINT EM_STCODE_FK FOREIGN KEY (EM_STCODE) REFERENCES COMEIN.STORES(ST_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM "EM" FOR COMEIN.EMPLOYEES;

-- GRANT
GRANT SELECT ON "EM" TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON "EM" TO GILDONG; 

 
 -------------------------------------------------------------------------------- STOCK TABLE(SC)
 CREATE TABLE STOCK(
SC_GOCODE NCHAR(4),
SC_CODE DATE,
SC_STOCKS  NUMBER(3,0),
SC_EXPIRE DATE
) TABLESPACE USERS;

-- PROPERTY
ALTER TABLE STOCK
MODIFY SC_CODE DEFAULT SYSDATE
MODIFY SC_STOCKS NOT NULL
MODIFY SC_EXPIRE NOT NULL;

-- CONSTRAINT
ALTER TABLE STOCK
ADD CONSTRAINT SC_GOCODE_CODE_PK PRIMARY KEY (SC_GOCODE, SC_CODE);
ALTER TABLE STOCK
ADD CONSTRAINT SC_CODE_FK FOREIGN KEY(SC_GOCODE) REFERENCES COMEIN.GOODS(GO_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM SC FOR COMEIN.STOCK;

-- GRANT
GRANT SELECT ON SC TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON SC TO DOOLY; 



 -------------------------------------------------------------------------------- ORDERS TABLE(OD)
CREATE TABLE ORDERS(
OD_CODE DATE,
OD_EMSTCODE NCHAR(4),
OD_EMCODE NCHAR(4),
OD_CMCODE NCHAR(5),
OD_STATE NCHAR(1)
)TABLESPACE USERS;

-- PROPERTY
ALTER TABLE ORDERS
MODIFY OD_CODE DEFAULT SYSDATE
MODIFY OD_EMSTCODE NOT NULL
MODIFY OD_EMCODE NOT NULL
MODIFY OD_CMCODE NOT NULL
;

-- CONSTRAINTS
ALTER TABLE ORDERS
ADD CONSTRAINT OD_CODE_PK PRIMARY KEY(OD_CODE);

ALTER TABLE ORDERS
ADD CONSTRAINT OD_EMCODE_FK FOREIGN KEY(OD_EMCODE, OD_EMSTCODE) 
REFERENCES COMEIN.EMPLOYEES(EM_CODE, EM_STCODE); 

ALTER TABLE ORDERS
ADD CONSTRAINT OD_CMCODE_FK FOREIGN KEY(OD_CMCODE) 
REFERENCES COMEIN.CUSTOMER(CM_CODE); 

-- SYNONYM 
CREATE PUBLIC SYNONYM OD FOR COMEIN.ORDERS;

-- GRANT
GRANT SELECT ON OD TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON OD TO DOUNER;


 -------------------------------------------------------------------------------- ORDERDETAIL TABLE(OT)
CREATE TABLE ORDERDETAIL(
OT_ODCODE DATE NOT NULL,
OT_GOCODE NCHAR(4) NOT NULL,
OT_QTY NUMBER(2,0) DEFAULT 0,
OT_STATE NCHAR(1) NOT NULL
)TABLESPACE USERS;

-- CONSTRAINT
ALTER TABLE ORDERDETAIL
ADD CONSTRAINT OT_ODCODE_GOCODE_PK PRIMARY KEY (OT_ODCODE, OT_GOCODE);
ALTER TABLE ORDERDETAIL
ADD CONSTRAINT OT_ODCODE_FK FOREIGN KEY(OT_ODCODE) REFERENCES COMEIN.ORDERS (OD_CODE);
ALTER TABLE ORDERDETAIL
ADD CONSTRAINT OT_GOCODE_FK FOREIGN KEY(OT_GOCODE) REFERENCES COMEIN.GOODS (GO_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM OT FOR COMEIN.ORDERDETAIL;

-- GRANT
GRANT SELECT ON OT TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON OT TO DOUNER; 


 -------------------------------------------------------------------------------- POINT TABLE(PO)
CREATE TABLE "POINT"(
PO_CMCODE NCHAR(5),
PO_ODCODE DATE,
PO_STATE NUMBER(1),
PO_AMOUNT NUMBER(6,0)
)TABLESPACE USERS;

--PROPERTY
ALTER TABLE "POINT"
MODIFY PO_CMCODE NOT NULL
MODIFY PO_ODCODE NOT NULL
MODIFY PO_STATE NOT NULL
MODIFY PO_AMOUNT DEFAULT 0;
-- CONSTRAINT
ALTER TABLE "POINT"
ADD CONSTRAINT PO_CMCODE_ODCODE_PK PRIMARY KEY (PO_CMCODE, PO_ODCODE);
ALTER TABLE "POINT"
ADD CONSTRAINT PO_CMCODE_FK FOREIGN KEY (PO_CMCODE) REFERENCES COMEIN.CUSTOMER(CM_CODE); 
ALTER TABLE "POINT"
ADD CONSTRAINT PO_ODCODE_FK FOREIGN KEY (PO_ODCODE) REFERENCES COMEIN.ORDERS(OD_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM PO FOR COMEIN."POINT";

-- GRANT

GRANT SELECT ON PO TO DOOLY, GILDONG, DOUNER, HEEDONG;
GRANT INSERT, UPDATE, ALTER ON PO TO HEEDONG; 


SELECT * FROM SC;





