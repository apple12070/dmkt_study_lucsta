DESC ranking;
DESC items;

SELECT COUNT(*) FROM items;
SELECT * FROM ranking
LIMIT 1000;

SELECT * FROM items
INNER JOIN ranking ON ranking.item_code = items.item_code
WHERE ranking.main_category = "ALL";
# INNER을 쓴 구문과 안 쓴 구문도 동일.
SELECT * FROM items
JOIN ranking ON ranking.item_code = items.item_code
WHERE ranking.main_category = "ALL";

# 에러가 발생하는 주요 원인 => ON 뒤에 어떤 테이블에서 값을 찾아왔는가!!!
SELECT * FROM items AS A
JOIN ranking AS B 
ON B.item_code = A.item_code
WHERE B.main_category = "ALL";
# 만약 조건절에서 설정한 데이터값이 특정 테이블에서만 사용하는 경우, 테이블 언급을 생략할 수 있음

# 관습적으로 특정 테이블을 생략해서 키워드를 입력 => 해당 테이블의 첫 단어를 사용!
SELECT * FROM items AS IT
JOIN ranking RA 
ON RA.item_code = IT.item_code
WHERE main_category = "ALL";

SELECT title FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE main_category = "ALL";

# 미션!!! 전체 베스트상품 > 메인카테고리 ALL에서 판매자별 베스트상품 갯수를 출력해주세요.
SELECT * FROM ranking LIMIT 1;
SELECT * FROM items LIMIT 1;

SELECT provider,COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE R.main_category = "ALL"
GROUP BY provider
ORDER BY COUNT DESC;

# 미션!!! 메인 카테고리가 "패션의류"인 서브카테고리 포함, 패션의류 전체 베스트상품에서 판매자별 베스트상품 개수가 5 이상인 판매자와 해당 베스트상품의 갯수를 출력하세요. 
SELECT * FROM ranking LIMIT 1000;
SELECT * FROM items LIMIT 1;
SELECT DISTINCT main_category FROM ranking;

SELECT provider,main_category,COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE main_category = "패션의류"
GROUP BY provider
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;

# 미션!!! 메인카테고리가 신발/잡화
# 판매자별 상품갯수가 10개 이상인 판매자명 & 상품갯수 출력!

SELECT provider,main_category,COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE main_category = "신발/잡화"
GROUP BY provider
HAVING COUNT(*) >= 10
ORDER BY COUNT(*) DESC;

# 미션!!! 메인 카테고리가 화장품/헤어
# 해당 카테고리 내 평균, 최대, 최소 할인 가격을 출력해주세요 !!!

SELECT 
	main_category, 
	AVG(dis_price) ave_price, 
    MAX(dis_price) max_price, 
    MIN(dis_price) min_price  
    FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE main_category = "화장품/헤어";

# 66걸즈 마케터 혻은 MD 
# 지그재그 -> 리뷰 크롤링 -> #가성비 #저렴 #경제적 
# 크롤링 -> 지그재그 -> 주요인기상품 및 카테고리 상품명 & 상품가격 & 할인가격 크롤링
# MySQL -> 평균 // 할인 // 최대할인 확인 해 본 다음에 마케팅 기획하기