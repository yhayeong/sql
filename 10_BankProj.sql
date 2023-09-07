/* 
BankProj
*/


-- 테이블생성(클래스 생성)
CREATE TABLE ACCOUNT(
	id VARCHAR(100) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	balance INT DEFAULT 0 CHECK(balance>=0),
	grade VARCHAR(100)	
);

-- 계좌개설(인스턴스 생성) makeAccount
INSERT INTO account (id, NAME, balance, grade) VALUES ('10001', '홍길동', 100000, 'VIP');
INSERT INTO account (id, NAME, balance, grade) VALUES ('10002', '하길동', 100000, 'Gold');

-- 입금 deposit
UPDATE account SET balance=balance+10000 WHERE id='10001';

-- 출금 withdraw
UPDATE account SET balance=balance-5000 WHERE id='10001';

-- 전체계좌조회 allAccountInfo
SELECT * FROM account;

-- 특정계좌조회 accountInfo
SELECT * FROM account WHERE id='10001';










