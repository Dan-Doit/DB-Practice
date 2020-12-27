-- (1) 테이블 구성 살펴보기
    DESC EBDDSTU;
    
-- (2) ALIAS(별칭)으로 조회하기
    SELECT * FROM EBDDSTU;
    
    SELECT STUNUM AS 학생번호, STUNAME AS 이름,
           STUBIRTH AS 생년월일, GROUPNO AS 조
    FROM EBDDSTU;
    
-- (3) 중복데이터 제거 DISTINCT
    -- GROUPNO만 조회
    SELECT GROUPNO FROM EBDDSTU;
    SELECT DISTINCT GROUPNO FROM EBDDSTU;
    
-- (4) 정렬 ORDER BY
--  1) 오름차순 ASC
    SELECT DISTINCT GROUPNO 
    FROM EBDDSTU
    ORDER BY GROUPNO ASC;
--  2) 내림차순 DESC
    SELECT DISTINCT GROUPNO 
    FROM EBDDSTU
    ORDER BY GROUPNO DESC;
    
-- (5) 두가지 이상 조건 검색
--  1) AND : 조건식1과 조건식2가 모두 참일때 TRUE, 하나라도 거짓이면 FALSE
--  2) OR : 조건식중 하나라도 참이면 TRUE, 둘다 거짓일때 FALSE

-- Q1. 학생번호가 2225이면서 1조인 사람 검색!
-- Q2. 학생번호가 2225 또는 2226인 학생중 7조인 학생을 조회!

-- A1. 지수정
    SELECT * 
    FROM EBDDSTU
    WHERE STUNUM = 2225 AND GROUPNO = 1;
    
-- A2. 하현수
    SELECT * 
    FROM  EBDDSTU
    WHERE (STUNUM=2225 OR STUNUM=2226) AND GROUPNO=7;

-- (6) 산술연산, 문자연산
    SELECT *
    FROM EBDDSTU
    WHERE STUNUM >= 2222;
    
    SELECT *
    FROM EBDDSTU
    WHERE STUNAME >='김' AND STUNAME <='이';
    


-- 같은 컬럼에서 여러가지 조건 검색
-- (7) IN 연산자

-- Q3. 1조, 3조, 5조인 학생 검색!
SELECT *
FROM EBDDSTU
WHERE GROUPNO=1 OR GROUPNO=3 OR GROUPNO=5
ORDER BY GROUPNO ASC;

SELECT *
FROM EBDDSTU
WHERE GROUPNO IN (1,3,5)
ORDER BY GROUPNO ASC;

/*
    SELECT
    FROM
    WHERE [COL_NAME] IN (DATA1, DATA2, DATA3..);
*/

--Q4. 학생번호가 2223이상 2225이하인 학생 조회
SELECT *
FROM EBDDSTU
WHERE STUNUM >=2223 AND STUNUM<=2225;

-- (8) BETWEEN A AND B : A부터 B사이의 데이터 검색
/*
    SELECT
    FROM
    WHERE [COL_NAME] BETWEEN (MIN) AND (MAX);
*/

SELECT *
FROM EBDDSTU
WHERE STUNUM BETWEEN 2223 AND 2225;

-- Q5. 학생번호가 2223이상 2225이하가 아닌(NOT) 학생 조회!
SELECT *
FROM EBDDSTU
WHERE STUNUM NOT BETWEEN 2223 AND 2225;


-- ★ (9) LIKE ★ --
/*
    SELECT
    FROM
    WHERE [COL_NAME] LIKE (.....);
*/

-- ex) 첫 글자가 '김'으로 시작하는 데이터 조회
SELECT *
FROM EBDDSTU
WHERE STUNAME LIKE '김%';

-- ex) 두번째 글자가 '종'인 데이터 조회
SELECT *
FROM EBDDSTU
WHERE STUNAME LIKE '_종%';

-- ex) 세번째 글자가 '준'인 데이터 조회
SELECT *
FROM EBDDSTU
WHERE STUNAME LIKE '__준';

-- ex) 이름중에 '지'가 포함된 사람 데이터 조회
SELECT *
FROM EBDDSTU
WHERE STUNAME LIKE '%지%';

-- ' _ ', ' % ' => 와일드카드
-- '_(언더바)' => 어떤 값이든 상관없이 한개의 문자 데이터를 의미
-- '%(퍼센트)' => 길이랑 상관없이 (문자 없는 경우 포함) 모든 문자 데이터를 의미

