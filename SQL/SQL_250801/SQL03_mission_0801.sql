CREATE DATABASE membership_db;
USE membership_db;

CREATE TABLE members(
	id INT NOT NULL AUTO_INCREMENT,
    name CHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    birth VARCHAR(20) NOT NULL,
    regdate VARCHAR(20) NOT NULL,
    point VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);
ALTER TABLE members MODIFY COLUMN point INT UNSIGNED NOT NULL;

INSERT INTO members (id,name,email,birth,regdate,point,gender) VALUES
(1,"가나다","apple@naver.com","1999-12-23","2025-03-01","532","남성"),
(2,"김수연","grape@google.com","1997-10-3","2025-02-16","1035","여성"),
(3,"유하늘","peach@naver.com","2001-4-2","2025-01-13","893","남성"),
(4,"기보리","banana@google.com","1980-6-17","2023-07-25","1007","여성"),
(5,"아답터","monkey@hanmail.com","1995-2-28","2024-11-2","2355","남성");

SELECT * FROM members;

SELECT * FROM members WHERE point >= 1000;
SELECT * FROM members WHERE email LIKE "%google.com";