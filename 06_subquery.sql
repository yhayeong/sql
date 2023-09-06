-- 서브쿼리

-- cf. 서브쿼리 프리뷰
-- 노트북을 살수있는 고객을 조회하는 문제에서 조인보다 서브쿼리를 이용하는 것이 성능상 효율적인 이유:
-- 먼저 노트북 구입포인트  min,max를 가져온다음 고객테이블의 테이블과 비교하는것이 더 합리적임
-- (조인은 곱하는것이고 서브쿼리는 더하여 조회하는 것이므로)

-- 두개이상의 테이블의 데이터를 이용해야할때, 조인을 대제하는 수단으로 서브쿼리를 사용할 수 있다


-- 1. 대부분의 경우, 서브쿼리의 결과는 한 행이다(단일행 단일열 서브쿼리)
-- 비교연산자 =, <>(!=), >, >= 는 단일행 단일열 서브쿼리와 함께 사용해야한
-- cf. 다중행 다중열 서브쿼리와 함께 사용하는 연산자도 존재함


SELECT ename, comm 
FROM emp 
WHERE comm < (SELECT comm FROM emp WHERE ename='WARD');
-- 서브쿼리의 결과(WORD의 comm)보다 더 작은 comm인 행들 - 2행

-- 같은 것을 조인으로 조회할때는
SELECT e1.ename, e1.comm
FROM emp e1
JOIN emp e2 ON e1.COMM < e2.COMM
WHERE e2.ENAME='WARD';
SELECT e1.ename, e1.comm
FROM emp e1, emp e2
WHERE e2.ename='WARD' AND e1.comm<e2.comm;
-- 조인으로 조회시 14*14한뒤 비교하고 서브쿼리는 14+14이므로 성능상 더 좋다


-- student, department테이블을 이용하여 <서진수 학생의 주전공> 과 주전공이 같은 학생들을 조회
-- 서브쿼리 먼저 완성하여 작성하는것이 쉽다
SELECT s.name, s.deptno1, d.dname
FROM student s
JOIN department d ON s.deptno1=d.deptno
WHERE s.deptno1=(SELECT deptno1 FROM student WHERE NAME='서진수');

# <박원범 교수의 입사일>보다 나중에 입사한 교수들의 교수번호, 이름, 학과명, 입사일을 조회
SELECT p.profno, p.name, d.deptno, d.dname, p.hiredate
FROM professor p
left JOIN department d using(deptno)
WHERE p.hiredate>(SELECT hiredate FROM professor p WHERE NAME='박원범')
ORDER BY p.hiredate;

/* student테이블에서 <주전공이 '전자공학과'인 학과의 평균 몸무게>보다 몸무게가 많은 학생들의 이름과 몸무게 조회 */
SELECT ST.NAME, ST.WEIGHT
FROM STUDENT ST
WHERE ST.WEIGHT>(SELECT AVG(WEIGHT) 
						FROM STUDENT S 
						JOIN DEPARTMENT D ON S.DEPTNO1=D.DEPTNO 
						WHERE D.DNAME='전자공학과')
ORDER BY 2 DESC;


/* gogak,gift테이블을 이용하여 노트북을 받을 수 있는 고객의 이름,포인트 조회 
서브쿼리: 노트북의 g_start */
SELECT go.gname, go.POINT
FROM gogak go
WHERE go.point>=(SELECT g_start FROM gift WHERE gname='노트북');
 

-- emp, dept테이블을 이용하여 NEW YORK에서 근무하는 직원목록 조회
-- 서브쿼리: dept테이블에서 LOC=NEW YORK의 부서코드번호
SELECT * FROM emp
WHERE DEPTNO = (SELECT DEPTNO from dept WHERE LOC='NEW YORK');


/* 박원범 교수가 담당하는 학생의 목록 
서브쿼리: 박원범 교수의 교수번호 */
SELECT * FROM student
WHERE profno = (SELECT profno FROM professor WHERE NAME='박원범');