-- Q6. (학생이름)중 성이 '김', '이' 씨가 아닌 사람의 "이름" 만 조회! (별칭사용)
SELECT STUNAME AS 이름
FROM EBDDSTU
WHERE STUNAME NOT LIKE '김%' AND STUNAME NOT LIKE '이%';

/*
    (10) 대, 소문자를 바꿔주는 함수
         - UPPER : 모두 대문자로 변환
         - LOWER : 모두 소문자로 변환
         - INITCAP : 첫글자만 대문자, 나머지 소문자
*/

SELECT UPPER('aBcDeFg') AS "UPPER(대문자)"
FROM DUAL;

-- FROM DUAL : 임의로 출력값을 보여주는 창(가상의 테이블)

SELECT LOWER('aBcDeFg') AS "LOWER(소문자)"
FROM DUAL;

SELECT INITCAP('aBcDeFg') AS "INITCAP(첫글자 대문자)"
FROM DUAL;


/*
    (11) 문자열 길이를 구하는 LENGTH
*/

SELECT LENGTH('Abc/De+가나다123') AS 문자열길이
FROM DUAL;

-- Q.이름 세글자 미만인 학생의 이름과 글자수를 조회!
SELECT STUNAME, LENGTH(STUNAME)
FROM EBDDSTU
WHERE LENGTH(STUNAME)<3;

-- 문자의 크기를 조회(byte) : LENGTHB
-- '가', 'A', 'a', '#', '?' 의 문자크기 조회

SELECT LENGTHB('가') AS "한글 ('가')",
       LENGTHB('A') AS "대문자 ('A')",
       LENGTHB('a') AS "소문자 ('a')",
       LENGTHB('#') AS "특수문자 ('#')",
       LENGTHB('?') AS "특수문자 ('?')",
       LENGTHB('3') AS "숫자 ('3')",
       LENGTHB('ㄱ') AS "한글자음 ('ㄱ')",
       LENGTHB('ㅗ') AS "한글모음 ('ㅗ')"
FROM DUAL;

/*
    (12) 문자열 일부를 추출하는 SUBSTR
    SUBSTR('문자열데이터' or [COL_NAME], 시작위치, 추출길이)
*/

-- 문자열데이터
SELECT SUBSTR('HELLO!!', 1, 2)
FROM DUAL;

SELECT SUBSTR('HELLO!!', 3, 2)
FROM DUAL;

-- Q. EBDDSTU 테이블에서 태어난 해가 95인 사람의 이름과 생년월일을 검색!
SELECT STUNAME, STUBIRTH
FROM EBDDSTU
WHERE SUBSTR(STUBIRTH,3,2) = 95;

-- Q. EBDDSTU 테이블에서 생일이 7월인 사람의 이름과 날짜(일)를 검색! (별칭사용해서 구해보기)
SELECT STUNAME AS 이름, SUBSTR(STUBIRTH,9,2) AS 생일
FROM EBDDSTU
WHERE SUBSTR(STUBIRTH,6,2) = 07;

/*
    (13) 문자열 데이터 안에서 특정 문자 위치를 찾는 INSTR
    INSTR('문자열데이터' or [COL_NAME],'찾고자 하는 문자', 시작위치(기본값1),
            같은 문자일 경우 몇번째 문자인지(기본값1) )
*/

SELECT INSTR('HELLO, ORACLE!', 'B') AS INSTR1,       -- 첫번째 L
       INSTR('HELLO, ORACLE!', 'L', 5) AS INSTR2,    -- 5번째 글자부터 첫번째 L
       INSTR('HELLO, ORACLE!', 'L', 2, 3) AS INSTR3, -- 2번째 글자부터 세번째 L
       INSTR('HELLO, ORACLE!', 'O', 1, 1) AS INSTR4, -- 1번째 글자부터 첫번째 O
       INSTR('HELLO, ORACLE!', 'O', 1, 2) AS INSTR5  -- 1번째 글자부터 두번째 O
FROM DUAL;

/*
    (14) 특정문자를 다른 문자로 바꿔주는 REPLACE
    REPLACE('문자열데이터' or [COL_NAME], 찾는 문자, 바꿀 문자) : 찾은 문자 → 바꿀 문자
    REPLACE('문자열데이터' or [COL_NAME], 찾는 문자) : 찾은 문자 제거
*/

