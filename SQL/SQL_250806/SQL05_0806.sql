SELECT rating FROM film
GROUP BY rating;

SELECT rating, COUNT(*) FROM film
GROUP BY rating;

SELECT rating, COUNT(*) FROM film
WHERE rating = "PG" OR rating = "G"
GROUP BY rating;

#미션!!! film 테이블에서 영화등급이 G등급인 영화 제목을 모두 출력해주세요.
SELECT title FROM film WHERE rating = "G" ;

SELECT title FROM film WHERE rating = "G" OR rating = "PG";

#미션!!! 필름 테이블에서 영화개봉 년도가 2006년 또는 2007년이고, 영화등급이 PG 또는 G등급인 영화의 제목만 출력해주세요!!!

SELECT * FROM film LIMIT 1;

SELECT title FROM film 
WHERE 
	(release_year = "2007" OR release_year = "2006") 
	AND 
	(rating = "PG" OR rating = "G");
    
#미션!!! film 테이블에서 rating으로 그룹을 묶어서, 각 등급별 영화 갯수와 등급, 각 그룹별 평균 rental_rate를 출력해주세요.

SELECT * FROM film LIMIT 1;
SELECT 
    rating AS rates,
    COUNT(*) AS count,
    AVG(rental_rate) 
FROM film GROUP BY rating;

# GROUP BY -> 집계함수를 사용해서 들어오면, 해당 컬럼값이 실제 그룹핑과 관계가 없더라도 출력값으로 허용 (*예외조항)

# film 테이블에서 rating으로 그룹을 묶어서 각 등급별 영화 갯수와 각 등급별 평균 렌탈비용을 출력하는데 평균 렌탈비용이 높은 순으로 출력하세요.

SELECT * FROM film LIMIT 1;
SELECT 
    rating AS rates,
    COUNT(*) AS total_films,
    AVG(rental_rate) AS avg_rental_rate
FROM film GROUP BY rating
ORDER BY avg_rental_rate DESC;


/* 
미션!!! 각 등급별 영화 길이가 130분 이상인 영화의 갯수와 등급을 출력해보세요
*/

SELECT * FROM film LIMIT 1;
SELECT rating,COUNT(*) filmcount 
FROM film 
WHERE length >= 130 
GROUP BY rating
ORDER BY filmcount DESC;