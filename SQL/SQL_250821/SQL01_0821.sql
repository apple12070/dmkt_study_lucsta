#문제 9. address 테이블에는 address_id가 있지만, customer 테이블에는 
#없는 데이터의 갯수 출력!!! (*INNER JOIN // RIGHT JOIN)
USE sakila;

#INNER JOIN 버전
SELECT * FROM address; #603
SELECT * FROM customer; #599

SELECT
	COUNT(A.address_id)
FROM address A
JOIN customer C USING (address_id);

SELECT 
	(SELECT COUNT(*) FROM address) - 
	(SELECT
		COUNT(A.address_id)
	FROM address A
	JOIN customer C USING (address_id)) AS no_customer_address;

# 1 + 2 = 3

#RIGHT JOIN 버전
SELECT COUNT(*) AS no_customer_address
FROM customer C
RIGHT OUTER JOIN address A 
ON A.address_id = C.address_id
WHERE customer_id IS NULL;

#문제 10. 캐나다 고객에게 이메일 마케팅 캠페인을 진행하고자 합니다.
#캐나다 고객의 이름과 이메일 주소 리스트를 출력해주세요.

SELECT * FROM customer LIMIT 5; #customer_id, address_id
SELECT * FROM address LIMIT 50; #address_id, city_id
SELECT * FROM country LIMIT 150; #country_id
SELECT * FROM city LIMIT 150; #country_id, city_id

SELECT CONCAT(C.first_name," ",C.last_name) AS Name, C.email AS Email FROM customer C
JOIN address A ON A.address_id = C.address_id
JOIN city CI ON CI.city_id = A.city_id
JOIN country CO ON CO.country_id = CI.country_id
WHERE CO.country = "Canada";

#선생님 코드
#customer => address_id
#address => address_id & city_id
#city => city_id & country_id
#country => country_id

SELECT
	first_name,
    last_name,
    email
FROM customer
JOIN address AD USING(address_id)
JOIN city CI USING(city_id)
JOIN country CO USING(country_id)
WHERE CO.country = "Canada";

#문제 11. 신혼부부들 타겟고객들의 매출이 최근 저조해져서 가족영화를 홍보대상으로 
#삼고자 합니다. 가족 영화로 분류된 모든 영화 리스트를 출력해주세요.

SELECT * FROM category LIMIT 50; #category_id, name("Family")
SELECT * FROM film LIMIT 50; #film_id, title
SELECT * FROM film_category LIMIT 50; #film_id, category_id

SELECT F.title, C.name FROM film F
JOIN film_category FC USING (film_id)
JOIN category C USING (category_id)
WHERE C.name = "Family";

#선생님 코드
SELECT F.title
FROM film F
JOIN film_category FC USING(film_id)
JOIN category CA USING(category_id)
WHERE CA.name = "Family";

#문제12. 가장 자주 대여하는 영화 리스트를 참고로 보고 싶습니다.
#가장 자주 대여하는 영화 순으로 100개만 뽑아주세요.
#뽑아달라는 것의 의미는 "영화제목"과 "렌탈횟수"

SELECT * FROM film LIMIT 5; #film_id, title
SELECT * FROM inventory LIMIT 5; #film_id, inventory_id
SELECT * FROM rental LIMIT 5; #inventory_id

SELECT F.title, COUNT(R.rental_id) AS rental_num FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.title
ORDER BY rental_num DESC LIMIT 100;

#선생님 코드
SELECT F.title, COUNT(*) FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id
ORDER BY COUNT(*) DESC LIMIT 100;

#문제 13. 각 스토어별로 매출을 확인하고 싶습니다. 관련 데이터를 출력해주세요.
#관련 데이터는 다음과 같습니다.
#"도시,국가" // 스토어ID // 스토어별 총 매출

SELECT * FROM store LIMIT 5; #stord_id,address_id
SELECT * FROM address LIMIT 5; #address_id,city_id
SELECT * FROM city LIMIT 5; #country_id,city
SELECT * FROM country LIMIT 5; #country_id,country

