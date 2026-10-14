CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');

INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Ainura', 'Toktomamatova', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');

SELECT * FROM Students;

UPDATE Students
SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek'
AND last_name = 'Sharshenov';

SELECT * FROM Students;

DELETE FROM Students
WHERE first_name = 'Gulzat'
AND last_name = 'Sultanova';

SELECT * FROM Students;

DELETE FROM Students
WHERE birth_date < '2002-01-01';

SELECT * FROM Students;

INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Nursultan', 'Isakov', '2002-04-10'),
('Meerim', 'Bekova', '2003-06-12'),
('Tilek', 'Uulu', '2001-11-05');

SELECT * FROM Students;

UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov');

SELECT * FROM Students;

DELETE FROM Students
WHERE student_id IN (2, 3, 5);

SELECT * FROM Students;

DROP TABLE Students;

\dt