USE bestproducts;

#미션!!! 메인카테고리와 서브카테고리별 평균할인가격과 평균할인률을 출력해주세요.

SELECT * FROM ranking LIMIT 1;
SELECT * FROM items LIMIT 1;

SELECT 
	R.main_category,
    R.sub_category, 
    AVG(dis_price) avg_price, 
    AVG(discount_percent) avg_percent 
    FROM items I
JOIN ranking R ON R.item_code = I.item_code
GROUP BY R.main_category, R.sub_category
ORDER BY avg_percent DESC;

#선생님 코드

SELECT * FROM items LIMIT 1;
SELECT AVG(dis_price), AVG(discount_percent)
FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY R.main_category, R.sub_category
ORDER BY AVG(discount_percent) DESC;

#미션 2!!! 판매자별 베스트상품 갯수, 평균할인가격, 평균할인율을 출력해주세요.
# - 상품갯수 순으로 내림차순 정렬해주세요.

SELECT * FROM items LIMIT 1;
SELECT * FROM ranking LIMIT 1;

SELECT I.provider, COUNT(item_code) item ,AVG(dis_price)avg_price ,AVG(discount_percent) avg_percent 
FROM items I
GROUP BY I.provider
ORDER BY item DESC;

#선생님 코드

SELECT 
	provider,
    COUNT(*) count,
	AVG(dis_price) dis_price, 
	AVG(discount_percent) dis_percent
FROM items
GROUP BY provider
ORDER BY count DESC;

#미션 3!!! 메인카테고리별 베스트상품 갯수가 20개 이상인 판매자별 평균할인가격, 평균할인율, 베스트상품 갯수를 출력해주세요.

SELECT
	R.main_category,
	AVG(dis_price) dis_price,
    AVG(discount_percent) dis_percent,
    COUNT(I.item_code) item
FROM items I
JOIN ranking R ON I.item_code = R.item_code
GROUP BY R.main_category 
HAVING item >=20
ORDER BY item DESC;

#선생님 코드

SELECT
	R.main_category,
	I.provider,
    COUNT(*) count,
	AVG(dis_price) dis_price,
    AVG(discount_percent) dis_percent
FROM items I
JOIN ranking R ON I.item_code = R.item_code
WHERE provider IS NOT NULL AND provider != ''
GROUP BY I.provider, R.main_category
ORDER BY count DESC;

#미션 4!!! items 테이블에서 discount_price가 5만원 이상인 상품들 중 main_category별 평균 dis_price와 discount_percent를 출력하세요.

SELECT 
	R.main_category,
	AVG(dis_price) dis_price,
    AVG(discount_percent) dis_percent
FROM items I
JOIN ranking R ON I.item_code=R.item_code
WHERE dis_price >= 50000
GROUP BY R.main_category
ORDER BY dis_price DESC;

#선생님 코드

SELECT
	main_category,
	AVG(dis_price),
    AVG(discount_percent)
FROM items I
JOIN ranking R ON I.item_code = R.item_code
WHERE dis_price >= 50000
GROUP BY main_category;