SELECT * FROM store LIMIT 5; #stord_id,address_id
SELECT * FROM  staff LIMIT 5; # address_id,amount
SELECT * FROM payment LIMIT 5; # staff_id,amount

SELECT 
	CONCAT(city.city,",",country.country) AS Address,
    store.store_id,
    SUM(payment.amount) AS Total_amount
FROM store
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id)
JOIN staff USING(store_id)
JOIN payment USING(staff_id)
GROUP BY store.store_id
ORDER BY store.store_id;

#선생님 코드
#payment -> amount //staff_id
#staff -> staff_id & stord_id
#store -> store_id & address_id
#address -> address_id & city_id
#city -> city_id & country_id
#country -> country_id

SELECT 
	CONCAT(CI.city, ", ",CO.country) AS store,
    STO.store_id AS Store_ID,
    SUM(P.amount) AS Total_Sales
FROM payment P
JOIN staff STA ON STA.staff_id = P.staff_id
JOIN store STO ON STO.store_id = STA.store_id
JOIN address A ON A.address_id = STO.address_id
JOIN city CI ON CI.city_id = A.city_id
JOIN country CO ON CO.country_id = CI.country_id
GROUP BY STO.store_id;

#문제 14. 가장 렌탈비용을 많이 지불한 상위 10명의 VIP 고객에게 선물을 배송하고자 합니다.
#해당 VIP 고객들의 이름, 주소, 이메일, 그리고 각 고객별 그동안 총 지불비용을 출력해주세요.

SELECT * FROM customer LIMIT 5; #customer_id,address_id,first_name,last_name,email
SELECT * FROM rental LIMIT 5; #rental_id,customer_id
SELECT * FROM  staff LIMIT 5; # address_id,amount
SELECT * FROM payment LIMIT 5; # staff_id,amount

SELECT 
	ROW_NUMBER() OVER (ORDER BY SUM(P.amount) DESC) AS row_num,
    C.customer_id, CONCAT(C.first_name," ",C.last_name) AS Name, 
    C.email, 
    SUM(P.amount) AS Total_payment
FROM customer C
JOIN address A USING(address_id)
JOIN payment P USING(customer_id)
GROUP BY C.customer_id
ORDER BY SUM(P.amount) DESC LIMIT 10;

#선생님 코드
SELECT
	C.first_name, C.last_name,
    A.address, C.email,
	SUM(P.amount) AS total_amount
FROM payment P
JOIN customer C USING(customer_id)
JOIN address A USING(address_id)
GROUP BY P.customer_id
ORDER BY total_amount DESC
LIMIT 10;

#문제 15. actor 테이블의 배우 이름을 first_name과 last_name의 조합으로 
#출력해주세요. 단, 소문자로 출력해주세요. Actor_Name이라는 필드명으로 출력하세요.

SELECT * FROM actor LIMIT 5;
SELECT 
	LOWER(CONCAT(first_name, " ",last_name)) AS Actor_Name 
FROM actor;

#선생님 코드
SELECT
	CONCAT(
		UPPER(LEFT(first_name,1)), LOWER(SUBSTR(first_name, 2)),
        " ",
        UPPER(LEFT(last_name,1)), LOWER(SUBSTR(last_name, 2))
        ) AS Actor_Name
FROM actor;

#문제 16. 언어가 영어인 영화 중 영화 타이틀이 K와 Q로 시작하는 영화의 타이틀만 출력해주세요.
#서브쿼리로 가져오세요.

SELECT * FROM film LIMIT 5;
SELECT * FROM language LIMIT 5; #language_id,name(English)

SELECT title 
FROM film
WHERE language_id =(
	SELECT language_id
    FROM language
    WHERE name = 'English'
)
AND (title LIKE 'K%' OR title LIKE 'Q%');

#선생님 코드

SELECT
	title