/* gogak, gift테이블을 사용하여 안광훈 고객이 포인트로 받을 수 있는 상품 목록 조회
서브쿼리: 안광훈의 포인트 */
SELECT * FROM GIFT
WHERE G_START <= (SELECT POINT FROM GOGAK WHERE GNAME='안광훈');


/* emp테이블에서 sales부서가 아닌 나머지 부서인 직원을 조회 
서브쿼리: sales부서의 부서번호 */
SELECT E.EMPNO, E.ENAME, D.DNAME
FROM EMP E
JOIN DEPT D USING(DEPTNO)
WHERE E.DEPTNO <> (SELECT DEPTNO FROM DEPT WHERE DNAME='SALES');


/* student테이블에서 학점이 B미만인 학생의 목록을 조회 
서브쿼리(비교에 쓸 행): 학점 B0의 최소 점수 */
SELECT S.STUDNO, S.NAME, E.TOTAL
FROM STUDENT S
JOIN EXAM_01 E USING(STUDNO)
WHERE E.TOTAL < (SELECT MIN_POINT FROM HAKJUM WHERE GRADE='B0');

-- cf. 서브쿼리 이용하지 않고 구해보기
SELECT S.STUDNO, S.NAME, E.TOTAL, H.GRADE
FROM STUDENT S
JOIN EXAM_01 E USING(STUDNO)
JOIN HAKJUM H ON E.TOTAL BETWEEN H.MIN_POINT AND H.MAX_POINT
WHERE H.GRADE NOT LIKE 'A%' AND H.GRADE NOT LIKE'B%';
-- WHERE H.GRADE NOT IN ('A+', 'A0', 'B+', 'B0');



/* 학점이 A0인 학생 목록 조회
서브쿼리: A0의 최소점수와 A0의 최대점수 - where절에서 학생의점수와 between연산에 사용 */
SELECT S.STUDNO, S.NAME, E.TOTAL
FROM STUDENT S
JOIN EXAM_01 E USING(STUDNO)
WHERE E.TOTAL BETWEEN (SELECT MIN_POINT FROM HAKJUM WHERE GRADE='A0') 
						AND (SELECT MAX_POINT FROM HAKJUM WHERE GRADE='A0');





-- 2. 다중행 서브쿼리와 함께 쓰는 비교연산자 
-- in, exists, >any, >all : 이 연산자의 우측에 <여러행이 결과인 서브쿼리>가 온다
-- ~중에 속하는지, ~값이 하나라도 있으면, 어떤 하나보다만 크면(==가장 작은것보다만 크면), 모든것보다 크면(==가장 큰것보다 크면)


/* emp2, dept2테이블을 이용하여 포항본사에서 근무하는 직원의 목록을 조회
서브쿼리(다중행): dept2의 area가 서울지사인 부서넘버 -> 4행 */
SELECT E.EMPNO, E.NAME, D.DNAME, D.AREA
FROM EMP2 E
JOIN DEPT2 D ON E.DEPTNO=D.DCODE
WHERE E.DEPTNO IN (SELECT DCODE FROM DEPT2 WHERE AREA LIKE '포항%');


/* emp2테이블을 이용하여 과장 직급들 중 연봉이 가장 적은 직원보다 더 많이 받는 직원 목록 조회
다중행 서브쿼리: 과장직급인 직원의 최소 연봉 */
SELECT E.EMPNO, E.NAME, E.`POSITION`, E.PAY
FROM EMP2 E
WHERE E.PAY >ANY (SELECT PAY FROM EMP2 WHERE `POSITION`='과장');

-- 단일행서브쿼리를 이용할 수도 있다
SELECT E.EMPNO, E.NAME, E.`POSITION`, E.PAY
FROM EMP2 E
WHERE E.PAY > (SELECT MIN(PAY) FROM EMP2 WHERE `POSITION`='과장');


/* *** 학년별로 가장 키가 큰 학생을 조회 
다중열 다중행 서브쿼리: 학년별 가장 큰 키 (그룹바이 이용) */
SELECT grade, NAME, height
FROM student 
WHERE (grade, height) in (SELECT grade, max(height)
									FROM student
									GROUP BY grade)
