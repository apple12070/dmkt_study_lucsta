# 250828 미션!!! 
# sakila DB의 “영화 대여 내역”을 바탕으로 다음 항목을 모두 출력하는 SQL 쿼리문을 작성해주세요.
# 고객별 대여 순위, 이전 대여와의 간격, 다음 대여와의 간격,고객별 첫 번째 및 마지막 대여 일자, 
# 고객별 대여 건의 백분위 순위 및 누적분포, 고객별 대여 내역의 3개 그룹 분할, 분할된 그룹 내 대여날짜 기준 오름차순 정렬
# 위 항목들을 customer_id, rental_date와 함께 “모두 포함하여 출력”하는 SQL 쿼리를 작성해주세요.

USE sakila;

SELECT * FROM rental LIMIT 5;


WITH rental_counts AS (
	SELECT
		customer_id,
        COUNT(*) AS total_rentals
	FROM rental
    GROUP BY customer_id
),
customer_rank AS (
	SELECT
		customer_id,
		total_rentals,
		PERCENT_RANK() OVER (ORDER BY total_rentals) AS percentage_rank,
        CUME_DIST() OVER (ORDER BY total_rentals) AS cumulative_dist,
        NTILE(3) OVER (ORDER BY total_rentals) AS rental_group
	FROM rental_counts
)
SELECT
    R.customer_id,  # customer_id
    R.rental_date,  # rental_date
    CR.percentage_rank, # 고객별 대여 건의 백분위 순위
    CR.cumulative_dist, # 고객별 대여 건의 누적 분포
    CR.rental_group,  # 고객별 대여 내역의 3개 그룹 분할
    DENSE_RANK() OVER (ORDER BY CR.total_rentals) AS customer_ranking, # 고객별 대여 순위
	LAG(R.rental_date,1,0) OVER (PARTITION BY R.customer_id ORDER BY rental_date) AS prev_date,  # 이전 대여와의 간격
    LEAD(R.rental_date,1,0) OVER (PARTITION BY R.customer_id ORDER BY rental_date) AS after_date, # 다음 대여와의 간격
    FIRST_VALUE(R.rental_date) OVER (PARTITION BY R.customer_id ORDER BY rental_date) AS first_rental_date, # 고객별 첫번째 대여 일자
    LAST_VALUE(R.rental_date) OVER (PARTITION BY R.customer_id ORDER BY rental_date
								ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_rental_date, # 고객별 마지막 대여 일자
    ROW_NUMBER() OVER (PARTITION BY CR.rental_group ORDER BY R.customer_id,R.rental_date) AS group_row_number #  분할된 그룹 내 대여날짜 기준 오름차순 정렬
FROM rental R
JOIN rental_counts RC ON RC.customer_id = R.customer_id
JOIN customer_rank CR ON R.customer_id = CR.customer_id
ORDER BY CR.rental_group, R.rental_date;

