-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY, 
 Customer_Name VARCHAR(250) NOT NULL, 
 Email VARCHAR(50) UNIQUE 
);
-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY, 
 Customer_id INT, 
 Order_date DATE NOT NULL, 
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id) 
)
select * from Customers
select * from Orders

--Part – A
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
begin try
	declare @ans INT
	 SET @ans=1/0
end try
begin catch
	print ERROR_MESSAGE()
END CATCH


--2. Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
    DECLARE @str VARCHAR(50), @num INT;
    SET @str = 'hello';
    
    SET @num = CAST(@str AS INT);  -- This will cause a conversion error
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();  -- Catch and print the error message
END CATCH;


--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result.

CREATE or alter PROCEDURE AddTwoNumbers  
    @num1 VARCHAR(50),  
    @num2 VARCHAR(50)  
AS  
BEGIN  
    DECLARE @int1 INT, @int2 INT;  
  
    BEGIN TRY   
        SET @int1 = CAST(@num1 AS INT);  
        SET @int2 = CAST(@num2 AS INT);  
   
        PRINT 'Sum: ' + CAST((@int1 + @int2) AS VARCHAR); 
		 
    END TRY  
    BEGIN CATCH  
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);  
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);  
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);  
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');  
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR);  
        PRINT 'Error Message: ' + ERROR_MESSAGE();  
    END CATCH  
END;

exec AddTwoNumbers 1,2
exec AddTwoNumbers '1','2'
exec AddTwoNumbers '1','a'



--4. Handle a Primary Key Violation while inserting data into customers table and print the error details 
--such as the error message, error number, severity, and state.
INSERT INTO customers (customer_id, customer_name, email)  
VALUES (2, 'Jeet Bhalodi', 'jeet@gmail.com');

INSERT INTO customers (customer_id, customer_name, email)  
VALUES (3, 'Jeet Bhalodi', 'jee@gmail.com');

BEGIN TRY   
    INSERT INTO customers (customer_id, customer_name, email)  
    VALUES (2, 'Jeet Bhalodi', 'jeet@gmail.com');
END TRY  
BEGIN CATCH  
   
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);  
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);  
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);  
    PRINT 'Error Message: ' + ERROR_MESSAGE();  
END CATCH;


--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws 
--Error like no Customer_id is available in database.

CREATE or alter PROCEDURE CheckCustomerExists  
    @Customer_id INT  
AS  
BEGIN  
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @Customer_id)  
    BEGIN  
        THROW 555555, 'No Customer_id is available in the database.', 1;  
    END  
    ELSE  
    BEGIN  
        PRINT 'Customer exists in the database.';  
    END  
END

EXEC CheckCustomerExists 1;
EXEC CheckCustomerExists 999;


--Part – B
--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error 
--message.
BEGIN TRY
    INSERT INTO Orders (Order_id, Customer_id, Order_date)
    VALUES (2, 2, GETDATE());
END TRY
BEGIN CATCH
    PRINT 'Error: Foreign Key Violation. Customer_id does not exist.';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;

select * from Customers
select * from Orders

--7. Throw custom exception that throws error if the data is invalid.
CREATE or alter PROCEDURE Validate_Customer
@Customer_id INT  
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @Customer_id)  
    BEGIN
        THROW 50002, 'Error: Invalid data provided', 1;
    END
    ELSE
    BEGIN
        PRINT 'Data is valid';
    END
END;

Validate_Customer 1

--8. Create a Procedure to Update Customer’s Email with Error Handling
CREATE or alter PROCEDURE Update_Customer_Email
    @Customer_id INT,
    @NewEmail VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
    BEGIN
        THROW 50003, 'Error: Customer ID not found', 1;
    END
    
    BEGIN TRY
        UPDATE Customers
        SET Email = @NewEmail
        WHERE Customer_id = @Customer_id;
        PRINT 'Email updated successfully';
    END TRY
    BEGIN CATCH
        PRINT 'Error: Failed to update email';
    END CATCH;
END;

Update_Customer_Email 3,'johnnnnnn@gmail.com'

select * from Customers


-----part-c
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another
CREATE or alter PROCEDURE Handle_Duplicate_Customer
    @Customer_id INT,
    @Customer_Name VARCHAR(250),
    @Email VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
    BEGIN
        PRINT 'The Customer_id is already taken. Try another one.';
    END
    ELSE
    BEGIN
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@Customer_id, @Customer_Name, @Email);
        PRINT 'Customer added successfully';
    END
END;

Handle_Duplicate_Customer 1,'bhavy','bhavy@gmail.com'

select * from Customers


--10) Handle Duplicate Email Insertion in Customers Table.
CREATE or alter PROCEDURE Handle_Duplicate_Email
    @Customer_id INT,
    @Customer_Name VARCHAR(250),
    @Email VARCHAR(50)
AS
BEGIN
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Customers WHERE Email = @Email)
    BEGIN
        PRINT 'Error: This email is already registered. Try another one.';
    END
    ELSE
    BEGIN
        BEGIN TRY
            INSERT INTO Customers (Customer_id, Customer_Name, Email)
            VALUES (@Customer_id, @Customer_Name, @Email);
            PRINT 'Customer added successfully';
        END TRY
        BEGIN CATCH
            PRINT 'Error: Could not insert customer record.';
            PRINT 'Error Message: ' + ERROR_MESSAGE();
        END CATCH;
    END
END;

Handle_Duplicate_Email 3,'Bhavy','jeet@gmail.com'

