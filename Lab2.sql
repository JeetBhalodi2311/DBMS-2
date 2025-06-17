CREATE TABLE Department ( 
DepartmentID INT PRIMARY KEY, 
DepartmentName VARCHAR(100) NOT NULL UNIQUE 
); 


CREATE TABLE Designation ( 
DesignationID INT PRIMARY KEY, 
DesignationName VARCHAR(100) NOT NULL UNIQUE 
); 


CREATE TABLE Person ( 
PersonID INT PRIMARY KEY IDENTITY(101,1), 
FirstName VARCHAR(100) NOT NULL, 
LastName VARCHAR(100) NOT NULL, 
Salary DECIMAL(8, 2) NOT NULL, 
JoiningDate DATETIME NOT NULL, 
DepartmentID INT NULL, 
DesignationID INT NULL, 
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID), 
FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID) 
); 

--PART-A

--1
--INSERT
CREATE OR ALTER PROCEDURE PR_INSERT_DEPARTMENT
@ID INT,
@NAME VARCHAR(50)
AS 
BEGIN
	INSERT INTO Department VALUES(@ID,@NAME)
END

PR_INSERT_DEPARTMENT 1,'ADMIN'
PR_INSERT_DEPARTMENT 2,'IT'
PR_INSERT_DEPARTMENT 3,'HR'
PR_INSERT_DEPARTMENT 4,'ACCOUNT'

SELECT *FROM Department
----------------------------------------------------
CREATE OR ALTER PROCEDURE PR_DESIGNATION
@ID INT,
@NAME VARCHAR(50)
AS
BEGIN
	INSERT INTO Designation VALUES(@ID,@NAME)
END

PR_DESIGNATION 11,'JOBBER'
PR_DESIGNATION 12, 'WELDER'
PR_DESIGNATION 13,'CLERK'
PR_DESIGNATION 14,'MANAGER'
PR_DESIGNATION 15,'CEO'

SELECT * FROM Designation
-----------------------------------------------------
CREATE OR ALTER PROCEDURE PR_PERSON
@FNAME VARCHAR(100),
@LNAME VARCHAR(100),
@SAL DECIMAL(8,2),
@DATE DATETIME,
@DID INT=NULL ,
@DESID INT=NULL
AS
BEGIN
	INSERT INTO Person VALUES(@FNAME,@LNAME,@SAL,@DATE,@DID,@DESID)
END

PR_PERSON 'RAHUL','ANSHU',56000,'01-01-1990',1,12
PR_PERSON 'HARDIK','HINSU',18000,'1990-09-25',2,11
PR_PERSON 'BHAVIN','KAMANI',25000,'1991-05-14',NULL,11
PR_PERSON 'BHOOMI','PATEL',39000,'2014-02-12',1,13
PR_PERSON 'ROHIT','RAJGOR',17000,'1990-07-23',2,15
PR_PERSON 'PRIYA','MEHTA',25000,'1990-10-18',2,NULL
PR_PERSON 'NEHA','TRIVEDI',18000,'2014-02-20',3,15

SELECT * FROM Person
---------------------------------------------------------------

--DELETE
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DELETE
@ID INT
AS
BEGIN
	DELETE FROM DEPARTMENT
	WHERE DepartmentID = @ID
END

PR_DEPARTMENT_DELETE 4
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_DESIGNATION_DELETE
@ID INT
AS
BEGIN
	DELETE FROM Designation
	WHERE DesignationID = @ID
END

PR_DESIGNATION_DELETE 15
-----------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_PERSON_DELETE
@ID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PERSONID = @ID
END

PR_PERSON_DELETE 107
-----------------------------------------------------------------

--UPDATE
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_UPDATE
	@ID INT,
	@NAME VARCHAR(50)
AS
BEGIN
	UPDATE DEPARTMENT
	SET DepartmentName = @NAME
	WHERE DepartmentID = @ID
END

PR_DEPARTMENT_UPDATE 3,'CSE'
-----------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_Designation_UPDATE
	@ID INT,
	@NAME VARCHAR(50)
AS
BEGIN
	UPDATE Designation
	SET DesignationNAME = @NAME
	WHERE DesignationID = @ID
END

PR_Designation_UPDATE 15,'SETH'
-----------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_PERSON_UPDATE
	@ID INT,
	@FNAME VARCHAR(50),
	@LNAME VARCHAR(50),
	@SAL INT,
	@DATE DATETIME(50),
	@DID INT,
	@DISID INT
