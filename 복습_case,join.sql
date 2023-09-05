-- 0905 케이스문, 조인문 복습 

-- *** SUBSTR(컬럼명, 시작, 끝) 
-- *** CASE문 마지막에 END를 빠뜨리지 말것
-- *** GROUP BY 할 때 조회의 기준이 되는 테이블의 컬럼으로 그룹바이할것
-- *** 실행시 아무 반응이 없을때 확인할것 :
-- 		주석 띄어쓰기, 앞 쿼리의 세미콜론



-- STUDENT, DEPARTMENT테이블을 이용하여 학번, 학생명, 제1학과명 조회
SELECT s.studno, s.NAME, d.dname
FROM student s
JOIN department d ON s.deptno1=d.deptno;

-- 담당교수가 없는 학생, 담당학생이 없는 교수도 다 포함하여 출력
SELECT s.name, p.name
FROM student s
left JOIN professor p ON s.profno=p.profno
UNION
SELECT s.name, p.name
FROM student s
RIGHT JOIN professor p ON s.profno=p.profno;

-- STUDENT, DEPARTMENT, PROFESSOR테이블을 이용하여 학번 이름 제1전공명 담당교수명 조회
SELECT s.studno, s.name, d.dname, p.name
FROM student s
left JOIN department d ON s.deptno1=d.deptno
LEFT JOIN professor p ON s.profno=p.profno;

-- STUDENT, EXAM_01테이블을 이용하여 학생별 점수를 출력, 학점도 추가
SELECT s.name, e.total, h.grade 
FROM student s 
LEFT JOIN exam_01 e ON s.studno=e.studno
LEFT JOIN hakjum h ON e.total BETWEEN h.min_point AND h.max_point
ORDER BY h.grade;


-- GOGAK, GIFT테이블을 이용하여 고객의 모든 정보와 고객이 
-- 본인의 포인트로 받을 수 있는 가장 좋은 상품을 조회
SELECT go.gname, gi.gname
FROM gogak go
JOIN gift gi ON go.point BETWEEN gi.g_start AND gi.g_end;

-- EMP2, P_GRADE테이블을 이용하여 자신과 같은 직급의 최대, 최소 급여를 조회
SELECT e.name, e.`POSITION`, p.s_pay, p.e_pay
FROM emp2 e
JOIN p_grade p ON e.`POSITION`=p.`position`;




-- *** 헷갈리는 문제
-- EMP2, P_GRADE테이블을 이용하여 이름,직위,나이,본인의 나이에 해당하는 예상직급조회
SELECT E.NAME 이름, E.POSITION 직위, YEAR(CURDATE())-YEAR(E.BIRTHDAY) 나이, G.POSITION 직급
FROM EMP2 E, P_GRADE G
WHERE YEAR(CURDATE())-YEAR(E.BIRTHDAY) BETWEEN G.S_AGE AND G.E_AGE;

SELECT E.NAME 이름, E.POSITION 직위, YEAR(CURDATE())-YEAR(E.BIRTHDAY) 나이, G.POSITION 직위
FROM EMP2 E JOIN P_GRADE G
ON YEAR(CURDATE())-YEAR(E.BIRTHDAY) BETWEEN G.S_AGE AND G.E_AGE;

-- 노트북을 탈 만한 포인트를 가진 고객의 고객명,포인트,상품명(노트북)을 조회
SELECT GO.GNAME, GO.POINT, GI.GNAME
FROM GOGAK GO JOIN GIFT GI ON GO.`POINT` >= GI.G_START
WHERE GI.GNAME='노트북';




-- *** 셀프조인
-- DEPT2테이블을 이용하여 부서의 모든 정보와 그 부서의 상위부서명을 조회
SELECT d1.dcode, d1.DNAME, d2.DCODE, d2.DNAME
FROM dept2 d1
left JOIN dept2 d2 ON d1.PDEPT=d2.DCODE; 
-- d1은 기준부서, d2는 d1의 상위부서를 의미


-- EMP테이블을 이용하여 직원의 사번,이름,담당매니저 사번, 담당매니저 이름 조회
SELECT e1.EMPNO, e1.ENAME, e2.EMPNO, e2.ENAME
FROM emp e1
left JOIN emp e2 ON e1.MGR=e2.EMPNO ;
-- e1은 기준직원, e2는 해당직원의 담당매니저를 의미


-- department테이블을 이용하여 컴퓨터정보학부에 해당하는 학생의 학번, 이름, 학과번호, 학과명 조회
SELECT s.name, s.deptno1, d1.dname, d2.dname
FROM student s
JOIN department d1 ON s.deptno1=d1.deptno
JOIN department d2 ON d1.part=d2.deptno
WHERE d2.dname='컴퓨터정보학부';
-- d1은 학과, d2는 학부를 의미


-- 전자제어관에서 수업을 듣는 학생을 전부 조회(제1전공과 제2전공 모두 고려)
SELECT s.name, d1.dname, d1.build, d2.dname, d2.build
FROM student s
JOIN department d1 ON s.deptno1=d1.deptno
left JOIN department d2 ON s.deptno2=d2.deptno
WHERE d1.build='전자제어관' OR d2.build='전자제어관';
-- d1은 제1전공, d2는 제2전공을 의미


-- EMP테이블을 이용해 자기보다 입사일이 빠른 직원의 인원수 조회
SELECT e1.ENAME, COUNT(e2.hiredate)
FROM emp e1
left JOIN emp e2 ON e1.HIREDATE > e2.HIREDATE
GROUP BY e1.empno;
-- e1은 기준이되는 직원들, e2는 비교대상이 될 직원들을 의미
-- *** 그룹바이할때 e2가 아닌 e1의 컬럼으로 그룹화한다(기준직원집단e1을 분류할 값)
-- *** left조인이 아닌 일반조인시 e1.HIREDATE > e2.HIREDATE인 레코드가 없는 SMITH는 포함되지 않게되므로 13행이 반환됨


-- PROFESSOR 테이블을 이용하여 교수번호, 교수이름, 입사일, 자신보다 먼저 입사한 교수인원을 조회
SELECT p1.profno, p1.name, p1.hiredate, COUNT(p2.profno) 입사선배수
FROM professor p1
LEFT JOIN professor p2 ON p1.hiredate> p2.hiredate 
GROUP BY p1.profno
ORDER BY 입사선배수;
-- left조인하지 않고 일반조인하게되면 15행이 반환됨




