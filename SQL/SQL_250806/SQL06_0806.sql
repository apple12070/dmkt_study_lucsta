CREATE DATABASE IF NOT EXISTS sqlDB_v1;
USE sqlDB_V1;

SET FOREIGN_KEY_CHECKS = 0; # 외래키를 끌 수 있는 옵션

CREATE TABLE userTbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height SMALLINT,
    mDate DATE
);

CREATE TABLE buyTbl (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    prodName CHAR(4),
    groupName CHAR(4),
    price INT NOT NULL,
    amount SMALLINT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTbl(userID)
);

INSERT INTO userTbl (userID, name, birthYear, addr, mobile1, mobile2, height, mDate)
VALUES ("DAVID", "박세진", 2000, "서울", "010","12345678", 182, '2000-12-31');

INSERT INTO buyTbl (userID, prodName, groupName, price, amount)
VALUES ("DAVID", "에어조던", "패션잡화", 30, 2);

SELECT * FROM userTbl;

DELETE FROM userTbl WHERE userID = "DAVID";

SHOW TABLE STATUS LIKE 'userTbl';
SHOW TABLE STATUS LIKE 'buyTbl';

SELECT * FROM userTbl;
DELETE FROM userTbl WHERE userID = "DAVID"; # 에러가 나야 정상!
/* 이게 참조값으로 설정되엉 있으니 삭제가 안 되는 것이 정상인데 지금... 흠
1. 아까 최초의 외래키를 참조해 오고자 하는 값이 존재하지 않는데, 값을 생성하고자 할 때, 당연히 에러가 나오는 것이 아주 지극히 정상
2. 외래키의 참조 대상인데, 해당 키를 삭제하겠다라고 했을 때, 삭제가 되지 않아야 지극히 정상
3. 생성 // 삭제 -> 맥 (*어떤 프로그램을 설치하던지 기본 설정을 무조건 그대로 유지한 상태 실행)
4. 윈도우 운영체제의 경우에는 설치 시, 설정 선택 변경에 따라서 기본 설정이 바뀌어져 있을 수 있다.
-> 윈도우 -> 메인보드, 메모리 등의 미세한 버전 차이? 로 인해 초기 설정을 MySQL이 다르게 인식할 수도 있음 극히 드묾.

해결방안 : 맨 위에 SET foreign_key_checks = 1;
*/