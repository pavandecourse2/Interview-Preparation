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


----------------------------------------------------------------------------------------------
create table table1(id int)
insert into table1 values (1), (1),(2),(null),(null)

create table table2(id int)
insert into table2 values (1),(3),(null)

select * from table1 t1 join table2  t2 on t1.id = t2.id 

select * from table1 t1 left join table2  t2 on t1.id = t2.id 

select * from table1 t1 right join table2  t2 on t1.id = t2.id 

select * from table1 t1 full join table2  t2 on t1.id = t2.id 
   
select * from table1 t1 cross join table2  t2    

------------------------------------------------------------------------------

--Let us first create student table
create table students(sname varchar(50), sid varchar(50), marks int)

--Insert the records
insert into students values('A','X',75),('A','Y',75),('A','Z',80),('B','X',90),('B','Y',91),('B','Z',75)


with stud_marks as(
select * , row_number() over (partition by sname order by marks desc ) as rrn from students)
select sname,sum(marks)
from stud_marks
where rrn <=2
group by sname;


-----------------------------------------------------------------------------------------------
--Create EmployeesID table
create table employeesID (id int);

--Insert the records
insert into employeesID values (2),(5),(6),(6),(7),(8),(8);

select * from employeesID;

with maxid as (
select id
from employeesID
group by id
having count(id) = 1) select max(id) from maxid ;

--2nd method
select max(id) from  (
         select id,count(*) over(partition by id) as rrn from employeesID
         ) as d 
         where rrn = 1;
--3rd method
SELECT MAX(id)
FROM employeesID
WHERE id IN (
  SELECT id
  FROM employeesID
  GROUP BY id
  HAVING COUNT(*) = 1
);

-----------------------------------------------------------------------

--DDL
create table tablea (empid int, empname varchar(50), salary int);
create table tableb (empid int, empname varchar(50), salary int);

--Insert the records
insert into tablea values(1,'AA',1000),(2,'BB',300);
insert into tableb values(2,'BB',400),(3,'CC',100);


--2nd method
with cte as (select *,row_number() over(partition by empid order by salary ) as rrn from (
              (select * from tablea
              union
              select * from tableb 
              )
              )
              a)
select empid,empname,salary from cte where rrn=1

--1st method
select empid,empname,min(salary) from(
 
              select * from tablea
              union
              select * from tableb ) a
              group by empid,empname


--------------------------------------------------
--Let us first create sales table

create table salesDB(month varchar(50), ytd_sales int, monthnum int)
delete from salesDB;

--Insert the records
insert into salesDB values('jan',15,1),('feb',22,2),('mar',35,3),('apr',45,4),('may',60,5)

select * from salesDB;

with cte as (
select month,ytd_sales,monthnum,lag(ytd_sales,1,0) over(order by monthnum) as lag_sales from salesDB )
select month,ytd_sales, (ytd_sales - lag_sales) as periodic_sales from cte;

----------------------------------------
---Let us first create sales table
create table happiness_tbl (ranking int, country varchar(50))

---Insert the records
insert into happiness_tbl values (1,'Finland'),(2,'Denmark'),(3,'Iceland'),
(4,'Israel'),(5,'Netherlands'),(6,'Sweden'),(7,'Norway'),(8,'Switzerland'),
(9,'Luxembourg'),(128,'Srilanka'),(126,'India')

select * from happiness_tbl;

with cte as (
select ranking,country, case when country = 'India' then 1
                             when country ='Srilanka' then 2
                             else 3 end as derivied_rank
from happiness_tbl
)
select country from cte order by derivied_rank;

-------------------------------------------------------------------------------
--Let us first create students table
create table studnts_tbl (sname varchar(50), marks int)

--Insert the records
insert into studnts_tbl values ('A', 75),('B', 30),('C', 55),('A', 60),('D', 91),
('B', 19),('G', 36),('S', 65),('K', 49)

select * from studnts_tbl;

---case 1
 
select *,  case 
              when marks >=80 then 'Excellent'
              when marks >=60 and marks <80 then 'VGood' 
              when marks >=35 and marks <60 then 'Good' 
              Else 'Poor' end as 'Grade'
              from studnts_tbl);
--case-2:
alter table studnts_tbl add grade as (
   case 
              when marks >=80 then 'Excellent'
              when marks >=60 and marks <80 then 'VGood' 
              when marks >=35 and marks <60 then 'Good' 
              Else 'Poor' end  );

---------------------------------------------------------------------
--Let us first create cinemas table
create table cinema_tbl (seat_id int, free int)

--Insert the records
insert into cinema_tbl values (1,1),(2,0),(3,1),(4,0),(5,1),(6,1),(7,1),(8,0),(9,1),(10,1)

