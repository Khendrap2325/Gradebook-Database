DROP DATABASE IF EXISTS Gradebook;
CREATE DATABASE Gradebook;
USE Gradebook;

CREATE TABLE Professor (
     professor_id INT PRIMARY KEY,
     first_name VARCHAR(50),
     last_name VARCHAR(50),
     contact_info VARCHAR(50),
     office_location VARCHAR(50)
);

CREATE TABLE Courses (
	course_id INT PRIMARY KEY,
    professor_id INT,
    department VARCHAR(100),
    course_section INT,
    course_name VARCHAR(100),
    semester VARCHAR(25),
    year INT,
    FOREIGN KEY (professor_id) REFERENCES Professor (professor_id)
    );


CREATE TABLE Category (
     category_id INT PRIMARY KEY,
     category_name VARCHAR(100),
     weight_percent DECIMAL(10,2)
); 
CREATE TABLE Student (
      student_id INT PRIMARY KEY,
      first_name VARCHAR(50),
      last_name VARCHAR(50)
);
CREATE TABLE Assignment (
     assignment_id INT PRIMARY KEY,
     category_id INT,
     course_id INT,
     assignment_name VARCHAR(100),
     max_score INT,
     FOREIGN KEY (category_id) REFERENCES Category (category_id),
     FOREIGN KEY (course_id) REFERENCES Courses (course_id)
);


CREATE TABLE Grade (
grade_id INT PRIMARY KEY,
student_id INT,
assignment_id INT,
course_id INT,
student_score INT,
date DATE,
FOREIGN KEY (student_id) REFERENCES Student (student_id),
FOREIGN KEY (assignment_id) REFERENCES Assignment (assignment_id),
FOREIGN KEY (course_id) REFERENCES Courses (course_id)
);



INSERT INTO Professor
VALUES
(18571,'john', 'doe', "763-587-9999", "room 37"),
(18572,'mary', 'jane', "202-777-9489", "room 22"),
(18573,'monica', 'lewinsky', "404-697-3674", "room 1"),
(18574,'lana', 'del ray', "625-222-7548", "room 6");

INSERT INTO Student
VALUES
(259871,'steve', 'jobs'),
(259872,'ivy', 'Qee'),
(259873,'sam', 'smith'),
(259874,'victoria', 'paris');

INSERT INTO Category
VALUES
(1, 'Participation', 0.10),
(2, 'Homework', 0.20),
(3, 'Tests', 0.50),
(4, 'Project', 0.20);

INSERT INTO Courses(course_id,professor_id,department,course_section,course_name,semester,year)
VALUES
(808, 18571,'math', 1, 'linear algebra', 'fall', 2023),
(607, 18572,'english', 1, 'russian literature', 'fall', 2023),
(505, 18573, 'science', 1, 'astronomy', 'spring', 2024),
(304, 18574, 'math', 1, 'pre calculus', 'spring', 2024);

INSERT INTO Assignment(assignment_id, category_id, course_id, assignment_name, max_score)
VALUES

-- assignments in course_id = 808:
    (105, 1, 808, 'Exit ticket 1', 100),
    (112, 1, 808, 'Exit ticket 2', 100),
    (113, 1, 808, 'Exit ticket 3', 100),
    (101, 2, 808, 'Homework 1', 100),
	(106, 2, 808, 'Homework 1', 100),
	(110, 2, 808, 'Homework 2', 100),
	(111, 2, 808, 'Homework 3', 100),
    (108, 3, 808, 'Linear Test 1', 100),
    (109, 3, 808, 'Linear Test 2', 100),
    (114, 4, 808, 'Project 1', 100),
    
-- assignments in course_id = 304:
	(104, 3, 304, 'Theory Exam', 100),
	(107, 2, 304, 'Homework 1',100),
    
-- assignments in course_id = 607:
	(102, 3, 607, 'Test 3', 100),
    
-- assignments in course_id = 505:
	(103, 4, 505, 'Bison Project', 100);


INSERT INTO Grade (grade_id,student_id, assignment_id, course_id, student_score, date)
VALUES 

-- Assignments of student 1 (steve jobs):
	-- Linear Algebra
		(201, 259871, 101, 808, 65, '2024-04-15'),
	-- Pre-calculus
		(207, 259871, 107, 304, 86, '2024-04-15'),
        
