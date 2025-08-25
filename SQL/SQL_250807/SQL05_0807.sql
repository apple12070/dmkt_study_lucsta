USE musinsa_db_v1;

SELECT * FROM customers LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM reviews LIMIT 10;

#미션 1 ) 회원등급별 인원수 출력
SELECT grade, COUNT(*) 
FROM customers
GROUP BY grade
ORDER BY COUNT(*) DESC;

#미션 2) 상품별 평균평점 출력
SELECT product_name, AVG(rating) RT
FROM products P
JOIN reviews R
ON P.product_id = R.product_id
GROUP BY product_name
ORDER BY RT DESC;

#미션 3) 최근 30일 이내에 주문된 전체 총 건수 출력

SELECT COUNT(*) 
FROM orders
WHERE order_date >= CURDATE() - INTERVAL 30 DAY;

# 상품별 최근 한달간 주문건수를 구하세요!
SELECT * FROM orders LIMIT 1;
SELECT * FROM products LIMIT 1;

SELECT O.product_id, product_name P, COUNT(*) AS recent_order_count
FROM orders O
JOIN products P ON O.product_id = P.product_id
WHERE O.order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY product_id
ORDER BY recent_order_count DESC;

#미션!!! 고객별 총 구매 건수와 구매 수량을 구하시고 출력해주세요.

SELECT * FROM customers LIMIT 1;
SELECT * FROM orders LIMIT 1;

SELECT name,COUNT(O.customer_id) orders , SUM(quantity) quantity 
FROM orders O
JOIN customers C ON O.customer_id = C.customer_id
GROUP BY O.customer_id
ORDER BY orders DESC;

# 선생님 버전 !! GROUP BY는 id값으로 하는 것이 좋음! name으로 하면 중복값 나와서 결과값 달라질 수 있음
SELECT * FROM orders LIMIT 1;

SELECT
	O.customer_id,
    C.name,
    COUNT(*) order_count,
    SUM(O.quantity) total_quantity
FROM orders O
JOIN customers C ON O.customer_id= C.customer_id
GROUP BY O.customer_id
ORDER BY order_count DESC;

#미션!!! 고객별 총 구매금액(*할인가를 기준)을 계산 후 출력해주세요!!!
SELECT * FROM products LIMIT 1;
SELECT * FROM customers LIMIT 1;
SELECT * FROM orders LIMIT 1;

SELECT O.customer_id, C.name, SUM(P.discount_price * O.quantity) total_purchase FROM products P
JOIN orders O ON P.product_id = O.product_id
JOIN customers C ON C.customer_id = O.customer_id
GROUP BY O.customer_id
ORDER BY total_purchase DESC;

#선생님 코드
SELECT 
	O.customer_id, 
    C.name,
    SUM(P.discount_price * O.quantity) AS total_spent
FROM orders O
JOIN customers C ON O.customer_id = C.customer_id
JOIN products P ON O.product_id = P.product_id
GROUP BY O.customer_id
ORDER BY total_spent DESC;

#미션!!! 지금까지 가장 많이 판매된 상품 TOP 5를 출력해주세요!

SELECT * FROM products LIMIT 1;
SELECT * FROM customers LIMIT 1;
SELECT * FROM orders LIMIT 1;

SELECT P.product_name product_name, SUM(O.quantity) amount FROM products P
JOIN orders O ON O.product_id = P.product_id
JOIN customers C ON O.customer_id = C.customer_id
GROUP BY P.product_name
ORDER BY amount DESC LIMIT 5;

#선생님 코드

SELECT P.product_name, SUM(O.quantity) total_sold
FROM orders O
JOIN products P ON O.product_id = P.product_id
GROUP BY O.product_id
ORDER BY total_sold DESC LIMIT 5;

#미션!!! 평균 평점이 4.5 이상인 상품명과 평점을 출력해주세요. (*인기상품 추출)
SELECT * FROM products LIMIT 1;
SELECT * FROM reviews LIMIT 1;

SELECT P.product_name, AVG(R.rating) average_rating FROM products P
JOIN reviews R ON P.product_id = R.product_id
GROUP BY P.product_name
HAVING average_rating >=4.5
ORDER BY average_rating DESC;

#선생님 코드

SELECT P.product_name, AVG(R.rating) avg_rating
FROM reviews R
JOIN products P ON R.product_id = P.product_id
GROUP BY R.product_id
HAVING avg_rating >= 4.5
ORDER BY avg_rating DESC;
