CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)


CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);

insert into EMPLOYEEDETAILS values(1,'patel','12345678','CSE',50000,'2024-02-23')

update EMPLOYEEDETAILS 
set EmployeeName='Jeet'
where EmployeeID=1

delete from EMPLOYEEDETAILS
where EmployeeID=1

select * from EMPLOYEEDETAILS
select * from EmployeeLogs

--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
create or alter Trigger tr_insert
on EMPLOYEEDETAILS
After insert
as
begin
	PRINT'Employee record inserted'
end;
------------
create or alter Trigger tr_delete
on EMPLOYEEDETAILS
After delete
as
begin
	PRINT'Employee record deleted'
end;
-----------
create or alter Trigger tr_update
on EMPLOYEEDETAILS
After update
as
begin
	PRINT'Employee record updated'
end;

--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.
create or alter trigger tr_insert_log
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	insert into EmployeeLogs(EmployeeID,EmployeeName,ActionPerformed,ActionDate)
	SELECT inserted.EmployeeID, inserted.EmployeeName,'INSERT',GETDATE()
    FROM inserted;
end;

--------------

create or alter trigger tr_update_log
ON EMPLOYEEDETAILS
AFTER update
AS
BEGIN
	insert into EmployeeLogs(EmployeeID,EmployeeName,ActionPerformed,ActionDate)
	SELECT inserted.EmployeeID, inserted.EmployeeName,'UPDATE',GETDATE()
    FROM inserted;
end;

-------

create or alter trigger tr_delete_log
ON EMPLOYEEDETAILS
AFTER DELETE
AS
BEGIN
	insert into EmployeeLogs(EmployeeID,EmployeeName,ActionPerformed,ActionDate)
	SELECT deleted.EmployeeID, deleted.EmployeeName,'DELETE',GETDATE()
    FROM deleted;
end;

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
CREATE OR ALTER TRIGGER tr_bonus
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
    DECLARE @salary DECIMAL(10,2), @id INT;
    
    SELECT @salary = Salary, @id = EmployeeID 
    FROM inserted;
    
    UPDATE EMPLOYEEDETAILS
    SET Salary = (@salary * 0.10)+@salary
    WHERE EmployeeID = @id;
END;


--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
create or alter trigger tr_date
ON EMPLOYEEDETAILS
AFTER INSERT,update
AS
BEGIN
	
	declare @date datetime,@id int;
	select @date = JoiningDate from inserted
	select @id = EmployeeID from inserted

	if @date is null
	begin 
		update EMPLOYEEDETAILS
		set JoiningDate = ISNULL(JoiningDate, GETDATE())
		where EmployeeID = @id
	end

end;



--5)	Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)
create or alter trigger tr_no_check
ON EMPLOYEEDETAILS
After INSERT
AS
BEGIN

	declare @cn varchar(100),@id int;
	select @cn = ContactNo from inserted
	select @id = EmployeeID from inserted

	if len(@cn)!=10
	begin 
		delete EMPLOYEEDETAILS 
		where EmployeeID = @id
	end
	
	--insert into EMPLOYEEDETAILS
	--SELECT EmployeeID, EmployeeName,ContactNo,Department,Salary,JoiningDate FROM inserted
	--where len(ContactNo)=10;
end;

insert into EMPLOYEEDETAILS values(24,'jeet','1234567890','CSE',50000,null)
insert into EMPLOYEEDETAILS values(5,'patel','1234567891','CSE',50000,'2024-02-23')
insert into EMPLOYEEDETAILS values(6,'patel','12345622791','CSE',50000,'2024-02-23')

delete EMPLOYEEDETAILS
where EmployeeID=8

select * from EMPLOYEEDETAILS
select * from EmployeeLogs



----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);


CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
CREATE OR ALTER TRIGGER trgCheckRating
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Rating <= 5.5)
    BEGIN
        RAISERROR ('Cannot insert movie with rating <= 5.5', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Movies SELECT * FROM inserted;
    END
END;


--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
CREATE OR ALTER TRIGGER trgPreventDuplicateTitle
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE MovieTitle IN (SELECT MovieTitle FROM Movies))
    BEGIN
        INSERT INTO MoviesLog (OperationType, MovieID, MovieTitle, Rating, ReleaseDate, Duration)
        SELECT 'DUPLICATE ATTEMPT', MovieID, MovieTitle, Rating, ReleaseDate, Duration FROM inserted;
        RAISERROR ('Cannot insert duplicate movie title', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Movies SELECT * FROM inserted;
    END
END;


--4.	Create trigger that prevents to insert pre-release movies.
CREATE OR ALTER TRIGGER trgPreventPreRelease
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE ReleaseDate > GETDATE())
    BEGIN
        RAISERROR ('Cannot insert pre-release movie', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Movies SELECT * FROM inserted;
    END
END;

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.

CREATE OR ALTER TRIGGER trgCheckDuration
ON Movies
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Duration > 120)
    BEGIN
        RAISERROR ('Duration cannot be greater than 120 minutes', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE Movies
        SET MovieTitle = i.MovieTitle, Rating = i.Rating, ReleaseDate = i.ReleaseDate, Duration = i.Duration
        FROM inserted i
        JOIN Movies m ON i.MovieID = m.MovieID;
    END
END;