-- Assignments of student 2 (ivy qee):
	-- Russian Literature
		(202, 259872, 102, 607, 75, '2024-04-15'),
	-- Linear Algebra
		(208, 259872, 110, 808, 100, '2024-04-15'),
		(209, 259872, 111, 808, 70, '2024-04-15'),
		(210, 259872, 108, 808, 89, '2024-04-15'),
		(211, 259872, 109, 808, 79, '2024-04-15'),
		(212, 259872, 114, 808, 100, '2024-04-15'),
        (215, 259872, 112, 808, 45, '2024-04-15'),
		(216, 259872, 113, 808, 32, '2024-04-15'),
        
-- Assignments of student 3 (sam smith):
	-- Astronomy
		(203, 259873, 103, 505, 85, '2024-04-15'),
        
-- Assignments of student 4 (victoria smith):
	-- Pre-calculus
		(204, 259874, 104, 304, 65, '2024-04-15'),
	-- Linear Algebra
		(205, 259874, 106, 808, 40, '2024-04-15'),
		(206, 259874, 105, 808, 67, '2024-04-15');


-- show the tables with the inserted contents;
SELECT *
FROM Professor;

SELECT *
FROM Courses;

SELECT *
FROM Category;

SELECT *
FROM Assignment;

SELECT *
FROM Student;

SELECT *
FROM Grade;

-- compute the average/highest/lowest score of an assignment


SELECT MAX(student_score) as max_score
FROM Grade as GR JOIN Assignment as A ON GR.assignment_id = A.assignment_id
WHERE assignment_name = 'Homework 1';

SELECT AVG(G.student_score) AS average_score
FROM Grade G
JOIN Assignment A ON G.assignment_id = A.assignment_id
WHERE A.assignment_name = 'Homework 1' -- Change 'Homework 1' to the desired assignment name
AND A.course_id = 808; -- Change 808 to the desired course_id


SELECT MIN(student_score) as min_score
FROM Grade as GR JOIN Assignment as A ON GR.assignment_id = A.assignment_id
WHERE assignment_name = 'Homework 1';

#List all the students of a given course
SELECT DISTINCT
	C.course_name, 
    GR.course_id, 
    GR.student_id, 
    ST.first_name, 
    ST.last_name
FROM Grade as GR JOIN Student as ST ON GR.student_id = ST.student_id
	JOIN Courses as C ON C.course_id = GR.course_id
WHERE GR.course_id = 808; 

-- List all students in given course and their scores for each assignment
SELECT
	ST.student_id,
    ST.first_name,
    ST.last_name,
    A.assignment_name,
    GR.student_score
FROM
	Grade AS GR
JOIN
	Student as ST ON GR.student_id = ST.student_id
JOIN 
	Assignment AS A ON GR.assignment_id = A.assignment_id
JOIN 
	Courses AS C ON GR.course_id = C.course_id
WHERE
	C.course_id = 808;
    
-- Add and assignment to a course
INSERT INTO Assignment(assignment_id, category_id, course_id, assignment_name, max_score)
VALUES
(115, 4, 607, 'Russian Essay', 100);
SELECT *
FROM Assignment;

SELECT 
    C.course_name,
    S.student_id,
    S.first_name,
    S.last_name,
    A.assignment_name,
    G.student_score
FROM 
    Grade G
JOIN 
    Student S ON G.student_id = S.student_id
JOIN 
    Courses C ON G.course_id = C.course_id
JOIN 
    Assignment A ON G.assignment_id = A.assignment_id
WHERE 
    C.course_id = 808;
    
-- Change the percentages of the categories for a course
UPDATE Category
SET weight_percent = 0.15
WHERE category_id= 1 ;

UPDATE Category
SET weight_percent = 0.25
WHERE category_id = 2;

UPDATE Category
SET weight_percent = 0.40
WHERE category_id= 3;

UPDATE Category
SET weight_percent = 0.20
WHERE category_id = 4;

SELECT * 
FROM Category;


-- Add 2 points to the score of each student on an assignment
UPDATE Grade
SET student_score = student_score + 2
WHERE grade_id = 201;

UPDATE Grade
SET student_score = student_score + 2
WHERE grade_id = 207;

UPDATE Grade
SET student_score = student_score + 2
WHERE grade_id = 203;

UPDATE Grade
SET student_score = student_score + 2
WHERE grade_id = 205;

SELECT *
FROM Grade;

-- Add 2 points to student with last name containing "Q"
UPDATE Grade as GR
JOIN Student as ST ON GR.student_id = ST.student_id JOIN Courses AS C ON C.course_id = GR.course_id
SET GR.student_score = GR.student_score + 2
WHERE ST.last_name ='Qee' AND GR.course_id = 808;

