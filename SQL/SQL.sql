SELECT  distinct  first_name, gender
FROM parks_and_recreation.employee_demographics; 

#Where Clause
select *
from employee_salary
where first_name = "Leslie";

SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'male';

SELECT *
FROM employee_demographics
Where (first_name = 'leslie' AND age = 44) OR age > 55;

-- Like Statement
-- % and _
SELECT *
FROM employee_demographics
Where birth_date like '1989%';

-- Group By and Order By clause
SELECT gender, avg(age), max(age), min(age), count(age)
FROM employee_demographics
group by gender; 

-- Order by
select *
from employee_demographics
order by gender, age;

-- having vs where clause
SELECT gender, avg(age)
FROM employee_demographics
group by gender
having avg(age) > 40; 

select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary);

-- limit
select *
from employee_demographics
order by age desc
limit 2, 1;

-- Aliasing
select gender
from employee_demographics
group by gender
having avg_age > 40;

-- inner joins and outer joins
select dem.employee_id, age, occupation
from employee_demographics AS dem
inner join employee_salary as sal
     on dem.employee_id = sal.employee_id;

-- Outer Join     
select *
from employee_demographics AS dem
right join employee_salary as sal
     on dem.employee_id = sal.employee_id;

-- Self join
Select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_name,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary emp1
join employee_salary emp2
	on emp1.employee_id + 1 = emp2.employee_id
;

-- joining multiple tables
select *
from employee_demographics AS dem
inner join employee_salary as sal
     on dem.employee_id = sal.employee_id
inner join parks_departments pd
	on sal.dept_id = pd.department_id
;

select *
from parks_departments
;

-- Unions - allows you to combine rows of data from separate tables
select  first_name, last_name
from employee_demographics
union all
select first_name, last_name
from employee_salary
;


select  first_name, last_name, 'old man' as label
from employee_demographics
where age > 40 and gender = 'male'
union
select  first_name, last_name, 'old lady' as label
from employee_demographics
where age > 40 and gender = 'female'
union
select  first_name, last_name, 'high earner' as label
from employee_salary
where salary > 70000
order by first_name, last_name
;

-- String Functions

select length('skyfall');

select first_name, length(first_name)
from employee_demographics
order by 2
;

select upper('sky');
select lower('sky');

select first_name, upper(first_name), lower(last_name)
from employee_demographics
;

select rtrim('               sky                  ');

-- Substring
select first_name, 
left(first_name, 4),
right(first_name, 4),
substring(first_name, 3, 2),
birth_date,
substring(birth_date, 6, 2) as birth_month
from employee_demographics
;

select first_name, replace(first_name, 'a', 'z')
from employee_demographics
;

select locate('x', 'alexander');

-- Concatenation
select first_name, last_name,
concat(first_name, ' ', last_name)
from employee_demographics
;

-- Case statements
select first_name, last_name, 
case
	when age <= 30 then 'young'
    when age between 31 and 50 then 'old'
    when age >= 50 then "on death's door"
end as Age_bracket
from employee_demographics
;

-- Pay increase and bonuss
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus

select first_name, last_name, salary,
case
	when salary < 50000 then salary + 1.05
    when salary > 50000 then salary + 1.07
end as new_salary
from employee_salary;

select first_name, last_name, salary,
case
	when salary < 50000 then salary * 1.05
    when salary > 50000 then salary * 1.07
end as new_salary,
case
	when dept_id = 6 then salary * .10
end as bonus
from employee_salary;

-- Subqueries
select *
from employee_demographics
where employee_id in
				(select employee_id
					from employee_salary
                     where dept_id = 1)
;

select first_name, salary,
(select avg(salary)
from employee_salary)
from employee_salary;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender;

select *
from (select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender) as agg_table;

-- Window functions

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id;
    
select dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as dense_rank_num
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id;