SELECT REPLACE('010-5680-8050', '-', ' ') AS "REPLACE 기본형",
       REPLACE('010-5680-8050', '-') AS "REPLACE 선택형"
FROM DUAL;

/*
    (15) 두 칼럼 데이터(또는 문자열데이터)를 합치는 CONCAT
    
*/

SELECT CONCAT(STUNUM, STUNAME)
FROM EBDDSTU;

-- 학생번호 : 학생이름
-- ex) 2201 : 강동훈

SELECT CONCAT(CONCAT(STUNUM,' : '), STUNAME) AS STU
FROM EBDDSTU;

SELECT STUNUM || ' : ' || STUNAME AS STU
FROM EBDDSTU;

-- CONCAT 대신 || => ( [Shift] + [￦] : | )

SELECT * FROM EBDDSTU WHERE STUNAME LIKE '%'||'김'||'%';

-- ★★★★★
SELECT * FROM EBDDSTU WHERE STUNAME LIKE '%'||?||'%';
SELECT * FROM EBDDSTU WHERE STUNAME LIKE '%?%';
-- ? 대신 '김' 으로 바뀌기 때문에 CONCAT을 이용

/*
    (16)데이터의 빈 공간을 특정 문자로 채우는 LPAD, RPAD
    - LPAD('문자열', 데이터자릿수, 빈공간에 채울문자(기본값 ' '))
    - RPAD('문자열', 데이터자릿수, 빈공간에 채울문자(기본값 ' '))
*/

    SELECT 'ICIA',
            LPAD('가나다', 7, '#') AS LPAD1,
            RPAD('ICIA', 7, '*') AS RPAD1,
            LPAD('ICIA', 7) AS LPAD2,
            RPAD('ICIA', 7) AS RPAD2
    FROM DUAL;
    
    SELECT STUNAME,LPAD(STUNAME,8,'#')
    FROM EBDDSTU;
    
    -- Ex1. 1) 주민번호 950713-1******
    -- 주어진 문자열 => 950713-1234567
    -- 주어진 문자열 => 951225-2234567 => 951225-2******
    -- RPAD, SUBSTR
    SELECT RPAD(SUBSTR(SSN,1,8),LENGTH(SSN),'*')
    FROM DUAL;
    
    
    -- Ex2. 2) 전화번호 010-****-8924
    -- 주어진 문자열 => 010-1234-8924
    -- 주어진 문자열 => 010-5678-1234 => 010-****-1234
    -- RPAD, SUBSTR, CONCAT
    SELECT RPAD(SUBSTR(PHONE,1,4),8,'*') || SUBSTR(PHONE,9)
    FROM DUAL;


-------------------------------------------------------------------------------
-- (1) 집합
-- A그룹 : 4조인 사람
SELECT *
FROM EBDDSTU
WHERE GROUPNO = 4;

-- B그룹 : 성이 '김'씨인 사람
SELECT * 
FROM EBDDSTU
WHERE STUNAME LIKE '김%';

-- 교집합(INTERSECT) : 집합중에 공통된 부분
SELECT *FROM EBDDSTU WHERE GROUPNO = 4
INTERSECT 
SELECT * FROM EBDDSTU WHERE STUNAME LIKE '김%';

-- 합집합(UNION) : 모든 결과 데이터를 출력
SELECT *FROM EBDDSTU WHERE GROUPNO = 4
UNION 
SELECT * FROM EBDDSTU WHERE STUNAME LIKE '김%';

-- A : 3 / B : 8
-- INTERSECT : 2
-- UNION : 9    => ( A + B - INTERSECT ): 3+8-2 = 9

-- 차집합(MINUS) : 먼저 검색한 데이터에서 나중에 검색한 데이터를 빼준다.
SELECT *FROM EBDDSTU WHERE GROUPNO = 4
MINUS
SELECT * FROM EBDDSTU WHERE STUNAME LIKE '김%';

-- A-B => 3 - 8 =??
-- A - (A INTERSECT B) => 3 - 2 = 1(허남용)

-- (2) 공백제거 : TRIM(), LTRIM(), RTRIM()
SELECT '     인천일보아카데미      ',TRIM('     인천일보아카데미      ')
FROM DUAL;

SELECT LTRIM('     인천일보아카데미      ') AS LTRIM1,
       RTRIM('     인천일보아카데미      ') AS RTRIM1
FROM DUAL;