FROM film
WHERE language_id IN (
	SELECT language_id FROM language
    WHERE name = "English"
) AND (title LIKE "K%" OR title LIKE "Q%");

#문제 17. Alone Trip에 나오는 배우 이름을 모두 출력하세요. ->하나의 문장으로 출력!
#단, 배우이름은 actor_name이라는 필드명으로 출력해주세요.
#서브쿼리를 사용해주세요.

SELECT * FROM actor LIMIT 5; #actor_id
SELECT * FROM film_actor LIMIT 5; #actor_id, film_id
SELECT * FROM film LIMIT 5; #film_id

SELECT CONCAT(first_name, " ",last_name) AS actor_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id IN (
		SELECT film_id FROM film
        WHERE title = "Alone Trip"
	) 
) ;

#선생님 코드
SELECT
	CONCAT(first_name," ",last_name) actor_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id IN (
		SELECT film_id FROM film
        WHERE title ="Alone Trip"
    )
);

#문제 19. 2005년 8월에 각 스태프 멤버가 올린 매출을 출력해주세요.
#스태프 멤버의 필드명은 Staff_Member로, 매출필드명은 Total_Amount로 출력해주세요.

SELECT * FROM  staff LIMIT 5; # staff_id
SELECT * FROM payment LIMIT 5; # staff_id,amount

SELECT 
    (SELECT CONCAT(first_name, ' ', last_name) 
     FROM staff s 
     WHERE s.staff_id = p.staff_id) AS Staff_Member,
    SUM(amount) AS Total_Amount
FROM payment p
WHERE DATE_FORMAT(p.payment_date, '%Y-%m') = '2005-08'
GROUP BY p.staff_id;

#선생님 코드
SELECT
	CONCAT(S.first_name, " ", last_name) Staff_Member,
    SUM(P.amount) Total_Amount
FROM staff S
JOIN payment P USING (staff_id)
WHERE payment_date LIKE "2005-08%"
GROUP BY P.staff_id;

SELECT
	CONCAT(S.first_name, " ", last_name) Staff_Member,
    SUM(P.amount) Total_Amount
FROM staff S
JOIN payment P USING (staff_id)
WHERE 
	EXTRACT(YEAR FROM payment_date) = 2005 AND
	EXTRACT(MONTH FROM payment_date) = 8
GROUP BY P.staff_id;

SELECT
	CONCAT(S.first_name, " ", last_name) Staff_Member,
    SUM(P.amount) Total_Amount
FROM staff S
JOIN payment P USING (staff_id)
WHERE 
	YEAR(payment_date) = 2005 AND
	MONTH(payment_date) = 8
GROUP BY P.staff_id;

#문제 20. 각 카테고리의 평균 영화 러닝타임이 전체 평균 러닝타임보다 큰
#카테고리들의 카테고리명과 해당 카테고리의 평균 러닝타임을 출력하세요.

SELECT * FROM film LIMIT 5; #film_id,length
SELECT * FROM film_category LIMIT 5; #film_id,category_id
SELECT * FROM category LIMIT 5; #category_id,name

SELECT AVG(F.length) FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
    WHERE category_id IN (
		SELECT category_id FROM category
        WHERE 
    )
);

#선생님 코드

SELECT
	C.name,
	AVG(F.length) film_length
FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name
HAVING AVG(F.length) > (
	SELECT AVG(length) FROM film
);

#문제 21. 각 카테고리별 평균 영화 대여시간과 해당 카테고리명을 출력하세요.
#단, 영화 대여 시간 => 영화 대여 및 반납 시간의 차이, hour를 단위로 사용하세요.

SELECT * FROM category LIMIT 5; #category_id, name
SELECT * FROM film_category LIMIT 5; # category_id,film_id
SELECT * FROM inventory LIMIT 5; # film_id,inventory_id
SELECT * FROM rental LIMIT 5; # inventory_id