ORDER BY 2;
-- where절에 2개이상의 컬럼을 비교대상으로 할 수 있다(연산자 오른쪽 역시 다중열이어야함)
-- *** where절에서 피연산자1과 피연산자2의 컬럼수가 같아야함
-- 정리: 다중행서브쿼리와 함께 사용하는 in연산자는 다중열 비교도 가능하다



/* student테이블에서 2학년인 학생 중 몸무게가 가장 적게 나가는 학생보다 몸무게가 적은 학생 목록 조회 
다중행 서브쿼리: 2학년인 학생들의 몸무게 */

SELECT s.name, s.grade, s.weight
FROM student s 
WHERE s.weight <all (SELECT weight FROM student WHERE grade=2);

-- 단일행 서브쿼리를 이용할 수도 있다
SELECT s.name, s.grade, s.weight
FROM student s 
WHERE s.weight < (SELECT min(weight) FROM student WHERE grade=2);






/* 
지금까지는 서브쿼리가 메인쿼리에 의존적이지 않았다
아래와 같은 경우는 서브쿼리가 메인쿼리에 의존적인 경우에 해당(성능이슈가 있으나 편리를 위해 서브쿼리를 사용하기도 함)
이런 경우는 별칭을 통해 메인쿼리->서브쿼리에서 사용

Q. emp2테이블에서 자신이 속한 부서의 평균연봉보다 적게 받는 직원을 조회
단일행 서브쿼리: 부서별 평균 연봉
*/

-- 선생님(7행)
SELECT e1.name, e1.pay, d.dname
FROM emp2 e1
JOIN dept2 d ON e1.DEPTNO=d.dcode
WHERE e1.pay < (SELECT AVG(pay) FROM emp2 WHERE deptno=e1.deptno);
-- 서브쿼리가 메인쿼리에 의존적이므로(서브쿼리에서 메인쿼리의 컬럼을 사용중), 서브쿼리만 단독 실행 불가함

-- 다중행 서브쿼리 이용해보기?
-- SELECT e.* FROM emp2 
-- WHERE e.pay <any (SELECT deptno, AVG(pay)
-- 					FROM emp2
-- 					GROUP BY deptno);
-- 미해결@@@ 
-- 불가한 이유: 조회대상인 직원들의 부서에 따라 where절의 비교기준이 달라져야하는 문제이므로 서브쿼리가 부서별평균연봉이기만 하면 x..?
-- detpno는 일치하면서 avg는 <비교해보기





 



/* emp2, dept2테이블에서 각 부서별 평균연봉을 구하고 
그 중에서 평균연봉이 가장 적은 부서의 평균연봉보다 많이 받는 직원들의 직원명, 부서명, 연봉 조회
다중행 서브쿼리: 각 부서별 평균연봉 (부서개수인 13행)(부서코드 없이 평균연봉 한 컬럼만 반환) */

SELECT e.NAME, d.DNAME, e.PAY
FROM emp2 e
JOIN dept2 d ON e.DEPTNO=d.DCODE
WHERE e.pay <ANY (SELECT AVG(pay)
						FROM emp2
						GROUP BY DEPTNO);
-- cf. 그룹바이할때는 select절에 그룹함수와 그룹핑에 사용한 컬럼명만 작성 가능						
	
						
/* professor, department테이블에서 각 학과별 입사일이 가장 오래된 교수의 교수번호, 이름, 입사일, 학과명 조회 
다중열 다중열 서브쿼리: 학과별 가장 오래된min 입사일 
다중행 서브쿼리와 함께 사용하는 비교연산자 in은 다중컬럼 비교도 가능하다 */
SELECT p.profno, p.name, p.hiredate, d.dname
FROM professor p
JOIN department d using(deptno)
WHERE (p.deptno, p.hiredate) IN (SELECT deptno, MIN(hiredate)
											FROM professor
											GROUP BY deptno);
						
