-- (3) 절대값 : ABS()
SELECT ABS(5) AS "절대값 5", ABS('-10') AS "절대값 -10",
        ABS(5)+ABS('-10') AS 결과
FROM DUAL;

-- (4) 반올림 : ROUND()
SELECT ROUND(1234.5678)
FROM DUAL;

SELECT ROUND(1234.5678, 1) AS "소숫점 1번째"
FROM DUAL;

-- Q1.숫자 '일의 자리'에서 반올림 : 1230
-- Q2.숫자 '십의 자리'에서 반올림 : 1200
SELECT ROUND(1234.5678, -1),
       ROUND(1234.5678, -2)
FROM DUAL;

SELECT 
ROUND(1234.5678, -1) AS "일의자리 반올림",
ROUND(1234.5678, -2) AS "십의자리 반올림"
FROM DUAL;

SELECT ROUND(1234.5678) AS ROUND,
       ROUND(1234.5678,0) AS ROUND_0,   --소숫점 0번째 자리까지 출력하겠다.
       ROUND(1234.5678,1) AS ROUND_1,   --소숫점 1번째 자리까지 출력하겠다. (두번째 자리에서 반올림)
       ROUND(1234.5678,2) AS ROUND_2,   --소숫점 2번째 자리까지 출력하겠다. (세번째 자리에서 반올림)
       ROUND(1234.5678,-1) AS ROUND_MINUS1,
       ROUND(1234.5678,-2) AS ROUND_MINUS2
FROM DUAL;

-- (5)버림 : TRUNC()
SELECT TRUNC(1234.5678) AS TRUNC,
       TRUNC(1234.5678,0) AS TRUNC_0,   
       TRUNC(1234.5678,1) AS TRUNC_1,   
       TRUNC(1234.5678,2) AS TRUNC_2,   
       TRUNC(1234.5678,-1) AS TRUNC_MINUS1,
       TRUNC(1234.5678,-2) AS TRUNC_MINUS2
FROM DUAL;

-- (6) 가까운 정수 찾기
--  1) CEIL : 본인보다 큰 정수
--  2) FLOOR : 본인보다 작은 정수
SELECT 
    CEIL(3.14), FLOOR(3.14),
    CEIL(-3.14), FLOOR(-3.14)
FROM DUAL;

-- (7) 나머지 값 구하기 : MOD(A,B)
-- 15/4 => 몫 : 3
-- 15%4 => 나머지 : 3

SELECT FLOOR(15/4) AS 몫 , MOD(15,4) AS 나머지
FROM DUAL;

-- Q. 1년은 몇주로 되어있는지 구해보자!
SELECT ROUND(365/7) AS "1년은 몇주?"
FROM DUAL;

SELECT SYSDATE
FROM DUAL;      

-- 2020-12-23 에서 2020/12/23으로 변경


-- 날짜 형식 설정
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';


-- (8) 날짜 관련 함수
-- (DATE DATA) + 숫자 : 숫자만큼 이후 날짜
-- (DATE DATA) - 숫자 : 숫자만큼 이전 날짜
-- (DATE DATA1) - (DATE DATA2) : 두 날짜간 일수 계산
-- (DATE DATA1) + (DATE DATA2) : 연산 불가능
SELECT
    SYSDATE AS "NOW(오늘)",
    SYSDATE+1 AS "TOMORROW(내일)",
    SYSDATE-1 AS "YESTERDAY(어제)"
FROM DUAL;
    
-- 오늘, 일주일전, 일주일후 조회!
SELECT
    SYSDATE AS "NOW(오늘)",
    SYSDATE-7 AS "일주일 전",
    SYSDATE+9 AS "9일 후"
FROM DUAL;

-- 두 날짜간 일수 계산
SELECT
    SYSDATE+5 AS "5일후",
    SYSDATE-5 AS "5일전",
    (SYSDATE+5) - (SYSDATE-5) AS "일수 계산"
FROM DUAL;

-- 개월 수 구하기 : MONTHS_BETWEEN()
SELECT CEIL(MONTHS_BETWEEN('2021-03-03','2020-09-14'))
FROM DUAL;

-- 개월 수 더하기 : ADD_MONTHS()
SELECT ADD_MONTHS(SYSDATE, 3)
FROM DUAL;

-- 다가올 요일에 해당하는 날짜 : NEXT_DAY(날짜,'X요일')
-- Q. 다음주 화요일 날짜 조회!
SELECT NEXT_DAY(SYSDATE, '토요일') AS "돌아오는 토요일"
FROM DUAL;

