--Final SQL Lab and Homework
--Duration - 180 minutes
--
--In these practice questions you’ll return again to the omni_pool database, so re-establish your connection in DBeaver if it has lapsed.
--
--
--Submission
--
--When answering these questions, please save your SQL script in DBeaver, copy it over to your homework repo and then add, commit and push that for submission tonight. Please add section and question numbers as SQL comments, like so:
--
----MVP
----Q1
--
--
--1 MVP
--
--
--Question 1.
--Are there any pay_details records lacking both a local_account_no and iban number?
SELECT id 
FROM pay_details
WHERE 
	local_account_no IS NULL AND 
	iban IS NULL; 

--Question 2.
--Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).
SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY country ASC NULLS LAST, last_name ASC NULLS LAST ;


--Question 3.
--Find the details of the top ten highest paid employees in the corporation.
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;

--Question 4.
--Find the first_name, last_name and salary of the lowest paid employee in Hungary.
SELECT 
	first_name,
	last_name,
	salary 
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

--Question 5.
--Find all the details of any employees with a ‘yahoo’ email address?
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';

--Question 6.
--Obtain a count by department of the employees who started work with the corporation in 2003.
SELECT 
	department ,
	COUNT(id) AS joined_in_2003
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department
ORDER BY department ;

--Question 7.
--Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours.
--
--Hint
--You need to GROUP BY two columns here.
SELECT 
	department ,
	fte_hours ,
	COUNT(id) AS num_employees
FROM employees
GROUP BY department, fte_hours 
ORDER BY department ASC NULLS LAST, fte_hours ASC, num_employees;


--Question 8.
--Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme.
SELECT 
	pension_enrol ,
	COUNT(id)
FROM employees 
GROUP BY pension_enrol   ;
 

--Question 9.
--What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?
SELECT 
	MAX(salary) as max_salary
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1.0;


--Question 10.
--Get a table of country, number of employees in that country, and the average salary of employees in that country for any countries in which more than 30 employees are based. Order the table by average salary descending.
--
--
--Hints
--A HAVING clause is needed to filter using an aggregate function.
--
--You can pass a column alias to ORDER BY.
SELECT 
	country,
	COUNT(id) AS num_of_employees,
	ROUND(AVG(salary)) AS avg_salary
FROM employees
GROUP BY country 
HAVING COUNT(id) > 30
ORDER BY avg_salary DESC



--Question 11.
--Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.
SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_yearly_salary
FROM employees;


--Question 12.
--Find the first name and last name of all employees who lack a local_tax_code.

--Hint
--local_tax_code is a field in table pay_details, and first_name and last_name are fields in table employees, so this query requires some sort of JOIN!
SELECT 
	e.first_name,
	e.last_name,
	p.local_tax_code 
FROM employees AS e INNER JOIN pay_details AS p 
	ON e.id = p.id
WHERE p.local_tax_code IS NULL;


--Question 13.
--The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.

--Hints
--charge_cost is in teams, while salary and fte_hours are in employees, so a join will be necessary
--
--You will need to change the type of charge_cost in order to perform the calculation
SELECT 
	e.id,
	(48 * 35 * CAST(charge_cost AS INT4) - salary) * fte_hours AS expected_profit
FROM employees AS e INNER JOIN teams AS t 
	ON e.team_id = t.id;
--
--Question 14.
--Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.
SELECT 
	department,	
	COUNT(id) AS missing_first_name
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY missing_first_name DESC, department ASC;

--Question 15.
--[Bit Tougher] Return a table of those employee first_names shared by more than one employee, together with a count of the number of times each first_name occurs. Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.
SELECT 
	first_name,	
	COUNT(id) AS popular_first_name
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING COUNT(first_name) >= 2
ORDER BY COUNT(first_name) DESC, first_name ASC;

--Question 16.
--[Tough] Find the proportion of employees in each department who are grade 1.
--
--Hints
--Think of the desired proportion for a given department as the number of employees in that department who are grade 1, divided by the total number of employees in that department. 

SELECT 
	department,
	CAST(SUM(CAST(grade = 1 AS INT4))AS REAL) / COUNT(id) AS proportion_of_grade_1_employees
FROM employees 
GROUP BY department
ORDER BY department 

--You can write an expression in a SELECT statement, e.g. grade = 1. This would result in BOOLEAN values.
--
--
--If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. The CAST() function lets you convert data types.
--
--
--In SQL, an INTEGER divided by an INTEGER yields an INTEGER. To get a REAL value, you need to convert the top, bottom or both sides of the division to REAL.
--
--
--2 Extension
--Some of these problems may need you to do some online research on SQL statements we haven’t seen in the lessons up until now… Don’t worry, we’ll give you pointers, and it’s good practice looking up help and answers online, data analysts and programmers do this all the time! If you get stuck, it might also help to sketch out a rough version of the table you want on paper (the column headings and first few rows are usually enough).
--
--Note that some of these questions may be best answered using CTEs or window functions: have a look at the optional lesson included in today’s notes!
--
--Question 17.
--[Tough] Get a list of the id, first_name, last_name, department, salary and fte_hours of employees in the largest department. Add two extra columns showing the ratio of each employee’s salary to that department’s average salary, and each employee’s fte_hours to that department’s average fte_hours.
--
--
--[Extension - how could you generalise your query to be able to handle the fact that two or more departments may be tied in their counts of employees. In that case, we probably don’t want to arbitrarily return details for employees in just one of these departments].
--
--Hints
--Writing a CTE to calculate the name, average salary and average fte_hours of the largest department is an efficient way to do this.
--
--Another solution might involve combining a subquery with window functions.
--
--
--Question 18.
--Have a look again at your table for MVP question 8. It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status. This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a CASE statement?
--
--
--Hints
--COALESCE() lets you substitute a chosen value for NULLs in a column, e.g. COALESCE(text_column, 'unknown') would substitute 'unknown' for every NULL in text_column. The substituted value has to match the data type of the column otherwise PostgreSQL will return an error.
--
--CAST() let’s you change the data type of a column, e.g. CAST(boolean_column AS VARCHAR) will turn TRUE values in boolean_column into text 'true', FALSE to text 'false', and will leave NULLs as NULL
--
--
--Question 19.
--Find the first name, last name, email address and start date of all the employees who are members of the ‘Equality and Diversity’ committee. Order the member employees by their length of service in the company, longest first.
--
--
--
--Question 20.
--[Tough!] Use a CASE() operator to group employees who are members of committees into salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000). A NULL salary should lead to 'none' in salary_class. Count the number of committee members in each salary_class.
--
--
--Hints
--You likely want to count DISTINCT() employees in each salary_class
--
--You will need to GROUP BY salary_class