--Academic Management System
/* Design and develop an Academic Management System using SQL. The projects should involve three tables 1.StudentInfo 2. CoursesInfo 3.EnrollmentInfo. The Aim is to create a system that allows for managing student information and course enrollment. The project will include the following tasks: */

--Task 1 --Database Creation--
/* 
a) Create the StudentInfo table with columns STU_ ID, STU_NAME, DOB, PHONE_NO, EMAIL_ID,ADDRESS.
b) Create the CoursesInfo table with columns COURSE_ID, COURSE_NAME,COURSE_INSTRUCTOR NAME.
c) Create the EnrollmentInfo with columns ENROLLMENT_ID, STU_ ID, COURSE_ID,
ENROLL_STATUS(Enrolled/Not Enrolled). 
The FOREIGN KEY constraint in the EnrollmentInfo table references the STU_ID column in the StudentInfo table and the COURSE_ID column in the CoursesInfo table. */

create table StudentInfo (STU_ID INT PRIMARY KEY, STU_NAME Varchar(25), DOB DATE, PHONE_NO INT, EMAIL_ID Varchar(50), ADDRESS varchar(100));

create table CourseInfo (COURSE_ID INT Primary key, COURSE_NAME varchar(25), COURSE_INSTRUCTOR_NAME varchar(25));

create table EnrollmentInfo (ENROLLMENT_ID varchar(25) Primary key, STU_ID INT, COURSE_ID INT, ENROLL_STATUS varchar(25) CHECK (ENROLL_STATUS IN ('Enrolled','Not Enrolled')) NOT NULL,
FOREIGN KEY (STU_ID) references StudentInfo(STU_ID),
FOREIGN KEY (COURSE_ID) references CourseInfo(COURSE_ID));

--Changing phone number (Studentinfo table) from int to bigint as value exceeds--
ALTER TABLE StudentInfo
ALTER COLUMN PHONE_NO BIGINT;

--disabling ENROLLMENT_ID from being a primary key in EnrollmentInfo since duplicate enrollment id cannot be inserted--
ALTER TABLE EnrollmentInfo DROP CONSTRAINT PK__Enrollme__A7418A1A2F9D23C9;

--Task 2 --Data Creation--
/*
Insert some sample data for StudentInfo table , CoursesInfo table, EnrollmentInfo with respective fields */

Insert into StudentInfo (STU_ID,STU_NAME,DOB,PHONE_NO,EMAIL_ID,ADDRESS) 
Values 
(1, 'Hannah', '2020-04-22', '9876543297', 'beauty@gmail.com', 'first cross street, Sydney'),
(2, 'Joannah', '2022-06-06', '9876543298', 'cutie@gmail.com', 'second cross street, Delhi'),
(3, 'Johans', '2024-01-03', '9876543299', 'hanny@gmail.com', 'third cross street, Oslo'),
(4, 'Janez', '2020-04-22', '9876543300', 'janez@gmail.com', 'fourth cross street, Bethlahem'),
(5, 'Giannah', '2020-04-22', '9876543301', 'gia@gmail.com', 'fifth cross street, Dubai');


Insert into CourseInfo (COURSE_ID,COURSE_NAME,COURSE_INSTRUCTOR_NAME)
Values 
(301, 'Swimming', 'Isaac'),
(302, 'Cooking', 'Mary'),
(303, 'Sewing', 'Suganthi'),
(304, 'Gardening', 'Malliga');

Insert into EnrollmentInfo (ENROLLMENT_ID,STU_ID,COURSE_ID,ENROLL_STATUS)
Values
('DA1', '1', '304', 'Enrolled'),
('DA2', '2', '301', 'Enrolled'),
('DA3', '4', '303', 'Enrolled'),
('DA4', '5', '304', 'Enrolled'),
('DA5', '3', '302', 'Enrolled'),
('DA5', '3', '301', 'Enrolled');



--Task 3 --Retrieve the Student Information--
/*
a) Write a query to retrieve student details, such as student name, contact informations, and Enrollment status */