SELECT *
FROM Grade;
-- compute student grade

DELIMITER //
CREATE FUNCTION calc_category_score(student_id INT, course_id INT, category_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE total_pts_earned DECIMAL(10,2);
    DECLARE total_pts_avail DECIMAL(10,2);
    DECLARE category_score DECIMAL(10,2);

	-- Compute total points earned for category
	SELECT 
		SUM(GR.student_score) 
	INTO 
		total_pts_earned
	FROM
		Grade AS GR
	JOIN 
		Assignment AS A ON GR.assignment_id = A.assignment_id
		JOIN Student AS ST ON GR.student_id = ST.student_id
	WHERE
		GR.student_id = student_id AND GR.course_id = course_id AND A.category_id = category_id;
	
    -- compute total points available for category
    SELECT
		SUM(A.max_score) 
	INTO 
		total_pts_avail
	FROM 
		Assignment AS A
	JOIN 
		Grade AS GR ON GR.assignment_id = A.assignment_id
		JOIN Student AS ST ON GR.student_id = ST.student_id
	WHERE
		GR.student_id = student_id
		AND A.course_id = course_id
        AND A.category_id = category_id;
        
	-- compute category score
	IF total_pts_avail IS NOT NULL AND total_pts_avail > 0 THEN
		SET category_score = total_pts_earned / total_pts_avail;
	ELSE
		SET category_score = 0;
	END IF;
    
	-- apply category weight to category score
    IF category_id = 1 THEN -- category = participation
		SET category_score = category_score * (
			SELECT 
				weight_percent 
			FROM 
				Category AS C
            WHERE 
				C.category_id = 1);
                
	ELSEIF category_id = 2 THEN -- category = homework
		SET category_score = category_score * (
			SELECT 
				weight_percent 
			FROM 
				Category AS C
            WHERE 
				C.category_id = 2);
                
	ELSEIF category_id = 3 THEN -- category = tests
		SET category_score = category_score * (
			SELECT 
				weight_percent 
			FROM 
				Category AS C
            WHERE 
				C.category_id = 3);
                
	ELSEIF category_id = 4 THEN -- category = project
		SET category_score = category_score * (
			SELECT 
				weight_percent 
			FROM 
				Category AS C
            WHERE 
				C.category_id = 4);
	END IF;
    
	RETURN category_score; 
END //
DELIMITER ;

SELECT 
	ST.student_id,
	ST.first_name,
	ST.last_name,
    C.course_id,
	calc_category_score(ST.student_id, C.course_id, 1) AS part_score, 
	calc_category_score(ST.student_id, C.course_id, 2) AS homework_score,
	calc_category_score(ST.student_id, C.course_id, 3) AS test_score,
	calc_category_score(ST.student_id, C.course_id, 4) AS project_score,
	((calc_category_score(ST.student_id, C.course_id, 1) + 
	calc_category_score(ST.student_id, C.course_id, 2) + 
	calc_category_score(ST.student_id, C.course_id, 3) + 
	calc_category_score(ST.student_id, C.course_id, 4)) * 100) AS final_grade
FROM 
	Student AS ST,
    Courses AS C
ORDER BY ST.student_id;

DELIMITER //

CREATE FUNCTION calc_category_score_with_drop(student_id INT, course_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE final_grade DECIMAL(10,2);

    -- Subquery to identify the lowest score for the student across all assignments for the course
    SELECT MIN(G.student_score)
    INTO @lowest_score
    FROM Grade G
    INNER JOIN Assignment A ON G.assignment_id = A.assignment_id
    WHERE G.student_id = student_id AND A.course_id = course_id;

    -- Calculate the final grade after excluding the lowest score
    SELECT SUM(
        CASE 
            WHEN G.student_score = @lowest_score THEN 0
            ELSE G.student_score
        END * C.weight_percent / A.max_score) / SUM(C.weight_percent)
    INTO final_grade
    FROM Grade G
    INNER JOIN Assignment A ON G.assignment_id = A.assignment_id
    INNER JOIN Category C ON A.category_id = C.category_id
    WHERE G.student_id = student_id AND A.course_id = course_id;

    -- Return the final grade normalized to a 100-point scale
    RETURN (final_grade * 100);
END //

DELIMITER ;

SELECT 
    ST.student_id,
    ST.first_name,
    ST.last_name,
    C.course_id,
    calc_category_score_with_drop(ST.student_id, C.course_id) AS final_grade
FROM 
    Student AS ST,
    Courses AS C 
ORDER BY 
    ST.student_id;


