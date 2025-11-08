USE interpark;

SELECT * FROM performances;

# 1. 크롤링한 전체 데이터 개수 (COUNT 집계 함수)
SELECT COUNT(*) AS Total_performances FROM performances;

# 2. 크롤링한 데이터 가운데 어떤 지역.장소에서 가장 많이 공연을 하고 있는지 확인
SELECT place, COUNT(*) AS 개수 FROM performances GROUP BY place ORDER BY 개수 DESC;

# 3. 특정 장소 공연 조회
SELECT * FROM performances WHERE place LIKE "%전국 각 지역%";

# 4. 공연 일정이 가까운 순 정렬 (*시작일을 기준)
SELECT title, place, SUBSTRING_INDEX(date_range, ' - ', 1) AS start_date FROM performances ORDER BY start_date DESC;