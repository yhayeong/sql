-- 2. 날짜 함수
-- curdate() == current_date() (DATE타입)
SELECT CURDATE(); -- 2023-09-04 cf. EMP테이블의 HIREDATE는 DATE타입임
SELECT CURRENT_DATE();

SELECT CURDATE()+1; -- 20230905

SELECT ADDDATE(CURDATE(), INTERVAL 1 DAY); -- 2023-09-05
SELECT ADDDATE(CURDATE(), INTERVAL 1 MONTH); -- 2023-10-04
SELECT ADDDATE(CURDATE(), INTERVAL -1 MONTH); -- 2023-08-04
SELECT ADDDATE(CURDATE(), INTERVAL -1 YEAR); -- 2022-09-04
SELECT DATE_ADD(CURDATE(), INTERVAL -1 YEAR); -- 2022-09-04

-- emp테이블에서 각 직원의 입사일과 10년 기념일을 조회
SELECT ename, hiredate, ADDDATE(hiredate, INTERVAL 10 YEAR) AS "10년 기념일" from emp; 
SELECT ename, hiredate, ADDDATE(hiredate, 2) FROM emp; -- 이틀 후 (기본은 DAY)

-- curtime() == current_time()  (TIME타입)
SELECT CURTIME(), CURRENT_TIME(); -- 17:49:26
SELECT CURTIME(), ADDTIME(CURTIME(), '1:10:5'); -- 09:53:02 | 11:03:07 (1시간 10분 5초를 더하기)

-- now() : 현재 날짜와 시간 (DATE-TIME타입)
SELECT NOW(); -- 2023-09-04 17:49:44
SELECT NOW(), ADDTIME(NOW() ,'2 1:20:5'); -- 2023-09-05 09:54:31 | 2023-09-07 11:14:36 (2일 1시간 20분 5초를 더하기)

-- DATEDIFF : 날짜 간격 계산
SELECT HIREDATE, DATEDIFF(CURDATE(), HIREDATE) FROM emp;
SELECT DATEDIFF(CURDATE(), '1945-8-15') "광복으로부터 몇 일"; -- 28510

-- DATE_FORMAT
SELECT DATE_FORMAT('2017-06-15', "%M %D %Y"); -- June 15th 2017
SELECT DATE_FORMAT(NOW(), "%c %D %Y %a %H:%i:%s");
SELECT DATE_FORMAT(NOW(), "%r"); -- 10:15:27 AM
-- 연: %Y(2023), %y(23)
-- 월: %M(September), %b(sep), %m(09), %c(9)
-- 일: %D(5th) %d(05), %e(5)
-- 요일: %W(Tuesday), %a(Tue)
-- 시간: %H(24시간제), %l(12시간제)
-- %r: hh:mm:ss AM, PM형식으로 시간 표시
-- 분: %i
-- 초: %S
-- cf. 정리 https://oneul-losnue.tistory.com/123
-- https://www.w3schools.com/mysql/func_mysql_date_format.asp

-- DATE_SUB : 날짜 빼기
SELECT CURDATE(), DATE_SUB(CURDATE(), INTERVAL 10 DAY); -- 2023-08-26 (오늘 날짜에서 10일 빼기)
SELECT CURDATE(), ADDDATE(CURDATE(), INTERVAL -10 DAY);

-- DAY, DAYOFMONTH : 날짜에서 '일'만 추출
SELECT hiredate, DAY(hiredate) FROM emp;
SELECT hiredate, DAYOFMONTH(hiredate) FROM emp;

-- 각종 추출함수
SELECT hiredate, YEAR(hiredate) FROM emp;
SELECT hiredate, month(hiredate) FROM emp;
SELECT NOW(), HOUR(NOW());
SELECT NOW(), MINUTE(NOW());
SELECT NOW(), SECOND(NOW());


-- DAYNAME : 날짜에서 '요일'만 추출
SELECT hiredate, DAYNAME(hiredate), DAYOFWEEK(hiredate) FROM emp;  -- 일요일을 1로하여 요일을 숫자로 반환
SELECT CURDATE(), DAYNAME(CURDATE()) 요일, DAYOFWEEK(CURDATE()) 요일넘버;

-- EXTRACT로 추출하기
SELECT CURDATE(), EXTRACT(MONTH FROM CURDATE()) AS "추출한'월'";
SELECT CURDATE(), EXTRACT(YEAR FROM CURDATE()) AS "추출한'연'";
SELECT CURDATE(), EXTRACT(DAY FROM CURDATE()) AS "추출한'일'";

SELECT NOW(), EXTRACT(HOUR FROM NOW()) AS "추출한'시간'";
SELECT NOW(), EXTRACT(MINUTE FROM NOW()) AS "추출한'분'";
SELECT NOW(), EXTRACT(SECOND FROM NOW()) AS "추출한'초'";