select 
s.STU_NAME as Student_Name,
s.PHONE_NO as Phone_Number,
s.EMAIL_ID as Email_id,
s.ADDRESS as Address,
e.ENROLL_STATUS as Enrollment_status,
c.COURSE_NAME as Course_Name
From StudentInfo s
Join EnrollmentInfo e ON s.STU_ID=e.STU_ID
Join CourseInfo c ON e.COURSE_ID=c.COURSE_ID;

/* b) Write a query to retrieve a list of courses in which a specific student is enrolled */

select 
s.STU_NAME as Student_Name,
c.COURSE_NAME as Course_Name
From CourseInfo c 
Join EnrollmentInfo e on c.COURSE_ID=e.COURSE_ID
Join StudentInfo s on s.STU_ID=e.STU_ID
where s.STU_NAME = 'Johans';

/* c) Write a query to retrieve course information, including course name, instructor information. */

Select COURSE_NAME, COURSE_INSTRUCTOR_NAME as Instructor_Name
from CourseInfo;

/*d) Write a query to retrieve course information for a specific course. */

select COURSE_NAME, COURSE_ID, COURSE_INSTRUCTOR_NAME as Instructor_Name from CourseInfo
where COURSE_NAME='Swimming';

/*e) Write a query to retrieve course information for multiple courses. */

select COURSE_NAME, COURSE_ID, COURSE_INSTRUCTOR_NAME as Instructor_Name from CourseInfo;

/* f) Test the queries to ensure accurate retrieval of student information. ( execute the queries and verify the results against the expected output.) */

select * from StudentInfo
where STU_NAME IN ('Johans', 'Janez');  -- Sample testing with IN operator.

select * from StudentInfo
where STU_NAME = 'Hannah' OR STU_NAME = 'Joannah';   -- Sample testing with OR operator.

--Task 4 --4. Reporting and Analytics (Using joining queries) --
/* a) Write a query to retrieve the number of students enrolled in each course */

Select c.COURSE_NAME, COUNT(s.STU_NAME) AS Student_Count
FROM
StudentInfo s
JOIN EnrollmentInfo e on s.STU_ID = e.STU_ID
Join CourseInfo c on c.COURSE_ID = e.COURSE_ID
WHERE
e.ENROLL_STATUS = 'Enrolled'
Group by c.COURSE_NAME;

/* b) Write a query to retrieve the list of students enrolled in a specific course  */

Select s.STU_NAME as Students_Enrolled_In_Swimming
FROM StudentInfo s
JOIN EnrollmentInfo e on s.STU_ID = e.STU_ID
Join CourseInfo c on c.COURSE_ID = e.COURSE_ID
WHERE
e.ENROLL_STATUS = 'Enrolled' and e.COURSE_ID = '301';

/* c) Write a query to retrieve the count of enrolled students for each instructor.  */

Select c.COURSE_INSTRUCTOR_NAME, count(s.STU_NAME) as Students_Enrolled
from StudentInfo s
JOIN EnrollmentInfo e on s.STU_ID = e.STU_ID
join CourseInfo c on e.COURSE_ID = c.COURSE_ID
where e.ENROLL_STATUS = 'Enrolled'
Group by c.COURSE_INSTRUCTOR_NAME;

/* d) Write a query to retrieve the list of students who are enrolled in multiple courses */

select s.STU_NAME as Students_Enrolled_In_Multiple_Courses
from CourseInfo c
JOIN EnrollmentInfo e on c.COURSE_ID = e.COURSE_ID
JOIN StudentInfo s on s.STU_ID = e.STU_ID
where ENROLL_STATUS = 'Enrolled'
GROUP BY s.STU_NAME
Having count(*) > 1;

/* e) Write a query to retrieve the courses that have the highest number of enrolled students (arranging from highest to lowest) */

Select c.COURSE_NAME, Count(s.STU_NAME) as Enrolled_Students_Count
FROM CourseInfo c
Join EnrollmentInfo e on c.COURSE_ID = e.COURSE_ID
JOIN StudentInfo s on s.STU_ID = e.STU_ID
where ENROLL_STATUS = 'Enrolled'
group by c.COURSE_NAME
order by Enrolled_Students_Count DESC;

select * FROM StudentInfo;
select * FROM CourseInfo;
select * FROM EnrollmentInfo;