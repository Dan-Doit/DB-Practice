/*
DataBase Term
 - Relation = Table
 - Attribute = Field = Column = 속성 --> 일관된 데이터타입만 저장 가능
 - Tuple = Record = Row = 속성들의 집합
 - Domain : 속성이 취할 수 있는 값의 범위
 - Cardinality : Tuple의 수
 - Degree : Attribute의 수
 - Relation Schema : 속성의 이름
 - Relation Instance : Tuple의 집합

 - Key : Row를 구분하기 위한 하나 이상의 Column
   -- Primary Key : 수 많은 Record사이에서 현재 레코드의
                    유일한 특성을 갖게 하는 하나 이상의 속성
                  : 1개의 테이블에 1개의 PK만 존재
   -- Foreign Key : 1:N관계를 갖는 두 개의 테이블에서 N의 속성을 갖고 있는 테이블의 
                    Column Data는 반드시 1의 속성을 갖는 테이블의 Column Data와
                    일치시킴으로써 두 개의 테이블의 관계에서 Object Integrity와 
                    Reference Integrity을 유지하도록 한다.
                
                    
DataBase Normalization
   : 데이터의 중복으로 인한 이상(Anomaly) 현상 제거
   1. Insert Anomaly
      : 새로운 데이터를 삽입하기 위해 불필요한 데이터도 함께 삽입해야 하는 문제
   2. Update Anomaly
      : 중복 튜플 중 일부만 변경하여 데이터가 불일치하게 되는 문제 
   3. Deletion Anomaly
      : 데이터를 삭제할 경우 데이터가 포함된 레코드가 삭제되므로 삭제하지 말아야 할
        데이터도 함께 삭제되는 문제
*/
SELECT * FROM DBA_USERS;

/* 2020-10-19 User Creation 
    Syntax____
    CREATE USER [USER_NAME]
    IDENTIFIED BY "[PASSWORD]";
    
    PROCESS
     - USER CREATION
     - GRANT PRIVILEAGE
    EXEC
     1. LOCAL WORK
     2. LOCAL SHUTDOWN --> SERVER WORK
*/
CREATE USER HOONZZANG
IDENTIFIED BY "7777"; --> LACKS CREATE SESSION PRIVILEAGE 
-- DCL : GRANT[REVOKE] [PRIV_NAME | ROLE: 권한의 집합]
GRANT CREATE SESSION TO HOONZZANG;  -- CONNECT
REVOKE CREATE SESSION FROM HOONZZANG;

-- DROP USER
DROP USER HOONZZANG;

/* DBA ACCOUNT CREATION 
    SYS --> HOONZZANG :: 8888 :: DBA ROLE
   DEV ACCOUNT CREATION 
    DBA --> HOON :: 0000 :: CONNECT, RESOURCE ROLE
*/
-- DBA :: <- SYS
CREATE USER HOONZZANG
IDENTIFIED BY "8888";
GRANT DBA TO HOONZZANG;

-- DEV :: <-- DBA
CREATE USER HOON
IDENTIFIED BY "0000";
GRANT CONNECT, RESOURCE TO HOON;

-- USER CHECK
SELECT * FROM DBA_USERS;

-- DROP ANONYMOUS ACCOUNT
DROP USER ANONYMOUS;

-- 객체 권한 조회
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_TAB_PRIVS_MADE;
SELECT * FROM USER_TAB_PRIVS_RECD;

-- ROLE에 부여된 시스템 || 객체 권한
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'DBA';
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RESOURCE';
SELECT * FROM USER_ROLE_PRIVS;

/* USER CREATION
    SYN___
    CREATE USER [USER_NAME] IDENTIFIED BY "[PASSWORD]"
    *DEFAULT TABLESPACE [TBS_NAME]
    TEMPORATY TABLESPACE [TBS_NAME]
    *QUOTA [INTEGER M | UNLIMITED] ON [TBS_NAME];
*/

/* DBA :: USERS  :: UNLIMITED */
ALTER USER HOONZZANG
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

/* DEV :: USERS  :: UNLIMITED */
ALTER USER HOON
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

