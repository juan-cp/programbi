CREATE TABLE departments (
  dept_no VARCHAR(10),
  dept_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (dept_no)
);

select * from departments 

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender VARCHAR(2) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

select * from employees

CREATE TABLE salaries (
	emp_no int NOT NULL,
	salary BIGINT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

select * from salaries

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(20) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

select * from titles

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(10) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
 dept_no VARCHAR (10),
 emp_no INT,
 from_date DATE NOT NULL,
 to_date DATE NOT NULL,
 FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
 FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

select * from dept_emp
select * from dept_manager



--p1

select employees.*, salaries.* 
from employees left join salaries on employees.emp_no=salaries.emp_no

--p2

select * from employees
where year(hire_date)=1986

--p3

select dept_manager.*, employees.*, departments.*
from dept_manager 
left join employees on dept_manager.emp_no=employees.emp_no
left join departments on dept_manager.dept_no=departments.dept_no

--p4

--relacion entre empleado y departamento : dept_emp
--conectar employees con departments a traves de dept_emp

select employees.*, dept_emp.*, departments.*
from employees inner join dept_emp on employees.emp_no=dept_emp.emp_no
inner join departments on departments.dept_no=dept_emp.dept_no

--p5

select * from employees 
where first_name='Hercules'
and last_name like 'b%'

--p6

select employees.*, dept_emp.*, departments.*
from employees inner join dept_emp on employees.emp_no=dept_emp.emp_no
inner join departments on departments.dept_no=dept_emp.dept_no
where departments.dept_name='Sales'

--p7

select employees.*, dept_emp.*, departments.*
from employees inner join dept_emp on employees.emp_no=dept_emp.emp_no
inner join departments on departments.dept_no=dept_emp.dept_no
where departments.dept_name in ('Sales', 'Development')

--p8

select last_name, count(emp_no) as cuenta
from employees
group by last_name
order by cuenta desc





