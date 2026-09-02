select * from employees where department ='IT';

CREATE INDEX IX_employees_department
ON employees(department);