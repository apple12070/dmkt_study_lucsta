# 영화 길이에 대한 백분위 순위와 누적분포 계산
# 백분위 순위 : 전체를 100% -> 0 ~ 1 => PERCENT_RANK()
# 누적분포 : 전체를 기준으로 각 그룹의 비율이 몇프로대까지인지를 누적해서 보는 것 +> CUME_DIST()

# PERCENT_RANK() / CUME_DIST() 활용 예시
SELECT
	title, length,
    PERCENT_RANK() OVER (ORDER BY length) AS percent,
    CUME_DIST() OVER (ORDER BY length) AS cume
FROM film;

# NTILE() 활용 예시
SELECT
	customer_id,
    CONCAT(first_name,", ",last_name) AS customer_name,
    NTILE(4) OVER (ORDER BY customer_id) AS customer_group
FROM customer;

# 문제 1.
# payment 테이블에서 각 고객들의 결제금액을 출력하세요.
# 단, 출력 내용은 다음과 같아야 합니다.
# 고객ID, 고객 결제금액, 해당 행의 결제금액의 이전 결제금액, 해당 행의 결제 금액의 다음 결제금액 

SELECT * FROM payment LIMIT 5; # customer_id, amount

SELECT
	customer_id, 
    amount, 
    LAG(amount,1,0) OVER () AS lag_amount, 
    LEAD(amount,1,0) OVER () AS lead_amount
FROM payment;
# -> 고객별이니까 PARTITION BY 걸어줬어야 함

# 선생님 코드 
SELECT
	customer_id,
    amount,
    LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS previous_amount,
    LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS next_amount
FROM payment;

# 문제 2.
# rental 테이블에서 각 고객별로 첫번째 대여일자와 마지막 대여일자를 출력하세요.
# 출력 결과물에는 고객ID, 첫번째 대여일자, 마지막 대여일자가 포함되어있으면 됩니다.

SELECT * FROM rental LIMIT 5;

