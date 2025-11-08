# (오후강의 시작) PARTITION BY부터 설명 다시!

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) count
    # PARTITION BY customer_id 
    # => 전체 파티션(=한 고객의 모든 행)을 그룹처럼 나누고,
    # 고객 한 명이 총 몇 번 대여했는지 누적 개수 없이 고정된 값이 전 행에 반복 표시됨
    # PARTITION BY customer_id ORDER BY rental_date
    # => 고객별로 나눈 뒤, rental_date 기준으로 앞에서부터 순서대로 누적 카운트를 세어줌
FROM rental;

# 고객별 대여날짜 누적 대여 횟수 계산 (1)
SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) counts
	# customer_id로 파티션을 나누고 rental_date 기준으로 오름차순 정렬
    # ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW로 customer_id별로 누적카운트
	# => UNBOUNDED PRECEDING = 해당 파티션의 첫번째 행
    # => CURRENT ROW = 해당 파티션의 현재 행
FROM rental;

# 고객별 대여날짜 누적 대여 횟수 계산 (2)
SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) counts
	# customer_id로 파티션을 나누고 rental_date 기준으로 오름차순 정렬
    # ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    # => UNBOUNDED PRECEDING = 해당 파티션의 첫번째 행
    # => UNBOUNDED FOLLOWING = 해당 파티션의 마지막 행
    # 그래서 해당 파티션의 처음부터 마지막번째 행까지 전체 범위의 값을 각 행에 불러옴
FROM rental;

# 고객별 대여날짜 누적 대여 횟수 계산 (3)
SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) counts
	# customer_id로 파티션을 나누고 rental_date 기준으로 오름차순 정렬
    # ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    # => 해당 행을 기준으로 하나 앞의 행의 값, 하나 뒤의 행의 값까지 불러옴
FROM rental;

# 고객별 대여날짜 누적 대여 횟수 계산 (4)
SELECT
	R.customer_id,
	R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment P
JOIN rental R USING(rental_id);

# 고객별 대여날짜 누적 대여 횟수 계산 (5)
SELECT
	R.customer_id,
	R.rental_date,
    P.amount,
    DATE(R.rental_date),
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sample
FROM payment P
JOIN rental R USING(rental_id);
# ROWS -> 특정 부분집합의 행을 물리적으로 해석 
# (rental_date의 값이 같아도 행 순서에 따라 구분하여 각 행을 따로 계산)

# 고객별 대여날짜 누적 대여 횟수 계산 (6)
SELECT
	R.customer_id,
	R.rental_date,
    P.amount,
    DATE(R.rental_date),
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(rental_date)
						RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sample
FROM payment P
JOIN rental R USING(rental_id);

# 영화별 날짜에 따른 누적매출수입
SELECT 
	I.film_id,
	P.amount,
    P.payment_date,
    SUM(P.amount) OVER (PARTITION BY I.film_id ORDER BY P.payment_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id);

# 장르별 영화 대여 수익
# 영화 장르의 수익성 분석이 필요합니다!!
# 영화장르별 대여 수익의 누적합계와 전체 대여수익 대비 비율을 출력해주세요.

SELECT
    C.name AS category_name,
    SUM(P.amount) AS genre_revenue,
    SUM(SUM(P.amount)) OVER () AS total_revenue,
    SUM(P.amount) / SUM(SUM(P.amount)) OVER () * 100 AS revenue_ratio
FROM category C
JOIN film_category FC ON C.category_id = FC.category_id
JOIN film F ON FC.film_id = F.film_id
JOIN inventory I ON F.film_id = I.film_id
JOIN rental R ON I.inventory_id = R.inventory_id
JOIN payment P ON R.rental_id = P.rental_id
GROUP BY C.name
ORDER BY genre_revenue DESC;
# SUM(SUM()) -> 집계함수 안에 집계함수 사용은 불가능하지만 윈도우 함수(OVER()) 쓰면 가능

# 선생님 코드 (WITH절 활용)
#rental_id  // inventory_id // film_id // category_id
# WITH => 장르당 총 합계 매출금액
WITH genre_revenue AS (
	SELECT
		C.name genre,
		SUM(P.amount) revenue
	FROM payment P
	JOIN rental R USING(rental_id)
	JOIN inventory I USING(inventory_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	GROUP BY C.name
)
SELECT
	genre,
    revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue2,
			# 전체 장르 수익을 내림차순으로 나열하고, 순차적으로
			# 누적합계를 구하기 위하여 "PARTITION BY revenue" 생략
			# PARTITION BY를 쓰면 장르별로 나뉘어 각각의 장르 안에서 누적합이 계산됨(의미x)
	revenue / SUM(revenue) OVER() revenue_ratio
FROM genre_revenue;

# LAG() / LEAD() / FIRST_VALUE() / LAST_VALUE() 활용 예시

SELECT
	rental_id,
    rental_date,
    LAG(rental_id, 1, 0) OVER(ORDER BY rental_date) prev_rental,
    LEAD(rental_id, 1, 0) OVER(ORDER BY rental_date) next_rental
FROM rental;

SELECT
	I.film_id,
    R.rental_date,
    FIRST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date),
    LAST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date
									ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
					# LAST_VALUE()는 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING을 
                    # 같이 써야 진짜 "전체 파티션 내 마지막 값"을 얻을 수 있음.
                    # 그렇지 않으면 현재 행까지의 마지막 값만 반환될 수 있음.
FROM rental R
JOIN inventory I USING(inventory_id)