with free_seat as (
select seat_id,free,lag(free,1,0) over(order by seat_id) as previous_seat,
              lead(free,1,0) over(order by seat_id) as next_seat
              from cinema_tbl )
select seat_id,free,previous_seat,next_seat
from free_seat 
where free = 1 and (previous_seat = 1 or next_seat =1);

-------------------------------------------------------------------------------

--Let us first create brands table
create table brands (category varchar(50), brand_name varchar(50))

--Insert the records
insert into brands values ('chocolates', '5-star'),
(NULL, 'dairy milk'),(NULL, 'perk'),(NULL, 'eclair'),
('Biscuits', 'Britania'),(NULL, 'good day'),(NULL, 'boost')

select category,brand_name from brands;
--step-1 :get the row_number
with cte as (
select category,brand_name,row_number() over(order by (select null)) as rrn_num from brands),
--step-2 : get the count of different category
cte2 as (select *,count(category) over(order by rrn_num) as cnt from cte)
--step-3 fill the category based on count
select first_value(category) over(partition by cnt order by rrn_num) as category,brand_name from cte2;

----------------------------------------------------------------------------------------
---Let us first create input table
create table tbl_maxval (col1 varchar(50), col2 int, col3 int);

---Insert the records
insert into tbl_maxval values ('a',10,20),('b',50,30);

--1st method
with cte as (
select *, GREATEST(col2,col3) as max_val from tbl_maxval )
select col1,max_val from cte;

 --2nd method
 with cte as (
 select * , case 
                 when col2 >= col3 then col2 else col3 end as max_val from tbl_maxval) 
select col1,max_val from cte;

----------------------------------------------------------------------

--Let us first create sales table
create table salesvar_tbl (dt date, sales int)

--Insert the records
insert into salesvar_tbl values ('2023-10-03', 10),('2023-10-04', 20),
('2023-10-05', 60),('2023-10-06', 50),('2023-10-07', 10);


select * from salesvar_tbl;

with cte1 as(
select *,lag(sales) over(order by dt) as previous_sales from salesvar_tbl),
cte2 as (
select * ,coalesce((sales - previous_sales) *100 / previous_sales,0)
as percentage_variance from cte1)

select dt, sales,percentage_variance
from cte2 where percentage_variance >=0;
------------------------------------------------
--t us first create input table
--eate table tbl_cnt (col1 int, col2 varchar(50))

--rt the records
insert into tbl_cnt values (1, 'a,b,c'),(2, 'a,b')

select col1,col2 from tbl_cnt;
select col1,len(rePLAce(col2,',','') ) as cnt from tbl_cnt;

-------------------------------------------------------------

--Let us create Emp table and insert records
create table emptb(empid int, empname varchar(50), salary int, deptid int);
insert into empTB values 
(1,'Nikitha',45000,206),
(2,'Ashish',42000,207),
(3,'David',40000,206),
(4,'Ram',50000,207),
(5,'John',35000,208),
(6,'Mark',50000,207),
(7,'Aravind',39000,208);

--Let us create Dept table and insert records
create table deptTB (deptid int, deptname varchar(50))
insert into deptTB values (206,'HR'),(207,'IT'),(208,'Finance')

with cte as(
select e.*,d.deptname,rank() over (partition by e.deptid order by salary desc) as rank
from emptb e  join deptTB d  on e.deptid = d.deptid
)
select deptname, STRING_AGG(empname,',') as empname from cte where rank=1
group by deptname;
--------------------------------------------------------------
create table empdept_tbl (eid int, dept varchar(50),scores float)
insert into empdept_tbl values (1, 'd1', 1.0),
(2, 'd1', 5.28),(3, 'd1', 4.0),(4,'d2', 8.0),
(5, 'd1', 2.5),(6, 'd2', 7.0),(7, 'd3', 9.0),
(8, 'd4', 10.2)

select * from empdept_tbl;


select *,first_value(scores) over(partition by dept order by scores desc) as first_value  from empdept_tbl);

update empdept_tbl  set scores = (select max(scores) from empdept_tbl t2 where t2.dept = empdept_tbl.dept)

-------------------------------------------------------------------------------------
--Let us create Customer table and insert records
create table customer_tbl (id int, email varchar(50))
insert into customer_tbl values (1,'abc@gmail.com'),(2,'xyz@hotmail.com'),
(3,'pqr@outlook.com')

select * from customer_tbl;

select SUBSTRING(email,CHARINDEX('@',email)+ 1,len(email)) as email1  from customer_tbl

select email,left(email,(charindex('@',email)-1)) as name,
             substring(email,CHARINDEX('@',email)+1,len(email)) as domain
             from customer_tbl;
