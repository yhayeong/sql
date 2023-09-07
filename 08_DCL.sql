-- DCL : 계정의 권한 조작
-- grant(권한 부여), revoke(권한 회수)
-- ex. 제약 - 참조하고 있는 자식테이블의 데이터가 있는 경우에는 삭제 불가 or 부모테이블의 값을 함께 삭제

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
-- *** fk 만들기 오류나는 이유로,
-- article의 writer에는 hong이 있는데, 참조하고자하는 부모테이블의 id에 hong이 없었기 때문
-- 제약조건에 위배되는 데이터 hong 때문에(즉 writer가 부모컬럼에 없는 값을 가지고 있기 때문에) fk로 만들수없다

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



------------------------------------------------------------------------




------------------------------------------------------------------------



------------------------------------------------------------------------


 