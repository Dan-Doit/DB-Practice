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


SELECT * FROM ST;


SELECT *
FROM CM 
WHERE CM_CODE IN (SELECT OD_CMCODE AS TESTS FROM OD WHERE OD_EMCODE = 'G001')  AND (CM_PHONE LIKE '%'|| '5672' || '%' OR  CM_PHONE LIKE '%'|| '5674' || '%');

SELECT *
FROM CM
WHERE CM_CODE IN (SELECT OD_CMCODE FROM OD WHERE OD_EMCODE ='G001') AND (CM_NAME LIKE '%병사%' OR CM_NAME LIKE '%시민%');


INSERT INTO ST (ST_CODE, ST_NAME, ST_ADDR) VALUES ('D003','해골','서울시 강남구');

SELECT *
FROM CM
WHERE CM_NAME LIKE '%' || (SELECT ST_NAME FROM ST WHERE ST_CODE = 'D003') || '%';

DELETE FROM ST WHERE ST_NAME = (SELECT ST_NAME FROM ST WHERE ST_CODE = 'D003');
COMMIT;
SELECT * FROM ST;












SELECT * FROM OD;
SELECT * FROM "EM";
SELECT * FROM CM;
-- 고길동이 판 사람들 중에 핸드폰 뒷자리가 77인사람
SELECT *
FROM "CM"
WHERE CM_CODE IN(SELECT OD_CMCODE FROM OD WHERE OD_EMCODE = 'G001') AND CM_PHONE = (SELECT CM_PHONE FROM CM WHERE CM_PHONE LIKE '%77'); 

-- D003 -> ST번호
-- CM 사람들중에 해골이 들어간 사람들 찾기

SELECT *
FROM CM
WHERE CM_NAME LIKE '%' || (SELECT ST_NAME FROM ST WHERE ST_CODE = 'D003')||'%' ;
 

COMMIT;





/* JOIN과 GROUP BY 활용 예제 */
/* 특정일(특정범위)의 상품별 판매 현황 
    -- 일일 매출현황
    -- 월별 매출현황
    ---------------------------------------------------
      상품코드     상품명       주문건수       매출액
       OT GO        GO           OT        OT * GO
    ---------------------------------------------------*/
CREATE OR REPLACE VIEW ODINFO AS
SELECT 
OT_ODCODE AS ODCODE,
GO_CODE AS GOCODE,
GO_NAME AS GONAME,
OT_ODCODE AS CNT,
OT_QTY AS QTY,
OT_QTY * GO_PRICE AS AMOUNT
FROM OT INNER JOIN GO ON GO.GO_CODE = OT.OT_GOCODE;

SELECT GOCODE, GONAME, COUNT(ODCODE), SUM(AMOUNT)
FROM ODINFO
WHERE TO_CHAR(ODCODE,'YYYYMMDD') >= '20200820' AND TO_CHAR(ODCODE,'YYYYMMDD') <= '20201020'
GROUP BY GOCODE, GONAME;




-- 월별 주문량
SELECT SUBSTR(ODCODE,1,6), COUNT(SUBSTR(ODCODE,1,6))
FROM(SELECT ODCODE
FROM ODINFO
GROUP BY ODCODE)ACE
GROUP BY SUBSTR(ODCODE,1,6);
-- 월별 금액
SELECT 
TO_CHAR(ODCODE,'YYYYMM'),
SUM(AMOUNT)
FROM ODINFO
GROUP BY TO_CHAR(ODCODE,'YYYYMM');



/* 특정 상품의 월별 매출 추이 
    --------------------------------------
      매출월        주문건수       매출액
    --------------------------------------*/
