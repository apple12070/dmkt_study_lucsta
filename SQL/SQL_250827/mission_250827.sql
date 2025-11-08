# 250827 미션!!! 
# Sakila DB를 참고해서, 가장 많은 영화를 대여한 고객(*단, 가장 많은 영화의 기준 -> 동일한 영화를 반복해서 대여한 경우의 수는 제외, 오직 서로 다른 영화를 대여했다는 기준으로만) 을 찾아내고, 
# 해당 고객이 대여한 영화 갯수를 찾아주세요. 또한 해당 고객이 대여한 영화가 가장 많이 속한 카테고리(*단, 이때에는 동일한 영화를 반복해서 대여한 경우의 수도 포함)도 찾아주세요.

USE sakila;

SELECT * FROM customer LIMIT 5; # customer_id
SELECT * FROM rental LIMIT 5; # customer_id, inventory_id
SELECT * FROM inventory LIMIT 5; # inventory_id, film_id
SELECT * FROM film LIMIT 5; # film_id
SELECT * FROM film_category LIMIT 5; # film_id, category_id
SELECT * FROM category LIMIT 5; # category_id

# 중복 없이 가장 많은 영화를 대여한 고객(RANK() OVER -> ORDER BY COUNT(DISTINCT F.film_id) -> DESC), *1등 여러명 있을 수 있음
# 해당 고객이 대여한 영화 갯수(중복x)(COUNT(DISTINCT F.film_id)), 
# 해당 고객이 대여한 영화가 가장 많이 속한 카테고리(ROW_NUMBER() OVER -> PARTITION BY customer_id -> ORDER BY COUNT(*)) *카테고리는 1등 하나만 출력
----------------------------------------------------------------------

SELECT 
    customer_id,
    customer_name,
    distinct_movie_count,
    top_category
FROM (
    SELECT 
        C.customer_id,
        CONCAT(C.first_name, " ", C.last_name) AS customer_name,
        COUNT(DISTINCT F.film_id) AS distinct_movie_count,
        CAT.name AS top_category,
        COUNT(*) AS category_rental_count,
        ROW_NUMBER() OVER (
            PARTITION BY C.customer_id ORDER BY COUNT(*) DESC
        ) AS category_ranking,
        RANK() OVER (
            ORDER BY COUNT(DISTINCT F.film_id) DESC
        ) AS customer_ranking
    FROM customer C
    JOIN rental R USING(customer_id)
    JOIN inventory I USING(inventory_id)
    JOIN film F USING(film_id)
    JOIN film_category FC USING(film_id)
    JOIN category CAT USING(category_id)
    GROUP BY C.customer_id, CAT.name
) abc
WHERE category_ranking = 1 AND customer_ranking = 1
ORDER BY customer_id ASC;
	