-- Q. 다음주 토요일 조회!
SELECT NEXT_DAY(SYSDATE+7, '토요일') AS "다음주 토요일"
FROM DUAL;

-- 이번달 / 특정달의 마지막 일수 : LAST_DAY()
SELECT LAST_DAY('20200913') FROM DUAL;


-- ★★★
-- TO_CHAR, TO_NUMBER, TO_DATE

-- TO_CHAR : 숫자 또는 날짜를 문자데이터로 전환
--           ex)String.valueOf(100)

-- TO_NUMBER : 문자를 숫자로
--             ex) Integer.parseInt("100")

-- TO_DATE : 문자를 날짜로
SELECT TO_DATE('20201011') FROM DUAL;



SELECT TO_CHAR(SYSDATE, 'MM-DD DAY') FROM DUAL;

-- DAY : 'ㅁ'요일
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL;

-- DY : '화' (요일약자)
SELECT TO_CHAR(SYSDATE, 'DY') FROM DUAL;

-- MON : 월
SELECT TO_CHAR(SYSDATE, 'MON') FROM DUAL;
-- (일)

-- D : [일주일 기준 일수 (일요일 = 1)]
SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;

-- DDD : [365일(1년)기준으로 오늘까지 일수] 365-8
SELECT TO_CHAR(SYSDATE, 'DDD') FROM DUAL;

-- W : [한달 기준 몇주차]
SELECT TO_CHAR(SYSDATE, 'W') FROM DUAL;

-- WW : [1년 기준 몇주차]
SELECT TO_CHAR(SYSDATE, 'WW') FROM DUAL;

-- DL : 2020년 12월 23일 수요일 [해당지역 날짜 형식]
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

-- (9) 시간형식 설정
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

SELECT SYSDATE FROM DUAL;

-- AM : 오전
SELECT TO_CHAR(SYSDATE,'AM') FROM DUAL;

-- PM : 오후
SELECT TO_CHAR(SYSDATE,'PM') FROM DUAL;

-- HH와 HH24 차이
SELECT TO_CHAR(SYSDATE,'HH') AS HH,
TO_CHAR(SYSDATE,'HH24')AS HH24
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'PM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'PM HH24:MI:SS') FROM DUAL;

-- BC : 서기
-- CC : 21세기

-- (10) NULL 처리 함수 : NVL, NVL2
-- NULLTEST 테이블 생성
CREATE TABLE NULLTEST(
    NNAME   NVARCHAR2(10),
    NAGE    NUMBER,
    NFRIEND NVARCHAR2(5)
);

-- 데이터 삽입
INSERT INTO NULLTEST(NNAME) VALUES ('황인철');
INSERT INTO NULLTEST VALUES ('하현수', 25, 'X');

SELECT * FROM NULLTEST;

-- NVL : 컬럼에 데이터 NULL일 경우 변경
-- NVL([COL_NAME], '변경할 데이터')
SELECT NNAME, NVL(NAGE,999), NVL(NFRIEND, '많음')
FROM NULLTEST;

-- NVL2
-- NVL2([COL_NAME], ①NULL이 아닐경우 변경할 데이터 , ②NULL일 경우 변경할 데이터 )
SELECT NNAME,NAGE, NVL2(NAGE,999,20), NFRIEND, NVL2(NFRIEND, '많음', '없음')
FROM NULLTEST;

-- (11) 그룹화 함수
INSERT INTO NULLTEST VALUES ('문상진', 28, '100');
INSERT INTO NULLTEST VALUES ('변명훈', 24, '33');

SELECT * FROM NULLTEST;

-- SUM( ) : 지정한 컬럼 데이터의 합 : 77
SELECT SUM(NAGE) FROM NULLTEST;

-- COUNT( ) : 지정한 컬럼 데이터의 갯수 : 3
SELECT COUNT(NAGE) FROM NULLTEST;

-- AVG = SUM / COUNT
-- AVG( ) : 지정한 컬럼 데이터의 평균 : 25.66
SELECT AVG(NAGE) FROM NULLTEST;

-- MIN( ) : 지정한 컬럼 데이터의 최솟값
SELECT MIN(NAGE) FROM NULLTEST;

-- MAX( ) : 지정한 컬럼 데이터의 최댓값
SELECT MAX(NAGE) FROM NULLTEST;



    
    


