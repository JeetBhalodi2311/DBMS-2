create table Products
(
	Product_id int primary key,
	Product_Name varchar(100) not null,
	Price decimal(10,2) not null
);

insert into Products values(1,'Smartphone',35000)
insert into Products values(2,'Laptop',55000)
insert into Products values(3,'Headphones',5500)
insert into Products values(4,'Television',85000)
insert into Products values(5,'Gaming Console',32000)

select * from Products

------------------------------------------------------------------

--1. Create a cursor Product_Cursor to fetch all the rows from a products table. 

Declare @id int,@name varchar(100),@rate decimal(10,2)

Declare Product_Cursor Cursor
for select Product_id,Product_Name,Price from Products

open Product_Cursor

Fetch next from Product_Cursor 
Into @id,@name,@rate

While @@FETCH_STATUS=0
Begin
	Print Concat(@id,'-',@name,'-',@rate)
	
	Fetch next from Product_Cursor 
	Into @id,@name,@rate
End

Close Product_Cursor

Deallocate Product_Cursor

------------------------------------------------------------------

--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. (Example: 1_Smartphone) 

Declare @id2 int,@name2 varchar(100)

Declare Product_Cursor_Fetch Cursor
for select Product_id,Product_Name from Products

open Product_Cursor_Fetch

Fetch next from Product_Cursor_Fetch 
Into @id2,@name2

While @@FETCH_STATUS=0
Begin
	Print Concat(@id2,'_',@name2)
	
	Fetch next from Product_Cursor_Fetch 
	Into @id2,@name2
End

Close Product_Cursor_Fetch

Deallocate Product_Cursor_Fetch
------------------------------------------------------------------

--3. Create a Cursor to Find and Display Products Above Price 30,000. 

Declare @id3 int,@name3 varchar(100),@rate3 decimal(10,2)

Declare Product_Cursor_Price_30000 Cursor
for select Product_id,Product_Name,Price from Products Where Price>30000

open Product_Cursor_Price_30000

Fetch next from Product_Cursor_Price_30000 
Into @id3,@name3,@rate3

While @@FETCH_STATUS=0
Begin

	Print Concat(@id3,'-',@name3,'-',@rate3)
	
	Fetch next from Product_Cursor_Price_30000 
	Into @id3,@name3,@rate3
End

Close Product_Cursor_Price_30000

Deallocate Product_Cursor_Price_30000

------------------------------------------------------------------

--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table. 

Declare @id4 int

Declare Product_CursorDelete cursor
for select Product_id from Products

Open Product_CursorDelete

Fetch next from Product_CursorDelete
into @id4

While @@FETCH_STATUS=0
Begin
	Delete from Products where Product_id=@id4

	Fetch next from Product_CursorDelete
	into @id4
End

Close Product_CursorDelete

Deallocate Product_CursorDelete

------------------------------------------------------------------


--PART-B

--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%. 

Declare @id5 int,@name5 varchar(100),@rate5 decimal(10,2)

Declare Product_CursorUpdate Cursor
for select Product_id,Product_Name,Price from Products

open Product_CursorUpdate

Fetch next from Product_CursorUpdate 
Into @id5,@name5,@rate5

While @@FETCH_STATUS=0
Begin
	Print Concat(@id5,'-',@name5,'-',@rate5)

	Set @rate5 = @rate5*1.10

	Update Products
	Set Price=@rate5
	where Product_id=@id5

	Print Concat(@id5,'-',@name5,'-',@rate5)
	
	Fetch next from Product_CursorUpdate 
	Into @id5,@name5,@rate5
End

Close Product_CursorUpdate

Deallocate Product_CursorUpdate		

------------------------------------------------------------------

--6. Create a Cursor to Rounds the price of each product to the nearest whole number. 

Declare @id6 int,@name6 varchar(100),@rate6 decimal(10,2)

Declare RoundOf_Cursor Cursor
For Select Product_id,Product_Name,Price from Products

Open RoundOf_Cursor

Fetch next from RoundOf_Cursor 
Into @id6,@name6,@rate6

While @@FETCH_STATUS=0
Begin
	SET @rate6=ROUND(@rate6,0)

	Update Products
	Set Price=@rate6
	where Product_id=@id6

	Print Concat(@id6,'-',@name6,'-',@rate6)

	Fetch next from RoundOf_Cursor 
	Into @id6,@name6,@rate6
End

Close RoundOf_Cursor

Deallocate RoundOf_Cursor	


------------------------------------------------------------------

--PART-C

create table NewProducts
(
	Product_id int primary key,
	Product_Name varchar(100) not null,
	Price decimal(10,2) not null
);


--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” (Note: Create NewProducts table first with same fields as Products table) 

Declare @id7 int,@name7 varchar(100),@rate7 decimal(10,2)


Declare Product_CursorInsert Cursor
for select Product_id,Product_Name,Price from Products Where Product_Name='Laptop'

open Product_CursorInsert

Fetch next from Product_CursorInsert 
Into @id7,@name7,@rate7

While @@FETCH_STATUS=0
Begin

	Insert into NewProducts values(@id7,@name7,@rate7)
		
	Fetch next from Product_CursorInsert 
	Into @id7,@name7,@rate7
End

Close Product_CursorInsert

Deallocate Product_CursorInsert

Select * from NewProducts

------------------------------------------------------------------

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products with a price above 50000 to an archive table, removing them from the original Products table. 

create table ArchivedProducts
(
	Product_id int primary key,
	Product_Name varchar(100) not null,
	Price decimal(10,2) not null
);


Declare @id8 int,@name8 varchar(100),@rate8 decimal(10,2)

Declare Product_CursorArchive Cursor
for select Product_id,Product_Name,Price from Products where Price>50000

open Product_CursorArchive

Fetch next from Product_CursorArchive 
Into @id8,@name8,@rate8

While @@FETCH_STATUS=0
Begin
	Insert into ArchivedProducts values(@id8,@name8,@rate8)

	Delete from Products where Product_id=@id8
	
	Fetch next from Product_CursorArchive 
	Into @id8,@name8,@rate8
End

Close Product_CursorArchive

Deallocate Product_CursorArchive

Select * from Products
Select * from ArchivedProducts

------------------------------------------------------------------