SELECT * FROM DBA_USERS;

/* 테이블 설계 시 알아야 할 내용 
   0. PROCESS 
      ENTITY 도출 --> ENTITY 배치 --> ENTITY RELATIONSHIP
      
   1. ENTITY
      - KEY ENTITY
      - MAIN ENTITY
      - ACTION ENTITY
      - PRODUCTION ENTITY
   2. NORMALIZATION
   3. ATTRIBUTE
   4. IDENTIFIER
   5. RELATIONSHIP
   6. DOMAIN
*/

/* 2020-10-20 :: TABLE
    PROCESS
      1. CREATE :: ATTRIBUTES 
      2. CREATE :: TABLESPACE 
      3. ALTER  :: CONSTRAINTS
      4. CREATE :: SYNONYM  --> 소유주만 사용가능
                :: PUBLIC SYNONYM --> 소유주 뿐만 아니라 권한을 부여받은 계정도 사용
                   --> DML구문에서만 사용 가능 
      5. GRANT  :: OBJECT PRIVILEGE
      
    SYNTAX____________
    CREATE TABLE [TAB_NAME](
      [COL_NAME]    [DATA-TYPE]     [PROPERTY],
          :              :               :    ,
      [COL_NAME]    [DATA-TYPE]     [PROPERTY],
      CONSTRAINT 
    )TABLESPACE [TBS_NAME];
*/
-- 1. DBA :: STORE TABLE(ST)
CREATE TABLE STORES(
 ST_CODE    NCHAR(4),
 ST_NAME    NVARCHAR2(100),
 ST_ADDR    NVARCHAR2(100)
)TABLESPACE USERS;

/* CONSTRAINTS 
    : 특정 테이블의 특정 컬럼에 입력 제한 용도
    1. PRIMARY KEY
       - 하나의 테이블에 한 개의 PK 지정 가능
       - UNIQUE
       - NOT NULL
*/
-- ADD
ALTER TABLE STORES
ADD CONSTRAINT ST_CODE_PK  PRIMARY KEY(ST_CODE);
-- DROP
ALTER TABLE STORES
DROP CONSTRAINT ST_CODE_PK;

-- DATA INSERT
INSERT INTO STORES(ST_CODE, ST_NAME, ST_ADDR) 
VALUES('I001', '훈이네마켓', '인천시 미추홀구 학익동');
INSERT INTO STORES(ST_CODE, ST_NAME, ST_ADDR) 
VALUES('I001', '훈이네마켓', '인천시 미추홀구 학익동'); --> X
INSERT INTO STORES(ST_CODE, ST_NAME, ST_ADDR) 
VALUES( NULL, '훈이네마켓', '인천시 미추홀구 학익동');  --> X

   /* ALTER 의 활용 
    SUB COMMAND :   ADD --> 컬럼 추가
                    ADD CONSTRAINT --> 제약조건 추가
                    DROP COLUMN --> 컬럼 제거
                    DROP CONSTRAINT --> 제약조건 제거
                    MODIFY  --> 컬럼 수정
   */
   -- 컬럼 수정(DATA TYPE, PROPERTY)
   ALTER TABLE STORES MODIFY ST_ADDR NOT NULL;
   -- 컬럼 제거
   ALTER TABLE STORES DROP COLUMN ST_ADDR;
   -- 컬럼 추가
   ALTER TABLE STORES ADD ST_ADDR  NVARCHAR2(100);
   -- -- 컬럼 수정(DATA TYPE, PROPERTY)
   UPDATE STORES SET ST_ADDR = '인천광역시 미추홀구 학익동' WHERE ST_CODE = 'I001';
   ALTER TABLE STORES MODIFY ST_ADDR NOT NULL;
   
/* SYNONYM
    : 특정 테이블의 호출 이름을 별칭으로 가능
    : SYNONYM을 CREATE한 계정만이 사용 가능
    : DML구문(INSERT, UPDATE, DELETE, SELECT)사용 가능
    SYNTAX________
    CREATE SYNONYM [TAB_ALIAS] FOR [OBJECT]
*/
CREATE SYNONYM ST FOR HOONZZANG.STORES;
DROP SYNONYM ST;
SELECT * FROM ST;

