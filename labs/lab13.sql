CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    email VARCHAR(100),
    age INTEGER,
    hire_date DATE,
    experience_years INTEGER,
    bonus DECIMAL(10,2)
);

INSERT INTO employees
(first_name, last_name, department, salary, email, age, hire_date, experience_years, bonus)
VALUES
('Alice', 'Johnson', 'Engineering', 120000, 'alice@example.com', 28, '2024-02-10', 6, 10000),
('Bob', 'Smith', 'Engineering', 80000, 'bob@example.com', 35, '2022-05-15', 8, NULL),
('Carol', 'Davis', 'Engineering', 70000, NULL, 42, '2023-07-20', 10, 5000),
('David', 'Brown', 'Engineering', 65000, 'david@example.com', 25, '2024-08-01', 3, NULL),
('Eva', 'Wilson', 'Engineering', 90000, 'eva@example.com', 52, '2021-03-10', 15, 8000),
('Frank', 'Miller', 'Engineering', 55000, 'frank@example.com', 31, '2025-01-05', 4, 3000),
('Grace', 'Lee', 'Sales', 60000, 'grace@example.com', 29, '2023-01-15', 5, NULL),
('Henry', 'King', 'Sales', 75000, NULL, 45, '2022-09-30', 12, 4000),
('Irene', 'White', 'Marketing', 50000, 'irene@example.com', 54, '2024-04-12', 20, NULL);

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT COUNT(email) AS employees_with_email
FROM employees;

SELECT COUNT(DISTINCT department) AS unique_departments
FROM employees;

SELECT SUM(salary) AS total_salaries
FROM employees;

SELECT AVG(salary) AS average_salary
FROM employees;

SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;

SELECT department, AVG(age) AS avg_age
FROM employees
GROUP BY department;

SELECT department, MAX(hire_date) AS latest_hire
FROM employees
GROUP BY department;

CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    department VARCHAR(100),
    sales_amount DECIMAL(10,2)
);

INSERT INTO sales_data (department, sales_amount) VALUES
('Engineering', 10000),
('Engineering', 15000),
('Sales', 20000),
('Sales', 12000),
('Marketing', 8000);

SELECT department, SUM(sales_amount) AS total_sales
FROM sales_data
GROUP BY department;

SELECT department,
       STRING_AGG(first_name, ', ') AS employee_names
FROM employees
GROUP BY department;

CREATE TABLE employee_skills (
    employee_id INTEGER,
    skill_name VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO employee_skills VALUES
(1, 'PostgreSQL'),
(1, 'Python'),
(1, 'Docker'),
(2, 'Java'),
(2, 'SQL'),
(3, 'Excel'),
(3, 'Power BI');

SELECT employee_id,
       STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills
GROUP BY employee_id;

SELECT department,
       ARRAY_AGG(salary) AS salary_array
FROM employees
GROUP BY department;

SELECT department,
       ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees
GROUP BY department;

SELECT
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

SELECT CORR(experience_years, salary)
       AS experience_salary_correlation
FROM employees;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1000),
('Phone', 'Electronics', 700),
('Keyboard', 'Electronics', 100),
('Desk', 'Furniture', 400),
('Chair', 'Furniture', 200);

SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products
GROUP BY category;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO sales (sale_date, amount) VALUES
('2024-01-15', 1000),
('2024-02-20', 1500),
('2024-04-10', 2000),
('2024-07-05', 2500),
('2025-01-12', 3000),
('2025-05-18', 3500);

SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales
GROUP BY
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    rating DECIMAL(2,1),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO product_reviews (product_id, rating) VALUES
(1, 5.0),
(1, 4.5),
(1, 4.0),
(1, 5.0),
(1, 4.5),
(1, 4.5),
(1, 5.0),
(1, 4.0),
(1, 4.5),
(1, 5.0),

(2, 3.0),
(2, 4.0),
(2, 3.5),
(2, 4.0),
(2, 3.5),
(2, 4.0),
(2, 3.0),
(2, 4.0),
(2, 3.5),
(2, 4.0);

SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING AVG(rating) > 4.0
AND COUNT(*) >= 10;

SELECT department,
       AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department;

SELECT
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS dept_avg_salary
FROM employees;

SELECT
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees;

SELECT
    SUM(bonus) AS total_bonus,
    AVG(bonus) AS avg_bonus,
    COUNT(bonus) AS employees_with_bonus
FROM employees;

SELECT
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_std_dev
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;

SELECT
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT /
    (SELECT COUNT(*) FROM employees) * 100 AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;

DROP TABLE product_reviews;
DROP TABLE employee_skills;
DROP TABLE sales_data;
DROP TABLE sales;
DROP TABLE products;
DROP TABLE employees;

\dt