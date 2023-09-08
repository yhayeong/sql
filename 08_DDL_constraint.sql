-- DDL

-- 제약조건
-- not null, unique, primary key, foreign key, check

------------------------------------------------------------------------

-- 1. pk

CREATE TABLE temp(
	id INT PRIMARY KEY, -- unique & not null
	NAME VARCHAR(20) NOT NULL 
);

------------------------------------------------------------------------

-- 2. unique
CREATE TABLE temp2(
	email VARCHAR(50) UNIQUE -- 빨간 열쇠 아이콘
);

INSERT INTO temp2 VALUES (NULL);
-- *** unique는 null값이 허용되고, null은 중복으로 삽입 가능

------------------------------------------------------------------------

-- 3. check
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

-- 4. fk

-- 유저와 글 테이블 생성
CREATE TABLE USER(
	id VARCHAR(20) PRIMARY KEY,
	NAME VARCHAR(20) NOT NULL
);
CREATE TABLE article(
	num INT AUTO_INCREMENT PRIMARY KEY, -- 1)
	title VARCHAR(50),
	content VARCHAR(1000),
	writer VARCHAR(20) REFERENCES USER(id) -- 2)
);
-- 1) AUTO_INCREMENT : 따로 INSERT하지 않거나 null을 입력해도 값이 1부터 자동증가하며 들어감
-- 2) USER테이블의 유일한값(보통은 PK)을 참조한 FK


INSERT INTO article (title, content) VALUES ('제목입니다', '내용입니다.'); 
INSERT INTO article (title, content, writer) VALUES ('제목입니다', '내용입니다.', 'hong');
-- user테이블에 hong이 없을때 hong을 writer에 삽입 불가

INSERT INTO user VALUES ('hong', '홍길동');
DELETE FROM user WHERE id='hong';
UPDATE user SET id='kong' WHERE id='hong';
-- user의 id 'hong'은 article테이블에서 참조되고 있으므로 삭제 혹은 변경 불가

UPDATE user SET NAME='공길동' WHERE id='hong';
-- user의 name컬럼은 참조되고있지 않으므로 변경 가능 
INSERT INTO user VALUES ('song', '송길동');
DELETE FROM user WHERE id='song';
-- 아직 참조되고 있지 않은 컬럼의 데이터 삭제 가능

-- fk 제약조건 삭제(DDL)
ALTER TABLE article DROP FOREIGN KEY NAME_of_fk;
DELETE FROM user WHERE id='hong';
-- fk를 삭제했으므로 (즉 참조관계가 끊어진) user의 id 'hong'은 삭제가능해짐


-- 생성된 테이블에 fk 제약조건 추가
-- ADD CONSTRAINT ARTICLE_USER_FK 문장은 fk 이름을 지정하는 법
ALTER TABLE article
ADD CONSTRAINT ARTICLE_USER_FK
FOREIGN KEY(writer) REFERENCES user(id);
-- *** fk 설정 오류 이유 :
-- fk로 설정하고자하는 컬럼인 writer에는 hong이 있는데, 참조하고자하는 부모컬럼 id에 hong이 없는상태이기 때문
-- 제약조건에 위배되는 데이터hong 때문에(즉 writer가 부모컬럼에 없는 값을 가지고 있기 때문에) fk로 만들수없다

ALTER TABLE article DROP FOREIGN KEY ARTICLE_USER_FK;

ALTER TABLE article
ADD CONSTRAINT ARTICLE_USER_FK
FOREIGN KEY(writer) REFERENCES user(id)
ON DELETE CASCADE;
-- ON DELETE CASCADE 옵션을 주면서 fk를 만들면
-- 부모컬럼의 데이터를 삭제할때 참조하고있는 자식컬럼의 데이터가 함께 삭제된다(참좁무결성 보장)

DELETE FROM user WHERE id='hong';
-- user테이블의 id컬럼의 데이터'hong'을 참조하고 있는 
-- article테이블의 writer컬럼의 데이터'hong'역시 삭제된다 (행 삭제)

------------------------------------------------------------------------

-- *** fk 연습

DROP TABLE article;
DROP TABLE user;

CREATE TABLE user(
	id VARCHAR(100),
	NAME VARCHAR(100)
);

CREATE TABLE article (
	num INT AUTO_INCREMENT PRIMARY key,
	-- mysql에서 AUTO_INCREMENT(오라클의 시퀀스에 해당)는 pk여야함
	title VARCHAR(500),
	content VARCHAR(1000),
	writer VARCHAR(100)
);


-- (1) 제약조건 추가
ALTER TABLE USER ADD CONSTRAINT USER_PK PRIMARY KEY (id);
ALTER TABLE article ADD CONSTRAINT ARTICLE_USER_FK FOREIGN KEY(writer) REFERENCES user(id);
-- [ADD CONSTRAINT 제약조건명]은 생략 가능