/* OBJECT PRIVILEGE :: 개체 소유자
    SYNTAX___________
    GRANT [OBJ_PRIV_NAME], ... , [OBJ_PRIV_NAME] ON [OBJECT] TO [SCHEMA]
*/
GRANT SELECT ON HOONZZANG.STORES TO HOON;
-- HOON조회
SELECT * FROM HOONZZANG.STORES;

--> DBA : PUBLIC SYNONYM 
CREATE PUBLIC SYNONYM ST FOR HOONZZANG.STORES;
   --> HOON 사용
   SELECT * FROM ST;
   
-- 2. DBA :: GOODS TABLE(GO)
CREATE TABLE GOODS(
 GO_CODE        NCHAR(4),
 GO_NAME        NVARCHAR2(50),
 GO_PRICE       NUMBER(7,0),
 GO_COMMENTS    NVARCHAR2(100)
)TABLESPACE USERS;

 -- PROPERTY
 ALTER TABLE GOODS
 MODIFY GO_NAME NOT NULL
 MODIFY GO_PRICE DEFAULT 0;
 
 -- 2-3. CONSTRAINTS 
 ALTER TABLE GOODS
 ADD CONSTRAINT GO_CODE_PK   PRIMARY KEY(GO_CODE);
 
 -- 2-4. SYNONYM
 CREATE PUBLIC SYNONYM GO FOR HOONZZANG.GOODS;
 
 -- 2-5. GRANT 
 GRANT INSERT, SELECT ON HOONZZANG.GOODS TO HOON;
 
 -- 2-6. TEST DATA  <-- DEV
 INSERT INTO GO(GO_CODE, GO_NAME, GO_PRICE, GO_COMMENTS) 
 VALUES('1001', '새우깡', 1500, '일반');
 INSERT INTO GO(GO_CODE, GO_NAME, GO_PRICE, GO_COMMENTS) 
 VALUES('1002', '새우깡', 3000, '노래방');
 
 SELECT * FROM GO;
 
-- 3. DBA :: CUSTOMER TABLE(CM)
CREATE TABLE CUSTOMER(
 CM_CODE    NCHAR(5),
 CM_NAME    NVARCHAR2(5)
)TABLESPACE USERS;

 -- PROPERTY
 
 -- 3-3. CONSTRAINTS 
 ALTER TABLE CUSTOMER
 ADD CONSTRAINT CM_CODE_PK  PRIMARY KEY(CM_CODE);
 
 -- 3-4. SYNONYM
 CREATE PUBLIC SYNONYM CM FOR HOONZZANG.CUSTOMER;
 
 -- 3-5. GRANT
 GRANT INSERT,SELECT ON HOONZZANG.CUSTOMER TO HOON;
 
 -- 3-6. TEST DATA  <-- DEV
 INSERT INTO CM(CM_CODE, CM_NAME) VALUES('C0001', '다사가');
 INSERT INTO CM(CM_CODE, CM_NAME) VALUES('C0002', '더없어');
 INSERT INTO CM(CM_CODE, CM_NAME) VALUES('C0003', '또왔어');
 INSERT INTO CM(CM_CODE, CM_NAME) VALUES('C0000', '비회원');
 
 SELECT * FROM CM;
 
 COMMIT;
 
 -- CM_PHONE ADD :: DBA
 ALTER TABLE CUSTOMER
 ADD CM_PHONE   NCHAR(11);
 -- CM_PHONE UNIQUE CONSTRAINT ADD  :: DBA
 ALTER TABLE CUSTOMER
 ADD CONSTRAINT CM_PHONE_UK     UNIQUE(CM_PHONE);
 
 GRANT UPDATE ON HOONZZANG.CUSTOMER TO HOON;
 -- TEST DATA :: DEV
 UPDATE CM SET CM_PHONE = '01056808050' WHERE CM_CODE = 'C0001';
 UPDATE CM SET CM_PHONE = '01056808050' WHERE CM_CODE = 'C0002';  --> X
 
 SELECT * FROM CM;
 
 
