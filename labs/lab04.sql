CREATE TABLE students (
    name VARCHAR(100),
    email VARCHAR(255) 
);  

INSERT INTO students (name, email)
VALUES
    ('Alymbek', 'alymbek@example.com'),
    ('Timur', 'timur@example.com'),
    ('Beka', 'beka@example.com');

SELECT * FROM students;

DROP TABLE students;

postgres=# CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255),
    faculty VARCHAR(100)
);

postgres=# INSERT INTO students (name, email, faculty)
VALUES
    ('Alymbek', 'alymbek@example.com', 'COMSEH'),
    ('Timur', 'timur@example.com', 'MED'),
    ('Beka', 'beka@example.com', 'MAT');

SELECT * FROM students;

postgres=# SELECT student_id, faculty FROM students;

postgres=# SELECT name, email FROM students WHERE name = 'Timur';

postgres=# select student_id, name, email from students order by student_id;

postgres=# select student_id, name, email from students order by student_id DESC;

postgres=# select name, email from students limit 2;

