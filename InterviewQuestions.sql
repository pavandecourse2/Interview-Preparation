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