-- EMPOLYEES TABLE(EM) :: DBA
CREATE TABLE EMPLOYEES(
 EM_STCODE      NCHAR(4),
 EM_CODE        NCHAR(4),
 EM_PWD         NVARCHAR2(10),
 EM_NAME        NVARCHAR2(5)
)TABLESPACE USERS;

 -- PROPERTY
 ALTER TABLE EMPLOYEES
 MODIFY EM_PWD  NOT NULL
 MODIFY EM_NAME NOT NULL;
 
 -- CONSTRAINTS
 ALTER TABLE EMPLOYEES
 ADD CONSTRAINT EM_STCODE_CODE_PK PRIMARY KEY(EM_STCODE, EM_CODE)
 ADD CONSTRAINT EM_STCODE_FK    FOREIGN KEY(EM_STCODE) REFERENCES STORES(ST_CODE);
 
 -- SYNONYM
 CREATE PUBLIC SYNONYM "EM" FOR HOONZZANG.EMPLOYEES;
 
 -- GRANT 
 GRANT ALL ON HOONZZANG.EMPLOYEES TO HOON;
 
 -- TEST DATA :: DEV
 INSERT INTO "EM"(EM_STCODE, EM_CODE, EM_PWD, EM_NAME) 
 VALUES('I001', 'E001', '1234', '다팔아');
 INSERT INTO "EM"(EM_STCODE, EM_CODE, EM_PWD, EM_NAME) 
 VALUES('I002', 'E002', '1234', '다팔아');  --> X
 
 SELECT * FROM "EM";
 COMMIT;
 
-- TABLE CREATE :: STOCK
CREATE TABLE STOCK(
SC_GOCODE   NCHAR(4),
SC_CODE     DATE,
SC_STOCKS   NUMBER(3,0),
SC_EXPIRE   DATE
)TABLESPACE USERS;

-- PROPERTY
ALTER TABLE STOCK
MODIFY SC_STOCKS DEFAULT 0
MODIFY SC_EXPIRE NOT NULL;

-- CONSTRAINT 
ALTER TABLE STOCK
ADD CONSTRAINT SC_GOCODE_CODE_PK PRIMARY KEY (SC_GOCODE, SC_CODE)
ADD CONSTRAINT SC_GOCODE_FK FOREIGN KEY (SC_GOCODE) REFERENCES HOONZZANG.GOODS(GO_CODE);

-- SYNONYM
CREATE PUBLIC SYNONYM SC FOR HOONZZANG.STOCK;

-- GRANT
GRANT ALL ON SC TO HOON;

-- INSERT
INSERT INTO SC (SC_GOCODE, SC_CODE, SC_STOCKS, SC_EXPIRE) 
VALUES ('1001',SYSDATE,10,'20221020');

-- COMMIT
COMMIT;

-- TEST
SELECT * FROM USER_TAB_COLS WHERE TABLE_NAME = 'STOCK';

SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'HOON';

-- CHECK
SELECT * FROM HOONZZANG.STORES;
SELECT * FROM USER_TABLES;
SELECT * FROM USER_TAB_COLS WHERE TABLE_NAME = 'EMPLOYEES';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEES';


