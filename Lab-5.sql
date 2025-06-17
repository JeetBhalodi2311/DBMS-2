CREATE TABLE PersonInfo (
PersonID INT PRIMARY KEY,
PersonName VARCHAR(100) NOT NULL,
Salary DECIMAL(8,2) NOT NULL,
JoiningDate DATETIME NULL,
City VARCHAR(100) NOT NULL,
Age INT NULL,
BirthDate DATETIME NOT NULL
);

insert into PersonInfo values(1,'jeet',50000,'2024-11-23','Rajkot',20,'2006-2-24')
insert into PersonInfo values(2,'Bhavy',50000,'2024-11-23','Rajkot',20,'2006-2-24')
insert into PersonInfo values(3,'patel',50000,'2024-11-23','Rajkot',20,'2006-2-24')
insert into PersonInfo values(4,'Bhalodi',50000,'2024-11-23','Rajkot',20,'2006-2-24')

update PersonInfo
set PersonName = 'Jeet Bhalodi'
where PersonID=5

delete from PersonInfo
where PersonID=5

select * from PersonInfo
select*from PersonLog

-- Creating PersonLog Table
CREATE TABLE PersonLog (
PLogID INT PRIMARY KEY IDENTITY(1,1),
PersonID INT NOT NULL,
PersonName VARCHAR(250) NOT NULL,
Operation VARCHAR(50) NOT NULL,
UpdateDate DATETIME NOT NULL,
);

-------------------------------------------------------------------------------------
--Part – A
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display a message “Record is Affected.”

create or alter Trigger tr_PersonInfo_insert
on PersonInfo
After insert
as
begin
	PRINT'Insert Successfully'
end;
------------
create or alter Trigger tr_PersonInfo_delete
on PersonInfo
After delete
as
begin
	PRINT'Delete Successfully'
end;
-----------
create or alter Trigger tr_PersonInfo_update
on PersonInfo
After update
as
begin
	PRINT'Update Record Successfully'
end;
-----------
create or alter Trigger tr_PersonInfo_all
on PersonInfo
After insert,delete,update
as
begin
	PRINT'Record is Affected'
end;
-------------------------------------------------------------------------------------

--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.

select * from PersonLog

CREATE TRIGGER trg_InsertPersonInfo
ON PersonInfo
AFTER INSERT
AS
BEGIN
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    SELECT inserted.PersonID, inserted.PersonName,'INSERT',GETDATE()
    FROM inserted;
END;

CREATE TRIGGER trg_InsertPersonInfo_update
ON PersonInfo
AFTER Update
AS
BEGIN
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    SELECT inserted.PersonID, inserted.PersonName,'Update',GETDATE()
    FROM inserted;
END;

CREATE TRIGGER trg_InsertPersonInfo__delete
ON PersonInfo
AFTER Delete
AS
BEGIN
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    SELECT deleted.PersonID, deleted.PersonName,'Delete',GETDATE()
    FROM deleted;
END;

-------------------------------------------------------------------------------------

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.

create or alter trigger tr_instead_insert
on personinfo
INSTEAD OF INSERT
as
begin
	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	SELECT PersonID, PersonName, 'INSERT', GETDATE() FROM inserted;
end

----------------
create or alter trigger tr_instead_delete
on personinfo
INSTEAD OF Delete
as
begin
	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	SELECT PersonID, PersonName, 'DELETE', GETDATE() FROM inserted;
end
------------------------
create or alter trigger tr_instead_update
on personinfo
INSTEAD OF Update
as
begin
	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	SELECT PersonID, PersonName, 'UPDATE', GETDATE() FROM inserted;
end

select * from PersonLog
-------------------------------------------------------------------------------------

--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into uppercase whenever the record is inserted.

CREATE or alter TRIGGER trg_InsertUppercasePersonName
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET PersonName = UPPER(inserted.PersonName)
    FROM inserted
    WHERE PersonInfo.PersonID = inserted.PersonID;
END;

-------------------------------------------------------------------------------------

--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
create or alter trigger tr_instead_DUPLICET
on personinfo
INSTEAD OF INSERT
as
begin
	insert into personinfo
	SELECT PersonID, PersonName,Salary,JoiningDate,City,Age,BirthDate FROM inserted
	where PersonName not in (select PersonName from personinfo);
end;

-------------------------------------------------------------------------------------

--6. Create trigger that prevent Age below 18 years.
CREATE or alter TRIGGER tr_AGE18
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
	insert into PersonInfo
	SELECT PersonID, PersonName,Salary,JoiningDate,City,Age,BirthDate FROM inserted
	WHERE AGE>18;
END;

DROP TRIGGER TR_AGE18

SELECT * FROM PersonInfo
SELECT * FROM PersonLog
-------------------------------------------------------------------------------------

--Part – B

--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update that age in Person table.

CREATE TRIGGER tr_CalculateAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, BirthDate, GETDATE())
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END;

insert into PersonInfo values(14,'jeet',1110,null,'Rajkot',100,'2006-2-24')
insert into PersonInfo values(6,'Bhavy',50000,'2023-10-21','Rajkot',20,'2006-2-24')
insert into PersonInfo values(7,'patel',50000,'2020-11-23','Rajkot',20,'2006-2-24')
insert into PersonInfo values(11,'Bhalodi',50000,'2006-02-24','Rajkot',20,'2005-2-24')


-------------------------------------------------------------------------------------

--8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE TRIGGER tr_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.PersonID = d.PersonID
        WHERE i.Salary < d.Salary * 0.9
    )
    BEGIN
        RAISERROR ('Salary decrease is limited to 10%.', 16, 1);
        UPDATE p
        SET p.Salary = d.Salary
        FROM PersonInfo p
        JOIN deleted d ON p.PersonID = d.PersonID
        WHERE p.PersonID = d.PersonID;
    END
END;


-------------------------------------------------------------------------------------

--Part – C

--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL during an INSERT.
CREATE TRIGGER tr_DefaultJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = GETDATE()
    WHERE JoiningDate IS NULL AND PersonID IN (SELECT PersonID FROM inserted);
END;

-------------------------------------------------------------------------------------

--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints ‘Record deleted successfully from PersonLog’.
CREATE TRIGGER tr_DeleteMessage
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog.'
END;


delete from PersonLog
where PLogID=34
