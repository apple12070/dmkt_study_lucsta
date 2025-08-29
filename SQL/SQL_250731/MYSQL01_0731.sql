/*  <- 한 단락 주석처리가 가능함!
현재 이 공간을 통해서 SQL 언어를 작성할 예정!!!
해당 공간에 한 줄씩 코드를 작성 -> 쿼리(문)
하나의 쿼리가 종료되었다는 것을 정의 -> ;
*/

# 1. DB 생성 : CREATE DATABASE dbname -> DB를 생성하는 명령문
# 2. DB 목록 확인 : SHOW DATABASES; -> 현재 접속할 수 있는 DB의 리스트를 보여줌
# 3. DB 접속 : USE dbname; -> 특정 DB에 접속할 수 있게 도와줌
# 4. Table 생성 : CREATE TABLE
# 5. Data 삽입
# 6. DB 삭제 : DROP DATABASE IF EXISTS dbname // DROP DATABASE dbname

/*
CREATE TABLE mytable(
	id, name VARCHAR(50), PRIMARY
);
*/

-- CREATE DATABASE david; 
-- USE david;

-- CREATE TABLE mytable (
-- 	id TINYINT UNSIGNED, 
--     name VARCHAR(50),
--     PRIMARY KEY(id)
-- );

--  CREATE TABLE mytable (
--  	id FLOAT, 
--      name VARCHAR(50),
--      PRIMARY KEY(id)
--  );
 
--   CREATE TABLE mytable (
--  	id INT UNSIGNED, 
--      name VARCHAR(50),
--      PRIMARY KEY(id)
--  );
 
--    CREATE TABLE mytable (
--  	id INT NOT NULL AUTO_INCREMENT, 
--      name VARCHAR(50),
--      PRIMARY KEY(id)
--  );
 
--     CREATE TABLE mytable (
--  	id INT NOT NULL AUTO_INCREMENT, 
--      name CHAR(50),  # 50개의 문자열이 들어올 수 있는 공간을 항상 마련해놓음.
--      city VARCHAR(50), # 최대 50개까지 입력 -> 5개
--      PRIMARY KEY(id)
     
--          CREATE TABLE mytable (
--  	id INT NOT NULL AUTO_INCREMENT, 
--      name VARCHAR(50), # 50개의 문자열이 들어올 수 있는 공간을 항상 마련해놓음. 
--      PRIMARY KEY(id)  # 하나의 레코드 안에 프라이머리 키 복수 가능
--  );
 
CREATE TABLE mytable (
 	 id INT NOT NULL AUTO_INCREMENT, 
     name VARCHAR(50) NOT NULL,
     modelnumber VARCHAR(15) NOT NULL,
     series VARCHAR(30) NOT NULL,
     PRIMARY KEY(id)
 );