/* 2020-10-21 팀실습 
1. SYS___ 
   SELECT * FROM DBA_USERS;
   DROP USER [USER_NAME] CASCADE;
2. SYS___
   DBA_TEAM 생성 및 권한 부여
3. DBA____
   STORE, GOODS, CUSTOMER, EMPLOYEE, STOCK 테이블 생성 후 
     PROPERTY, CONSTRIANT, PUBLIC SYNONYM 생성
4. DBA_____
   DEV_TEAM 계정 생성 후 테이블 접근(SELECT) 권한 부여
   DEV1_TEAM :: STORE, EMPLOYEE :: INSERT, UPDATE 
   DEV2_TEAM :: GOODS, STOCK :: INSERT, UPDATE 
   DEV3_TEAM ::  
   DEV4_TEAM :: CUSTOMER :: INSERT, UPDATE

5. CHECK

-- USER CHECK :: DBA
SELECT * FROM DBA_USERS;

-- TABLE CHECK :: DBA
SELECT * FROM USER_TABLES;
SELECT * FROM USER_TAB_COLS WHERE TABLE_NAME = '';
SELECT * FROM USER_CONSTRAINT WHERE TABLE_NAME = '';

-- PRIVILEGES :: DBA
SELECT * FROM USER_TAB_PRIVS WHERE GRANTEE = 'HOON';
SELECT * FROM USER_TAB_PRIVS_MADE WHERE GRANTEE = 'HOON';

-- PRIVILEGES :: DEV
SELECT * FROM USER_TAB_PRIVS_RECD;

*/
GRANT SELECT, INSERT, UPDATE ON HOONZZANG.STORES TO HOON;
GRANT SELECT, INSERT, UPDATE ON HOONZZANG.GOODS TO HOON; 
GRANT SELECT, INSERT, UPDATE ON HOONZZANG.CUSTOMER TO HOON;
GRANT SELECT, INSERT, UPDATE ON HOONZZANG.EMPLOYEES TO HOON; 
GRANT SELECT, INSERT, UPDATE ON HOONZZANG.STOCK TO HOON; 

/* 2020-10-21 */
-- ORDERS(OD) :: DBA
CREATE TABLE ORDERS(
 OD_CODE    DATE,
 OD_EMSTCODE NCHAR(4),
 OD_EMCODE  NCHAR(4),
 OD_CMCODE  NCHAR(5),
 OD_STATE   NCHAR(1)
)TABLESPACE USERS;

  -- PROPERTY
  ALTER TABLE ORDERS
  MODIFY OD_EMCODE NOT NULL
  MODIFY OD_EMSTCODE NOT NULL
  MODIFY OD_CMCODE NOT NULL
  MODIFY OD_STATE NOT NULL;

  -- CONSTRAINTS
  ALTER TABLE ORDERS
  ADD CONSTRAINT OD_CODE_PK   PRIMARY KEY(OD_CODE) 
  ADD CONSTRAINT OD_EMSTCODE_EMCODE_FK FOREIGN KEY(OD_EMSTCODE, OD_EMCODE) REFERENCES EMPLOYEES(EM_STCODE, EM_CODE)
  ADD CONSTRAINT OD_CMCODE_FK FOREIGN KEY(OD_CMCODE) REFERENCES CUSTOMER(CM_CODE);

  -- SYNONYM
  CREATE PUBLIC SYNONYM OD FOR HOONZZANG.ORDERS;

  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON HOONZZANG.ORDERS TO HOON;

-- ORDERDETAIL(OT) :: DBA
CREATE TABLE ORDERDETAIL(
 OT_ODCODE   DATE,
 OT_GOCODE  NCHAR(4),
 OT_QTY     NUMBER(2,0),
 OT_STATE   NCHAR(1)
)TABLESPACE USERS;

  -- PROPERTY
  ALTER TABLE ORDERDETAIL
  MODIFY OT_QTY DEFAULT 0
  MODIFY OT_STATE NOT NULL;
  
  -- CONSTRAINTS
  ALTER TABLE ORDERDETAIL
  ADD CONSTRAINT OT_ODCODE_GOCODE_PK    PRIMARY KEY(OT_ODCODE, OT_GOCODE)
  ADD CONSTRAINT OT_ODCODE_FK   FOREIGN KEY(OT_ODCODE) REFERENCES ORDERS(OD_CODE)
  ADD CONSTRAINT OT_GOCODE_FK   FOREIGN KEY(OT_GOCODE) REFERENCES GOODS(GO_CODE);
  
  -- SYNONYM
  CREATE PUBLIC SYNONYM OT FOR HOONZZANG.ORDERDETAIL;
  
  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON HOONZZANG.ORDERDETAIL TO HOON;
  
  