---------------------------------------------------------------------------------------
--Let us create Customer table and insert records
CREATE TABLE employees_tbl (empid INT,ename VARCHAR(50),salary INT,managerid INT)

INSERT INTO employees_tbl VALUES (1, 'John', 50000, NULL),
(2, 'Alice', 40000, 1),(3, 'Bob', 70000, 1),
(4, 'Emily', 55000, NULL),
(5, 'Charlie', 65000, 4),
(6, 'David', 50000, 4)

select * from  employees_tbl;

select e.*,m.*
from employees_tbl e join  employees_tbl m
on e.empid = m.managerid
where m.managerid is not null;

select * from  employees_tbl;

select  e.ename empname ,e.salary as empsalary ,
 m.ename as mgrname ,m.salary as mgrsalary 
from employees_tbl e join  employees_tbl m
on e.managerid = m.empid
 where e.salary > m.salary;
 -----------------------------------------------------------
create table prd_tbl (dt date, brand varchar(50), model varchar(50),production_cost int)

--Insert the records
insert into prd_tbl values ('2023-12-01', 'A', 'A1', 1000),
('2023-12-01', 'A', 'A2', 1300),('2023-12-01', 'B', 'B1', 800),
('2023-12-02', 'A', 'A1', 1800),('2023-12-02', 'B', 'B1', 900), 
('2023-12-10', 'A', 'A1', 1400),('2023-12-10', 'A', 'A1', 1200), 
('2023-12-10', 'C', 'C1', 2500)

select * from prd_tbl;

select *,sum(production_cost) over (partition by dt,brand order by dt) as agg_cost
from prd_tbl;
-------------------------------------------------------------------------------------

--Let us first create exchange_rates table
CREATE TABLE exchange_rates (
    currency_code VARCHAR(3),
    date DATE,
    currency_exchange_rate DECIMAL(10, 2)
)

--Insert the records
INSERT INTO exchange_rates (currency_code, date, currency_exchange_rate) VALUES
('USD', '2024-06-01', 1.20),
('USD', '2024-06-02', 1.21),
('USD', '2024-06-03', 1.22),
('USD', '2024-06-04', 1.23),
('USD', '2024-07-01', 1.25),
('USD', '2024-07-02', 1.26),
('USD', '2024-07-03', 1.27),
('EUR', '2024-06-01', 1.40),
('EUR', '2024-06-02', 1.41),
('EUR', '2024-06-03', 1.42),
('EUR', '2024-06-04', 1.43),
('EUR', '2024-07-01', 1.45),
('EUR', '2024-07-02', 1.46),
('EUR', '2024-07-03', 1.47)

select * from exchange_rates;

with cte as (
select *,concat(currency_code,'_',year(date),'_',month(date)) as currencycode_year_month,
row_number() over(partition by currency_code,year(date),month(date) order by date) as  row_num_asc,
row_number() over(partition by currency_code,year(date),month(date) order by date desc) as  row_num_desc
from exchange_rates)
select currencycode_year_month,
max(case when row_num_asc = 1 then currency_exchange_rate end )as currency_rate_starting_day_of_month,
max(case when row_num_desc = 1 then currency_exchange_rate end) as currency_rate_ending_day_of_month
from cte 
group by currencycode_year_month;

------------------------------------------------------
---Let us create tables and insert data
CREATE TABLE department_tbl (deptid INT, deptname VARCHAR(50))
INSERT INTO department_tbl VALUES (101, 'HR'), (102, 'Finance'), (103, 'Marketing');

CREATE TABLE employee_tbl (empid INT, salary INT, deptid INT)
INSERT INTO employee_tbl VALUES (1, 70000, 101),(2, 50000, 101),
(3, 60000, 101),(4, 65000, 102),(5, 65000, 102),(6, 55000, 102),
(7, 60000, 103),(8, 70000, 103),(9, 80000, 103);

with cte as (
select e.empid,e.salary, d.deptname,d.deptid ,dense_rank() over(partition by e.deptid order by e.salary desc) as rank
from employee_tbl e join department_tbl d on e.deptid = d.deptid)
select empid,salary,deptid,deptname
from cte
where rank=2;
------------------------------------------------------------------
CREATE TABLE employees_gender_tbl (eid INT, ename VARCHAR(50), gender VARCHAR(10))

INSERT INTO employees_gender_tbl VALUES (1, 'John Doe', 'Male'),(2, 'Jane Smith', 'Female'),
(3, 'Michael Johnson', 'Male'),(4, 'Emily Davis', 'Female'),(5, 'Robert Brown', 'Male'),
(6, 'Sophia Wilson', 'Female'),(7, 'David Lee', 'Male'),(8, 'Emma White', 'Female'),
(9, 'James Taylor', 'Male'),(10, 'William Clark', 'Male')
 
 WITH cte AS