AS
BEGIN
	UPDATE PERSON
	SET 
		FIRSTNAME = @FNAME,
		LASTNAME = @LNAME,
		SALARY = @SAL,
		JoiningDate = @DATE,
		DepartmentID = @DID,
		DesignationID = @DISID
	WHERE PERSONID = @ID
END

PR_PERSON_UPDATE 101,'JEET','ANSHU',56000,'01-01-1990',1,12
PR_PERSON_UPDATE 101,'JEET','BHALODI',56000,'01-01-1990',1,12
PR_PERSON_UPDATE 101,'JEET','BHALODI',96000,'01-01-1990',1,12
PR_PERSON_UPDATE 104,'BHAVY','PATEL',39000,'2014-02-12',1,13
PR_PERSON_UPDATE 105,'BHAVY','PATEL',39000,'2014-02-12',1,13
PR_PERSON_UPDATE 106,'ABC','BHALODI',4000,'2014-02-12',1,13
-----------------------------------------------------------------

--2
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_PK
@ID INT
AS
BEGIN
	SELECT * FROM DEPARTMENT
	WHERE DepartmentID = @id
END

PR_DEPARTMENT_PK 1
------------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_Designation_PK
@ID INT
AS
BEGIN
	SELECT * FROM Designation
	WHERE DesignationID = @id
END

PR_Designation_PK 15
------------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_PERSON_PK
@ID INT
AS
BEGIN
	SELECT * FROM PERSON
	WHERE PERSONID = @id
END

PR_PERSON_PK 101
------------------------------------------------------------------
--3
CREATE OR ALTER PROCEDURE PR_FK_PERSON_DEPARTMENT
AS
BEGIN
	SELECT * FROM
	PERSON JOIN DEPARTMENT
	ON PERSON.DepartmentID = DEPARTMENT.DepartmentID
END

PR_FK_PERSON_DEPARTMENT
-------------------------------------------------------------------
CREATE OR ALTER PROCEDURE PR_FK_PERSON_Designation
AS
BEGIN
	SELECT * FROM
	PERSON JOIN Designation
	ON PERSON.DesignationID = Designation.DesignationID
END

PR_FK_PERSON_Designation

------------------------------------------------------------------
--4
CREATE OR ALTER PROCEDURE PR_TOP3
AS
BEGIN
	SELECT TOP 3 * FROM PERSON
END

PR_TOP3




-------------------------------------------------------------------------

--PART-B
--5	
CREATE OR ALTER PROCEDURE PR_dname
@DNAME VARCHAR(50)
AS
BEGIN
	SELECT P.FIRSTNAME  FROM PERSON P JOIN Department D
	ON P.DepartmentID = D.DepartmentID
	WHERE D.DepartmentNAME = @DNAME
END

PR_dname 'HR'
PR_dname 'IT'
PR_dname 'ADMIN'
PR_dname 'ACCOUNT'

----------------------------------------------------------------------------
--6. Create Procedure that takes department name & designation name as input and returns a table with 
--worker’s first name, salary, joining date & department name.
create or alter procedure PR_3joins
	@Deptnm varchar(100),
	@Designationnm varchar(100)
AS
BEGIN
	SELECT Person.FirstName,PERSON.SALARY,PERSON.JoiningDate,DEPARTMENT.DepartmentName 
	FROM
	PERSON JOIN DEPARTMENT
	ON PERSON.DepartmentID=DEPARTMENT.DepartmentID
	JOIN Designation
	ON PERSON.DesignationID=DESIGNATION.DesignationID
	WHERE 
	DepartmentName=@Deptnm AND
	DesignationName=@Designationnm
END

EXEC PR_3joins 'ADMIN','clerk'


--7. Create a Procedure that takes the first name as an input parameter and display all the details of the 
--worker with their department & designation name.
CREATE OR ALTER procedure PR_ALLDETAIL
	@FNM VARCHAR(100)
AS
BEGIN
	SELECT * FROM
	PERSON JOIN DEPARTMENT
	ON PERSON.DepartmentID=DEPARTMENT.DepartmentID
	JOIN Designation
	ON PERSON.DesignationID=Designation.DesignationID
	WHERE FirstName=@FNM
END
EXEC PR_ALLDETAIL 'ROHIT'


--8. Create Procedure which displays department wise maximum, minimum & total salaries.
CREATE OR ALTER PROCEDURE PR_TOTAL
AS
BEGIN
	SELECT DepartmentName,MIN(SALARY) AS MINIMUM ,MAX(SALARY) AS MAXIMUM ,SUM(SALARY) AS TOTAL
	FROM PERSON JOIN DEPARTMENT
	ON PERSON.DepartmentID=DEPARTMENT.DepartmentID
	GROUP BY DEPARTMENTNAME