-- POINTS(PO) :: DBA
CREATE TABLE POINTS(
 PO_CMCODE  NCHAR(5),
 PO_ODCODE  DATE,
 PO_STATE   NUMBER(1,0),
 PO_AMOUNT  NUMBER(6,0)
)TABLESPACE USERS;

  -- PROPERTY
  ALTER TABLE POINTS
  MODIFY PO_STATE   NOT NULL
  MODIFY PO_AMOUNT  DEFAULT 0;
  
  -- CONSTRAINTS
  ALTER TABLE POINTS
  ADD CONSTRAINT PO_CMCODE_ODCODE_PK    PRIMARY KEY(PO_CMCODE, PO_ODCODE)
  ADD CONSTRAINT PO_CMCODE_FK   FOREIGN KEY(PO_CMCODE) REFERENCES CUSTOMER(CM_CODE)
  ADD CONSTRAINT PO_ODCODE_FK   FOREIGN KEY(PO_ODCODE) REFERENCES ORDERS(OD_CODE);
  
  -- SYNONYM
  CREATE PUBLIC SYNONYM PO FOR HOONZZANG.POINTS;
  
  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON HOONZZANG.POINTS TO HOON;
  
/* 날짜데이터의 DEFAULT VALUE 지정 
   STOCK :: SC_CODE :: SYSDATE
   ORDERS:: OD_CODE :: SYSDATE
*/
SELECT SYSDATE FROM DUAL;

-- DBA --> DEV  :: GRANT - ALTER
GRANT ALTER ON HOONZZANG.STORES TO HOON;
GRANT ALTER ON HOONZZANG.EMPLOYEES TO HOON;
GRANT ALTER ON HOONZZANG.CUSTOMER TO HOON;
GRANT ALTER ON HOONZZANG.GOODS TO HOON;
GRANT ALTER ON HOONZZANG.STOCK TO HOON;
GRANT ALTER ON HOONZZANG.ORDERS TO HOON;
GRANT ALTER ON HOONZZANG.ORDERDETAIL TO HOON;
GRANT ALTER ON HOONZZANG.POINTS TO HOON;

-- ALTER권한을 가진 DEV가 실행
ALTER TABLE HOONZZANG.STOCK MODIFY SC_CODE DEFAULT SYSDATE;
ALTER TABLE HOONZZANG.ORDERS MODIFY OD_CODE DEFAULT SYSDATE;

/* 2020-10-21 */
/* DDL : DATA DEFINITION LANGUAGE
         : CREATE, ALTER, DROP
   DCL : DATA CONTROL LANGUAGE
         : GRANT, REVOKE 
   DML : DATA MANIPULATION LANGUAGE
         : INSERT, UPDATE, DELETE
 (S)QL : QUERY LANGUAGE
         : SELECT 
*/
/* INSERT INTO ~
    SYN_____
    INSERT INTO [TAB_NAME]([COL1_NAME], ..., [COLn_NAME]) 
    VALUES(VALUE1, ..., VALUEn);
    
    IMPORTANCE 
      :: RELATION이 설정되어 있다면 PARENT TABLE부터 CHILD TABLE 순서로 INSERT 수행
*/
SELECT * FROM USER_TAB_COLS WHERE TABLE_NAME = 'EMPLOYEES';

/* DML :: UPDATE ~ SET 
    SYNTAX__________
    UPDATE [TAB_NAME] SET [COL_NAME] = [VALUE];
    UPDATE [TAB_NAME] SET [COL_NAME] = [VALUE] WHERE [COL_NAME] [COMPARE] [VALUE] ;
*/
SELECT * FROM PO;
UPDATE PO SET PO_AMOUNT = 1000;
ROLLBACK;

UPDATE PO SET PO_AMOUNT = 10000 WHERE PO_CMCODE = 'C0010';


/* 3번 : ORDERS & ORDERDETAIL UPDATE 
    SELECT * FROM OD;
    SELECT * FROM OT;
*/  
UPDATE OD SET OD_CODE = SYSDATE -1 WHERE OD_CODE = '20201021154248';

/* DELETE 
    SYNTAX___________
    DELETE FROM [TAB_NAME];
    DELETE FROM [TAB_NAME] WHERE [COL_NAME] [COMPARE] [VALUE];
*/