SELECT
    customer_id,
    FIRST_VALUE(rental_date) OVER (
        PARTITION BY customer_id 
        ORDER BY rental_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_rentaldate,
    LAST_VALUE(rental_date) OVER (
        PARTITION BY customer_id 
        ORDER BY rental_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_rentaldate
FROM rental;
# -> DISTINCT로 중복 제거해주기 
# -> FIRST_VALUE 구할 땐 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 안 써도 됨

# 선생님 코드
SELECT
	DISTINCT customer_id,
    FIRST_VALUE(rental_date) OVER 
		(PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
	LAST_VALUE(rental_date) OVER 
		(PARTITION BY customer_id ORDER BY rental_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_rental_date   
FROM rental;

# 문제 3.
# payment 테이블에서 각 직원이 처리한 첫번째 결제와 마지막 결제 금액을 출력해주세요.
# 직원ID, 첫번째 결제금액, 마지막 결제금액을 출력해주세요.

SELECT * FROM payment LIMIT 5;

SELECT
	staff_id,
    FIRST_VALUE(amount) OVER 
		(PARTITION BY staff_id ORDER BY payment_date) AS first_payment,
	LAST_VALUE(amount) OVER
		(PARTITION BY staff_id ORDER BY payment_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) AS last_payment
FROM payment;
# -> DISTINCT 쓰라고!!!!!!!!!!!!!

# 선생님 코드
SELECT
	DISTINCT staff_id,
    FIRST_VALUE(amount) OVER
		(PARTITION BY staff_id ORDER BY payment_date) AS first_payment_amount,
	LAST_VALUE(amount) OVER
		(PARTITION BY staff_id ORDER BY payment_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_payment_amount
FROM payment;

# 문제 4.
# film 테이블에서 각 영화의 대여기간에 대한 백분위 순위, 누적분포를 계산해주세요.
# 영화제목, 대여기간, 백분위 순위, 누적분포가 출력되게 해주세요.

SELECT * FROM film LIMIT 5;

SELECT
    title,
    rental_duration,
    PERCENT_RANK() OVER (ORDER BY rental_duration) AS percent_rank,
    CUME_DIST()  OVER (ORDER BY rental_duration) AS cume_dist
FROM film;
# -> 별칭에 함수 연결돼서 실행 안됨

# 선생님 코드
SELECT
	title, rental_duration,
    PERCENT_RANK() OVER (ORDER BY rental_duration) AS percentile_rank,
    CUME_DIST() OVER (ORDER BY rental_duration) AS cumulative_distribution
FROM film;

# 문제 5.
# customer 테이블에서 각 고객의 결제 금액에 대한 백분위 순위와 누적분포를 계산해주세요.
# 고객ID, 총 결제금액, 백분위 순위, 누적분포 -> 출력되어야 할 대상

SELECT * FROM customer LIMIT 5;
SELECT * FROM payment LIMIT 5;

SELECT
    customer_id,
    total_amount,
    PERCENT_RANK() OVER (ORDER BY total_amount) AS percentage_rank,
    CUME_DIST()  OVER (ORDER BY total_amount) AS cumulative_distribution
FROM (
    SELECT
        C.customer_id,
        SUM(P.amount) AS total_amount
    FROM customer C
    JOIN payment P ON C.customer_id = P.customer_id
    GROUP BY C.customer_id
) abc
ORDER BY customer_id;

# 선생님 코드
SELECT
	C.customer_id, SUM(P.amount) AS total_amount,
    PERCENT_RANK() OVER (ORDER BY SUM(P.amount) DESC) AS percentile_rank,
    CUME_DIST() OVER (ORDER BY SUM(P.amount) DESC) AS cumulative_distribution
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id
ORDER BY total_amount;
# 윈도우 함수에서는 AS 별칭 가져오기 불가능! (total_amount)

# 문제 6.
# rental 테이블에서 각 고객별로 대여순서에 따른 누적 대여 횟수를 출력해주세요.
# 대여순서 => 대여한 날짜를 오름차순으로 정렬한 것!
# 대여 ID, 고객 ID, 대여 날짜, 누적 대여 횟수 -> 출력되어야 합니다!

SELECT * FROM rental LIMIT 5;

SELECT
    rental_id,
    customer_id,
    rental_date,
    COUNT(*) OVER (
        PARTITION BY customer_id
        ORDER BY rental_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_rentals
FROM rental
ORDER BY customer_id, rental_date;

# 선생님 코드
SELECT
	rental_id, customer_id, rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                    AS cumulative_amount
FROM rental;

# 문제 7.
# payment 테이블에서 각 고객별로 결제 일자에 따른 누적 결제 금액을 출력해주세요.
# 결제 ID, 고객 ID, 결제 날짜, 결제 금액, 누적 결제 금액

SELECT * FROM payment LIMIT 5;

SELECT 
	payment_id, customer_id, payment_date, amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                AS cumulative_amount
FROM payment;

# 선생님 코드
SELECT 
	payment_id, customer_id, payment_date, amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                AS cumulative_amount
FROM payment;

# 문제 8.
# rental 테이블에서 각 직원들의 대여 날짜에 따른 대여횟수와 각 직원별 누적 대여 횟수를 출력해주세요.
# 대여ID, 직원ID, 대여 날짜, 대여 횟수, 누적대여횟수 -> 출력되어야 하는 값!

SELECT * FROM rental LIMIT 5;

SELECT
	rental_id, staff_id, rental_date, 
    COUNT(*) OVER (PARTITION BY rental_date ORDER BY staff_id) AS rental_count,
    COUNT(*) OVER (PARTITION BY staff_id ORDER BY rental_date
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                AS cumulative_rental_count
FROM rental;					

# 선생님 코드
SELECT
	rental_id, staff_id, rental_date,
    COUNT(*) OVER (PARTITION BY staff_id, DATE(rental_date)) AS rental_count,
    COUNT(*) OVER (PARTITION BY staff_id ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count
FROM rental;

# 문제 9.
# customer 테이블과 payment 테이블을 사용해서 각 도시별 고객의 총 결제 금액 순위를 출력!
# 고객 ID, 도시, 총 결제 금액, 도시 순위 -> 출력되어야 할 값!

SELECT * FROM customer LIMIT 5; # customer_id, address_id
SELECT * FROM payment LIMIT 5; # customer_id
SELECT * FROM city LIMIT 5; # city_id
SELECT * FROM address LIMIT 5; #address_id, city_id

SELECT
	C.customer_id, CI.city, 
    SUM(amount) ,
    ROW_NUMBER() OVER 
FROM customerm C
JOIN payment P USING(customer_id)
JOIN address A USING(address_id)
JOIN city CI USING(city_id);

# 선생님 코드
SELECT
    C.customer_id, CI.city,
    SUM(P.amount) AS total_amount,
    RANK() OVER (PARTITION BY CI.city ORDER BY SUM(P.amount) DESC) AS ranking
FROM customer C
JOIN address A USING (address_id)
JOIN city CI USING (city_id)
JOIN payment P USING (customer_id)
GROUP BY C.customer_id;

# 문제 10.
# customer 테이블에서 고객별 대여 횟수에 따라 4개의 그룹으로 나눠주세요.
# 고객ID, 대여횟수, 그룹 -> 출력될 수 있도록 해주세요!

SELECT * FROM customer LIMIT 5;

SELECT
    customer_id,
    rental_count,
    NTILE(4) OVER (ORDER BY rental_count DESC) AS rental_group
FROM (
    SELECT 
        customer_id,
        COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
) AS customer_rentals;

# 선생님 코드
SELECT
	C.customer_id,
    COUNT(*) AS rental_count,
    NTILE(4) OVER (ORDER BY COUNT(*) DESC)
FROM customer C
JOIN rental R USING(customer_id)
GROUP BY C.customer_id;

# 문제 11.
# film 테이블에서 영화를 대여기간에 따라서 5개의 그룹으로 나누어주세요.
# 영화 ID, 대여기간, 그룹 -> 출력되어야 할 데이터

SELECT * FROM film LIMIT 5;

SELECT 
	film_id,title, rental_duration,
    NTILE(5) OVER (ORDER BY rental_duration)
FROM film;

# 선생님 코드
SELECT
	film_id, rental_duration,
    NTILE(5) OVER (ORDER BY rental_duration)
FROM film;

# 문제 12.
# payment 테이블 에서 각 고객별로 지불 내역에 행 번호를 부여해주세요.
# 고객별 지불내역의 행 번호는 payment_date가 낮은 순으로 부여해주세요.
# 지불ID, 고객ID, 지불 날짜, 지불 금액, 행 번호가 출력되도록 해주세요.

SELECT * FROM payment LIMIT 5;

SELECT
	payment_id, customer_id, payment_date, amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date)
FROM payment;

# 선생님 코드
SELECT
	payment_id, customer_id, payment_date, amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS row_numbers
FROM payment;

# 문제 13.
# film 테이블에서 각 등급별로 영화에 행 번호를 부여하세요!
# 영화는 대여기간에 따라 정렬될 수 있도록 해주세요.
# 영화 ID, 등급, 대여기간, 행번호 -> 출력!!

SELECT * FROM film LIMIT 5;

SELECT
	film_id, rating, rental_duration,
    ROW_NUMBER() OVER (PARTITION BY rating ORDER BY rental_duration) AS row_numbers
FROM film;

# 선생님 코드
SELECT
	film_id, rating, rental_duration,
    ROW_NUMBER() OVER (PARTITION BY rating ORDER BY rental_duration) AS row_numbers
FROM film;

# 문제 14.
# customer 테이블과 payment 테이블을 사용해서 고객을 총 결제금액에 따라 10개의 금액으로 나누고 
# 각 그룹 내에서 고객별 총 결제 금액에 따라 번호를 부여하세요.
# 고객ID, 총 결제금액, 그룹, 그룹 내 행 번호 -> 출력해주세요!

SELECT * FROM customer LIMIT 5;
SELECT * FROM payment LIMIT 5;

SELECT C.customer_id, SUM(P.amount),
	NTILE(10) OVER (ORDER BY SUM(P.amount)),
    ROW_NUMBER() OVER (PARTITION BY NTILE(10) OVER (ORDER BY SUM(P.amount)) ORDER BY SUM(P.amount))
FROM customer C
JOIN payment P USING(customer_id);
# 에잇 모르겠다

# 선생님 코드
WITH CustomerPayments AS (
	SELECT
		C.customer_id,
		SUM(P.amount) AS total_amount  # 고객당 총 결제금액
	FROM customer C
	JOIN payment P USING(customer_id)
	GROUP BY C.customer_id
),
CustomerGroup AS (
	SELECT
		customer_id, total_amount,
        NTILE(10) OVER (ORDER BY total_amount) AS ten
	FROM CustomerPayments
)
SELECT
	customer_id, total_amount, ten,
    ROW_NUMBER() OVER (PARTITION BY ten ORDER BY total_amount) AS row_numbers
FROM CustomerGroup;
# WITH 절 VS 서브쿼리 둘중에 하나 골라서 실행하는데, WITH절이 훨씬 편함. 서브쿼리는 잘 안 씀. 