END

EXEC PR_TOTAL

--9. Create Procedure which displays designation wise average & total salaries.
CREATE OR ALTER PROCEDURE PR_AVG
AS
BEGIN
	SELECT DesignationName, AVG(SALARY) AS AVRAGE,SUM(SALARY) AS TOTAL
	FROM PERSON JOIN Designation
	ON PERSON.DesignationID=DESIGNATION.DesignationID
	GROUP BY DesignationName
END
EXEC PR_AVG

--PART C

--10. Create Procedure that Accepts Department Name and Returns Person Count.
CREATE OR ALTER PROCEDURE PR_PERSON_COUNT_BY_DEPT
    @DeptName VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS PersonCount
    FROM PERSON JOIN DEPARTMENT 
    ON PERSON.DepartmentID = DEPARTMENT.DepartmentID
    WHERE 
        DEPARTMENT.DepartmentName = @DeptName;
END
exec PR_PERSON_COUNT_BY_DEPT 'ADMIN'


--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than 
--input salary value along with their department and designation details
CREATE OR ALTER PROCEDURE PR_DISPLAYSLARY
    @SALARY DECIMAL(8, 2) 
AS
BEGIN
    SELECT 
        PERSON.*, DEPARTMENT.DepartmentName,DESIGNATION.DesignationName
    FROM PERSON JOIN DEPARTMENT 
	ON PERSON.DepartmentID = DEPARTMENT.DepartmentID
    JOIN DESIGNATION 
	ON PERSON.DesignationID = DESIGNATION.DesignationID
    WHERE 
        PERSON.SALARY > @SALARY; 
END

EXEC PR_DISPLAYSLARY 10000


--12. Create a procedure to find the department(s) with the highest total salary among all departments.
CREATE OR ALTER PROCEDURE PR_FIND
AS
BEGIN
    SELECT 
        DEPARTMENT.DepartmentName,
        SUM(PERSON.Salary) AS TotalSalary,
        MAX(PERSON.Salary) AS MaximumSalary
    FROM PERSON JOIN DEPARTMENT
    ON PERSON.DepartmentID = DEPARTMENT.DepartmentID
    GROUP BY 
        DEPARTMENT.DepartmentName;
END;

EXEC PR_FIND



--13. Create a procedure that takes a designation name as input and returns a list of all workers under that 
--designation who joined within the last 10 years, along with their department.
create or alter procedure PR_in
	@Designation_nm varchar(100)
AS
BEGIN
	SELECT * from person join department
	on PERSON.DepartmentID = DEPARTMENT.DepartmentID
	join Designation 
	on PERSON.DesignationID = DESIGNATION.DesignationID
	where
	DESIGNATION.DesignationName = @Designation_nm 
        AND DATEDIFF(YEAR, Person.JoiningDate, GETDATE()) <= 10;
end
exec PR_in 'SETH'
SELECT * FROM DESIGNATION

--14. Create a procedure to list the number of workers in each department who do not have a designation 
--assigned
CREATE OR ALTER PROCEDURE PR_NoDesignation
AS
BEGIN
    SELECT DEPARTMENT.DepartmentName,
        COUNT(PERSON.PersonID) AS COUNT_PERSON
    FROM PERSON JOIN  DEPARTMENT
    ON 
        PERSON.DepartmentID = DEPARTMENT.DepartmentID
    WHERE 
        PERSON.DesignationID IS NULL
    GROUP BY 
        DEPARTMENT.DepartmentName;
END;

EXEC PR_NoDesignation

--Create a procedure to retrieve the details of workers in departments where the average salary is above 
--12000.
CREATE OR ALTER PROCEDURE PR_AvgSalaryAbove
AS
BEGIN
    SELECT 
        PERSON.PersonID,
        PERSON.FirstName,
        PERSON.Salary,
        DEPARTMENT.DepartmentName
    FROM 
        PERSON JOIN DEPARTMENT 
    ON 
        PERSON.DepartmentID = DEPARTMENT.DepartmentID
    WHERE 
        DEPARTMENT.DepartmentID IN (
            SELECT DepartmentID
            FROM PERSON
            GROUP BY DepartmentID
            HAVING 
                AVG(Salary) > 12000
        );
END

EXEC PR_AvgSalaryAbove