-- JOIN

CREATE TABLE TEST1(
A VARCHAR(10),
B VARCHAR(20));

CREATE TABLEKOSTA TEST2(
A VARCHAR(10),
C VARCHAR(20),
D VARCHAR(20));

INSERT INTO TEST1 VALUES('A1','B1');
INSERT INTO TEST1 VALUES('A2','B2');
INSERT INTO TEST2 VALUES('A3','C3','D3');
INSERT INTO TEST2 VALUES('A4','C4','D4');
INSERT INTO TEST2 VALUES('A5','C5','D5');

SELECT * FROM TEST1; -- 2X2
SELECT * FROM TEST2; -- 3X3
SELECT T1.*, T2.* FROM TEST1 T1, TEST2 T2; -- 6X5 (모든 경우의 수 : 곱하기된 결과가 나온다-카티션곱)(행은 곱, 열은 합)
SELECT T1.*, T2.* FROM TEST1 T1, TEST2 T2 WHERE T1.A='a1';
SELECT T1.A, T2.A FROM TEST1 T1, TEST2 T2 WHERE T1.A='a1';

SELECT E.ENAME, D.DNAME FROM EMP E, DEPT D;

-------------------------------------------------------------------------------
-- EMP테이블의 DEPTNO와 DEPT테이블의 DEPTNO가 같은 레코드를 조회(조인의 원리)
SELECT E.EMPNO, E.ENAME, D.DNAME 
FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO;

-- 표준조인문(안시JOIN문) 사용을 권장
-- 일반조인 == INNER JOIN
SELECT E.EMPNO, E.ENAME, D.DNAME
FROM EMP E JOIN DEPT D ON E.DEPTNO=D.DEPTNO;


-- STUDENT, DEPARTMENT테이블을 이용하여 학번, 학생명, 제1학과명 조회
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 제1학과명
FROM STUDENT S JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO; 

SELECT S.STUDNO, S.NAME, D.DNAME
FROM STUDENT S, DEPARTMENT D
WHERE S.DEPTNO1=D.DEPTNO;


-- 학생에 대한 담당교수명 조회
SELECT S.STUDNO 학번, S.NAME 이름, P.NAME 담당교수명
FROM STUDENT S JOIN PROFESSOR P ON S.PROFNO=P.PROFNO;

SELECT S.STUDNO, S.NAME, P.NAME
FROM STUDENT S, PROFESSOR P WHERE S.PROFNO=P.PROFNO;

-- LEFT JOIN (NULL값이 있어 1:1조인이 안되는 경우에, 왼쪽은 매칭되는것이 없더라도 모두 출력)
-- 담당교수가 없는 학생도 고려해서 출력되게함
SELECT S.STUDNO 학번, S.NAME 이름, P.NAME 담당교수명
FROM STUDENT S LEFT JOIN PROFESSOR P ON S.PROFNO=P.PROFNO ORDER BY 담당교수명;

-- RIGHT JOIN (오른쪽은 매칭되는것이 없더라도 모두 출력)
-- 담당학생이 없는 교수도 출력되게함
SELECT S.STUDNO 학번, S.NAME 이름, P.NAME 담당교수명
FROM STUDENT S RIGHT JOIN PROFESSOR P ON S.PROFNO=P.PROFNO;

-- 매치되는것이 없는 경우도 다 출력
SELECT S.STUDNO 학번, S.NAME 이름, P.NAME 담당교수명
FROM STUDENT S LEFT JOIN PROFESSOR P ON S.PROFNO=P.PROFNO
UNION
SELECT S.STUDNO 학번, S.NAME 이름, P.NAME 담당교수명
FROM STUDENT S RIGHT JOIN PROFESSOR P ON S.PROFNO=P.PROFNO;



-- STUDENT, DEPARTMENT, PROFESSOR테이블을 이용하여 학번 이름 제1전공명 담당교수명 조회
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 제1전공명, P.NAME 담당교수명
FROM STUDENT S 
JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO
LEFT JOIN PROFESSOR P ON S.PROFNO=P.PROFNO;

-- STUDENT, EXAM_01테이블을 이용하여 학생별 점수를 출력
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 학과명, E.TOTAL 점수
FROM STUDENT S
JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO
JOIN EXAM_01 E ON S.STUDNO=E.STUDNO
ORDER BY 점수 DESC;



-- HAKJUM테이블과 조인하여 학점까지 표시
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 학과명, E.TOTAL 점수, H.GRADE 학점
FROM STUDENT S
JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO
JOIN EXAM_01 E ON S.STUDNO=E.STUDNO
JOIN HAKJUM H ON E.TOTAL BETWEEN H.MIN_POINT AND H.MAX_POINT
-- JOIN HAKJUM H ON H.MIN_POINT<= E.TOTAL AND E.TOTAL<=H.MAX_POINT
ORDER BY 학점;

SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 학과명, E.TOTAL 점수, H.GRADE 학점
FROM STUDENT S, DEPARTMENT D, EXAM_01 E, HAKJUM H
WHERE S.DEPTNO1=D.DEPTNO
AND S.STUDNO=E.STUDNO
AND E.TOTAL BETWEEN H.MIN_POINT AND H.MAX_POINT
ORDER BY 학점;



-- GOGAK, GIFT테이블을 이용하여 고객의 모든 정보와 고객이 본인의 포인트로 받을 수 있는 가장 좋은 상품을 조회
SELECT GO.*, GI.GNAME
FROM GOGAK GO
JOIN GIFT GI ON GO.POINT BETWEEN GI.G_START AND GI.G_END
ORDER BY GO.POINT;

SELECT GO.*, GI.GNAME
FROM GOGAK GO, GIFT GI
WHERE GO.POINT BETWEEN GI.G_START AND GI.G_END
ORDER BY GO.POINT;



-- EMP2, P_GRADE테이블을 이용하여 자신과 같은 직급의 최대, 최소 급여를 조회
-- 선생님 9X4
SELECT E.NAME, E.PAY, G.S_PAY, G.E_PAY
FROM EMP2 E JOIN P_GRADE G
ON E.`POSITION`=G.`POSITION`;




-- EMP2, P_GRADE테이블을 이용하여 이름,직위,나이,본인의 나이에 해당하는 예상직급조회
SELECT E.NAME 이름, E.POSITION 직위, YEAR(CURDATE())-YEAR(E.BIRTHDAY) 나이, G.POSITION 직급
FROM EMP2 E, P_GRADE G
WHERE YEAR(CURDATE())-YEAR(E.BIRTHDAY) BETWEEN G.S_AGE AND G.E_AGE
ORDER BY 3 DESC;
 


-- 노트북을 탈 만한 포인트를 가진 고객의 고객명,포인트,상품명(노트북)을 조회
SELECT GO.GNAME, GO.POINT, GI.GNAME
FROM GOGAK GO, GIFT GI
WHERE GI.GNAME='노트북' AND GO.`POINT`>=GI.G_START;

SELECT GO.GNAME, GO.POINT, GI.GNAME
FROM GOGAK GO JOIN GIFT GI ON GO.`POINT`>=GI.G_START
WHERE GI.GNAME='노트북';

/* cf. 조인 대신 서브쿼리 이용 가능
 
gogak,gift테이블을 이용하여 노트북을 받을 수 있는 고객의 이름,포인트 조회 
서브쿼리: 노트북의 g_start */
SELECT go.gname, go.POINT
FROM gogak go
WHERE go.point>(SELECT g_start FROM gift WHERE gname='노트북')
 



---------------------------------------------------------------------------------
-- ***셀프조인***
-- DEPT2테이블을 이용하여 부서의 모든 정보와 그 부서의 상위부서명을 조회
-- ***먼저 카티션곱을 만들어두고 그 뒤에 걸러야함***
SELECT D.*, PD.DNAME
FROM DEPT2 D LEFT JOIN DEPT2 PD
ON D.PDEPT=PD.DCODE;

-- 카티션곱의 결과를 먼저 조회
SELECT D.*, PD.*
FROM DEPT2 D, DEPT2 PD
ORDER BY 1;

-- CF. 표준조인문에서만 LEFT JOIN, RIGHT JOIN이 가능하다



-- EMP테이블을 이용하여 직원의 사번,이름,담당매니저 사번, 담당매니저 이름 조회
SELECT E.EMPNO 사번, E.ENAME 이름, EM.EMPNO "담당매니저 사번", EM.ENAME "담당매니저 이름"
FROM EMP E
LEFT JOIN EMP EM
ON E.MGR=EM.EMPNO; -- 매니저가 없는 KING도 출력

-- 선생님
SELECT E.EMPNO, E.ENAME, M.EMPNO, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR=M.EMPNO;


-- STUDENT, DEPARTMENT테이블을 이용하여 학번, 이름, 제1전공명, 제2전공명 조회
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 제1전공명, D2.DNAME 제2전공명
FROM STUDENT S
JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO -- 제1전공이 NULL인 STUDENT는 없으므로 LEFT를 하지 않았을때도  결과는 같다
LEFT JOIN DEPARTMENT D2 ON S.DEPTNO2=D2.DEPTNO;


