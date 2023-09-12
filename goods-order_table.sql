-- 혼자 풀이

CREATE TABLE GOODS (
	CODE VARCHAR(250) PRIMARY KEY,
	NAME VARCHAR(250),
	price INT,
	stock INT,
	category VARCHAR(250)
);

CREATE TABLE `ORDER` (
	NO INT PRIMARY KEY,
	customer VARCHAR(250),
	productcode VARCHAR(250),
	amount INT,
	ISCANCELED TINYINT(1) DEFAULT 0
);
ALTER TABLE `ORDER` ADD FOREIGN KEY(productcode) REFERENCES goods(CODE);

-- UPDATE goods SET stock=30 WHERE (SELECT productcode FROM order WHERE NO=1);

DELETE FROM goods;
DELETE FROM `order`;

DROP TABLE `order`;
DROP TABLE goods;




-- 아래로 답

CREATE TABLE goods(
	CODE VARCHAR(20) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	price INT,
	stock INT,
	category VARCHAR(100)
);

CREATE TABLE `ORDER`(
	NO INT PRIMARY KEY,
	customer VARCHAR(100) NOT NULL,
	productCode VARCHAR(20) REFERENCES goods(CODE),
	amount INT,
	isCanceled TINYINT
);

-- 메인메뉴10.주문내역조회 (고객명과 취소여부를 통해 정상or취소 주문건수와 합계금액 조회)
select count(*), SUM(o.amount*g.price) 
from `order` o join goods g ON o.productCode=g.CODE 
where customer='홍길동' and isCanceled=1;

SELECT * FROM `order`;

DELETE FROM goods;
DELETE FROM `order`;