/*
DCL : 계정, 권한 


루트 계정(root)으로 접속한 상태에서 계정를 생성할 수 있다.
CREATE USER 계정명 IDENTIFIED BY 비밀번호;

루트 계정만이 어떤계정의 비밀번호를 변경할 수 있다.
ALTER USER 계정명 IDENTIFIED BY 새비밀번호;

루트 계정만이 어떤계정을 삭제할 수 있다.
DROP USER 계정명;

루트 계정만이 어떤계정에 권한을 부여할 수 있다.
GRANT SELECT, INSERT, UPDATE ON 데이터베이스명.* TO '계정명';
GRANT ALL PRIVILEGES ON 데이터베이스명.테이블명 TO '계정명'; 

루트 계정만이 어떤계정의 권한을 회수할 수 있다.
REVOKE SELECT, UPDATE ON 데이터베이스명.테이블명 FROM '계정명';
REVOKE ALL PRIVILEGES ON 데이터베이스명.* FROM '계정명'; 

루트 계정에서 어떤계정이 가진 권한을 조회할 수 있다.
SHOW GRANTS FOR '계정명';


모든DB의 모든테이블 : *.*
특정데이터베이스의 모든테이블 : 데이터베이스명.*
특정데이터베이스의 특정테이블 : 데이터베이스명.테이블명

*/



------------------------
-- root계정에서 실행
------------------------
CREATE user kosta IDENTIFIED BY '1234';
ALTER USER kosta IDENTIFIED BY '1234';
DROP USER kosta;

GRANT SELECT, INSERT, UPDATE ON testdb.* TO 'kosta'; -- delete를 제외한 dml 권한 부여
GRANT ALL PRIVILEGES ON testdb.* TO 'kosta'; -- 해당 DB에 대한 모든 권한 부여
GRANT ALL PRIVILEGES ON *.* TO 'kosta'; -- 모든 DB에 대한 모든 권한 부여

REVOKE UPDATE ON testdb.* FROM 'kosta'; -- 해당 DB에 대해 update 권한 회수
REVOKE ALL PRIVILEGES ON testdb.* FROM 'kosta'; -- 해당 DB에 대해 모든 권한 회수
REVOKE ALL PRIVILEGES ON *.* FROM 'kosta'; 

SHOW GRANTS FOR 'kosta'; -- 해당 계정에 부여된 권한 확인
-- GRANT USAGE ON *.* TO `kosta`~: 부여된 권한은 없지만 계정은 있다는 것을 의미
-- GRANT ALL PRIVILEGES ON *.* TO `kosta`~ : 모든 권한을 가지고 있다는 것을 의미



--------------------------------
-- kosta계정에서 실행하여 확인
--------------------------------
SELECT * FROM ACCOUNT;
DELETE FROM ACCOUNT WHERE id='10001';