SELECT 
A.HH AS 판매월,
A.QQ AS 주문수량,
B.QQ AS 총금액
FROM 
(SELECT 
SUBSTR(ODCODE,1,6) AS HH, 
COUNT(SUBSTR(ODCODE,1,6)) AS QQ
FROM(SELECT ODCODE
FROM ODINFO
GROUP BY ODCODE)ACE
GROUP BY SUBSTR(ODCODE,1,6))A INNER JOIN
(SELECT 
TO_CHAR(ODCODE,'YYYYMM') AS HH,
SUM(AMOUNT) AS QQ
FROM ODINFO
GROUP BY TO_CHAR(ODCODE,'YYYYMM'))B
ON A.HH = B.HH;


/* 특정월의 베스트 상품(판매갯수) 현황 
    ------------------------------------------------------
      매출월    상품코드    상품명    주문건수       매출액
    ------------------------------------------------------*/
    SELECT *
    FROM ODINFO;
    
    -- 맥스값 만들기
    SELECT 날짜,MAX(상품수량)
    FROM TT
    GROUP BY 날짜;
    
    -- 값 불러오기
   CREATE OR REPLACE VIEW TT AS  
   SELECT 
   TO_CHAR(ODCODE,'YYYYMM') AS 날짜, 
   GONAME AS 상품이름,
   GOCODE AS 상품코드,
   SUM(QTY) AS 상품수량,
   SUM(AMOUNT) AS 총가격
   FROM ODINFO
   GROUP BY TO_CHAR(ODCODE,'YYYYMM'),GONAME,GOCODE;
   
   
   SELECT * 
   FROM TT
   WHERE (날짜, 상품수량) IN(SELECT 날짜,MAX(상품수량)
   FROM TT
   GROUP BY 날짜);
   


CREATE OR REPLACE VIEW ODINFO AS
SELECT 
OT_ODCODE AS ODCODE,
GO_CODE AS GOCODE,
GO_NAME AS GONAME,
OT_ODCODE AS CNT,
OT_QTY AS QTY,
OT_QTY * GO_PRICE AS AMOUNT
FROM OT INNER JOIN GO ON GO.GO_CODE = OT.OT_GOCODE;

/* 시간대별 매출추이 
    --------------------------------
      시간     평균주문건수  평균매출액
    --------------------------------*/

SELECT TO_CHAR(OD_CODE,'DDHH24') FROM OD
GROUP BY TO_CHAR(OD_CODE,'DDHH24') ;

SELECT 
AA.HH AS 시간,
AA.AG AS 평균건수,
TO_CHAR(BB.AG,'999,999,0') AS 평균매출액
FROM(
SELECT  
SUBSTR(TIMES,3,2) AS HH,
ROUND(SUM(CNT)/COUNT(TIMES),1) AS AG
FROM(

SELECT
TO_CHAR(OD_CODE,'DDHH24') AS TIMES,
COUNT(*) AS CNT
FROM OD
GROUP BY TO_CHAR(OD_CODE,'DDHH24')

)QQ
GROUP BY SUBSTR(TIMES,3,2))AA INNER JOIN (
-- INNER JOIN
SELECT 
SUBSTR(HH,3,2) AS HH,
ROUND(SUM(AMOUNT)/COUNT(HH),0) AS AG
FROM(
(SELECT 
TO_CHAR(ODCODE,'DDHH24') AS HH,
SUM(AMOUNT) AS AMOUNT
FROM ODINFO
GROUP BY TO_CHAR(ODCODE,'DDHH24')))
GROUP BY SUBSTR(HH,3,2))BB
-- ON 
ON AA.HH = BB.HH;



