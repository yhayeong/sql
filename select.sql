-- 2학년 또는 3학년인 학생
SELECT * FROM STUDENT WHERE GRADE=2 OR GRADE=3;
SELECT * FROM STUDENT WHERE GRADE>=2 AND GRADE<=3;
SELECT * FROM STUDENT WHERE GRADE IN(2,3);

-- 4학년이 아닌 학생
SELECT * FROM STUDENT WHERE NOT GRADE=4;
SELECT * FROM STUDENT WHERE GRADE NOT IN(4);

-- emp테이블에서 직무가 CLERK이거나 SALESMAN인 직원
SELECT EMPNO, ENAME, JOB FROM EMP WHERE JOB IN('CLERK', 'SALESMAN');

-- alias(별칭)
-- 큰따옴표 사용의 유일한 경우는 별칭이 스페이스바를 포함할때
deptSELECT EMPNO AS 사번, ENAME "이  름", JOB 직무 FROM EMP WHERE JOB IN('CLERK', 'SALESMAN');

SELECT * FROM professor WHERE hpage IS NOT NULL;
SELECT * FROM professor WHERE hpage IS NULL;

-- 날짜형식도 비교 연산자가 가능하다(최신 날짜일수록 크다)
SELECT * FROM student WHERE '1976-01-01'<=birthday AND birthday<='1976-12-31';
SELECT * FROM student WHERE birthday BETWEEN '1976-01-01' AND '1976-12-31';


SELECT * FROM emp WHERE deptno=10 AND sal>=2000;
SELECT * FROM professor WHERE deptno=101 AND POSITION='정교수';

SELECT * FROM student WHERE deptno1=101 OR deptno2=101;
SELECT * FROM student WHERE (deptno1=101 OR deptno2=101) AND grade IN (1,2);

SELECT NAME, POSITION, pay FROM emp2 WHERE emp_type='정규직' and pay>=50000000;

-- 컴퓨터 정보학부(컴퓨터/멀티미디어/소프트웨어공학과)에 소속된 교수의 이름, 직급, 소속학과 조회
SELECT NAME, POSITION, deptno FROM professor WHERE deptno IN (101, 102, 103); 

-- 조인형 교수가 담당하는 학생의 목록 조회
SELECT studno, NAME, grade, deptno1, profno FROM student WHERE profno=1001;

SELECT * FROM gogak;

-- 노트북을 선물로 받을 수 있는 포인트를 가진 고객의 고객번호, 이름,
SELECT gno, gname, POINT FROM gogak WHERE POINT>=600001;

SELECT studno, total FROM exam_01 WHERE 80<=total AND total <=89 order BY total;
SELECT studno, total FROM exam_01 WHERE total BETWEEN 80 AND 89; 

-- 정렬
studentSELECT * FROM emp ORDER BY sal ASC;
SELECT NAME FROM student ORDER BY deptno=10 ORDER BY s dwsc
select studno, NAME FROM student ORDER BY 2; -- 조회대상 컬럼의 두번째인 name순으로 정렬

SELECT STUDNO, NAME, BIRTHDAY, DEPTNO FROM STUDENT WHERE GRADE==4 ORDER BY 3;
SELECT * FROM EMP ORDER BY DEPTNO ASC, SAL DESC; -- 생략한 것은 ASC
SELECT * FROM STUDENT ORDER BY GRADE, HEIGHT DESC;

-- 중복 행 제거
SELECT DISTINCT(DEPTNO1) FROM student;

-- like연산자 : 컬럼의 문자열VARCHAR에만 쓴다 포함여부를 거를때
SELECT * FROM student WHERE NAME LIKE '%서%'; -- 서가 포함된 이름

-- 두번째 글자가 A인
SELECT * FROM emp WHERE job LIKE '_A%';

-- 9월이 생일인 학생
SELECT * FROM student WHERE jumin LIKE '__09%';

SELECT profno, NAME, pay, bonus, pay+ifnull(bonus,0) 합계  FROM professor;
-- 오라클의 NVL(컬럼명,0) == ifnull(컬럼명,0)

SELECT empno, ename, sal, comm FROM emp WHERE sal>1000 AND (comm<1000 OR comm IS NULL);