(
    SELECT
        gender,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY gender) AS rrn
    FROM employees_gender_tbl
)
SELECT
    gender,
    CAST(
        100.0 * MAX(rrn) / SUM(MAX(rrn)) over()
        AS DECIMAL(5,2)
    ) AS percentage_value
FROM cte
GROUP BY gender;


select gender,count(gender) as total, 100 * count(*) /(select count(*) from employees_gender_tbl) as gender_percentage
from employees_gender_tbl
group by gender;

-------------------------------------------------------------------------------------------
-- get 3rd saturday of the month

select getdate();

WITH cte AS (
    SELECT DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS Dates

    UNION ALL

    SELECT DATEADD(DAY, 1, Dates)
    FROM cte
    WHERE MONTH(DATEADD(DAY, 1, Dates)) = MONTH(GETDATE())
),
cte2 AS (
    SELECT
        Dates,
        DATENAME(WEEKDAY, Dates) AS DayName,
        ROW_NUMBER() OVER (ORDER BY Dates) AS Weekday
    FROM cte
    WHERE DATENAME(WEEKDAY, Dates) = 'Saturday'
)
SELECT *
FROM cte2
WHERE Weekday = 3;


-------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_getAllOrSelectedWeekDay
    @WeekdayOfMonth VARCHAR(15),
    @row_number int
AS
BEGIN
    --SET NOCOUNT ON;

    ;WITH cte AS (
        SELECT DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS Dates

        UNION ALL

        SELECT DATEADD(DAY, 1, Dates)
        FROM cte
        WHERE MONTH(DATEADD(DAY, 1, Dates)) = MONTH(GETDATE())
    ),
    cte2 AS (
        SELECT
            Dates,
            DATENAME(WEEKDAY, Dates) AS Weekday,
            ROW_NUMBER() OVER (ORDER BY Dates) AS Row_Num
        FROM cte
        WHERE DATENAME(WEEKDAY, Dates) = @WeekdayOfMonth
    )
     
     SELECT
    Dates,
    Weekday,
    Row_Num AS OccurrenceNumber
FROM cte2
    WHERE @row_number = 0
   OR Row_Num = @row_number;
   
END;
GO

dbo.sp_getAllOrSelectedWeekDay @WeekdayOfMonth ='Saturday',@row_number = 6;

----------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_getWeekdayOfMonth
    @WeekdayOfMonth VARCHAR(15),
    @row_number INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @WeekdayOfMonth NOT IN
       ('Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday')
    BEGIN
        THROW 50002, 'Enter a valid weekday name.', 1;
    END;

    IF @row_number < 0 OR @row_number > 5
    BEGIN
        THROW 50001, '@row_number must be between 0 and 5. Use 0 for all occurrences.', 1;
    END;

    ;WITH cte AS (
        SELECT DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS Dates

        UNION ALL

        SELECT DATEADD(DAY, 1, Dates)
        FROM cte
        WHERE Dates < EOMONTH(GETDATE())
    ),
    MatchingDays AS (
        SELECT
            Dates,
            DATENAME(WEEKDAY, Dates) AS Weekday,
            ROW_NUMBER() OVER (ORDER BY Dates) AS Row_Num
        FROM cte
        WHERE DATENAME(WEEKDAY, Dates) = @WeekdayOfMonth
    )
    SELECT
        Dates,
        Weekday,
        Row_Num AS OccurrenceNumber
    FROM MatchingDays
    WHERE @row_number = 0
       OR Row_Num = @row_number;
END;
GO

exec dbo.sp_getWeekdayOfMonth 'Monday' ,6;
-------------------------------------------------------
CREATE TABLE routes (Origin VARCHAR(50), Destination VARCHAR(50));

INSERT INTO routes VALUES ('Bangalore', 'Chennai'), ('Chennai', 'Bangalore'), ('Pune', 'Chennai'), ('Delhi', 'Pune');


--1st method
with cte as (
select *, row_number() over(partition by least(Origin,Destination),Greatest(Origin,Destination) order by Origin) as rrrn
from routes)
select * from cte where rrrn=1;

--2nd method

with cte as (
        select *, row_number() over(partition by 
                                               case  when origin < destination then origin else destination end ,
                                                case when origin > destination then origin else destination end
        order by origin ) as rrrn
        from routes)
select * from cte where rrrn=1;

--------------------------------------------------------------------

--Create table syntax
CREATE TABLE emps_tbl_1 (emp_name VARCHAR(50), dept_id INT, salary INT);

INSERT INTO emps_tbl_1 VALUES ('Siva', 1, 30000), 
('Ravi', 2, 40000), ('Prasad', 1, 50000),
('Sai', 2, 20000), ('Anna', 2, 10000);

