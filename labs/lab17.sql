CREATE DATABASE lab17_demo;

\c lab17_demo

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO products (product_name, price) VALUES
('Laptop', 999.99),
('Mouse', 25.99),
('Keyboard', 79.99);

INSERT INTO employees
(first_name, last_name, email, department) VALUES
('Alice', 'Johnson', 'alice@example.com', 'IT'),
('Bob', 'Smith', 'bob@example.com', 'Sales'),
('Carol', 'Brown', 'carol@example.com', 'IT');

INSERT INTO customers (name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Bob Wilson', 'bob@example.com');

COPY products
TO '/tmp/lab17_products.csv'
WITH CSV HEADER;

\! cat /tmp/lab17_products.csv

TRUNCATE TABLE products RESTART IDENTITY;

SELECT * FROM products;

COPY products
FROM '/tmp/lab17_products.csv'
WITH CSV HEADER;

SELECT * FROM products;

COPY employees
TO '/tmp/lab17_employees.txt'
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;

\! cat /tmp/lab17_employees.txt

COPY (
    SELECT *
    FROM employees
    WHERE department = 'IT'
)
TO '/tmp/lab17_it_employees.csv'
WITH CSV HEADER;

\! cat /tmp/lab17_it_employees.csv

COPY customers
TO '/tmp/lab17_customers.csv'
WITH CSV HEADER
DELIMITER ';'
QUOTE '"';

\! cat /tmp/lab17_customers.csv

\! pg_dump -h localhost -p 5432 -U erbolmederbekuulu -d lab17_demo -Fc -f /tmp/lab17_backup.dump

\! pg_restore --list /tmp/lab17_backup.dump

\! pg_dump -h localhost -p 5432 -U erbolmederbekuulu -d lab17_demo -s -f /tmp/lab17_schema.sql

\! pg_dump -h localhost -p 5432 -U erbolmederbekuulu -d lab17_demo -a -f /tmp/lab17_data.sql

CREATE DATABASE lab17_restore;

\! pg_restore -h localhost -p 5432 -U erbolmederbekuulu -d lab17_restore /tmp/lab17_backup.dump

\c lab17_restore

\dt

SELECT * FROM products;

SELECT * FROM employees;

SELECT * FROM customers;

\c lab17_demo

CREATE TABLE staging_customers
AS
SELECT *
FROM customers
WHERE 1 = 0;

COPY (
    SELECT *
    FROM customers
    LIMIT 10000 OFFSET 0
)
TO '/tmp/lab17_customers_batch.csv'
WITH CSV HEADER;

COPY staging_customers
FROM '/tmp/lab17_customers_batch.csv'
WITH CSV HEADER;

SELECT * FROM staging_customers;

\dt

\c postgres

DROP DATABASE lab17_restore;

DROP DATABASE lab17_demo;

\! rm -f /tmp/lab17_products.csv /tmp/lab17_employees.txt /tmp/lab17_it_employees.csv /tmp/lab17_customers.csv /tmp/lab17_customers_batch.csv /tmp/lab17_backup.dump /tmp/lab17_schema.sql /tmp/lab17_data.sql

\l