--------------------------------------------------------LAB - 5--------------------------------
----------------------------------Part – A:----------------------
--Create following table using query according to the definition.
create table Students(
StuID INT,
FirstName VARCHAR(25),
LastName VARCHAR(25),
Website VARCHAR(50),
City VARCHAR(25),
Address VARCHAR(100)
);


--Insert the following records in the STUDENT table.
 insert into Students(StuID,FirstName,LastName,Website,City,Address) values
 (1011,'Keyur', 'Patel', 'techonthenet.com','Rajkot', 'A-303,''Vasant Kunj'', Rajkot'),
(1022,'Hardik', 'Shah', 'digminecraft.com', 'Ahmedabad', '"Ram Krupa", Raiya Road'),
(1033,'Kajal', 'Trivedi', 'bigactivities.com', 'Baroda', 'Raj bhavan plot, near garden'),
(1044,'Bhoomi', 'Gajera', 'checkyourmath.com', 'Ahmedabad','"Jig''s Home", Narol'),
(1055,'Harmit', 'Mitel','@me.darshan.com', 'Rajkot', 'B-55, Raj Residency'),
(1066,'Ashok', 'Jani', NULL, 'Baroda', 'A502, Club House Building')

select * from Students


--From the above given tables perform the following queries (LIKE Operation):
--1. Display the name of students whose name starts with ‘k’.
	select FirstName from Students
	where FirstName like 'k%'
--2. Display the name of students whose name consists of five characters.
	select FirstName from Students
	where FirstName like '_____'
--3. Retrieve the first name & last name of students whose city name ends with a & contains six characters.
	select FirstName,LastName from Students
	where city like '_____a'
--4. Display all the students whose last name ends with ‘tel’.
	select * from Students
	where LastName like '%tel'
--5. Display all the students whose first name starts with ‘ha’ & ends with‘t’.
	select * from Students
	where FirstName like 'ha%t'
--6. Display all the students whose first name starts with ‘k’ and third character is ‘y’.
	select * from Students
	where FirstName like 'k_y%'
--7. Display the name of students having no website and name consists of five characters.
	select * from Students
	where website is null and FirstName like '_____'
--8. Display all the students whose last name consist of ‘jer’.
	select * from Students
	where LastName like '%jer%'
--9. Display all the students whose city name starts with either ‘r’ or ‘b’.
	select * from Students
	where city like '[rb]%'
--10. Display all the name students having websites.
	select * from Students
	where Website is not null
--11. Display all the students whose name starts from alphabet A to H.
	select * from Students
	where city like '[A-H]%'
--12. Display all the students whose name’s second character is vowel.
	select * from Students
	where city like '_[aeiou]%'
--13. Display the name of students having no website and name consists of minimum five characters.
	select * from Students
	where website is null and FirstName like '_____%'
--14. Display all the students whose last name starts with ‘Pat’.
	select * from Students
	where lastName like 'pat%'
--15. Display all the students whose city name does not starts with ‘b’.
	select * from Students
	where city not like 'b%'

---------------------------------Part – B:------------------------------------------------------

--1. Display all the students whose name starts from alphabet A or H.
	select * from Students
	where FirstName like '[AH]%'
--2. Display all the students whose name’s second character is vowel and of and start with H.
	select * from Students
	where FirstName like 'H[aeiou]%'
--3. Display all the students whose last name does not ends with ‘a’.
	select * from Students
	where LastName not like '%a'
--4. Display all the students whose first name starts with consonant.
	select * from Students
	where FirstName not like '[aeiou]%'
--5. Display all the students whose website contains .net
	select * from Students
	where website like '%.net%'

--Part – C:
--1. Display all the students whose address consist of -.
	select * from Students
	where Address  like '%-%'	
--2. Display all the students whose address contains single quote or double quote.
	select * from Students
	where Address  like '%''%' or Address  like '%"%'
--3. Display all the students whose website contains @.
	select * from Students
	where Website  like '%@%'
	select * from Students
--4. Display all the names those are either four or five characters.
	select * from Students
	where FirstName  like '%____%' or FirstName  like '%_____%'