select * from emps_tbl_1;

with cte as (
select * ,row_number() over(partition by dept_id order by salary) as min_sal,
row_number() over(partition by dept_id order by salary desc) as max_sal
from emps_tbl_1)

select dept_id ,
max(case when min_sal =1 then emp_name end)  as min_emp_name ,
max(case when max_sal =1 then emp_name end) as max_emp_name
from cte
group by dept_id;

--2nd method

select distinct dept_id, first_value(emp_name) over(partition by dept_id order by salary) as min_sal,
first_value(emp_name) over(partition by dept_id order by salary desc) as max_sal
from emps_tbl_1;

---------------------------
CREATE TABLE events ( pid INT, year INT ) 
-- Insert data into the table 
INSERT INTO events VALUES (1, 2019), (1, 2020), (1, 2021), (2, 2022), (2, 2021),(3, 2019), (3, 2021), (3, 2022)

with cte as(
select *,
	lag(year) over (partition by pid order by year) previous_year,
    lead(year) over (partition by pid order by year) next_year
from events
)
select distinct pid
from cte 
where year-previous_year = 1 
and next_year-year = 1;

------------------------------------------------------------------------------------------------------
--question-1:Find the second or nth highest salary.

CREATE TABLE Employee_prt (
    EmpId INT,
    EmpName VARCHAR(50),
    Salary INT
);

INSERT INTO Employee_prt VALUES
(1, 'Asha', 50000),
(2, 'Ravi', 70000),
(3, 'Neha', 70000),
(4, 'Kiran', 60000),
(5, 'John', 45000);

select * from employee_prt;
with cte as (
select *,dense_rank() over(order by salary desc) as rrn from Employee_prt)
select * from cte where rrn = 2;


--------------------------------------------------------
-->                                    question-2:Find duplicate records and remove duplicates using ROW_NUMBER().

CREATE TABLE Customers_prt (
    CustomerId INT,
    CustomerName VARCHAR(50),
    Email VARCHAR(100),
    CreatedDate DATE
);

INSERT INTO Customers_prt VALUES
(1, 'Asha',  'asha@gmail.com', '2026-01-10'),
(2, 'Ravi',  'ravi@gmail.com', '2026-01-11'),
(3, 'Asha',  'asha@gmail.com', '2026-02-15'),
(4, 'Neha',  'neha@gmail.com', '2026-01-12'),
(5, 'Ravi',  'ravi@gmail.com', '2026-03-01');

with duplicate_customer as (
select *, row_number() over(partition by email order by customerId) as rrn from Customers_prt
)

delete  from duplicate_customer where rrn>1;


