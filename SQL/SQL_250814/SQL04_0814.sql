SET SQL_SAFE_UPDATES = 0; 
#0은 falsy한 값. safe updates를 무력화하겠다는 뜻


START TRANSACTION;

UPDATE customer
SET first_name = "DAVID";
WHERE customer_id = 1;

COMMIT;

SELECT * FROM customer LIMIT 10;

-- ROLLBACK;