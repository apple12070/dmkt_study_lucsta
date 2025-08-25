SELECT title, rental_rate,
CASE
	WHEN rental_rate < 1 THEN "Cheap"
    WHEN rental_rate BETWEEN 1 AND 3 THEN "Moderate"
    ELSE "Expensive"
END AS PriceCategory
FROM film;

#미션!!! WITH를 사용해서, sakila 데이터베이스의 각 등급별 영화의 평균 길이를 알아보세요.

SELECT * FROM film LIMIT 3;

WITH Avg_Runningtime AS (
	SELECT AVG(length) FROM film
)
SELECT 
	rating, AVG(length) AS Avg_runningtime
FROM film AS F
JOIN Avg_Runningtime AR ON AR; 


WITH AvgFilmLength AS (
	SELECT rating, AVG(length) AS avg_length
	FROM film
	GROUP BY rating
)
SELECT * FROM AvgFilmLength;

#미션!!! CASE WHEN 절을 사용해서 customer 테이블의 고객들을 active 컬럼에 따라
#"1 => Active" 또는 "그렇지 않으면 => Inactive"로 분류 및 출력해주세요.

#선생님 코드
SELECT
	customer_id,
    CASE
		WHEN active = 1 THEN "Active"
        ELSE "Inactive"
    END AS CustomerStatus
FROM customer;

#미션!!! WITH를 사용해서, sakila의 film 테이블에서 각 rating에 따른
#평균 rental_duration을 계산해보세요.
SELECT * FROM film LIMIT 3;

WITH AvgRentalduration AS (
	SELECT rating, AVG(rental_duration) AS AvgRentalduration
    FROM film F
    GROUP BY rating
)
SELECT * FROM AvgRentalduration;

#선생님 코드
WITH AvgRentalDuration AS (
	SELECT 
		rating, AVG(rental_duration)
	FROM film
    GROUP BY rating
)
SELECT * FROM AvgRentalDuration;

#WITH를 사용해서 sakila의 payment 테이블에서 각 고객별 총 지불액을 계산하고,
#그 지불액에 따라 고객을 "Low, Medium, High"로 분류하세요.
# Low : 0-50
# Medium : 51-100
# High : 100달러 초과

SELECT * FROM payment LIMIT 3;
SELECT customer_id, SUM(amount) AS TotalAmount,
	CASE
		WHEN SUM(amount) <=50 THEN "Low"
		WHEN SUM(amount) BETWEEN 51 AND 100 THEN "Medium"
		ELSE "High"
	END AS Totalrate
FROM payment
GROUP BY customer_id;

#선생님 코드
WITH CustomPayments AS (
	SELECT	
        customer_id, SUM(amount) AS total_payment
		FROM Payment
    GROUP BY customer_id
)
SELECT
	customer_id, ROUND(total_payment, 0),
    CASE
		WHEN ROUND(total_payment,0) BETWEEN 0 AND 50 THEN "Low"
		WHEN ROUND(total_payment,0) BETWEEN 51 AND 100 THEN "Medium"
		ELSE "High"
	END AS PaymentStautus
FROM CustomPayments;

SELECT
	C.customer_id,
    CONCAT(C.first_name, " ", C.last_name) AS customer_name,
    GROUP_CONCAT(F.title ORDER BY F.title ASC SEPARATOR " / ") AS rented_movies
FROM customer C
JOIN rental R USING (customer_id)
JOIN inventory I USING (inventory_id)
JOIN film F USING (film_id)
GROUP BY C.customer_id
LIMIT 10;

#미션!!! 각 배우(actor)가 출연한 영화들의 제목을 세미콜론(;)으로 구분하여 하나의 문자열로
#출력하세요. 결과에는 배우ID, 배우이름, 출연영화제목 리스트가 포함되도록 해주세요.

SELECT * FROM actor LIMIT 5; #actor_id
SELECT * FROM film_actor LIMIT 5; #film_id,actor_id
SELECT * FROM film LIMIT 5; #film_id

SELECT CONCAT(first_name," ",last_name) AS ActorName, ;

#선생님 코드

#actor -> actor_id, first_name, last_name -> CONCAT()
#film_actor -> actor_id, film_id -> JOIN()
#film -> film_id, title -> GROUP_CONCAT()

SELECT
	A.actor_id,
    CONCAT(A.first_name, " ",A.last_name) AS actor_name,
    GROUP_CONCAT(F.title ORDER BY F.title ASC SEPARATOR " ; ") AS films
FROM actor AS A
JOIN film_actor FA USING(actor_id)
JOIN film F USING(film_id)
GROUP BY A.actor_id
;