-----------------------------------------------------------------
--question:3 :Find employees with the same salary.
CREATE TABLE Employees_prt2 (
    EmployeeId INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees_prt2 VALUES
(101, 'Asha',  'IT',      60000),
(102, 'Ravi',  'HR',      50000),
(103, 'Neha',  'IT',      60000),
(104, 'Kiran', 'Finance', 75000),
(105, 'John',  'HR',      50000),
(106, 'Meera', 'Finance', 80000);

with cte as (
select *, rank() over(order by salary ) as SalaryRank,
          count(*)over(partition by salary ) as SalaryCount from Employees_prt2)

select  
EmployeeId,
    EmployeeName,
    Department,
    Salary,
    SalaryRank,
    SalaryCount
from cte
 where SalaryCount >=2;

 --2nd method

 select EmployeeId,
    EmployeeName,
    Department,
    Salary
    from employees_prt2
    where salary in ( select Salary from Employees_prt2 group by salary having count(salary) > 1)
    order by salary, employeeid
    

-------------------------------------------------------------------------------------------
--question-4:Return the latest record for each customer/product.

CREATE TABLE Orders_prt (
    OrderId INT,
    CustomerId INT,
    ProductName VARCHAR(50),
    OrderDate DATE,
    Amount DECIMAL(10, 2)
);

INSERT INTO Orders_prt VALUES
(101, 1, 'Laptop', '2026-01-10', 60000),
(102, 1, 'Laptop', '2026-03-15', 65000),
(103, 1, 'Mouse',  '2026-02-20', 1200),
(104, 2, 'Laptop', '2026-01-05', 61000),
(105, 2, 'Laptop', '2026-04-01', 62000),
(106, 2, 'Mouse',  '2026-03-10', 1300);
    
 with recent_record as (
 select * , row_number() over(partition by customerId,productName order by orderdate desc) as recent_row from orders_prt
 )select * from recent_record where recent_row = 1 ;

 ------------------------------------------------
 --question-5:Find records present in one table but missing from another.
 --drop table SourceCustomers;
 --drop table TargetCustomers;
 CREATE TABLE SourceCustomers_prt (
    CustomerId INT,
    CustomerName VARCHAR(50)
);

CREATE TABLE TargetCustomers_prt (
    CustomerId INT,
    CustomerName VARCHAR(50)
);


INSERT INTO SourceCustomers_prt VALUES
(1, 'Asha'),
(2, 'Ravi'),
(3, 'Neha'),
(4, 'Kiran');

INSERT INTO TargetCustomers_prt VALUES
(1, 'Asha'),
(2, 'Ravi');
 
 select * from SourceCustomers_prt;

 select s.CustomerId,s.customername from SourceCustomers_prt s left join TargetCustomers_prt  t on s.CustomerId = t.CustomerId
 where t.CustomerId is null;
 ------------------------------------------------------------------------------
 --question-6:Find consecutive login dates or missing dates..
 CREATE TABLE UserLogins_prt (
    LoginId INT,
    UserId INT,
    LoginDate DATE
);

INSERT INTO UserLogins_prt VALUES
(1, 101, '2026-01-01'),
(2, 101, '2026-01-02'),
(3, 101, '2026-01-03'),
(4, 101, '2026-01-05'),
(5, 101, '2026-01-06'),
(6, 102, '2026-01-10'),
(7, 102, '2026-01-12'),
(8, 102, '2026-01-13');

--Missing Dates
with cte as(
select loginid,
       logindate,
       lead(logindate) over(partition by userid order by logindate) AS next_login_day
       from UserLogins_prt)
select loginid,dateadd(day,1,logindate) as missing_date
from cte
where datediff(day,logindate,next_login_day) > 1;


--consecutive login Dates
with cte as(
select loginid,
       logindate,
       lead(logindate) over(partition by userid order by logindate) AS next_login_day
       from UserLogins_prt)
select loginid,dateadd(day,1,logindate) as missing_date
from cte
where datediff(day,logindate,next_login_day) = 1;

----------------------------------------------------------

--Question-7:Calculate running total, moving average, and rank using window functions.

CREATE TABLE Sales_prt (
    SaleId INT,
    CustomerId INT,
    SaleDate DATE,
    Amount DECIMAL(10, 2)
);

INSERT INTO Sales_prt VALUES
(1, 101, '2026-01-01', 1000),
(2, 101, '2026-01-02', 1500),
(3, 101, '2026-01-03', 2000),
(4, 101, '2026-01-04', 1200),
(5, 102, '2026-01-01', 3000),
(6, 102, '2026-01-02', 2500),
(7, 102, '2026-01-03', 4000);

--method-1
select *,
        sum(amount) over(partition by customerId order by saledate rows between unbounded preceding and current row) as running_total,
        avg(amount) over(partition by customerId order by saledate rows between unbounded preceding and current row) as moving_avg_total,
        rank() over(partition by customerID order by amount desc) as ranking 
from Sales_prt

--method-2
 with cte1 as (
SELECT
    SaleId,
    CustomerId,
    SaleDate,
    Amount,

    SUM(Amount) OVER (
        PARTITION BY CustomerId
        ORDER BY SaleDate, SaleId
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal,

    AVG(Amount) OVER (
        PARTITION BY CustomerId
        ORDER BY SaleDate, SaleId
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage,

    SUM(Amount) OVER (
        PARTITION BY CustomerId
    ) AS CustomerTotal
FROM Sales_prt) select *, dense_rank() over( order by customerTotal desc) as ranking from cte1;

------------------------------------------------------------------------------------------------------
 
--question-8 :Find the first/last transaction for every customer.
CREATE TABLE Transactions_prt (
    TransactionId INT,
    CustomerId INT,
    TransactionDate DATE,
    Amount DECIMAL(10, 2)
);

INSERT INTO Transactions_prt VALUES
(101, 1, '2026-01-05', 1000),
(102, 1, '2026-02-10', 1500),
(103, 1, '2026-03-20', 2000),
(104, 2, '2026-01-15', 500),
(105, 2, '2026-04-01', 2500),
(106, 3, '2026-02-25', 1200); 

select * from Transactions_prt;
--1st method
WITH cte1 AS (
    SELECT
        TransactionId,
        CustomerId,
        TransactionDate,
        Amount,

        FIRST_VALUE(TransactionDate) OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate, TransactionId
        ) AS FirstTransactionDate,

        LAST_VALUE(TransactionDate) OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate, TransactionId
            ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
        ) AS LastTransactionDate
    FROM Transactions_prt
)
SELECT DISTINCT
    CustomerId,
    FirstTransactionDate AS StartingTransactionDate,
    LastTransactionDate AS EndingTransactionDate
FROM cte1
ORDER BY CustomerId;

--2nd method
WITH cte1 AS (
    SELECT
        TransactionId,
        CustomerId,
        TransactionDate,
        Amount,

        FIRST_VALUE(TransactionDate) OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate, TransactionId
        ) AS FirstTransactionDate,

        LAST_VALUE(TransactionDate) OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate, TransactionId
            ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
        ) AS LastTransactionDate
    FROM Transactions_prt
),
cte2 AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate, TransactionId
        ) AS first_trans_number,

        RANK() OVER (
            PARTITION BY CustomerId
            ORDER BY TransactionDate DESC, TransactionId DESC
        ) AS last_trans_number
    FROM cte1
)
SELECT
    CustomerId,
    MAX(FirstTransactionDate) AS FirstTransactionDate,
    MAX(LastTransactionDate) AS LastTransactionDate   
