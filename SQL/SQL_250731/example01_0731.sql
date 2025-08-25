CREATE DATABASE customer_db;
USE customer_db;

-- CREATE TABLE customer (
-- 	No INT NOT NULL AUTO_INCREMENT,
--     Name CHAR(20) NOT NULL,
--     Age TINYINT,reviews
--     Phone VARCHAR(20),
--     Email VARCHAR(30) NOT NULL,
--     Address VARCHAR(50),
--     PRIMARY KEY(No)
-- );

# DROP TABLE IF EXISTS customer;  # 이미 생성된 특정 테이블 삭제하기

# SHOW TABLES;  # 현재 보고있는 DB 안에 생성된 모든 테이블 확인 (하나의 DB 안에 복수의 테이블이 생성될 수 있음)

# DESC customer;  # 특정 테이블 안에 생성된 구조 확인하기

# 특정 테이블 내 속성 추가하기
# ALTER TABLE customer ADD COLUMN Color VARCHAR(12);

#특정 테이블 내 속성 변경하기
# Alter TABLE customer MODIFY COLUMN Color VARCHAR(20) NOT NULL ;

# 특정 테이블 내 속성명&속성타입 변경하기
# ALTER TABLE customer CHANGE COLUMN Phone Mobile VARCHAR(20) NOT NULL;

# 특정 테이블 내 속성 삭제하기
# ALTER TABLE customer DROP COLUMN Color;
