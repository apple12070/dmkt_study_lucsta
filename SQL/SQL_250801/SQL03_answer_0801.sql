CREATE DATABASE IF NOT EXISTS membership;
USE membership;

CREATE TABLE IF NOT EXISTS members (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    birth_date DATE, # '0000-00-00'
    signup_time DATETIME DEFAULT CURRENT_TIMESTAMP, # 'YYYY-MM-DD HH:MM:SS'
    points DECIMAL(10,2),  # 10진수(허용할 수 있는 정수의 자릿수, 허용할 수 있는 소수의 자릿수)
    gender ENUM('남', '여') NOT NULL
);

DESC members;

INSERT INTO members (name, email, birth_date, points, gender)
VALUES
('마동석','dong@google.com','1990-01-01',1000.50,'남'),
('장첸','jang@naver.com','1992-05-10',3500.75,'남')
('정마담','jung@google.com','1998-11-22',120.10,'여');

SELECT * FROM members;

SELECT name, points FROM members WHERE points >= 1000;

SELECT name, email FROM members WHERE email LIKE '%@google.com';

SELECT name, birth_date FROM members ORDER BY birth_date DESC;  # 내림차순
SELECT name, birth_date FROM members ORDER BY birth_date ASC;  # 오름차순