#미션!!! category테이블에서 Comedy, Sports, Family 카테고리의
#category_id와 카테고리명을 출력해주세요.

SELECT * FROM category LIMIT 5;

SELECT category_id , name
FROM category
WHERE name = "Comedy" OR name = "Sports" OR name = "Family"
GROUP BY category_id;

#선생님 코드
SELECT
	category_id,
    name 
FROM category
WHERE
	name = "Comedy" OR 
	name = "Sports" OR 
	name = "Family";

SELECT
	category_id, name
FROM category
WHERE
	name IN("Comedy", "Sports", "Family");
    
#미션!!! film_category 테이블에서 카테고리 ID별 영화 갯수 확인 및 출력 
SELECT * FROM film_category LIMIT 5;

SELECT category_id, COUNT(*) AS CNT
FROM film_category
GROUP BY category_id
ORDER BY category_id;

#선생님 코드
SELECT
	category_id, COUNT(*)
FROM film_category
GROUP BY category_id;

#미션!!! 카테고리가 Comedy인 영화 갯수 확인 및 출력 (*JOIN으로 작성해주세요)

SELECT * FROM film LIMIT 5; #film_id
SELECT * FROM category LIMIT 5; #category_id
SELECT * FROM film_category LIMIT 5; #category_id , film_id

SELECT COUNT(*) AS CNT
FROM film F 
JOIN film_category FC USING (film_id)
JOIN category C USING (category_id)
WHERE C.name = "Comedy";

#선생님 코드
SELECT COUNT(*) FROM category C
JOIN film_category F USING(category_id)
WHERE C.name = "Comedy";

#미션!!! 카테고리가 Comdey인 영화 갯수 확인 및 출력 (*Subquery로 작성해주세요.)
SELECT COUNT(*) AS CNT
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Comedy'
    )
);

#선생님 코드

SELECT COUNT(*) FROM film_category
WHERE category_id IN (
	SELECT category_id FROM category
    WHERE name ="Comedy"
);
	
#미션!!! Comedy, Sports, Family 각각의 카테고리별 영화 수 확인하기 (JOIN 사용)
SELECT * FROM category LIMIT 5;
SELECT * FROM film_category LIMIT 5;

SELECT C.name AS CategoryName, COUNT(*) AS CNT FROM film_category FC
JOIN category C USING (category_id)
WHERE C.name = "Comedy" OR C.name ="Sports" OR C.name ="Family"
GROUP BY category_id;

#선생님 코드
SELECT
	C.name, COUNT(*)
FROM category C
JOIN film_category USING(category_id)
WHERE 
	C.name IN ("Comedy","Sports","Family")
GROUP BY C.category_id;

#미션!!! 각 카테고리를 기준으로 영화 수가 70이상인 카테고리명을 출력해주세요.

SELECT * FROM film LIMIT 5; #film_id
SELECT * FROM category LIMIT 5; #category_id
SELECT * FROM film_category LIMIT 5; #category_id , film_id


SELECT C.name, COUNT(*) AS CNT
FROM film_category FC
JOIN category C ON FC.category_id = C.category_id
GROUP BY C.name
HAVING COUNT(*) >= 70;

#선생님 코드
SELECT C.name, COUNT(*) AS category_count FROM category C
JOIN film_category F USING(category_id)
GROUP BY C.category_id
HAVING COUNT(*) >= 70;

#미션!!! 각 카테고리에 포함된 영화들의 렌탈 횟수 구하기
SELECT * FROM film LIMIT 5; #film_id
SELECT * FROM film_category LIMIT 5; #film_id , category_id
SELECT * FROM category LIMIT 5; #category_id
SELECT * FROM inventory LIMIT 5; #inventory_id, film_id
SELECT * FROM rental LIMIT 5; #inventory_id

SELECT C.name CategoryName, COUNT(R.rental_id) AS RentalCount FROM film F
JOIN film_category FC USING (film_id)
JOIN category C USING (category_id)
JOIN inventory I USING (film_id)
JOIN rental R USING (inventory_id)
GROUP BY C.category_id
ORDER BY RentalCount DESC;

#선생님 코드

#렌탈횟수 -> 현재 우리가 가지고 있는 DVD 전체 총 아이템을 기준으로
#각 아이템들이 몇 번씩 렌탈이 되었는가?

#렌탈정보 : rental -> inventory_id
#inventory -> inventory_id,film_id
#film_category -> category_id,film_id
#category -> category_id

SELECT C.name,COUNT(*) FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY C.category_id;

#미션!!! Comedy, Sports, Family 카테고리에 포함되는 영화들의 렌탈 횟수 구하기

SELECT C.name,COUNT(*) FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
WHERE C.name IN ("Comedy","Sports","Family")
GROUP BY C.category_id;

#미션!!! 카테고리가 Comedy인 데이터의 렌탈 횟수 출력 (*서브쿼리 문법으로 작성)

SELECT 'Comedy' AS CategoryName,
       COUNT(*) AS RentalCount
FROM rental R
JOIN inventory I ON R.inventory_id = I.inventory_id
WHERE I.film_id IN (
    SELECT FC.film_id
    FROM film_category FC
    WHERE FC.category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Comedy'
    )
);

#선생님 코드

SELECT 
	COUNT(*)
FROM rental
WHERE inventory_id IN (
	SELECT inventory_id FROM inventory WHERE film_id IN (
		SELECT film_id FROM film_category WHERE category_id IN (
			SELECT category_id FROM category
            WHERE name = "Comedy"
		)
    )
);

#미션!!! address 테이블에는 address_id가 있지만, customer 테이블에는 
#없는 데이터의 갯수를 출력하세요. (*RIGHT JOIN)

SELECT * FROM address LIMIT 5;
SELECT * FROM customer LIMIT 5;

SELECT COUNT(*) AS NotUsedAddressCNT
FROM customer C
RIGHT JOIN address A ON C.address_id = A.address_id
WHERE C.address_id IS NULL;