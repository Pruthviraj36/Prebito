DROP TABLE STUDENT_DATA
create table STUDENT_DATA(
	NUM int,
	AName varchar(55),
	City varchar(55), 
	DID int
)

INSERT INTO STUDENT_DATA VALUES
(101, 'Raju', 'Rajkot', 10),
(102, 'Amit', 'Ahmedabad', 20),
(103, 'Sanjay', 'Baroda', 40),
(104, 'Neha', 'Rajkot', 20),
(105, 'Meera', 'Ahmedabad', 30),
(106, 'Mahesh', 'Baroda', 10)

--Part – A:
--1. Display details of students who are from computer department.
SELECT 
--2. Displays name of students whose SPI is more than 8.
--3. Display details of students of computer department who belongs to Rajkot city.
--4. Find total number of students of electrical department.
--5. Display name of student who is having maximum SPI.
--6. Display details of students having more than 1 backlog.