create table students(
	id serial primary key,
	name varchar(100),
	age int
);

INSERT INTO students (name, age) 
VALUES ('Alice', 21), ('Bob', 23); 

SELECT * FROM students;

DROP TABLE students;