SELECT CURDATE(), EXTRACT(WEEK FROM CURDATE()) AS "몇번째'주'인지";
SELECT CURDATE(), EXTRACT(YEAR_MONTH FROM CURDATE()) AS "연과 월";
SELECT CURDATE(), EXTRACT(QUARTER FROM CURDATE()) AS "분기";

-- EXTRACT와 ADDDATE가 범용성이 있으므로 기억해둘것


-- TIME_TO_SEC : 시간을 초로 변환
SELECT CURTIME(), TIME_TO_SEC(CURTIME());

-- TIMEDIFF : 시간 간격
SELECT CURTIME(), TIMEDIFF(curtime(), '08:48:27');
SELECT CURTIME(), TIME_TO_SEC(TIMEDIFF(CURTIME(), '08:48:27')); -- 두 시간의 차이(시분초포맷)를 초 단위로 변환하기





-- 3. 숫자 함수
-- 1) count : 조건에 맞는 레코드(행)의 수
SELECT COUNT(comm) FROM emp; -- 컬럼명을 매개변수로 넣으면 null을 제외하여 카운팅한다
SELECT COUNT(*) FROM emp WHERE deptno=10;

-- 2) sum
SELECT SUM(sal) FROM emp WHERE deptno=10;


-- 3) avg 널처리 주의
SELECT SUM(sal), AVG(sal) FROM emp WHERE deptno=10;
SELECT SUM(sal), sum(sal)/COUNT(sal) FROM emp WHERE deptno=10;

SELECT SUM(comm), COUNT(comm), AVG(comm) FROM emp; -- null이 아닌 0인 사람은 count와 avg의 대상이 되고있음
-- null을 0으로 바꿔서 계산해야함
SELECT SUM(comm), SUM(comm)/COUNT(*), AVG(IFNULL(comm,0)) FROM emp;
-- count와 avg는 null을 집계에 포함해야하는것이 맞는지 여부를  반드시 고려해야함
SELECT profno 교수번호, NAME 이름, pay 월급여, bonus 보너스, pay*12+IFNULL(bonus,0) 연봉 FROM professor;


-- 4) max, min
SELECT MAX(sal) FROM emp;
SELECT MIN(sal) FROM emp;
SELECT empno, ename, MAX(sal) FROM emp; --논리적 오류
SELECT empno, ename, MIN(sal) FROM emp;


-- 5) GROUP BY
-- 그룹별 함수 적용하기(ex. 각 부서별 인원 구하기)
SELECT deptno, COUNT(*), SUM(sal) FROM emp GROUP BY deptno; -- 부서별 행수와 급여합계
-- Group by할 경우 select절에는 그룹핑함수와 그룹핑에 쓴 컬럼명만 쓸 수 있다

SELECT deptno 그룹기준1, job 그룹기준2, COUNT(*), SUM(sal) FROM emp GROUP BY deptno, job;


-- student테이블에서 메인학과별 학생수 조회
SELECT deptno1 메인학과, COUNT(*) FROM student GROUP BY deptno1;
-- student테이블에서 학년별 평균키 조회
SELECT grade, AVG(height) FROM student GROUP BY grade;
SELECT grade, format(AVG(height),1) FROM student GROUP BY grade;

SELECT deptno 부서번호, MAX(sal) FROM emp GROUP BY 부서번호; -- 부서별 가장 높은 급여
SELECT deptno, ename, MAX(sal) FROM emp GROUP BY deptno; 
-- (가장 높은 급여를 가진 사람이 나오는것이 맞을것 같지만) 논리적 오류에 해당
-- 급여가 5000인 직원은 KING이지만 CLARK이 반환되는 것은 그룹핑된 그룹의 첫 ename이 나온것
-- 즉 group by에 사용된 deptno을 제외한 컬럼 ename은 사용하면 안된다
-- 정리: group by를 사용할때 select절에는  그룹함수와 그룹핑에 사용한 컬럼만 써야함


-- 부서별 sal평균이 2000 이상인 부서만 조회 - where가 아닌 having 사용
-- 그룹바이에 대한 조건은 having을 사용한다
SELECT deptno, AVG(sal) 부서별평균급여 FROM emp GROUP BY deptno HAVING 부서별평균급여>=2000;
SELECT deptno, AVG(sal) FROM emp GROUP BY deptno HAVING AVG(sal)>=2000;

-- student테이블에서 각 학과와 학년별 평균 몸무게, 최대/최소 몸무게를 조회
SELECT deptno1, grade, COUNT(*), AVG(weight), MAX(weight), MIN(weight) 
FROM student 
GROUP BY deptno1, grade
HAVING AVG(weight)>=50
-- ORDER BY deptno1, grade;
ORDER BY AVG(weight) DESC;

