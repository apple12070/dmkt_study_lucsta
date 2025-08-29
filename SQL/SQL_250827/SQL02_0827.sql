### 윈도우 함수 ###
## 1) 순위함수
# - RANK(), DENSE_RANK(), ROW_NUMBER()   #
# 위 3개의 함수는 공통적으로 OVER절을 함께 사용한다!
# ORDER BY 절을 통해서 순위를 매길 기준을 정의한다!
# SELECT 등 다른 구문을 불러오지 않고 해당 구문 안에서 원하는 값을 출력하는 것이 윈도우 함수

# 순위함수별 예시 (1)
SELECT 
	title,
    length,
    RANK() OVER (ORDER BY length DESC) AS ranking,
    # 동일한 순위값이 있을경우 중복 순위 부여하고 중복 수만큼 다음 순위는 건너뛴다.
    DENSE_RANK() OVER (ORDER BY length DESC) AS dense_ranking,
    # 동일한 순위값이 있을경우 중복 순위 부여하고 다음 순위는 건너뛰지 않는다.
    ROW_NUMBER() OVER (ORDER BY length DESC) AS row_numbers
    # 순위와 상관없이 각 행에 고유한 번호를 부여한다.
FROM film 
ORDER BY length DESC;

# 순위함수별 예시 (2)
SELECT 
	C.customer_id,
    CONCAT(C.first_name," ",C.last_name) AS customer_name,
    SUM(P.amount) total_amount,   #고객당 총 지출액
    RANK() OVER (ORDER BY SUM(P.amount) DESC) AS ranking,
    DENSE_RANK() OVER (ORDER BY SUM(P.amount) DESC) AS dense_ranking,
    ROW_NUMBER() OVER (ORDER BY SUM(P.amount) DESC) AS row_numbers
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;

## 2) 범위지정 옵션 
# (* 윈도우 집계 함수(SUM(),AVG(),COUNT(),MAX(),MIN())를 사용하기 위한 옵션)
# - PARTITION BY   #
# 특정 컬럼을 기준으로 데이터를 부분집합하여 분할할 때 사용 

# PARTITION BY 예시 
SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_rentals
    #customer_id를 기준으로 하나의 부분집합이 되었다!
    #ORDER BY를 하면 생성된 하나의 부분집합을 기준으로 오름차순정렬이 됨.
    #cumulative -> 누적된다는 뜻
    #ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    #-> 지정한 파티션 범위의 첫 행부터 현재 행까지를 범위로 지정 
    #윈도우 함수가 어떤 행 집합을 대상으로 누적.평균.순위 등을 계산해야 하는지
    #정확히 알려주기 위해서 범위를 지정.
FROM rental;

# - RANGE   #
# ORDER BY로 정렬된 값의 범위를 기준으로 집계 구간을 정함
# ROWS VS RANGE
# * ROWS : 단순히 행(row) 위치를 기준으로 범위를 잡음 -> 앞뒤 몇 행
# * RANGE : ORDER BY로 정렬된 값의 범위를 기준으로 집계 구간을 정함 -> 값이 같으면 전부 묶임

# RANGE 예시
SELECT 
	R.customer_id,
    R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date))
    # R.rental_date를 기준으로 범위를 지정하여 범위별 합계를 구함
FROM rental R
JOIN payment P USING(rental_id);


# 문제 1.
# customer 테이블에서 고객의 총 지출 금액을 계산하고, 총 지출 금액에 따라 고객의 순위를 매기세요.
# 출력되어질 결과값은 고객ID, 고객이름, 총 지출금액, 순위(rank)가 포함되도록 해주세요.

# 선생님 코드
SELECT 
	C.customer_id,
    CONCAT(C.first_name," ",C.last_name),
    SUM(P.amount),
    RANK() OVER (ORDER BY SUM(P.amount) DESC) ranking
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;
    
# 문제 2.
# film 테이블에서 각 영화의 대여횟수를 계산하고 대여횟수에 따라 영화의 순위를 매겨주세요.
# 만약 같은 대여 횟수가 발생했을 때에는 다음번째 순위를 건너뛰지 않고 출력해주세요.
# 출력해야할 값은 영화제목, 대여횟수, 순위가 포함될 수 있도록 해주세요.

SELECT
    F.title,
    COUNT(R.rental_id) AS rental_count,
    DENSE_RANK() OVER (ORDER BY COUNT(R.rental_id) DESC) AS ranking
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id, F.title
ORDER BY ranking;

# 선생님 코드
SELECT 
	F.title,
    COUNT(*) rental_count,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) ranking
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id;