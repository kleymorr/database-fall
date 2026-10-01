postgres=# CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

postgres=# DROP TABLE test_table;

postgres=# DROP TABLE IF EXISTS test_table;

postgres=# alter table students 
postgres-# add column date_of_birth date;

postgres=# alter table students
postgres-# drop column faculty;

postgres=# alter table students
postgres-# alter column first_name type text;

postgres=# alter table students
postgres-# add constraint unique_student_email unique (email);

postgres=# alter table students
postgres-# rename column email to email_address;

postgres=# alter table students
postgres-# rename to uni_students;

postgres=# CREATE TEMP TABLE test_version (
    id serial,     
    name varchar(100)
);

postgres=# drop table uni_students;