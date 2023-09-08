/* 개요
DDL : 테이블을 조작
create, alter, truncate(잘라내기/비우기), drop(삭제)
 + 제약조건

DML : 데이터를 조작
insert, update, delete, merge(병합)

DCL : 계정의 권한 조작
grant(권한 부여), revoke(권한 회수)
ex. 제약 - 참조하고 있는 자식테이블의 데이터가 있는 경우에는 삭제 불가 or 부모테이블의 값을 함께 삭제

TCL : 트랜잭션 조작
commit, rollbackkosta

DQL : 데이터 질의 
select
*/


-- DDL
-- 1. 데이터베이스 생성,삭제
CREATE DATABASE testdb;
DROP database testdb;




-- 2-1. 테이블 생성(대소문자 구별없음, INT는 사이즈 생략가능)
CREATE TABLE Person(
	NAME VARCHAR(100) NOT NULL,
	AGE INT DEFAULT 0,
	ADDRESS VARCHAR(100),
	EMAIL VARCHAR(100) PRIMARY KEY,
	BIRTHDAY DATE
-- 	PRIMARY KEY(EMAIL)
);

-- 컴럼에 PK를 붙이는 방식과 따로 PK를 작성하는 방식 모두 가능
-- PK는 not null & unique

-- 이미 있는 테이블에 ALTER를 통해 PK를 추가할 수 있다

-- cf. NUM INT AUTO_INCREMENT, (자동증가는 PK에서만 가능)

DROP TABLE person;




-- 2-2. 테이블 생성
-- 기존테이블을 이용하여 새 테이블 생성
CREATE TABLE emp_sub AS
SELECT empno, ename, job, hiredate, sal FROM emp WHERE deptno=10;

-- where절의 결과가 0이라면 (일부러 false로 만든 조건절을 이용하면) 데이터가 빈 테이블을 생성할 수 있다 
CREATE TABLE emp_tmp AS
SELECT empno, ename, job, hiredate, sal FROM emp WHERE 1=2;





-- 3. 테이블 변경
CREATE TABLE persons(
	id INT,
	last_name VARCHAR(255),
	first_name VARCHAR(255),
	address VARCHAR(255),
	city VARCHAR(200)
);

-- 컬럼 추가
ALTER TABLE persons ADD email VARCHAR(255);
-- 컬럼(의 길이) 변경
ALTER TABLE persons MODIFY COLUMN city VARCHAR(255);
-- 컬럼 삭제
ALTER TABLE persons DROP COLUMN email;
-- 컬럼 추가하면서 디폴트값 설정(null이 아닌 기본값으로 채워진다)
ALTER TABLE emp_sub ADD deptno int DEFAULT 10;
-- 컬럼명 변경
ALTER TABLE emp_sub RENAME COLUMN deptno TO dcode;
-- 테이블명 변경
RENAME TABLE emp_sub TO emp_10;




-- 4. truncate : 테이블 내용물 비우기
SELECT * FROM emp_10;
TRUNCATE TABLE emp_10;

-- cf.
-- delete(DML)와 truncate(DDL)의 차이점
-- CRUD는 데이터 조작을 의미 (삽입insert, 조회read, 갱신update, 삭제delete)
DELETE from emp;
-- 엄격히는, 이미 확보된 메모리 영역까지 삭제하는 truncate와 다르다
-- delete는 데이터를 삭제했다고 해서 empty메모리용량이 늘어나지 않는다