/* 요일별 매출추이 
    --------------------------------
      요일     평균주문건수  평균매출액
    --------------------------------*/
   SELECT 
   AA.DD AS 요일,
   AA.CC AS 평균주문건수,
   TO_CHAR(BB.CC,'999,999,0') AS 평균매출액
   FROM(
   SELECT TO_CHAR(TO_DATE(DD, 'YYYYMMDD'),'DAY') AS DD,
          ROUND(AVG(CC),1) AS CC
   FROM(
   
   SELECT TO_CHAR(OD_CODE, 'YYYYMMDD') AS DD,
   COUNT(OD_CODE) AS CC
   FROM OD
   GROUP BY TO_CHAR(OD_CODE, 'YYYYMMDD'))AA
   
   GROUP BY TO_CHAR(TO_DATE(DD, 'YYYYMMDD'),'DAY'))AA
   INNER JOIN(
     SELECT TO_CHAR(TO_DATE(DD, 'YYYYMMDD'),'DAY') AS DD,
          AVG(CC) AS CC
   FROM(
   
   SELECT TO_CHAR(ODCODE, 'YYYYMMDD') AS DD,
   SUM(AMOUNT) AS CC
   FROM ODINFO
   GROUP BY TO_CHAR(ODCODE, 'YYYYMMDD'))AA
   
   GROUP BY TO_CHAR(TO_DATE(DD, 'YYYYMMDD'),'DAY'))BB
   ON AA.DD = BB.DD;


/* OUTER JOIN의 활용예제 */

-- 특정 상점의 직원의 로그인과 로그아웃 횟수 기록 출력
/*
-----------------------------------------------------
사원코드      사원명       로그인횟수       로그아웃 횟수
-----------------------------------------------------*/

-- RIGHT OUTER JOIN
SELECT 
COALESCE(AA.CODE,BB.CODE) AS CODE,
COALESCE(LOGIN,0) AS LOGIN,
COALESCE(LOGOUT,0) AS LOGOUT
FROM
    (SELECT 
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGIN
     FROM HI 
     WHERE HI_STATE = 1
     GROUP BY HI_EMCODE)AA 
FULL OUTER JOIN(
-- JOIN
     SELECT 
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGOUT
     FROM HI 
     WHERE HI_STATE = -1
     GROUP BY HI_EMCODE)BB ON AA.CODE = BB.CODE;



-- FILL OUTER JOIN

SELECT 
EM_CODE AS 직원코드,
EM_NAME AS 직원명,
COALESCE(LOGIN, 0) AS 로그인횟수,
COALESCE(LOGOUT,0) AS 로그아웃횟수
FROM(
     SELECT 
     COALESCE(AA.CODE,BB.CODE) AS CODE,
     COALESCE(LOGIN,0) AS LOGIN,
     COALESCE(LOGOUT,0) AS LOGOUT
FROM
    (SELECT 
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGIN
     FROM HI 
     WHERE HI_STATE = 1
     GROUP BY HI_EMCODE)AA 
FULL OUTER JOIN(
-- JOIN
     SELECT 
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGOUT
     FROM HI 
     WHERE HI_STATE = -1
     GROUP BY HI_EMCODE)BB ON AA.CODE = BB.CODE)AA
-- JOIN
RIGHT OUTER JOIN "EM" ON EM_CODE = AA.CODE
-- 특정상점
WHERE EM_STCODE = 'D002';





/* 2. 특정 상점의 모든 직원중 로그인 횟수가 가장 많은 직원의 정보 출력 
    ----------------------------------------
      사원코드   사원명   로그인횟수   사원등급
    ----------------------------------------*/

-- MAX 로그인
SELECT
YY AS YY,
MAX(LOGIN)
FROM(
     SELECT 
     HI.HI_EMSTCODE AS YY,
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGIN
     FROM HI 
     WHERE HI_STATE = 1
     GROUP BY HI_EMCODE,HI.HI_EMSTCODE)
GROUP BY YY;


-- 특정 상점의 제일 많이 로그인한사람 찾기
SELECT 
EM_CODE 사원코드,
EM_NAME 사원이름,
EM_LEVEL 사원등급,
COALESCE(LOGIN, 0) 로그인횟수
FROM(
     SELECT 
     EM_CODE AS CODE,
     COUNT(HI_STATE) AS LOGIN
     FROM HI LEFT OUTER JOIN "EM" ON "EM".EM_CODE = HI.HI_EMCODE
     WHERE HI_STATE = 1
     GROUP BY EM_CODE)AA 

