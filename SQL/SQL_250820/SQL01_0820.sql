USE sakila;
SHOW TABLES;
SELECT * FROM actor LIMIT 5;
SELECT
	first_name,
    last_name
FROM actor
WHERE actor_id < 100;

CREATE VIEW ActorInfo AS 
SELECT
	first_name,
    last_name
FROM actor
WHERE actor_id < 100;

SELECT * FROM ActorInfo;

CREATE VIEW ActorInfo AS 
SELECT
	first_name,
    last_name
FROM actor
WHERE actor_id < 100; # 동일 가상테이블명 존재하기 때문에 에러 발생!(Error Code : 1050)

CREATE OR REPLACE VIEW ActorInfo AS 
SELECT
	first_name,
    last_name
FROM actor
WHERE actor_id < 100;

DROP VIEW ActorInfo;

CREATE OR REPLACE VIEW myview AS
SELECT * FROM customer
WHERE customer_id = 1;

SELECT * FROM myview;

SELECT * FROM customer
WHERE customer_id = 1;

UPDATE customer
SET first_name = "DAVID"
WHERE customer_id = 1;

UPDATE myview
SET first_name = "MARY"
WHERE customer_id = 1;

#미션!!! ActorInfo라는 VIEW를 만드세요. 해당 VIEW는 actor 테이블에서
#first_name과 last_name 컬럼을 포함하고 있어야 합니다.
#actor_id가 50미만인 배우만 포함해야 합니다.

CREATE OR REPLACE VIEW ActorInfo AS
SELECT 
	first_name,
    last_name
FROM actor
WHERE actor_id < 50;

SELECT * FROM ActorInfo;

#미션!!! film 테이블에서 렌탈비용이 2달러보다 높은 영화에 대한 VIEW를 만들어주세요.
#해당 VIEW의 이름은 ExpensiveFilms이고, title, rental_rate 컬럼만 표함해야합니다.


SELECT rental_rate FROM film LIMIT 5;
CREATE OR REPLACE VIEW ExpensiveFilms AS
SELECT title,rental_rate
FROM film
WHERE rental_rate > 2;

SELECT * FROM ExpensiveFilms;

#선생님 코드
CREATE OR REPLACE VIEW Expensive AS
SELECT
	title,
    rental_rate
FROM film
WHERE rental_rate > 2.00;
SELECT * FROM Expensive;

RENAME TABLE Expensive TO ExpensiveFilms;

#미션!!! 이미 만든 VIEW인 ActorInfo를 수정하며 
#actor_id가 100 미만인 배우만 포함하도록 해주세요.

CREATE OR REPLACE VIEW ActorInfo AS
SELECT 
	first_name,
    last_name
FROM actor
WHERE actor_id < 100;
SELECT * FROM ActorInfo;
-----
DROP VIEW ActorInfo;
DROP VIEW ExpensiveFilms;

SELECT * FROM film;
SELECT * FROM inventory;

WITH FilmInventory AS (
	SELECT DISTINCT film_id FROM inventory
)
SELECT
	F.film_id, F.title
FROM film AS F
JOIN FilmInventory FI ON F.film_id = FI.film_id; 

#VIEW의 경우에는 어떤 raw 데이터 (*원본)를 가지고 있는 테이블이 존재하는데,
#해당 테이블에서 주로 자주사용하는 데이터와 거의 사용하지 않는 데이터가 공존하는 경우,
#굳이 해당 테이블을 가져올 때마다 자주 사용하는 데이터만 추출해서 가져오는 것이 비효율적인 경우 사용

#WITH의 경우에는 서로 다른 복수의 테이블간 교차하는 컬럼 데이터를 기준으로 값을
#찾아와야 하는 경우에 임시로 복수의 테이블 내 필요한 데이터만 가지고 있는 테이블을 
#생성해놓으면 복잡한 구문이 상대적으로 간소화 될 수 있고, 코드의 가독성도 좋아짐