-- 데이터 삽입
-- INSERT into article VALUES(NULL, '제목1', '내용1', 'hong'); -- 부모컬럼에 없는 데이터 삽입 불가(fk 위배)
INSERT into article VALUES(NULL, '제목1', '내용1', NULL); -- null은 삽입 가능 (fk 위배되지 않음)

INSERT into user VALUES('hong', '홍길동');
INSERT INTO article VALUES(NULL, '제목2', '내용2', 'hong');
-- 부모컬럼에 있는 데이터 삽입 가능

-- DELETE FROM user WHERE id='hong';
-- UPDATE user SET id='kong' WHERE id='hong';
-- 참조되고 있는 부모컬럼의 데이터 삭제, 변경 불가

UPDATE user SET name='콩길동' WHERE id='hong';
-- (참조되지않는==)부모가 아닌 컬럼의 데이터 변경 가능


-- (2) 제약조건 삭제
ALTER TABLE article DROP CONSTRAINT ARTICLE_USER_FK;
INSERT INTO article VALUES (NULL, '송제목', '송내용', 'song'); 
-- 제약조건이 삭제됐기 때문에 부모컬럼에 없는 song값을 writer컬럼에 넣을 수 있음

-- ALTER TABLE article ADD CONSTRAINT ARTICLE_USER_FK FOREIGN KEY(writer) REFERENCES user(id);
-- 다시 제약조건 생성하려고하면 에러 발생하는데 그 이유는
-- 참조대상인 부모컬럼에 없는 값(제약조건에 위배되는 데이터)을 이미 가지고 있기 때문이다.

UPDATE article SET writer='hong' WHERE writer<>'hong';
-- fk위배를 해소하기 위해 hong이 아닌 데이터를 모두 hong으로 바꾼 뒤 다시 제약조건을 생성해본다


-- (3) ON DELETE CASCADE 옵션
ALTER TABLE article ADD CONSTRAINT ARTICLE_USER_FK FOREIGN KEY(writer) REFERENCES user(id) 
ON DELETE CASCADE;
-- 위와 같은 문제 발생을 예방하는 방법으로
-- fk를 생성할때 ON DELETE CASCADE 옵션을 추가하면 부모컬럼의 데이터를 삭제할때 참조하는 자식컬럼의 데이터 역시 삭제된다

DELETE FROM user WHERE id='hong';
-- 이제 참조되고있는 부모컬럼의 데이터이더라도 삭제 가능하며, 자식컬럼의 데이터가 함께 삭제된다 

-- 하지만 ON DELETE CASCADE는 위험성이 높아 실무에서 지양하는 방법이다
-- (참조여부를 인지하지 못한 채로 다수의 테이블에서 데이터를 삭제하게 될 가능성 때문)
 
------------------------------------------------------------------------

/* 제약조건 설정 표현식 정리

CREATE TABLE 테이블명(
	컬럼명1 자료형(사이즈) PRIMARY KEY,
	컬럼명2 자료형(사이즈) NOT NULL REFERENCES 부모테이블(부모컬럼)
);

CREATE TABLE 테이블명(
	컬럼명1 자료형(사이즈),
	컬럼명2 자료형(사이즈) NOT NULL,
	PRIMARY KEY(컬럼명1)
);

CREATE TABLE 테이블명(
	컬럼명1 INT AUTO_INCREMENT,
	컬럼명2 자료형(사이즈),
	PRIMARY KEY(컬럼명1),
	FOREIGN KEY(컬럼명2) REFERENCES 부모테이블(부모컬럼)
);

*/


------------------------------------------------------------------------

-- fk 연습문제
-- 실행없이 작성만 하기

CREATE TABLE tcons (
	NO INT,
	NAME VARCHAR(20),
	jumin VARCHAR(13),
	AREA INT,
	deptno VARCHAR(6)
);
ALTER TABLE tcons ADD CONSTRAINT tcons_no_pk PRIMARY KEY(NO);
ALTER TABLE tcons modify CONSTRAINT name VARCHAR(20) NOT null;
ALTER TABLE tcons modify CONSTRAINT jumin VARCHAR(23) NOT NULL;
-- 주의 : not null은 '컬럼의 수정'에 해당
ALTER TABLE tcons ADD CONSTRAINT tcons_jumin_uk UNIQUE(jumin);
ALTER TABLE tcons ADD CONSTRAINT tcons_area_ck CHECK(AREA IN(1,2,3,4));
ALTER TABLE tcons ADD CONSTRAINT tcons_deptno_fk FOREIGN KEY(deptno) REFERENCES dept2(dcode);

------------------------------------------------------------------------


 