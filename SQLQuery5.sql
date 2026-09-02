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