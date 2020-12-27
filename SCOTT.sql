-- SCOTT / TIGER 계정

-- 접속된 계정의 테이블 조회
SELECT TABLE_NAME FROM TABS;

-- 4개 테이블 조회
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;
SELECT * FROM BONUS;


-- ★★★★★
-- (1) GROUP BY : 특정 컬럼 또는 데이틀 기준으로 데이터를 그룹으로 묶음
--               (어떤 컬럼을 묶어야 효율적으로 사용할 수 있을지 생각)
--               (그룹을 묶게 되면 기준 컬럼 이외에 다른 컬럼은 조회가 불가)

/*
    SELECT
    FROM
    WHERE
    GROUP BY [그룹화할 COLUMN을 지정]
    ORDER BY [정렬할 COLUMN]
*/

-- 부서별 평균 급여 구하기
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- EMP(EMPLOYEE : 직원)
-- DEPT(DEPARTMENT : 부서)
-- SAL(SALARY : 급여, 월급)
-- COMM(COMMISSION : 수당)
-- LOC(LOCATION : 지역)
-- GRADE (등급)
-- LOSAL(LOW 최저급여)
-- HISAL(HIGH 최고급여)

-- Q1. 직급(JOB)별로 인원수, 급여합계, 평균급여를 구하여라.
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY JOB;

-- Q2. 직급(JOB)별 인원이 많은 순으로 정렬
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY JOB
ORDER BY COUNT(*) DESC;

-- (2) ROLLUP : 그룹화 데이터의 합계를 함께 출력
/*
    SELECT
    FROM
    WHERE
    GROUP BY ROLLUP([COL_NAME])
*/
SELECT JOB, COUNT(*) AS 인원수, SUM(SAL) AS 급여합계, ROUND(AVG(SAL)) AS 평균급여
FROM EMP
GROUP BY ROLLUP(JOB);

-- ★★★★★
-- (3) HAVING : GROUP BY 절을 사용해서 그룹화 된 결과 중
--              출력 그룹을 선별하는 조건식
/*
    SELECT
    FROM
    WHERE
    GROUP BY
    HAVING [출력그룹을 제한하는 조건식] ★★★★★
    ORDER BY
*/

SELECT DEPTNO, COUNT(*)     -- 부서번호, 인원수를 검색
FROM EMP                    -- 직원 테이블에서
WHERE SAL > 1500            -- 급여가 1500보다 큰 것을
GROUP BY DEPTNO             -- 부서번호별로 나눠서
HAVING DEPTNO >= 20         -- 부서번호 20 이상인 그룹중에서
ORDER BY DEPTNO ASC;        -- 부서번호가 작은것부터 차례로 정렬

-- Q1. EMP테이블에서 부서번호, 평균급여, 최고급여, 최저급여, 사원수 조회
--     단 평균 급여를 출력할 때 소숫점을 제외하고 각 부서번호 별로 출력
SELECT DEPTNO, ROUND(AVG(SAL)), MAX(SAL), MIN(SAL), COUNT(*)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- Q2. 같은직급에 종사하는 사원이 3명 이상인 직급과 인원수 출력
SELECT JOB, COUNT(*)
FROM EMP
GROUP BY JOB
HAVING COUNT(*) >= 3;

----------------------------------------------------------------

-- ★★★★★
-- (1) 조인(JOIN) : 두개 이상의 테이블을 연결하여 하나의 테이블 처럼 사용
--                  INNER JOIN, OUTER JOIN
--  1) 내부조인(INNER JOIN) : 두개 테이블의 열(COLUMN) 값이 같을 때
SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT *
FROM EMP , DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

-- ex) 별칭사용 INNER JOIN
SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

-- 2) 외부조인(OUTER JOIN)
--    : 조인 조건을 만족하지 않는 데이터를 처리하기 위함
--    : INNER JOIN이 두 테이블이 있는 일치하는 값만 가져오는 것에 비해
--    : OUTER JOIN은 어느 한쪽의 데이터를 모두 가져온다.
--    : LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN

/*
    !! LEFT OUT JOIN
    !! 첫번째 방법
    SELECT [TAB_NAME1].[COL_NAME], [TAB_NAME2].[COL_NAME]
    FORM [TAB_NAME1] LEFT OUTER JOIN [TAB_NAME2] 
    ON [TAB_NAME1].[COL_NAME] = [TAB_NAME2].[COL_NAME]
*/

SELECT E1.*, E2.ENAME AS 상사
FROM EMP E1 LEFT OUTER JOIN EMP E2
ON E1.MGR = E2.EMPNO;

/*
    !! 두번째 방법
    SELECT [TAB_NAME1].[COL_NAME],[TAB_NAME2].[COL_NAME]
    FROM [TAB_NAME1] , [TAB_NAME2]
    ON [TAB_NAME1].[COL_NAME] = [TAB2_NAME].[COL_NAME](+)
*/

SELECT E1.*, E2.ENAME AS 상사
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO(+);


-- RIGHT OUTER JOIN 예시
SELECT *
FROM EMP E1 RIGHT OUTER JOIN EMP E2
ON E1.MGR = E2.EMPNO;

SELECT *
FROM EMP E1, EMP E2
WHERE E1.MGR(+) = E2.EMPNO;

-- FULL OUTER JOIN
/*
    SELECT [TAB_NAME1].[COL_NAME], [TAB_NAME2].[COL_NAME]
    FORM [TAB_NAME1] FULL OUTER JOIN [TAB_NAME2] 
    ON [TAB_NAME1].[COL_NAME] = [TAB_NAME2].[COL_NAME]
*/

SELECT * 
FROM EMP E1 FULL OUTER JOIN EMP E2
ON E1.MGR = E2.EMPNO;


-- (3) 서브쿼리 : SQL문을 실행하는데 필요한 데이터를 추가로 조회하기 위해
--               SQL문 내부에서 SELECT문을 사용하는 것

-- Q1. 사원이름이 'JONES'인 사원의 급여를 출력 : 2975
SELECT ENAME, SAL
FROM EMP
WHERE ENAME='JONES';

-- Q2. 급여가 2975보다 높은 급여를 받는 사원정보 출력
SELECT * 
FROM EMP 
WHERE SAL > 2975;

-- Q1 + Q2 . 'JONES'의 급여보다 높은 급여를 받는 사원정보를 출력

/*
    SELECT
    FROM
    WHERE [COL_NAME] > ( SELECT [COL_NAME]
                         FROM
                         WHERE )

*/

SELECT * 
FROM EMP
WHERE SAL > (SELECT SAL 
             FROM EMP 
             WHERE ENAME = 'JONES');
    
/*
    - 서브쿼리의 특징
      1. 서브쿼리는 연산자와 같은 비교 또는 조회 대상의 오른쪽에 놓이며
         괄호( )로 묶어서 사용한다.
      2. 특수한 몇몇 경우를 제외하는 하고는 ORDER BY 절을 사용할 수 없다.
      3. 서브쿼리의 SELECT 절에 명시한 [COL_NAME]은 메인쿼리의 비교대상
         [COL_NAME]과 같은 자료형과 같은 갯수로 지정해야 한다.
      
*/

-- Q1. 받는 급여가 평균 급여 이상인 사람의 정보를 검색하시오.
-- Q2. 각 부서별 최고급여와 동일 급여를 받는 사원정보 출력








