-- DCL : 계정의 권한 조작
-- grant(권한 부여), revoke(권한 회수)
-- ex. 제약 - 참조하고 있는 자식테이블의 데이터가 있는 경우에는 삭제 불가 or 부모테이블의 값을 함께 삭제

-- 제약조건
-- not null, unique, primary key, foreign key, check

CREATE TABLE temp(
	id INT PRIMARY KEY, -- unique & not null
	NAME VARCHAR(20) NOT NULL 
);
------------------------------------------------------------------------
CREATE TABLE temp2(
	email VARCHAR(50) UNIQUE -- 빨간 열쇠 아이콘
);

INSERT INTO temp2 VALUES (NULL);
-- *** unique는 null값이 허용되고, null은 중복으로 삽입 가능
------------------------------------------------------------------------
CREATE TABLE temp3 (
	NAME VARCHAR(20) NOT NULL,
	age INT DEFAULT 1 CHECK(age>0) -- 값의 범위 제한
);

-- INSERT INTO temp3 VALUES ('hong'); 
-- 컬럼이 두개인 테이블에 한 컬럼에만 값을 삽입하고자할때는 컬럼명 명시해야함
INSERT INTO temp3 (NAME) VALUES ('hong');
-- name에만 주어진 값을 삽입하고 age에는 default값이 들어감

INSERT INTO temp3 VALUES ('kang', -1); 
-- age의 check제약조건 범위를 벗어나 삽입되지 않음
------------------------------------------------------------------------