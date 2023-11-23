CREATE TABLE MEMBER(
   id VARCHAR(100) PRIMARY KEY,
   NAME VARCHAR(100),
   PASSWORD VARCHAR(100),
   email VARCHAR(100),
   address VARCHAR(100)
);

CREATE TABLE BOARD (
	NUM INT AUTO_INCREMENT PRIMARY KEY,
	SUBJECT VARCHAR(255),
	CONTENT VARCHAR(255),
	WRITEDATE DATE,
	FILEURL VARCHAR(255),
	WRITER VARCHAR(100) REFERENCES member(ID),
	viewcount INT DEFAULT 0,
	likecount INT DEFAULT 0
);


CREATE TABLE boardlike (
   num INT AUTO_INCREMENT PRIMARY KEY,
   member_id VARCHAR(100) REFERENCES member(id),
   board_num INT REFERENCES board(num)
);

CREATE TABLE FILE(
	num INT AUTO_INCREMENT PRIMARY KEY,
	DIRECTORY VARCHAR(255),
	NAME VARCHAR(255),
	size INT,
	contenttype VARCHAR(255),
	uploaddate DATE,
	DATA LONGBLOB
);

CREATE TABLE ACCOUNT(
	id VARCHAR(100) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	balance INT DEFAULT 0 CHECK(balance>=0),
	TYPE VARCHAR(100),
	grade VARCHAR(100)	
);


SELECT * FROM board;

INSERT INTO member values ('user01', '김성탄1', '1234', 'email01@gmail.com', '주소1');
INSERT INTO member values ('user02', '김성탄2', '1234', 'email02@gmail.com', '주소2');
INSERT INTO member values ('user03', '김성탄3', '1234', 'email03@gmail.com', '주소3');
INSERT INTO member values ('user04', '김성탄4', '1234', 'email04@gmail.com', '주소4');
INSERT INTO member values ('user08', '김성탄8', '1234', 'email08@gmail.com', '주소8');

INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목', '내용', CURDATE(), 'user01');
INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목2', '내용', CURDATE(), 'user01');
INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목3', '내용', CURDATE(), 'user02');
INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목4', '내용', CURDATE(), 'user03');
INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목5', '내용', CURDATE(), 'user08');
INSERT INTO board (SUBJECT, content, writedate, writer) VALUES ('제목6', '내용', CURDATE(), 'user08');

INSERT INTO account VALUES ('10001', '김성탄1', 100000, 'normal', NULL);
INSERT INTO account VALUES ('10002', '김성탄2', 100000, 'special', 'VIP');
INSERT INTO account VALUES ('10003', '김성탄3', 100000, 'special', 'Gold');
