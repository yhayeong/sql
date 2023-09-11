-- Test_MariaDB_Script.sql
-- SQL_실기문제_수정.docs

/* 
문제 1
제품이 생산된 공장위치가 "SEOUL"인 제품 중 판매점에 재고가 없는 상품을 출력한다.

조건:
1) 재고가 없는 조건은 재고 수량이 0이거나 null을 의미한다.
2) null인 경우 0 으로 표시한다.
*/

SELECT p.pdname 제품카테고리, p.PDSUBNAME 제품명, f.facname 공장명, sr.stoname 판매점명, ifnull(st.stamount,0) 판매점재고수량
FROM product p
Left JOIN factory f using(FACTNO)
left JOIN stock st using(PDNO)
JOIN store sr USING(stono)
WHERE f.FACLOC="SEOUL" AND (st.stamount=0 OR st.stamount IS NULL);



/* 
제품카테고리가 “TV”인 제품 중 가장 싼 것보다 비싸고 ( 수정 전 : 싼 모든 제품과 )
제품카테고리가 “CELLPHONE”인 제품 중 가장 비싼 제품보다 싼 모든 제품을 출력한다.

조건:
1) UNION을 사용하지 않고 하나의 쿼리 문장으로 작성 한다.
2) 제품원가를 기준으로 한다.
*/
SELECT pdsubname 제품명, pdcost 제품원가, pdprice 제품가격
FROM product
WHERE pdcost > (SELECT MIN(pdcost) FROM product WHERE pdname='TV')
AND pdcost < (SELECT MAX(pdcost) FROM product WHERE pdname='CELLPHONE');


/*
공장 위치가 ‘CHANGWON’에서 생산된 제품들에 결함이 발견되어 생산된 모든 제품을 폐기 하고자 한다. 
문제 3. 신규 테이블을 만들어 패기 되는 모든 데이터를 관리하고자 한다.
*/
-- 서브쿼리로 테이블 생성하고 컬럼과 제약조건 추가하는 방식으로 생성
CREATE TABLE DISCARDED_PRODUCT AS
SELECT p.pdno, p.pdname, p.pdsubname, f.FACTNO, p.PDDATE, p.PDCOST, p.PDPRICE, p.PDAMOUNT
FROM product p
JOIN factory f USING(FACTNO)
WHERE 1=2;

ALTER TABLE DISCARDED_PRODUCT ADD DISCARDED_DATE DATE;
ALTER TABLE discarded_product ADD PRIMARY KEY(pdno);
ALTER TABLE discarded_product ADD FOREIGN KEY(factno) REFERENCES factory(factno);


/* 
문제 4. PRODUCT 테이블에서 폐기되는 제품정보들을 모두 조회하여 DISCARDED_PRODUCT 테이블로 INSERT한다.
단, 트랜잭션 처리를 반드시 한다.

폐기대상: 공장 위치가 ‘CHANGWON’에서 생산된 제품들

조건:
1) 폐기 날짜는 현재 시스템 날짜로 한다.
*/

INSERT INTO discarded_product (pdno, pdname, pdsubname, factno, pddate, pdcost, pdprice, pdamount, DISCARDED_DATE)
SELECT p.pdno, p.pdname, p.pdsubname, f.FACTNO, p.PDDATE, p.PDCOST, p.PDPRICE, p.PDAMOUNT, SYSDATE()
FROM product p
JOIN factory f USING(FACTNO)
WHERE FACTNO = (SELECT FACTNO FROM factory WHERE FACLOC='CHANGWON');



/* 문제 5.
[문제 4]에서 폐기된 제품을 PRODUCT 테이블에서 모두 삭제 한다. 
단, 트랜잭션 처리를 반드시 한다.
 */
 
START TRANSACTION;
 
DELETE FROM product 
WHERE pdno in (SELECT pdno FROM discarded_product);
 
COMMIT;
 
-- SELECT * FROM product;