/* 2020-10-22 SELECT 
    SYNTAXA__________
    5 * SELECT      [COL] AS "[ALIAS]", ..., [COL] AS "ALIAS"
    1 * FROM        [TAB | VIEW | INLINE-VIEW]
    2 * WHERE       [CONDITION]
    3   GROUP BY    [COL], ..., [COL]
    4   HAVING      [GROUP CONDITION]
    6   ORDER BY    [COL][ASC|DESC], ..., [COL][ASC|DESC]
*/
/* WHERE 
    COMPARATIVE OPERATOR :: > >= = !=(<>) < <= 
    COMBINED OPERATOR :: AND, OR
    ARITHMETIC OPERATOR :: + - * /
    SELECT OPERATOR :: IN(LIST), LIKE, IS NULL, NOT
*/
-- 특정 직원정보 검색
SELECT  EM_STCODE AS "STCODE", 
        EM_CODE AS "EMCODE", 
        EM_NAME AS "EMNAME", 
        EM_LEVEL AS "LEVEL" 
FROM EM
WHERE EM_STCODE = 'I001' AND EM_CODE = '1001'; 

-- 모든 상품 검색 QUERY
SELECT  GO_CODE AS GOCODE, 
        GO_NAME AS GONAME,
        GO_PRICE AS GOPRICE,
        GO_COMMENTS AS GOCOMMENTS
FROM GO;

-- 특정 상품 검색 QUERY
SELECT  GO_CODE AS GOCODE, 
        GO_NAME AS GONAME,
        GO_PRICE AS GOPRICE,
        GO_COMMENTS AS GOCOMMENTS
FROM GO
WHERE GO_CODE = '1001';

--
SELECT 
FROM OT
WHERE OT_ODECODE = '' AND  OT_GOCODE = '';

SELECT 
FROM OT
WHERE OT_ODECODE = '' AND  OT_GOCODE = '';
SELECT *
FROM GO
WHERE GO_CODE IN(SELECT DISTINCT OT_GOCODE FROM OT);

SELECT *
FROM GO
WHERE GO_CODE = '1001' OR GO_CODE = '2001' OR GO_CODE = '3001';


-- IS NULL
CREATE TABLE TESTS(
    T_CODE      NCHAR(1),
    T_PRICE     NUMBER(6,0),
    T_QTY       NUMBER(2,0)
)TABLESPACE USERS;

INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('1', 100, 1);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('2', 200, NULL);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('3', NULL, 10);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('4', 400, 10);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('5', NULL, NULL);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('6', 600, 5);
INSERT INTO TESTS(T_CODE, T_PRICE, T_QTY) VALUES('7', 700, 7);

SELECT * FROM TESTS;
-- 금액(T_PRICE * T_QTY)이 1000이상인 레코드 출력
SELECT *
FROM TESTS
WHERE (T_PRICE*T_QTY) >= 1000;

SELECT T_CODE, T_PRICE, T_QTY, COALESCE(T_PRICE*T_QTY, T_PRICE, T_QTY, 1)
FROM TESTS;

SELECT *
FROM TESTS
WHERE T_PRICE IS NOT NULL;

/* LIKE를 이용한 검색 
    WILD CARD :: % : 모든 문자를 대체
              :: _ : 하나의 문자를 대체
*/

SELECT * 
FROM CM
--WHERE CM_NAME LIKE '%김%';
-- APLLICATION
WHERE CM_NAME LIKE '%' || '김' || '%';


SELECT * 
FROM CM
WHERE CM_NAME LIKE '김%';
SELECT * 
FROM CM
WHERE CM_NAME LIKE '김____';

SELECT *
FROM CM
WHERE CM_CODE LIKE '%' || '05' || '%' OR
      CM_NAME LIKE '%' || '05' || '%' OR
      CM_PHONE LIKE '%' || '05' || '%';

SELECT *
FROM (SELECT CM_CODE || CM_NAME || CM_PHONE AS FULLTEXT FROM CM)
WHERE FULLTEXT LIKE '%' || '05' || '%';