RIGHT OUTER JOIN "EM" ON EM_CODE = AA.CODE

-- WHERE
WHERE (EM_STCODE,AA.LOGIN) IN(SELECT
YY AS YY,
MAX(LOGIN)
FROM(
     SELECT 
     HI.HI_EMSTCODE AS YY,
     HI_EMCODE AS CODE,
     COUNT(HI_STATE) AS LOGIN
     FROM HI 
     WHERE HI_STATE = 1
     GROUP BY HI_EMCODE,HI.HI_EMSTCODE)
     GROUP BY YY);




/* 3. 특정 상점의 모든 직원을 대상으로 직원별 판매실적을 출력
    ----------------------------------------
      사원코드   사원명   주문건수    매출액
      EM        EM      OD          OD, OT
    ----------------------------------------*/ 
-- 합계
SELECT 
OD_EMCODE AS CMCODE,
SUM(OT_QTY * GO_PRICE) AS AMOUNT
FROM OT INNER JOIN OD ON OT.OT_ODCODE = OD_CODE
INNER JOIN GO ON OT_GOCODE = GO_CODE
GROUP BY OD_EMCODE;

-- 주문
SELECT 
OD_EMCODE,
COUNT(OD_CODE)
FROM OD
GROUP BY OD_EMCODE;

SELECT 
EM_CODE AS 사원코드,
EM_NAME AS 사원이름,
ORDERS AS 주문건수,
AMOUNT AS 매출액
FROM(SELECT 
     OD_EMCODE AS EMCODE,
     SUM(OT_QTY * GO_PRICE) AS AMOUNT
     FROM OT INNER JOIN OD ON OT.OT_ODCODE = OD_CODE 
     INNER JOIN GO ON OT_GOCODE = GO_CODE
     GROUP BY OD_EMCODE)AA 
-- JOIN
INNER JOIN(
     SELECT 
     OD_EMCODE AS EMCODE,
     COUNT(OD_CODE) AS ORDERS
     FROM OD
     GROUP BY OD_EMCODE)BB
ON AA.EMCODE = BB.EMCODE RIGHT OUTER JOIN "EM" 
ON AA.EMCODE = "EM".EM_CODE

-- 특정상점
WHERE EM_STCODE = 'D001';



/* 4. 모든 상품의 정보 출력
    --------------------------------------------
      상품코드   상품명   가격    재고     유통기한
    --------------------------------------------*/
SELECT 
GO_CODE AS 상품코드,
GO_NAME AS 상품명,
GO_PRICE AS 가격,
COALESCE(SC_STOCKS, 0) AS 재고,
COALESCE(TO_CHAR(SC_EXPIRE,'YYYYMMDDHH24MISS'),'--------------') AS 유통기한
FROM GO LEFT OUTER JOIN SC ON GO_CODE = SC_GOCODE;

/* 5. 4의 결과중 판매가능한 상품정보를 출력
    --------------------------------------------
      상품코드   상품명   가격    재고     유통기한
    --------------------------------------------*/ 
-- VIEW 만들기
CREATE OR REPLACE VIEW CCC AS 
SELECT 
GO_CODE AS 상품코드,
GO_NAME AS 상품명,
GO_PRICE AS 가격,
COALESCE(SC_STOCKS, 0) AS 재고,
COALESCE(TO_CHAR(SC_EXPIRE,'YYYYMMDDHH24MISS'),'--------------') AS 유통기한
FROM GO LEFT OUTER JOIN SC ON GO_CODE = SC_GOCODE;

-- VIEW를 이용해 유효상품 출력
SELECT
상품코드, 상품명, 가격, 재고, 유통기한 
FROM CCC
WHERE 재고 > 0 AND 유통기한 > SYSDATE;


