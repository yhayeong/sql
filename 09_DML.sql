/* 
DML : insert, update, delete

cf.
delete(DML)와 truncate(DDL)의 차이점
CRUD는 데이터 조작을 의미 (삽입insert, 조회read, 갱신update, 삭제delete)

delete는 데이터를 삭제했다고 해서 empty메모리용량이 늘어나지 않는다
이미 확보된 메모리 영역까지 삭제하는 truncate(테이블비우기)와 다르다


1. 인서트
INSERT INTO 테이블명 (컬럼명1, 컬럼명2) VALUES (데이터, 데이터)

*/

INSERT INTO user (id, NAME) VALUES ('kong', '공길동');
INSERT INTO user (NAME, id) VALUES ('차길동', 'cha');
INSERT INTO user VALUES ('park', '박길동');
-- 컬럼목록 기재를 생략하게되면 모든 컬럼을 대상으로 데이터를 넣어줘야함


-- article테이블에 데이터 삽입하기
INSERT INTO article (title, content) VALUES ('title1', 'content1');
-- INSERT INTO article VALUES (NULL, 'title', 'content1', NULL); -- 바로 위와 같음
INSERT INTO article (title) VALUES ('title2');
INSERT INTO article (content) VALUES ('content');
INSERT INTO article (title, content, writer) VALUES ('title3', 'content3', 'kong');
INSERT INTO article (title, writer) VALUES ('title4', 'cha');
INSERT INTO article (content, writer) VALUES ('content5', 'park');
SELECT * FROM article; 



-- emp테이블에 데이터 삽입 
-- empno, ename, job, mgr, hiredate, sal, comm, deptno
-- int, var, var, int, date, int, int, int
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, deptno) VALUES (9999, 'hong', 'SALESMAN', 7369, CURDATE(), 1800, 40);
INSERT INTO emp VALUES (9999, 'hong', 'SALESMAN', 7369, CURDATE(), 1800, NULL, 40);

CREATE TABLE emp_sub (
	id INT,
	NAME VARCHAR(30)
);
INSERT INTO emp_sub (id, NAME) SELECT empno, ename FROM emp WHERE deptno=10;
-- 서브쿼리를 [values(데이터)] 대신 사용하여 인서트할 수 있다
-- 서브쿼리의 결과행 수만큼 삽입됨





/*  2. 업데이트
UPDATE 테이블명 SET 컬럼명1=데이터, 컬럼명2=데이터,... WHERE 조건;

emp테이블의 hong의 담당업무와 담당매니저를 바꾸기 */
UPDATE emp SET JOB='CLERK', MGR=7782 WHERE ename='hong';

-- comm이 0 또는 null인 직원들의 comm을 100으로 변경하기
UPDATE emp SET comm=100 WHERE comm IS NULL OR comm=0;

-- deptno이 10인 직원만 comm을 sal의 10%만큼 더 주기
UPDATE emp SET comm=comm+sal*0.1 WHERE deptno=10;

-- SMITH와 같은 직급인 직원들의 sal을 30% 인상하기 
-- 서브쿼리: SMITH의 직급
UPDATE emp SET sal=sal*1.3 WHERE job=(SELECT job FROM emp WHERE ename='SMITH');



/* 3. 딜리트
DELETE FROM 테이블명 WHERE 조건; 

emp테이블에서 이름이 hong인 행 삭제 */
DELETE FROM emp WHERE ename='hong';

-- emp에서 deptno이 40인 데이터 삭제
DELETE FROM emp WHERE DEPTNO=40;





/* 4. 트랜잭션
트랜잭션이란 하나이상의 dml질의를 한 작업단위로 묶은것.

*** START TRANSACTION 해주면 dml하는 시점에 물리적 반영이 아니라
COMMIT하는 시점에 물리적으로 반영되고, ROLLBACK이 가능하다.
(시작start transaction - 끝commit/rollback)

*** MySQL은 자동커밋이 디폴트이다.
즉, 트랜잭션내부에 있지 않은 경우 
각 명령문은 마치 START TRANSACTION 및 COMMIT로 둘러싸인 것처럼 동작하기 때문에
ROLLBACK하여 되돌릴 수 없다.
그러나 명령문 실행 중에 오류발생시 해당 명령문이 롤백된다. 

*/
START TRANSACTION;

DELETE FROM emp_sub WHERE NAME='CLARK';

ROLLBACK;

DELETE FROM emp_sub WHERE NAME='KING';

COMMIT;

SELECT * FROM emp_sub;