SELECT
	C.name,
	AVG(TIMESTAMPDIFF(HOUR,R.rental_date,R.return_date);
    
#선생님 코드
#대여시간 : rental => inventory_id
#inventory : inventory_id & film_id
#film_category : film_id & category_id
#category : category_id

SELECT
	C.name,
    AVG(TIMESTAMPDIFF(HOUR,R.rental_date,R.return_date)) AS diff_time
FROM rental R
JOIN inventory I USING (inventory_id)
JOIN film_category F USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name;

#문제 22. 새로운 임원이 부임했습니다. 총 매출액 상위 5개 장르의 매출액을 수시로 확인하고자 합니다.
#각 장르별 총 매출액(Total Sales), 각 장르(Genre) 이름으로 
#해당 데이터를 수시로 확인 할 수 있는 VIEW를 생성해주세요.
#VIEW의 이름은 top5_genres로 만들어주시고, 총 매출액 상위 5개 장르의 매출액이
#출력될 수 있도록 해주세요.

SELECT * FROM film LIMIT 5; #film_id
SELECT * FROM inventory LIMIT 5; #film_id,inventory_id
SELECT * FROM film_category LIMIT 5; #film_id,category_id
SELECT * FROM category LIMIT 5; #category_id, name
SELECT * FROM rental LIMIT 5; #inventory_id, rental_id
SELECT * FROM payment LIMIT 5; #rental_id, amount

CREATE OR REPLACE VIEW top5_genres AS 
SELECT 
	category.name AS Genre
	SUM(payment.amount) AS Total Sales
FROM category
JOIN film_category USING(category_id);

#선생님 코드

CREATE OR REPLACE VIEW top5_genres AS  
	SELECT 
		C.name AS Genre,
		SUM(P.amount) AS Total_Sales
    FROM payment P # rental_id
    JOIN rental R USING(rental_id) #inventory_id
    JOIN inventory I USING(inventory_id) #film_id
    JOIN film_category F USING(film_id) #category_id
    JOIN category C USING(category_id) #category_id
    GROUP BY C.name
    ORDER BY SUM(P.amount) DESC
    LIMIT 5;

SELECT * FROM top5_genres;

#문제23. 2005년 5월에 가장 많이 대여된 영화 3개를 찾아주세요. 영화제목과 대여횟수를 출력하면 됩니다!

SELECT * FROM rental LIMIT 5; #rental_id,inventory_id
SELECT * FROM film LIMIT 5; # film_id, title
SELECT * FROM inventory LIMIT 5; # film_id, inventory_id

SELECT F.title, COUNT(R.rental_id) rental_count FROM film F 
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE R.rental_date BETWEEN '2005-05-01' AND '2005-05-31'
GROUP BY F.title
ORDER BY rental_count DESC
LIMIT 3;

#선생님 코드

SELECT 
	F.title,
	COUNT(*) AS rental_count
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
WHERE
	MONTH(R.rental_date) = 5 AND
    YEAR(R.rental_date) = 2005
GROUP BY F.film_id
ORDER BY rental_count DESC
LIMIT 3;

#문제24. 대여된 적이 없는 영화를 찾으세요.

SELECT * FROM rental LIMIT 5; #rental_id,inventory_id
SELECT * FROM film LIMIT 5; # film_id, title
SELECT * FROM inventory LIMIT 5; # film_id, inventory_id

#선생님 코드

#rental =>inventory_id
#inventory =>inventory_id & film_id
#film => film_id

SELECT
	title
FROM film
WHERE film_id IN (
	SELECT film_id FROM inventory I
    JOIN rental R USING(inventory_id)
);

#문제25. 각 고객의 총 지출 금액의 평균보다 총 지출금액이 더 큰 고객 리스트를
#찾으세요. 그들의 이름과 그들이 지출한 총 금액을 보여주세요.
#고객 A 5번 렌트, 총 100달러
#고객 B 3번 렌트, 총 80달러
#고객당 평균 지출금액 90달러 

SELECT * FROM payment LIMIT 5; # payment_id, customer_id, amount
SELECT * FROM customer LIMIT 5; #customer_id, first_name,last_name

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING SUM(p.amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id
    ) AS sub
);

