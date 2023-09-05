-- 1. 문자열 함수

-- concat : 문자열 잇기 (여러 컬럼을 잇기)
SELECT CONCAT(ename, '(', job, ')') AS 'ENAME_JOB' FROM emp;
SELECT CONCAT(ename, '''s sal is $', sal) AS info FROM emp;

-- format : #,###,###.## (숫자형 데이터의 포맷 지정)
SELECT FORMAT(250500.1254, 2); -- 250,500.13 (소수점 두번째자리까지 반올림됨)

SELECT empno, ename, sal FROM emp; -- sal이 원래 숫자인데 
SELECT empno, ename, format(sal,0) FROM emp; -- 문자열로 포멧이 바뀌어 조회 된다(mySQL Client를 통해 조회할경우 int와는 달리 문자열만 세자리당 쉼표 추가됨)

-- insert : 문자열 내의 지정된 위치에 특정 문자 수만큼 문자열을 변경한다
SELECT INSERT('http://naver.com', 8, 5, 'kosta');  -- http://kosta.com
SELECT studno 학년, NAME 이름, INSERT(jumin, 7, 7, '*******') 주민번호, grade 학년 FROM student;
SELECT insert(GNAME,2, 1, '*') 고객명 FROM gogak;



-- instr : 문자열 내에서 특정 문자열의 위치를 반환
SELECT INSTR('http://naver.com', 'n'); -- 8
-- MySQL과 MariaDB는 from DUAL을 쓰지 않아도 됨 (느슨한 대신 정확하지 않고 애매한 문제가 생긴다는 단점이자 장점)

-- str(문자열의,어디부터,몇개)
SELECT NAME, INSTR(tel, ')') 괄호위치 FROM student ORDER BY 괄호위치 DESC;
SELECT NAME, SUBSTRING(tel from 1 for INSTR(tel,')')) FROM student;
SELECT NAME, SUBSTRING(tel, 1, INSTR(tel,')')) FROM student;
SELECT NAME, SUBSTRING(tel, 1, INSTR(tel,')') -1) FROM student; -- 괄호 전까지 잘라서 반환


-- substr은 where절에서도 잘 쓰인다 (9월에 태어난 고객 조회)
SELECT gNAME, jumin FROM gogak WHERE substr(jumin,3,2)=09;


-- 전화번호 가운데 번호만 조회하기 
SELECT NAME, SUBSTRING(tel, INSTR(tel,')')+1, INSTR(tel,'-')-INSTR(tel,')') -1) FROM student;

-- length : 문자열의 바이트 수  구하기 ('@'뒤로 오는 문자열의 길이)
SELECT tel, LENGTH(tel) FROM student;
SELECT email, LENGTH(SUBSTR(email, INSTR(email,'@') +1)) length FROM professor;

-- 이메일 주소를 ~@kosta.com로 바꾸기
SELECT email, insert(email, instr(email,'@')+1, length(SUBSTR(email, INSTR(email,'@') +1)), 'kosta.com') length FROM professor;


-- length는 글자그대로의 길이가 아니라 바이트수디(영문은 한글자당 1바이트, 한글은 한글자당 3바이트임을 확인할 수 있다)
SELECT ename, LENGTH(ename) FROM emp;
SELECT NAME, LENGTH(NAME) FROM student;
SELECT ename, CHAR_LENGTH(eNAME) FROM emp; -- 오롯이 글자수를 구한다
SELECT name, CHAR_LENGTH(NAME) FROM student;


-- substring == substr
SELECT SUBSTR('http://naver.com',8,5);
SELECT SUBSTRING('http://naver.com',8,5);


-- 소문자로 변경 : LOWER, LCASE
SELECT ename, LOWER(ename) FROM emp ;
SELECT ename, LCASE(ename) FROM emp ;

-- 대문자로 변경 : UPPER, UCASE
SELECT id, UPPER(id) FROM professor;
SELECT id, UCASE(id) FROM professor;

-- trim : 앞뒤 공백 제거
SELECT LENGTH('  test     '), length(TRIM('  test    '));
SELECT LENGTH('  test     '), length(LTRIM('  test    '));
select LENGTH('  test     '), length(RTRIM('  test    '));


SELECT ename, sal FROM emp;
-- 문자열은 왼쪽정렬, 숫자는 오른쪽정렬이 디폴트임

-- 문자열을 오른쪽정렬하기
SELECT LPAD(ename, 20, '#') 이름 FROM emp;
SELECT LPAD(ename, 20, ' ') 이름 FROM emp;
SELECT LPAD(email, 20, '123456789') FROM professor; -- 빈 자리 만큼 채워짐 123 또는 1234
-- 왼쪽을 특정 문자로 채워넣기

-- 오른쪽을 특정 문자로 채워넣기
SELECT RPAD(ename, 20, '$') 이름 FROM emp;



-- 2. 날짜 함수
-- curdate() == current_date()

SELECT CURDATE(); -- 2023-09-04 (DATE타입) cf. EMP테이블의 HIREDATE는 DATE타입임
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

-- curtime() == current_time()
SELECT CURTIME(), CURRENT_TIME(); -- 17:49:26 (TIME타입)

SELECT NOW(); -- 2023-09-04 17:49:44 (DATETIME타입)