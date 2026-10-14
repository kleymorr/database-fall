CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Carol', 'carol@example.com'),
('David', 'david@example.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 250.00),
(1, '2024-02-15', 120.00),
(2, '2023-12-20', 80.00),
(3, '2024-03-05', 400.00),
(NULL, '2024-04-01', 150.00);

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o
ON c.customer_id = o.customer_id;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

INSERT INTO products (product_name, price) VALUES
('Laptop', 1000),
('Phone', 700),
('Keyboard', 100);

SELECT c.name, p.product_name
FROM customers c
CROSS JOIN products p;

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(4, 1, 1);

SELECT
    c.name,
    o.order_date,
    oi.quantity,
    p.product_name,
    p.price
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN order_items oi
ON o.order_id = oi.order_id
INNER JOIN products p
ON oi.product_id = p.product_id;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees(employee_id)
);

INSERT INTO employees (name, manager_id) VALUES
('Alice Manager', NULL);

INSERT INTO employees (name, manager_id) VALUES
('Bob', 1),
('Carol', 1),
('David', 1);

SELECT
    e1.name AS employee,
    e2.name AS manager
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.employee_id;

SELECT
    c.name,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
AND o.total_amount > 100;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100)
);

CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20)
);

INSERT INTO users (username) VALUES
('john'),
('alice');

INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
(1, 'John', 'Smith', '555-1000');

SELECT
    u.username,
    up.first_name,
    up.last_name,
    up.phone
FROM users u
LEFT JOIN user_profiles up
ON u.user_id = up.user_id;

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(author_id),
    title VARCHAR(150),
    publication_year INTEGER
);

INSERT INTO authors (author_name) VALUES
('George Orwell'),
('J. K. Rowling');

INSERT INTO books (author_id, title, publication_year) VALUES
(1, '1984', 1949),
(1, 'Animal Farm', 1945),
(2, 'Harry Potter', 1997);

SELECT
    a.author_name,
    b.title,
    b.publication_year
FROM authors a
INNER JOIN books b
ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments (
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    enrollment_date DATE,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO students (student_name) VALUES
('Alice'),
('Bob'),
('Carol');

INSERT INTO courses (course_name) VALUES
('Database'),
('Networks'),
('Programming');

INSERT INTO enrollments
(student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-09-01', 'A'),
(1, 2, '2024-09-01', 'B+'),
(2, 1, '2024-09-01', 'A-'),
(3, 3, '2024-09-01', NULL);

SELECT
    s.student_name,
    c.course_name,
    e.enrollment_date,
    e.grade
FROM students s
INNER JOIN enrollments e
ON s.student_id = e.student_id
INNER JOIN courses c
ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX idx_order_items_order_id
ON order_items(order_id);

CREATE INDEX idx_order_items_product_id
ON order_items(product_id);

SELECT c.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

\dt

DROP TABLE enrollments;
DROP TABLE courses;
DROP TABLE students;

DROP TABLE books;
DROP TABLE authors;

DROP TABLE user_profiles;
DROP TABLE users;

DROP TABLE employees;

DROP TABLE order_items;
DROP TABLE products;
DROP TABLE orders;
DROP TABLE customers;

\dt