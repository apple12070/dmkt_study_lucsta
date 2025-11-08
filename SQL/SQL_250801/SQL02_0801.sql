DESC students;
SELECT * FROM students;

# UPDATE students SET name = 'David'; -> 이렇게 입력하면 모든 name 값을 David으로 변경. 함부로 이렇게 사용하면 안됨!!

UPDATE students SET name = '윤대협' WHERE id = 1;

UPDATE students SET age = '16세', grade = '9학년'
WHERE id = 1;

UPDATE students SET age = '16세', grade = '9학년'
WHERE name = '서태웅';

#아래 구문은 students라는 테이블 내 모든 데이터를 delete 하겠다는 뜻!
DELETE FROM students;

DELETE FROM	students WHERE name = '서태웅'; #  primary key가 아니라서 delete가 불가능(데이터의 안정성을 위함)

DELETE FROM students WHERE id = 2;

INSERT INTO students (name,age,grade) VALUES ("서태웅", "15세", "8학년");

# 만약 ID 값을 새롭게 재정렬을 하고 싶다면?
ALTER TABLE students AUTO_INCREMENT = 1;

INSERT INTO students VALUES(2, "강백호", "15세", "8학년"); # <- 수동으로 하나하나 입력하는 방법 