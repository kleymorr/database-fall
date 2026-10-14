CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    manager_id INTEGER,
    tenure INTEGER
);

INSERT INTO employees
(first_name, last_name, department, salary, manager_id, tenure)
VALUES
('Alice', 'Johnson', 'Engineering', 120000, NULL, 10),
('Bob', 'Smith', 'Engineering', 80000, 1, 7),
('Carol', 'Davis', 'Engineering', 70000, 1, 4),
('David', 'Brown', 'Sales', 65000, NULL, 8),
('Eva', 'Wilson', 'Sales', 90000, 4, 6),
('Frank', 'Miller', 'Marketing', 55000, NULL, 3);

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_id INTEGER,
    amount DECIMAL(12,2),
    product_name VARCHAR(100),
    status VARCHAR(50)
);

INSERT INTO orders (region_id, amount, product_name, status) VALUES
(1, 700000, 'Laptop', 'High Priority'),
(1, 500000, 'Phone', 'Medium Priority'),
(2, 400000, 'Keyboard', 'Low Priority'),
(2, 350000, 'Monitor', 'High Priority'),
(3, 1500000, 'Tablet', 'Medium Priority');

WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;

WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc
        ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;

CREATE TABLE warehouse_1 (
    product_id INTEGER,
    product_name VARCHAR(100),
    quantity INTEGER
);

CREATE TABLE warehouse_2 (
    product_id INTEGER,
    product_name VARCHAR(100),
    quantity INTEGER
);

INSERT INTO warehouse_1 VALUES
(1, 'Laptop', 5),
(2, 'Phone', 0),
(3, 'Keyboard', 0),
(4, 'Monitor', 10);

INSERT INTO warehouse_2 VALUES
(2, 'Phone', 0),
(3, 'Keyboard', 0),
(5, 'Tablet', 7),
(6, 'Mouse', 15);

SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;

SELECT product_name FROM warehouse_1
UNION ALL
SELECT product_name FROM warehouse_2;

SELECT product_id
FROM warehouse_1
WHERE quantity = 0
INTERSECT
SELECT product_id
FROM warehouse_2
WHERE quantity = 0;

SELECT product_name
FROM warehouse_1
EXCEPT
SELECT product_name
FROM warehouse_2;

SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dept_salary_rank
FROM employees;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year INTEGER,
    sales_amount DECIMAL(10,2)
);

INSERT INTO sales (product_name, year, sales_amount) VALUES
('Laptop', 2022, 10000),
('Laptop', 2023, 15000),
('Laptop', 2024, 20000),
('Phone', 2022, 8000),
('Phone', 2023, 12000),
('Phone', 2024, 18000),
('Tablet', 2022, 5000),
('Tablet', 2023, 7000),
('Tablet', 2024, 9000);

SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;

CREATE TABLE pivoted_sales AS
SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;

SELECT product_name, '2022' AS year, year_2022 AS sales_amount
FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount
FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount
FROM pivoted_sales
ORDER BY product_name, year;

SELECT
    employee_id,
    SUM(salary) OVER (
        PARTITION BY department
    ) AS total_dept_salary,
    AVG(salary) FILTER (
        WHERE tenure > 5
    ) OVER () AS avg_salary_senior
FROM employees;

SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;

EXPLAIN
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 70000;

EXPLAIN ANALYZE
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 70000;

CREATE INDEX idx_employees_salary
ON employees(salary);

\dt

DROP TABLE pivoted_sales;
DROP TABLE sales;

DROP TABLE warehouse_1;
DROP TABLE warehouse_2;

DROP TABLE orders;

DROP TABLE employees;

\dt