FROM cte2
GROUP BY CustomerId
ORDER BY CustomerId;
------------------------------------------------------------------------
--quetion-9:Remove reciprocal duplicates, such as A → B and B → A.
CREATE TABLE Routes_prt (
    RouteId INT,
    Origin VARCHAR(50),
    Destination VARCHAR(50)
);

INSERT INTO Routes_prt VALUES
(1, 'Delhi',   'Mumbai'),
(2, 'Mumbai',  'Delhi'),    -- reverse duplicate of RouteId 1
(3, 'Chennai', 'Bengaluru'),
(4, 'Bengaluru', 'Chennai'), -- reverse duplicate of RouteId 3
(5, 'Delhi',   'Kolkata'),
(6, 'Mumbai',  'Pune');

with route_pairs as (
select *, ROW_NUMBER() over(partition by 
                                case when origin < destination then origin else destination end ,
                                case when origin < destination then Destination else origin end
                                order by routeid) as row_num
from Routes_prt)

select * from route_pairs where row_num >1 
---------------------------------------------------------------------------
--question-10:Find the third Saturday / nth weekday of a month.

with cte1 as (
select DATEFROMPARTS(year(getdate()) , month(getdate()),1) as Dates
union all
select Dateadd(day,1,Dates) from cte1 where month(dateadd(day,1,Dates)) = month(getdate()))
,cte2 as(
 select Dates, DATENAME(WEEKDAY,Dates) as weekday ,row_number() over(order by dates) as row_num from cte1
 where datename(weekday,dates) ='Saturday')
 select * from cte2 where row_num=4;

 ---------------------------------------------------------------------------------------------------
 --quetion-11 :find customers who placed orders in every month of a given year.

 CREATE TABLE Orders_prt1 (
    OrderId INT,
    CustomerId INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2)
);

INSERT INTO Orders_prt1 VALUES
(1, 101, '2026-01-10', 100),
(2, 101, '2026-02-10', 200),
(3, 101, '2026-03-10', 150),
(4, 101, '2026-04-10', 180),
(5, 101, '2026-05-10', 120),
(6, 101, '2026-06-10', 300),
(7, 101, '2026-07-10', 250),
(8, 101, '2026-08-10', 100),
(9, 101, '2026-09-10', 400),
(10, 101, '2026-10-10', 200),
(11, 101, '2026-11-10', 150),
(12, 101, '2026-12-10', 500),

(13, 102, '2026-01-15', 100),
(14, 102, '2026-02-15', 200),
(15, 102, '2026-03-15', 150);


 declare @year int = 2026;
 select customerid 
 from orders_prt1
 where orderdate >=DATEFROMPARTS(@year,1,1)
 and orderdate<Datefromparts(@year +1,1,1)
 group by customerid
 having count (distinct month(orderdate)) = 12;

 --------------------------------------------------------------------------
 --quetion-12 :find customers who placed orders in consecutivly in 3 months

  with cte1 as(
 select customerid, DATEFROMPARTS(year(orderdate),month(orderdate),1) as ordersMonth from orders_prt1), 
 cte2 as (select customerid, ordersMonth ,
       lag(ordersMonth,1) over(partition by customerid order by ordersMonth) as  PreviousMonth,
       lag(ordersMonth,2) over(partition by customerid order by ordersMonth) as  TwoMonthsBefore
 from cte1)
 
  SELECT DISTINCT CustomerId
FROM cte2
WHERE DATEDIFF(MONTH, PreviousMonth, OrdersMonth) = 1
  AND DATEDIFF(MONTH, TwoMonthsBefore, OrdersMonth) = 2;
 --select distinct customerid,  TwoMonthsBefore as ConsecutiveStartMonth, PreviousMonth,ordersMonth as ConsecutiveEndMonth
 --from cte2