-- 컴퓨터정보학부에 해당하는 학생의 학번, 이름, 학과번호, 학과명 조회
SELECT S.STUDNO 학번, S.NAME 이름, S.DEPTNO1 학과번호, D.DNAME 학과명, D2.DNAME 학부명
FROM STUDENT S
JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO
JOIN DEPARTMENT D2 ON D.PART=D2.DEPTNO
WHERE D2.DNAME='컴퓨터정보학부';

SELECT S.STUDNO, S.NAME , S.DEPTNO1, D.DNAME, D2.DNAME
FROM STUDENT S, DEPARTMENT D, DEPARTMENT D2
WHERE S.DEPTNO1=D.DEPTNO
AND (D.PART=D2.DEPTNO
AND D2.DNAME='컴퓨터정보학부');




-- 전자제어관에서 수업을 듣는 학생을 전부 조회(제1전공과 제2전공 모두 고려)
SELECT S.STUDNO, S.NAME, D1.DNAME, D1.BUILD, D2.DNAME, D2.BUILD
FROM STUDENT S JOIN DEPARTMENT D1 ON S.DEPTNO1=D1.DEPTNO
LEFT JOIN DEPARTMENT D2 ON S.DEPTNO2=D2.DEPTNO
WHERE D1.BUILD='전자제어관' OR D2.BUILD='전자제어관';


-- EMP테이블을 이용해 자기보다 입사일이 빠른 직원의 인원수 조회
-- 1단계(카티션곱)
SELECT E1.EMPNO, E1.ENAME, E1.HIREDATE, E2.EMPNO, E2.ENAME, E2.HIREDATE
FROM EMP E1, EMP E2 ORDER BY 1;
-- 2단계(셀프조인)
SELECT E1.EMPNO, E1.ENAME, E1.HIREDATE, E2.EMPNO, E2.ENAME, E2.HIREDATE
FROM EMP E1 LEFT JOIN EMP E2 ON E1.HIREDATE > E2.HIREDATE;
-- 3단계(GROUP BY - EMPNO 혹은 ENAME 혹은 둘 다로 묶는다)
SELECT E1.EMPNO, E1.ENAME, E1.HIREDATE, COUNT(E2.HIREDATE) 입사선배수
FROM EMP E1 LEFT JOIN EMP E2 ON E1.HIREDATE > E2.HIREDATE
GROUP BY E1.EMPNO, E1.ENAME
ORDER BY 4;

-- PROFESSOR 테이블을 이용하여 교수번호, 교수이름, 입사일, 자신보다 먼저 입사한 교수인원을 조회
SELECT P1.PROFNO, P1.NAME, P1.HIREDATE, COUNT(P2.HIREDATE) 입사선배수
FROM PROFESSOR P1
LEFT JOIN PROFESSOR P2 ON P1.HIREDATE>P2.HIREDATE
GROUP BY P1.PROFNO
ORDER BY 4;


--------------------------------------------------------------------------------------------------
-- 기타

-- 조인에 사용하는 컬럼명이 같을때는 using(컬럼명)
SELECT e.*, d.dname
FROM emp e JOIN dept d USING(deptno);

-- 내추럴조인: 알아서 공통컬럼명으로 조인해줌
SELECT e.*, d.dname
FROM emp e NATURAL JOIN dept d;

-- 크로스조인==카티션곱
SELECT e.*, d.dname
FROM emp e CROSS JOIN dept d;


-- mySQL은 full outer join을 지원하지 않음
-- union을 이용하여 왼쪽테이블과 오른쪽테이블 모두 null값인 행 모두 포함되도록한다
-- union은 자동으로 중복 제거(UNION ALL 은 중복제거x)
SELECT s.*, p.name
FROM student s LEFT JOIN professor p ON s.profno=p.profno
UNION
SELECT s.*, p.name
FROM student s right JOIN professor p ON s.profno=p.profno;
-- 27행

SELECT s.*, p.name
FROM student s LEFT JOIN professor p ON s.profno=p.profno
UNION ALL
SELECT s.*, p.name
FROM student s right JOIN professor p ON s.profno=p.profno;
-- 42행




-- cf. 서브쿼리 프리뷰
-- 노트북을 살수있는 고객을 조회하는 문제에서 조인보다 서브쿼리를 이용하는 것이 성능상 효율적인 이유:
-- 먼저 노트북 구입포인트  min,max를 가져온다음
-- 고객테이블의 테이블과 비교하는것이 더 합리적임
-- (조인은 곱하는것이고 서브쿼리는 더하여 조회하는 것)

 


