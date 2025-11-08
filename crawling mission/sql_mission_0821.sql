# [8/21(목) 과제]
# 각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다.
# 각 고객별로 가장 많이 대여한 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, => SELECT 영화카테고리/대여횟수  // RANK() OR DENSE_RANK() =1 조건 걸기, PARTITION BY로 각 고객별로 나눠서 계산
# 그리고 해당 고객 이름을 조회하는 SQL 구문을 작성해주세요.  => SELECT 고객이름
# 자주 대여하는 카테고리에 동률이 있을 경우 모두 보여주세요.  => RANK() OR DENSE_RANK() OVER 아무거나 상관없을듯 어차피 최다대여항목만 출력하니께
--------------------------------------------------------------------------------------------------------------------------------------------------
# 1) SELECT 고객 이름, 영화카테고리, 대여횟수 , 2) 각 고객별로 최다대여한 영화 카테고리와 그 대여횟수 계산(PARTITION BY 도전.) (*최다대여횟수가 동률일 경우 다 출력해야 하니까 RANK()/DENSE_RANK() 얘도 도전.)

USE sakila;
SELECT * FROM customer LIMIT 5; # customer_id
SELECT * FROM rental LIMIT 5; # rental_id, customer_id
SELECT * FROM category LIMIT 5; # category_id, name
SELECT * FROM film_category LIMIT 5; #film_id, category_id
SELECT * FROM inventory LIMIT 5; #film_id, category_id
SELECT * FROM film LIMIT 5; #film_id, category_id

SELECT CustomerName, CategoryName, RentalCount
FROM (
    SELECT 
        C.customer_id,
        CONCAT(C.first_name, " ", C.last_name) AS CustomerName,
        CA.name AS CategoryName,
        COUNT(*) AS RentalCount,
        DENSE_RANK() OVER (PARTITION BY C.customer_id ORDER BY COUNT(*) DESC) AS Ranking
    FROM customer C
    JOIN rental R ON C.customer_id = R.customer_id
    JOIN inventory I ON R.inventory_id = I.inventory_id
    JOIN film F ON I.film_id = F.film_id
    JOIN film_category FC ON F.film_id = FC.film_id
    JOIN category CA ON FC.category_id = CA.category_id
    GROUP BY C.customer_id, CategoryName
) AS abc
WHERE Ranking = 1
ORDER BY CustomerName ASC;