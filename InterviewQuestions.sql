--Create table syntax
CREATE TABLE emps_tbl (emp_name VARCHAR(50), dept_id INT, salary INT);

INSERT INTO emps_tbl VALUES ('Siva', 1, 30000), ('Ravi', 2, 40000), ('Prasad', 1, 50000), ('Sai', 2, 20000), ('Anna', 2, 10000);

 

 WITH ranked_emps AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary) AS min_sal,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS max_sal
  FROM emps_tbl
)
SELECT
  dept_id,
  MAX(CASE WHEN min_sal = 1 THEN emp_name END) AS minsal_emp,
  MAX(CASE WHEN max_sal = 1 THEN emp_name END) AS maxsal_emp
FROM ranked_emps
GROUP BY dept_id;
------------------------------------------------------------------------

--Create table syntax
CREATE TABLE   cards (card_number BIGINT);
INSERT INTO cards VALUES (1234567812345678),(2345678923456789),(3456789034567890);

select * from cards;

--select * , replicate('*',12)  as new_cards from cards

select *,concat(replicate('*' , 12), right(card_number,4)) as new_cards from cards;


----------------------------------------------
CREATE TABLE   Employee (employee_id INT,ename VARCHAR(50),salary INT);
INSERT INTO Employee VALUES (3, 'Bob', 60000),(4, 'Diana', 70000),
(5, 'Eve', 60000),
(6, 'Frank', 80000),
(7, 'Grace', 70000),
(8, 'Henry', 90000);

select * from employee;

select t1.ename
from employee t1, Employee t2
where t1.salary = t2.salary and t1.ename <> t2.ename;


---------------------------------
--Create table syntax
CREATE TABLE transactions_1308 (transaction_id BIGINT, type VARCHAR(50), amount INT,transaction_date DATE)

-- Insert data into the table
INSERT INTO transactions_1308 VALUES (53151, 'deposit', 178, '2022-07-08'), 
(29776, 'withdrawal', 25, '2022-07-08'),(16461, 'withdrawal', 45, '2022-07-08'),
(19153, 'deposit', 65, '2022-07-10'),(77134, 'deposit', 32, '2022-07-10')


select * from transactions_1308;




