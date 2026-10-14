CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner_name VARCHAR(100),
    balance DECIMAL(10,2)
);

INSERT INTO accounts (owner_name, balance) VALUES
('Alice', 2000.00),
('Bob', 1000.00);

SELECT * FROM accounts;

BEGIN;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;

COMMIT;

SELECT * FROM accounts;

BEGIN;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;

SELECT * FROM accounts;

ROLLBACK;

SELECT * FROM accounts;

BEGIN;

SELECT balance
FROM accounts
WHERE account_id = 1;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;

COMMIT;

SELECT * FROM accounts;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    total DECIMAL(10,2)
);

CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    stock INTEGER
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES inventory(product_id),
    quantity INTEGER
);

INSERT INTO customers (name, email)
VALUES ('Main Customer', 'main@example.com');

INSERT INTO inventory (product_id, product_name, stock)
VALUES (101, 'Laptop', 10);

BEGIN;

INSERT INTO orders (customer_id, total)
VALUES (1, 250.00);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_order_id_seq'), 101, 2);

UPDATE inventory
SET stock = stock - 2
WHERE product_id = 101;

COMMIT;

SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM inventory;

BEGIN;

INSERT INTO customers (name, email)
VALUES ('John Doe', 'john@email.com');

INSERT INTO orders (customer_id, total)
VALUES (currval('customers_customer_id_seq'), 100.00);

COMMIT;

SELECT * FROM customers;
SELECT * FROM orders;

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM accounts;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM accounts
WHERE balance > 1000;

SELECT *
FROM accounts
WHERE balance > 1000;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT *
FROM accounts
WHERE balance > 1000;

SELECT *
FROM accounts
WHERE balance > 1000;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * FROM accounts;

UPDATE accounts
SET balance = balance * 1.05;

COMMIT;

SELECT * FROM accounts;

BEGIN;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM accounts;

COMMIT;

BEGIN;

INSERT INTO customers (name, email)
VALUES ('Alice Savepoint', 'alice@email.com');

SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total)
VALUES (currval('customers_customer_id_seq'), 500.00);

ROLLBACK TO SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total)
VALUES (currval('customers_customer_id_seq'), 300.00);

COMMIT;

SELECT * FROM customers;
SELECT * FROM orders;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2) CHECK (price >= 0)
);

BEGIN;

INSERT INTO products (name, price)
VALUES ('Laptop', 999.99);

SAVEPOINT sp1;

INSERT INTO products (name, price)
VALUES ('Mouse', 25.99);

SAVEPOINT sp2;

INSERT INTO products (name, price)
VALUES ('Invalid Product', -50.00);

ROLLBACK TO SAVEPOINT sp2;

INSERT INTO products (name, price)
VALUES ('Keyboard', 79.99);

COMMIT;

SELECT * FROM products;

CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    message TEXT
);

BEGIN;

INSERT INTO logs (message)
VALUES ('Starting process');

SAVEPOINT process_start;

INSERT INTO logs (message)
VALUES ('Process completed');

RELEASE SAVEPOINT process_start;

COMMIT;

SELECT * FROM logs;

SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

\dt

DROP TABLE order_items;
DROP TABLE orders;
DROP TABLE inventory;
DROP TABLE customers;

DROP TABLE products;
DROP TABLE logs;
DROP TABLE accounts;

\dt