SELECT film_id FROM film
UNION
SELECT film_id FROM inventory;

SELECT film_id FROM film
UNION ALL
SELECT film_id FROM inventory;

SELECT film_id FROM film
INTERSECT
SELECT film_id FROM inventory; #MySQL 8.0.31 이상에서만 사용가능한 문법

SELECT DISTINCT F.film_id
FROM film F
JOIN inventory I USING(film_id);

SELECT film_id
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM inventory
);

SELECT film_id FROM film
EXCEPT
SELECT film_id FROM inventory; #MySQL 8.0.31 이상에서만 사용가능한 문법

SELECT F.film_id
FROM film F
LEFT JOIN inventory I ON F.film_id = I.film_id
WHERE I.film_id IS NULL;

SELECT F.film_id
FROM film F
WHERE film_id NOT IN (
	SELECT I.film_id
    FROM inventory I
);

SELECT F.film_id
FROM film F
WHERE NOT EXISTS (
	SELECT I.film_id
    FROM inventory AS I
    WHERE F.film_id = I.film_id 
);

#미션!!! film 테이블과 film_category 테이블에서 각각 중복없이 film_id를 조회하는 SQL
#구문을 작성해주세요!
SELECT film_id FROM film
UNION
SELECT film_id FROM inventory;

#선생님 코드
SELECT film_id FROM film
UNION
SELECT film_id FROM film_category;

START TRANSACTION;

# UPDATE payment SET amount = 10.0; 누르지마누르지마
