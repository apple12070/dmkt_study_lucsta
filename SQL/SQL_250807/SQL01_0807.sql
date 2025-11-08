CREATE DATABASE IF NOT EXISTS bestproducts;
USE bestproducts;

DESC items;
SELECT COUNT(*) FROM items;
SELECT * FROM items
LIMIT 10;

SELECT provider FROM items
GROUP BY provider;

# 가설 : 베스트 랭킹에 등록되어있는 약 1만개 이상의 업체들 가운데 진짜 베스트 오브 베스트 업체라고 한다면, 
# 베스트 랭킹 안에 약 100개 정도의 자사 혹은 위탁 상품을 가지고 운영하고 있지 않을까?

SELECT provider FROM items
WHERE COUNT(*) >= 100
GROUP BY provider;

# SUM, MAX, MIN, AVG, COUNT 등과 같은 집계함수들은 절대 GROUP BY와 함께 WHERE절로는 사용 불가!!!
# 해당 상황이 바로 HAVING 절을 사용해야 하는 상황!!!
# 결론 : GROUP BY와 집계함수는 WHERE절로는 절대 사용불가!!!
# HAVING절의 위치는 반드시 GROUP BY 뒤에 오면 됨!!!

SELECT provider, COUNT(*) FROM items
GROUP BY provider HAVING COUNT(*) >= 100;

# GROUP BY 설정을 했다고 해서 집계함수를 아예 사용불가 x
# WHERE 안에 집계함수를 사용하고자 할 때에만 불가!!!

SELECT provider, COUNT(*) FROM items
WHERE 
	provider != "스마일배송" AND 
    provider != ""
GROUP BY provider
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC ;