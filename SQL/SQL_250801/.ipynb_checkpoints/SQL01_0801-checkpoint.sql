USE school;
DESC students;
SELECT * FROM students;

Alter TABLE students MODIFY COLUMN age VARCHAR(20);

UPDATE students SET age = "15세" WHERE id = 1;
UPDATE students SET grade = "8학년" WHERE id = 1;

UPDATE students SET age = "15세" WHERE id = 2;
UPDATE students SET grade = "8학년" WHERE id = 2;

UPDATE students SET age = "17세" WHERE id = 3;
UPDATE students SET grade = "10학년" WHERE id = 3;

UPDATE students SET age = "16세" WHERE id = 4;
UPDATE students SET grade = "9학년" WHERE id = 4;

UPDATE students SET age = "15세" WHERE id = 5;
UPDATE students SET grade = "8학년" WHERE id = 5;

SELECT name FROM students;
SELECT name, age FROM students;
SELECT * FROM students WHERE age = "16세";  # 대입연산자
SELECT * FROM students WHERE age != "16세";   #부정연산자
SELECT * FROM students WHERE age <> "16세";   #부정연산자
SELECT * FROM students WHERE age > "16세";    #비교연산자
SELECT * FROM students WHERE age <= "15세";

SELECT * FROM students WHERE grade != "10학년";

SELECT * FROM students WHERE age >="15세" AND grade = "10학년";

SELECT * FROM students WHERE (age <= "16세") AND (grade = "8학년");

SELECT * FROM students WHERE name = "강백호";

SELECT * FROM students WHERE name LIKE "%태%";
#앞뒤글자는 없어도 되고 "태"라는 글자가 있으면 됨. % 값은 0개여도 되고, 1개여도 됨
SELECT * FROM students WHERE name LIKE "_태_";  
#_만큼의 값을 무조건 가져와야 함. __ 두 개 썼으면 해당 값이 2개가 나와야 함. %보다 엄격하게 일치하는 데이터를 찾아오고자 할 때 사용
SELECT * FROM students WHERE name LIKE "___" 
#___ 3개 입력한 만큼 3글자의 값을 가져와야 함