-- where datediff(month,TwoMonthsBefore,ordersMonth) = 2 and 
-- datediff(month,PreviousMonth,ordersMonth) = 1;
-----------------------------------------------------------------------------------

CREATE TABLE Products_prt2 (
    ProductId INT,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders_prt2 (
    OrderId INT,
    CustomerId INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails_prt2 (
    OrderDetailId INT,
    OrderId INT,
    ProductId INT,
    Quantity INT
);

INSERT INTO Products_prt2 VALUES
(1, 'Laptop', 60000),
(2, 'Mouse', 1200),
(3, 'Keyboard', 2500),
(4, 'Monitor', 15000),
(5, 'Headphones', 3000);

INSERT INTO Orders_prt2 VALUES
(101, 1, '2026-01-10'),
(102, 2, '2026-01-15');

INSERT INTO OrderDetails_prt2 VALUES
(1, 101, 1, 1),  -- Laptop ordered
(2, 101, 2, 2),  -- Mouse ordered
(3, 102, 4, 1);  -- Monitor ordered

select * from OrderDetails_prt2;

select p.* from Products_prt2 p left join OrderDetails_prt2 od    on od.productid = p.ProductId
where od.ProductId is null;

--------------------------------------------------------------------------------

-->question13: find department with no employees
CREATE TABLE Departments_prt1 (
    DepartmentId INT,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Employees_prt1 (
    EmployeeId INT,
    EmployeeName VARCHAR(50),
    DepartmentId INT
);

INSERT INTO Departments_prt1 VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');

INSERT INTO Employees_prt1 VALUES
(101, 'Asha', 1),      -- IT
(102, 'Ravi', 1),      -- IT
(103, 'Neha', 2),      -- HR
(104, 'Kiran', 3);     -- Finance

select d.DepartmentName
from Departments_prt1 d  left join Employees_prt1 e on d.DepartmentId = e.DepartmentId
where e.EmployeeId is null;



-----------------------------------------------
-->question 14: find employee whose salary is greater then department salary
CREATE TABLE Employees_prt3 (
    EmployeeId INT,
    EmployeeName VARCHAR(50),
    DepartmentId INT,
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees_prt3 VALUES
(101, 'Asha',  1, 60000),
(102, 'Ravi',  1, 50000),
(103, 'Neha',  1, 70000),
(104, 'Kiran', 2, 45000),
(105, 'John',  2, 55000),
(106, 'Meera', 3, 80000);

with cte1 as (
select * , avg(salary) over(partition by departmentId ) as avg_dept_salary from Employees_prt3)
select *
from cte1
where salary > avg_dept_salary;

------------------------------------

-->question-15: Find the top 3 highest-paid employees in each department.
CREATE TABLE Employees_prt4 (
    EmployeeId INT,
    EmployeeName VARCHAR(50),
    DepartmentId INT,
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees_prt4 VALUES
(101, 'Asha',  1, 60000),
(102, 'Ravi',  1, 50000),
(103, 'Neha',  1, 70000),
(104, 'Kiran', 1, 65000),
(105, 'John',  2, 55000),
(106, 'Meera', 2, 80000),
(107, 'Anil',  2, 70000),
(108, 'Sara',  2, 65000);

select * from Employees_prt4 ;
with cte1 as (
select *, DENSE_RANK() over(partition by departmentid order by salary desc) as max_3_salary
from Employees_prt4)
select *
from cte1
where max_3_salary <=3

----------------------------------------------------
-->question-16:6. Find the median salary by department.

SELECT DISTINCT
    DepartmentId,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY Salary
    ) OVER (
        PARTITION BY DepartmentId
    ) AS MedianSalary
FROM Employees_prt4
ORDER BY DepartmentId;
----------------------------------------------------
-->question-17:Find customers whose total purchase is above the overall average customer purchase.
CREATE TABLE Orders_prt3 (
    OrderId INT,
    CustomerId INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2)
);

INSERT INTO Orders_prt3 VALUES
(1, 101, '2026-01-10', 1000),
(2, 101, '2026-02-15', 2000),  -- Customer 101 total = 3000

(3, 102, '2026-01-20', 500),
(4, 102, '2026-03-10', 700),   -- Customer 102 total = 1200

(5, 103, '2026-02-05', 4000),  -- Customer 103 total = 4000

(6, 104, '2026-03-25', 1800);  -- Customer 104 total = 1800

with cte1 as (
select *, sum(amount) over( partition by customerid order by customerid ) as totalpurchaseamount  
from Orders_prt3), cte2 as (

select customerid , totalpurchaseamount,avg(totalpurchaseamount) over() as avg_amount  from cte1  )

select distinct customerid ,totalpurchaseamount , avg_amount from cte2 where totalpurchaseamount > avg_amount;
 ---------------------------------