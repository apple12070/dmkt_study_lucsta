USE sakila;  # 특정 DB 접속
SHOW TABLES;  # 특정 DB의 테이블 목록을 볼 때
DESC actor;  #특정 테이블의 도메인을 볼 때
SELECT * FROM actor LIMIT 1;  # 특정 테이블의 data를 볼 때 (상위 레코드 하나만 출력)

#문제 1. 
#각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다.
#각 고객별로 가장 많이 대여한 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, 
#해당 고객 이름을 조회 할 수 있는 SQL 쿼리문을 작성해주세요. (8/21 미션 해설)

#첫번째 추출해야 할 데이터 (고객별 렌탈한 카테고리 및 그 건수) (첫번째 필터링)
# A고객 : 액션, 드라마, 패밀리
# A - 액션 : 2번 대여
# A - 드라마 : 1번 대여 
# A - 패밀리 : 3번 대여 
# .....
# Z고객까지 존재. 각 고객별로 대여한 카테고리의 종류나 갯수 다 다름.
# A-Z 고객들이 1000건의 렌탈데이터를 나눠가졌을 거 아녀.

#두번째 추출해야 할 데이터 
# A - 액션 / 드라마 / 패밀리 중 가장 렌탈한 횟수가 많은 카테고리를 한 번 더 필터링.
#customer_id, inventory_id, film_id, category_id 있는 테이블 조인되어야 함

#1. 고객이름 및 고객별 카테고리별 카테고리의 카운트수 추출 
SELECT C.first_name, C.last_name, CAT.name, COUNT(*) FROM customer C
#2. 필요한 테이블 조인
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category CAT USING(category_id)
#3. 고객별로 카테고리 묶어야 하므로 customer_id로 그룹핑 (복수의 그룹핑 가능)
GROUP BY C.customer_id, CAT.name
#4. 그룹핑한 데이터 중 원하는 정보만 필터링하기 위해 HAVING절 이용 
# (사용자별 렌탈한 카운트수 중 가장 큰 것 필터링)
#HAVING절은 새로운 쿼리문이 시작된다 생각하고 위의 구문과 연결짓지 않기. 데이터 꼬임)
#HAVING절 안에서 찾고자 하는 데이터는 전체 카운트수가 아닌
#고객별 카테고리 개수 중 최댓값이므로, 바깥에서 그룹핑이 끝난 데이터와 같은 AS를 사용하면 
#바깥 그룹핑 결과와 내부 그룹핑 결과가 뒤엉켜서 전체count와 부분count가 구분되지 않음.
HAVING COUNT(*) = (
	SELECT COUNT(*) FROM rental R2
    JOIN inventory I2 USING(inventory_id)
    JOIN film_category FC2 USING(film_id)
    # 서브쿼리에서는 "고객 C가 빌린 영화 카테고리별 count"를 뽑아야 함
    # 그런데 서브쿼리는 모든 고객의 데이터를 볼 수 있음
    # -> 특정 고객에 한정해야 바깥 고객(C.customer_id)과 매칭됨.
    # 따라서 아래의 WHERE 조건이 없으면 전체 고객의 카테고리 count 중 최댓값과
    # 비교하게 되어 전혀 다른 결과가 나옴!
    # = "바깥 쿼리의 고객 1명에 대해서만 서브퀄리 돌려라"는 연결고리 역할
    WHERE R2.customer_id = C.customer_id
    GROUP BY FC2.category_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

#문제 2. 
#2006-02-14 날짜를 기준으로, 2006-01-15부터, 2006-02-14날짜까지 영화를
#대여하지 않은 고객을 찾아주세요.
# NOT EXISTS ?

SELECT 
    C.customer_id,
    C.first_name,
    C.last_name
FROM customer C
WHERE NOT EXISTS (
    SELECT 1
    FROM rental R
    WHERE R.customer_id = C.customer_id
      AND R.rental_date BETWEEN '2006-01-15' AND '2006-02-14'
);

# 선생님 코드

SELECT 
	C.first_name, C.last_name 
FROM customer C
LEFT OUTER JOIN rental R 
ON C.customer_id = R.customer_id
AND TIMESTAMPDIFF(DAY, R.rental_date, "2006-02-14") <= 30
WHERE R.rental_id IS NULL;
#USING은 조인 키만 지정하는 축약형 문법이라 그 뒤에 AND...의 조건은 붙일 수 없음!
#단순 조인 키만 쓰려면 USING, 조건이 더 있으면 무조건 ON 사용!!

#문제 3. 
#가장 최근에 영화를 반납한 상위 10명의 고객 이름과 해당 고객들이 대여한 영화의 이름
#그리고 대여 기간을 출력해주세요!!

SELECT * FROM customer LIMIT 5; #customer_id
SELECT * FROM film LIMIT 5; #title, film_id
SELECT * FROM inventory LIMIT 5; #inventory_id, film_id
SELECT * FROM rental LIMIT 5;  #inventory_id,customer_id,rental_date,return_date

SELECT 
	CONCAT(C.first_name," ",C.last_name) Name,
    F.title Title,
    TIMESTAMPDIFF(DAY,R.rental_date,R.return_date) RentalDate
    FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id 
ORDER BY R.return_date DESC LIMIT 10;

#선생님 코드

SELECT 
	C.first_name,
    C.last_name,
    F.title,
    TIMESTAMPDIFF(DAY,R.rental_date,R.return_date)
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
ORDER BY R.return_date DESC
LIMIT 10;

#문제 4.
#각 직원의 매출을 찾고, 각 직원의 매출이 회사 전체 매출 중 어느 정도 비율을
#차지하는지 출력해주세요.
#출력 결과물은 직원 ID, 직원 이름, 직원 매출, 회사 전체 매출 기준 직원 매출의 비율까지 출력!

SELECT * FROM staff LIMIT 5; #staff_id, first_name, last_name
SELECT * FROM payment LIMIT 5; #staff_id, amount

SELECT 
    S.staff_id AS Staff_ID,
    CONCAT(S.first_name, " ", S.last_name) AS Staff_Name,
    CONCAT(SUM(P.amount),'$') AS Staff_Totalsale,
    CONCAT(ROUND(SUM(P.amount) / (SELECT SUM(amount) FROM payment) * 100, 2),'%') AS Sales_Ratio
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id;
# 스칼라 서브쿼리(SELECT), 인라인 뷰(FROM) 등 서브쿼리는 메인쿼리와 별도로 실행된다고
# 생각하고 바깥쿼리의 AS 가져다 쓰지 않기.(서브쿼리 내에서 별도의 AS 주는것이 안전하고 깔끔)

#선생님 코드

SELECT 
	S.staff_id,
    S.first_name, S.last_name,
    SUM(P.amount) staff_revenue,
    SUM(P.amount) / (SELECT SUM(amount) FROM payment) * 100 revenue_percentage
FROM staff S
JOIN payment P USINg(staff_id)
GROUP BY S.staff_id;