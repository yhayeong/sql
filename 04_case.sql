-- CASE-END
-- 자바의 switch문과 같고 오라클의 decode함수와 같다 
-- 조회할때 컬럼값을  조건에 따라 다른 값으로 변환하기
-- 부서번호별로 매치된 부서명으로 바꿔 조회
SELECT EMPNO, ENAME, DEPTNO, 
		 CASE WHEN DEPTNO=10 THEN 'ACCOUNTINT'
		 		WHEN DEPTNO=20 THEN 'RESEARCH'
		 		WHEN DEPTNO=30 THEN 'SALES'
		 		WHEN DEPTNO=40 THEN 'ORPERATIONS'
		 END AS 부서명
FROM emp;

SELECT EMPNO, ENAME, DEPTNO, 
		 CASE deptno 
 		 WHEN '10' THEN 'ACCOUNTINT'
 		 WHEN '20' THEN 'RESEARCH'
 		 WHEN '30' THEN 'SALES'
 		 WHEN '40' THEN 'ORPERATIONS'
		 END AS 부서명
FROM emp;

-- student테이블에서 주민번호를 이용해서 성별을 조회
SELECT NAME 이름, INSERT(JUMIN, 8, 7, '******') 주민번호, 
		 CASE WHEN SUBSTRING(JUMIN,7,1)='1' OR SUBSTRING(JUMIN,7,1)='3' THEN 'MAN' 
		      WHEN SUBSTRING(JUMIN,7,1)=2 OR SUBSTRING(JUMIN,7,1)=4 THEN 'WOMAN'
		 END AS 성별
FROM STUDENT
ORDER BY 성별, JUMIN;

SELECT NAME 이름, INSERT(JUMIN, 8, 7, '******') 주민번호, 
		 CASE SUBSTR(JUMIN,7,1)
 	    WHEN '1' THEN 'MAN'
 	    WHEN '3' THEN 'MAN'
 	    WHEN '2' THEN 'WOMAN'
 	    WHEN '4' THEN 'WOMAN'
		 END AS 성별
FROM STUDENT
ORDER BY 성별, JUMIN;

-- STUDENT테이블에서 1전공이 101번인 학생의 이름,전화번호,지역을 조회하기(지역은 전화번호의 지역변호를 이용하여 표시)
SELECT NAME 이름, TEL 전화번호, DEPTNO1 1전공,
		CASE SUBSTR(TEL, 1, INSTR(TEL,')')-1)
		WHEN '02' THEN '서울'
		WHEN '031' THEN '경기'
		WHEN '051' THEN '부산'
		WHEN '052' THEN '울산'
		WHEN '053' THEN '대구'
		WHEN '055' THEN '경남'
		END AS 지역
FROM STUDENT
WHERE DEPTNO1=101
ORDER BY 지역;



-- student테이블에서 생년월일을 참조하여 태어난 달과 분기를 조회

-- SELECT NAME 이름, BIRTHDAY 생년월일, MONTH(BIRTHDAY) 태어난달, 
--		 CASE MONTH(BIRTHDAY)
--		 WHEN '1' OR '2' OR '3' THEN '1/4분기'
--		 WHEN '4' OR '5' OR '6' THEN '2/4분기'
--		 WHEN '7' OR '8' OR '9' THEN '3/4분기'
--		 WHEN '10' OR '11' OR '12' THEN '4/4분기'
--		 END AS 분기
-- FROM student
-- ORDER BY 분기; 
-- 안되는 이유는 when에서 or혹은 between같은 연산자를 사용하기 위해서는 비교대상이 있어야하기 때문

SELECT NAME 이름, BIRTHDAY 생년월일, MONTH(BIRTHDAY) 태어난달, 
		 CASE WHEN MONTH(BIRTHDAY) IN (1,2,3) THEN '1/4분기'
				WHEN MONTH(BIRTHDAY) IN (4,5,6) THEN '2/4분기'
				WHEN MONTH(BIRTHDAY) IN (7,8,9) THEN '3/4분기'
				WHEN MONTH(BIRTHDAY) IN (10,11,12) THEN '4/4분기'
		 END AS 분기
FROM STUDENT
ORDER BY 분기; 

SELECT NAME 이름, BIRTHDAY 생년월일, MONTH(BIRTHDAY) 태어난달, 
		 CASE WHEN MONTH(BIRTHDAY) BETWEEN 1 AND 3 THEN '1/4분기'
				WHEN MONTH(BIRTHDAY) BETWEEN 4 AND 6 THEN '2/4분기'
				WHEN MONTH(BIRTHDAY) BETWEEN 7 AND 9 THEN '3/4분기'
				WHEN MONTH(BIRTHDAY) BETWEEN 10 AND 12 THEN '4/4분기'
		 END AS 분기
FROM STUDENT
ORDER BY 분기; 

SELECT NAME 이름, BIRTHDAY 생년월일, MONTH(BIRTHDAY) 태어난달, 
		 CASE WHEN MONTH(BIRTHDAY) BETWEEN 1 AND 3 THEN '1/4분기'
				WHEN MONTH(BIRTHDAY) BETWEEN 4 AND 6 THEN '2/4분기'
				WHEN MONTH(BIRTHDAY) BETWEEN 7 AND 9 THEN '3/4분기'
				ELSE '4/4분기'
		 END AS 분기
FROM STUDENT
ORDER BY 분기;



-- professor테이블에서 학과번호, 교수명, 학과명 조회(학과번호가 101인 교수만 학과명을 ~로 하고 나머지는 아무것도 출력하지 않는다)
SELECT DEPTNO 학과번호, NAME 교수명,
		CASE DEPTNO
		WHEN 101 THEN 'Computer Engineering'
		ELSE ''
		END 학과명
FROM PROFESSOR;
