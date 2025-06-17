CREATE or alter FUNCTION printHello()
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN 'HELLO WORD';
END;

select dbo.printHello() as GRETTING

-------------------------------------------------

create or alter function addTwoNumber
(
	@n1 int,
	@n2 int
)
returns int
as
begin
	return @n1+@n2;
end

select dbo.addTwoNumber(10,20) as SUM

-------------------------------------------------

create or alter function oddOReven
(
	@num int
)
returns varchar(20)
as
begin
	declare @result varchar(20) 

	if @num % 2 = 0
		set @result =  'EVEN NUMBER';
	else
		set @result = 'ODD NUMBER';

	return @result
end;

select dbo.oddOReven(5) as 'ODD / EVEN'

-------------------------------------------------

CREATE OR ALTER FUNCTION GetPersonDetailB()
RETURNS @PersonTable TABLE
(
    PersonID INT,
    FirstName VARCHAR(50)
)
AS
BEGIN
    INSERT INTO @PersonTable
    SELECT PersonID, FirstName
    FROM dbo.Person
    WHERE FirstName LIKE 'B%'

    RETURN
END

SELECT * FROM dbo.GetPersonDetailB()

select * from person

-------------------------------------------------

CREATE FUNCTION dbo.GetUniqueFirstNames()
RETURNS @FirstNameTable TABLE
(
    FirstName VARCHAR(50)
)
AS
BEGIN
    INSERT INTO @FirstNameTable
    SELECT DISTINCT FirstName
    FROM dbo.Person

    RETURN
END

SELECT * FROM  dbo.GetUniqueFirstNames()

-------------------------------------------------

create or alter function printNnumber
(
	@num int
)
returns @numberTable table (Number int)
as
begin
	declare @count int = 1

	while @count<=@num
	begin
		insert into @numberTable(Number) values (@count)
		set @count = @count+1
	end
	return;
end

select* from dbo.printNnumber(23)

-------------------------------------------------

create or alter function findFectorial(@num int)
returns int
as
begin
	declare @fect int = 1
	declare @count int = 1

	while @count<=@num
	begin
		set @fect = @fect*@count
		set @count = @count+1
	end
	return @fect
end

select dbo.findFectorial(4) as FECTORIAL

------------------------------------------------------------

--PART-B

--8
CREATE or alter FUNCTION CompareIntegers(@a INT, @b INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @result VARCHAR(50)
    SET @result = CASE 
                    WHEN @a < @b THEN 'The first integer is smaller than the second.'
                    WHEN @a = @b THEN 'Both integers are equal.'
                    WHEN @a > @b THEN 'The first integer is greater than the second.'
                    ELSE 'Invalid comparison.'
                  END
    RETURN @result
END;

select dbo.CompareIntegers(10,20)
select dbo.CompareIntegers(10,10)
select dbo.CompareIntegers(30,20)

------------------------------------------------------------

--9
CREATE OR ALTER FUNCTION fn_sum_even()
returns int
as
begin
	declare @sum int = 0
	declare @i int = 1
	while @i<=20
		begin 
			if @i%2=0
				set @sum+=@i
				set @i=@i+1
		end
		return @sum

end

select dbo.fn_sum_even()

------------------------------------------------------------

--10

 CREATE OR ALTER FUNCTION fn_pali_string(@str VARCHAR(50))
 RETURNS VARCHAR(50)
 AS
 BEGIN
	DECLARE @REV VARCHAR(50) , @MSG VARCHAR(50)
	SET @REV = REVERSE(@STR)
	IF @REV=@STR
		SET @MSG = 'PALINDROME'
	ELSE
		SET @MSG = 'NOT PALINDROME'
	RETURN @MSG
END

SELECT dbo.fn_pali_string('abcba')
SELECT dbo.fn_pali_string('jeet')

------------------------------------------------------------

--Part – C 

--11. Write a function to check whether a given number is prime or not. 
create or alter function fn_prime(@n int)
returns varchar(50)
as
begin
	declare @msg varchar(50),@i int=2,@flag int=1
	while @i<@n
	BEGIN
		if @n%@i=0
			set @flag=0
	set @i=@i+1
	END
	if @flag=1
		set @msg='Prime Number'
	else
		set @msg='Not Prime Number'
	return @msg
end

select dbo.fn_prime(5)

select dbo.fn_prime(8)

----------------------------------------------------------------

--12. Write a function which accepts two parameters start date & end date, and returns a difference in days. 
CREATE FUNCTION DateDifference(@startDate DATE, @endDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @startDate, @endDate)
END;

select dbo.DateDifference('2006-2-24','2024-2-24')
----------------------------------------------------------------


--13. Write a function which accepts two parameters year & month in integer and returns total days each year. 
CREATE FUNCTION TotalDaysInMonth(@year INT, @month INT)
RETURNS INT
AS
BEGIN
    RETURN DAY(EOMONTH(CONVERT(DATE, CONCAT(@year, '-', @month, '-01'))))
END;

select dbo.TotalDaysInMonth(2024,2)
----------------------------------------------------------------

--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons. 
CREATE FUNCTION GetPersonsByDepartment(@departmentID INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT * 
    FROM Person
    WHERE DepartmentID = @departmentID
);

select * from dbo.GetPersonsByDepartment(2)
----------------------------------------------------------------

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991. 
CREATE FUNCTION PersonsJoinedAfter(@joinDate DATE)
RETURNS TABLE
AS
RETURN 
(
    SELECT * 
    FROM Person
    WHERE JoiningDate > @joinDate
);


SELECT * FROM PersonsJoinedAfter('1991-01-01');