#선생님 코드

SELECT
	C.first_name, C.last_name,
    SUM(P.amount)
FROM payment P
JOIN customer C USING(customer_id)
GROUP BY C.customer_Id
HAVING SUM(P.amount) > (
	SELECT
		AVG(sum_amount)
	FROM (
		SELECT SUM(amount) AS sum_amount
	FROM payment
	GROUP BY customer_id
	) AS sub_query
);

#문제 26. 가장 많은 결제건을 처리한 직원이 누구인지 찾아주세요.
SELECT * FROM staff LIMIT 5; #staff_id, first_name,last_name
SELECT * FROM payment LIMIT 5; #staff_id

SELECT CONCAT(S.first_name, " ",S.last_name) StaffName, COUNT(*) FROM staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id
ORDER BY COUNT(*) DESC
LIMIT 1;

#선생님코드
SELECT
	S.staff_id, S.first_name, S.last_name,
    COUNT(*) AS count_many
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id
ORDER BY COUNT(*) DESC LIMIT 1;

#문제27. "액션" 카테고리에서 높은 영화 영상 등급을 받은 순으로, 상위 5개의 영화를 보여주새요.
#(*높은 영화 영상 등급 순으로의 정렬은 ORDER BY rating DESC)

SELECT * FROM film LIMIT 1; #film_id, title, rating
SELECT * FROM film_category LIMIT 1; #film_id,category_id
SELECT * FROM category LIMIT 1; #category_id

SELECT C.name, F.title FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = "Action"
ORDER BY rating DESC LIMIT 5;

#선생님 코드
SELECT 
	F.title, F.rating
FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = "Action"
ORDER BY rating DESC 
LIMIT 5;

SELECT
	DISTINCT rating
FROM film;
DESC film;
#film 테이블의 rating 컬럼은 enum타입 -> ('G','PG','PG-13','R','NC-17')로 값의 
#순서를 임의로 할당 -> DESC 걸면 NC-17부터 출력됨

#문제 28.각 영화 영상등급을 기준으로 영화별 대여기간의 평균을 찾아주세요.

#선생님 코드
SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating;

#문제 29. 매장 ID별 총 매출을 보여주는 VIEW를 생성하세요.

CREATE OR REPLACE VIEW AS;

SELECT * FROM store LIMIT 5; #stord_id
SELECT * FROM payment LIMIT 5; #payment_id,rental_id,amount
SELECT * FROM rental LIMIT 5; #inventory_id,rental_id
SELECT * FROM inventory LIMIT 5; #inventory_id,store_id

#선생님 코드

CREATE OR REPLACE VIEW total_sales_by_store AS 
	SELECT 
		S.store_id,
        SUM(P.amount)
	FROM store S 
    JOIN staff ST USING(store_id)
    JOIN payment P USING(staff_id)
    GROUP BY S.store_id;
    
SELECT * FROM total_sales_by_store;
DROP VIEW total_sales_by_store;

#문제30. 가장 많은 고객이 있는 상위 5개 국가를 보여주세요.

SELECT * FROM customer LIMIT 5; #customer_id,address_id
SELECT * FROM address LIMIT 5; #address_id, city_id
SELECT * FROM city LIMIT 5; #city_id, country_id
SELECT * FROM country LIMIT 5; #country_id, country

SELECT country.country, COUNT(customer.customer_id) FROM country
JOIN city USING(country_id)
JOIN address USING(city_id)
JOIN customer USING(address_id)
GROUP BY country
ORDER BY COUNT(customer.customer_id) DESC LIMIT 5;

#선생님 코드
SELECT
	CO.country,
    COUNT(*) customer_count
FROM country CO
JOIN city CI USING(country_id)
JOIN address A USING(city_id)
JOIN customer C USING(address_id)
GROUP BY CO.country
ORDER BY customer_count DESC LIMIT 5;


