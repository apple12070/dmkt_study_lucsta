
# 아직 배우지 않았지만... 값을 세팅할 수 있음
# 🔻 임계값 파라미터 (일종의 기준값을 세팅... 기준 : 최소한 20개는 되어야 한다)
SET @main_products := 20;
SET @excellent := 4.50;
SET @average := 4.00;

WITH cat AS (
	SELECT
		category,
        COUNT(*) AS product_cnt,
        SUM(review_count) AS total_reviews,
        ROUND(AVG(avg_rating), 2) AS avg_rating
	FROM top100_products
    GROUP BY category
    HAVING COUNT(*) >= @main_products
)
SELECT
	category, 
    product_cnt,
    total_reviews,
    avg_rating,
    CASE
		WHEN avg_rating >= @excellent THEN "Excellent"
		WHEN avg_rating >= @average THEN "Average"
        ELSE "Poor"
    END AS grade
FROM cat
ORDER BY avg_rating DESC;

-- SELECT category, COUNT(*)
-- FROM top100_products
-- GROUP BY category;
# 여성의류 카테고리가 32개로 우수하게 많음...! 굿
# 아니 근데 신발 다들 17갠ㄷㅔ 나만 22개 나옴 하...ㅋㅋㄱㅋ

# 🚩 카테고리별 리뷰 수 기준, 상위 10%에 해당하는 상품 목록
# 그룹으로 정렬!!! GROUP BY (X)
# 전체 총 데이터를 10등분으로 균일하게 나눠서 10%에 해당하는 자료값만 찾아오겠다는 뜻
# 🔻 NTILE(n) : n등분 !!! NTILE(10) : 10등분 !!!

WITH ranked AS (
	SELECT 
		*,
		NTILE(10) OVER (PARTITION BY category ORDER BY review_count DESC) AS decile
    FROM top100_products
)
SELECT 
	category,
    product_name,
    review_count,
    avg_rating
FROM ranked
WHERE decile = 1
ORDER BY review_count DESC; # 상위 10%! 이게 젤 첫 번째 10분의 1의 값을 뜻함 (내림차순이니까 상위 10%)

# NTILE(10) : 10등분 !!!
# PARTITION BY category : category별로!! 뭔가를 나눈다
# ORDER BY review_count DESC : review_count를 기준으로 (내림차순) 정렬해서 10등분으로 나눌 것임!!!
# 상위 10%만 필요하니까 10등분 한 것 중 가장 위에 것만 찾으면 됨
# AS decile : 몇분의몇 그런 뜻ㅇㅇ