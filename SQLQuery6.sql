--Create table syntax
CREATE TABLE transactions_1308 (transaction_id BIGINT, type VARCHAR(50), amount INT,transaction_date DATE)

-- Insert data into the table
INSERT INTO transactions_1308 VALUES (53151, 'deposit', 178, '2022-07-08'),
(29776, 'withdrawal', 25, '2022-07-08'),(16461, 'withdrawal', 45, '2022-07-08'),
(19153, 'deposit', 65, '2022-07-10'),(77134, 'deposit', 32, '2022-07-10')


with cte as (
	select * , ROW_NUMBER() OVER(ORDER BY transaction_date) AS rn ,
		(CASE
			when type = 'deposit' then amount else -amount
		END) AS trans
	from transactions_1308
	)
select transaction_id , type , amount , transaction_date , 
	SUM(trans) over(order by rn asc) AS balance_amount
from cte


with trans_amt as (
select * ,row_number() over(order by transaction_date) as  rn,
case when type ='deposit' then amount else -amount end  as balance_amount
from transactions_1308)
select transaction_id,type,amount,transaction_date ,sum(balance_amount) over(order by rn) as balance_amount
from trans_amt


---------------------------------------------------
--Create table syntax
CREATE TABLE Flights (cust_id INT, flight_id VARCHAR(10), origin VARCHAR(50), destination VARCHAR(50));

-- Insert data into the table
INSERT INTO Flights (cust_id, flight_id, origin, destination)
VALUES (1, 'SG1234', 'Delhi', 'Hyderabad'), 
(1, 'SG3476', 'Kochi', 'Mangalore'), 
(1, '69876', 'Hyderabad', 'Kochi'),
(2, '68749', 'Mumbai', 'Varanasi'),
(2, 'SG5723', 'Varanasi', 'Delhi');

--Method-1
with start_point_cte as (
select f.cust_id,f.origin
from flights f
where not exists (
     select 1 from flights x
	 where x.cust_id = f.cust_id and x.destination = f.origin   
	 )
)	 ,
end_point_cte as (
select cust_id,destination
from flights f
where not exists (
     select 1 from flights x
	 where x.cust_id = f.cust_id and x.origin = f.destination   
	 )
)
select s.cust_id,s.origin,e.destination
from start_point_cte s join  end_point_cte e
on s.cust_id = e.cust_id
order by s.cust_id


--2nd method
with origin_flights_cte as (
select  f1.cust_id,f1.origin
from flights f1
left join flights f2
on f1.cust_id = f2.cust_id
and f1.origin = f2.destination
where f2.origin is null
),
destination_flights_cte as (

select  f1.cust_id,f1.destination 
from flights f1
left join flights f2
on f1.cust_id = f2.cust_id
and f1.destination = f2.origin
where f2.origin is null
)

select o.cust_id,o.origin,e.destination
from origin_flights_cte o join destination_flights_cte e 
on o.cust_id = e.cust_id

-------------------------------------------------
select * from dept;

select * from Employee;

select * from emp;

with rank_cte as (
select *, DENSE_RANK() over (partition by deptno order by sal  desc ) as rnk
from emp)
select * from rank_cte where rnk = 2;



select * from orders;

-------
WITH monthly_orders AS (
    SELECT DISTINCT
        customerid,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, orderdate), 0) AS order_month
    FROM orders
),
orders_with_previous_month AS (
    SELECT
        customerid,
        order_month,
        LAG(order_month) OVER (
            PARTITION BY customerid
            ORDER BY order_month
        ) AS previous_order_month
    FROM monthly_orders
)
SELECT
    customerid,
    previous_order_month,
    order_month
FROM orders_with_previous_month
WHERE order_month = DATEADD(MONTH, 1, previous_order_month);




-------------------------------
CREATE TABLE ordersData (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

INSERT INTO ordersData (order_id, customer_id, order_date)
VALUES
    (1, 101, '2025-01-10'),
    (2, 101, '2025-02-15'),  -- consecutive with January
    (3, 101, '2025-04-08'),
    (4, 102, '2025-01-20'),
    (5, 102, '2025-03-10'),  -- not consecutive
    (6, 103, '2025-05-05'),
    (7, 103, '2025-06-22'),  -- consecutive
    (8, 103, '2025-06-28');  -- same month; ignored by DISTINCT


select * from ordersData;

WITH monthly_orders AS (
    SELECT
        customer_id,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS order_month
    FROM ordersData
),
orders_with_previous_month AS (
    SELECT
        customer_id,
        order_month,
        LAG(order_month) OVER (
            PARTITION BY customer_id
            ORDER BY order_month
        ) AS previous_order_month
    FROM monthly_orders
)
SELECT
    customer_id,
    previous_order_month,
    order_month
FROM orders_with_previous_month
WHERE order_month = DATEADD(MONTH, 1, previous_order_month);


-----------------------------------------------
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    sale_date DATE,
    amount DECIMAL(10, 2)
);

INSERT INTO sales (sale_id, customer_id, sale_date, amount)
VALUES
    (1, 101, '2025-01-01', 100.00),
    (2, 101, '2025-01-05', 200.00),
    (3, 101, '2025-01-10', 150.00),
    (4, 101, '2025-01-15', 300.00),
    (5, 102, '2025-01-02', 500.00),
    (6, 102, '2025-01-08', 250.00),
    (7, 102, '2025-01-12', 100.00);

select * from sales;


select sale_id,customer_id,sale_date,amount,
-- Total sales from the customer's first sale up to this sale
sum(amount) over(partition by customer_id
              order by sale_date,sale_id
              rows between unbounded preceding  and current row
              ) as running_total,


  -- Average amount for current and previous two sales
    AVG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY sale_date, sale_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS average_sales,

     -- Number of sales from the customer's first sale up to this sale
    COUNT(*) OVER (
        PARTITION BY customer_id
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_count
from sales;


--------------------------------------------
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (emp_id, emp_name, department, salary)
VALUES
    (1, 'Asha',   'IT',      60000),
    (2, 'Ravi',   'IT',      80000),
    (3, 'Neha',   'IT',      70000),
    (4, 'Kiran',  'HR',      45000),
    (5, 'Meera',  'HR',      55000),
    (6, 'Arjun',  'Finance', 90000),
    (7, 'Divya',  'Finance', 75000);
select salary ,avg(salary) from employees group by department;

SELECT
    e1.emp_id,
    e1.emp_name,
    e1.department,
    e1.salary,
    (
        SELECT AVG(e2.salary)
        FROM employees e2
        WHERE e2.department = e1.department
    ) AS department_avg_salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);
---2nd method
SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    e.salary,
    d.avg_salary AS department_avg_salary
FROM employees e
JOIN (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) d
    ON e.department = d.department
WHERE e.salary > d.avg_salary;