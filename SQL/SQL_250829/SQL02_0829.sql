# 문제 9. (0828일자 미션)
# sakila DB의 “영화 대여 내역”을 바탕으로 다음 항목을 모두 출력하는 SQL 쿼리문을 작성해주세요.
# 고객별 대여 순위, 이전 대여와의 간격, 다음 대여와의 간격,고객별 첫 번째 및 마지막 대여 일자, 
# 고객별 대여 건의 백분위 순위 및 누적분포, 고객별 대여 내역의 3개 그룹 분할, 분할된 그룹 내 대여날짜 기준 오름차순 정렬
# 위 항목들을 customer_id, rental_date와 함께 “모두 포함하여 출력”하는 SQL 쿼리를 작성해주세요.

WITH rental_data AS (
	SELECT
		rental_id,
		customer_id,
		rental_date,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_rank,
		LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS previous_rental_date,
		LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date,
		FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
		LAST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date
									ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_rental_date,
		PERCENT_RANK() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_percentile_rank,
		CUME_DIST() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_cumulative_dist,
		NTILE(3) OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_group
	FROM rental
),
rental_intervals AS (
	SELECT
		rental_id,
        customer_id,
        rental_date,
        rental_rank,
        first_rental_date,
        last_rental_date,
        rental_percentile_rank,
        rental_cumulative_dist,
        rental_group,
        DATEDIFF(rental_date, previous_rental_date) AS previous_rental_gap,
        DATEDIFF(rental_date, next_rental_date) AS next_rental_gap		
    FROM rental_data
),
grouped_rental_rank AS (
	SELECT 
		rental_id,
        customer_id,
        rental_date,
        rental_group,
        ROW_NUMBER() OVER (PARTITION BY customer_id, rental_group ORDER BY rental_date) AS group_rental_rank
    FROM rental_data
)
SELECT
	R.customer_id,
    R.rental_date,
    R.rental_rank,
    R.previous_rental_gap,
    R.next_rental_gap,
    R.first_rental_date,
    R.last_rental_date,
    R.rental_percentile_rank,
    R.rental_cumulative_dist,
    R.rental_group,
    G.group_rental_rank
FROM rental_intervals R
JOIN grouped_rental_rank G USING(rental_id);