# 문제 1.
# 각 고객별 결제 금액에 따른 순위를 출력해주세요.
# 고객ID, 렌탈ID, 고객의 결제 금액에 따른 순위
# 순위를 출력할 때, 동일한 값이 있을 경우, 순위를 부여하고, 다음 순서는 건너뛰지 않습니다.

SELECT * FROM customer LIMIT 5;
SELECT * FROM rental LIMIT 5;
SELECT * FROM payment LIMIT 5;

SELECT customer_id, rental_id,
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY SUM(amount))
FROM payment;
# 윈도우함수 안에 윈도우함수, 직접적인 집계함수 쓸 수 없음

# 선생님 코드
SELECT
	customer_id, rental_id, amount,
    DENSE_RANK() OVER
		(PARTITION BY customer_id ORDER BY amount DESC) AS amount_rank
FROM payment;

# 문제 2.
# 고객별 대여날짜 시간 순으로 정렬 후 아래 내용을 출력해주세요.
# 고객ID, 렌탈ID, 대여날짜 시간, 해당 대여날짜 시간을 기준으로 다음 대여날짜 시간 -> 출력!

SELECT * FROM rental LIMIT 5;

SELECT customer_id, rental_id, rental_date,
	LEAD(rental_date, 1, 0) OVER (PARTITION BY customer_id ORDER BY rental_date)
FROM rental;

# 선생님 코드
SELECT
	customer_id, rental_id, rental_date,
    LEAD(rental_date) OVER
		(PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date
FROM rental;

# 문제 3.
# 각 등급별로 대여기간이 가장 긴 영화의 제목을 출력하세요.

SELECT * FROM film LIMIT 5;

SELECT DISTINCT rating, title, 
	MAX(rental_duration) OVER (PARTITION BY film_id)
FROM film;

# 선생님 코드
SELECT
	DISTINCT rating,
    FIRST_VALUE(title) OVER
		(PARTITION BY rating ORDER BY rental_duration DESC)
        AS longest_retal_movie
FROM film;

# 문제 4.
# 각 고객을 활동상태가 높은 순으로 정렬하고, 이를 기준으로 3개의 그룹으로 나누세요.
# 그룹 내 고객의 순서를 customer_id가 낮은 순으로 정렬해주세요.
# 정렬 후 행 번호를 매겨주세요.
# customer_id, first_name, last_name, active, active_group, group_row_number

SELECT * FROM customer LIMIT 5;

SELECT customer_id, first_name, last_name, active,
	NTILE(3) OVER (PARTITION BY active ORDER BY active)
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id DESC)
FROM customer;
# 어려워어려워어려워어려워어려워

# 선생님 코드
    

	