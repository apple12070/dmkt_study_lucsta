# Netflix Data 분석 마케터
# 특정 데이터 존재 = 사용자별 하루 시청 시간
# A 사용자가 10일 5시간 30분 시청
# B 사용자가 15일 3시간 시청
#...

# STP => Segment => Target => Positioning => Persona

CREATE DATABASE IF NOT EXISTS NetflixData_v1;
USE NetflixData_v1;

CREATE TABLE users (
	user_id INT  PRIMARY KEY,
    user_name VARCHAR(50)
);  #부모 테이블

INSERT INTO users (user_id, user_name) VALUES (1, "Alice"),(2,"David"),(3,"Cathy");

SELECT * FROM users;

CREATE TABLE watch_history (
	watch_id INT PRIMARY KEY, 
    user_id INT,
    date_time DATE,
    hours_watched DECIMAL(4,1),  
    FOREIGN KEY(user_id) REFERENCES users(user_id)  
);   # 자식 테이블  # FOREIGN KEY 참조 REFERENCES 참조하고자 하는 대상

DESC watch_history;

INSERT INTO watch_history (watch_id, user_id, date_time, hours_watched)
VALUES 
(101, 1, "2025-07-10",5.5),
(102, 1, "2025-07-15",3.0),
(103, 2, "2025-07-20",7.0),
(104, 3, "2025-06-30",2.5),
(105, 2, "2025-07-05",4.0),
(106, 3, "2025-07-12",6.5),
(107, 1, "2025-06-25",1.0),
(108, 2, "2025-07-30",2.0);

SELECT * FROM watch_history;

# 특정 사용자의 영상 시청시간 기준, 내림차순

SELECT u.user_id, u.user_name, SUM(w.hours_watched) AS total_hours
FROM users u 
JOIN watch_history w ON u.user_id = w.user_id
WHERE w.date_time >= CURDATE() - INTERVAL 1 MONTH
GROUP BY u.user_id, u.user_name
ORDER BY total_hours DESC
LIMIT 10;