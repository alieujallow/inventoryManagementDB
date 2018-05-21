/*ALIEU JALLOW*/
/**********************************************************************************
								TASK 2.2			
***********************************************************************************/
/*Create database*/
CREATE DATABASE AJ10972018
GO

USE AJ10972018
GO

/*creating schemas*/
CREATE SCHEMA HR AUTHORIZATION dbo;
GO

CREATE SCHEMA Sales AUTHORIZATION dbo;
GO

CREATE SCHEMA Production AUTHORIZATION dbo;
GO

/*CREATING TABLES*/

/*creating the person table*/
CREATE TABLE HR.Person
(
	person_id INT NOT NULL IDENTITY (1,1),
	first_name VARCHAR(35) NOT NULL, 
	last_name VARCHAR(35) NOT NULL,
	gender CHAR(1) NOT NULL,
	phone VARCHAR(15) UNIQUE NOT NULL,  
	email VARCHAR(100) UNIQUE NULL,
	addres VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Person PRIMARY KEY CLUSTERED(person_id)   
);

/*creating the customer table*/
CREATE TABLE Sales.Customer
(
	customer_id INT NOT NULL,
	account_number VARCHAR(20) NOT NULL,
	account_name VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED(customer_id),
	CONSTRAINT FK_Customer_Person FOREIGN KEY(customer_id) REFERENCES HR.Person(person_id)
);

/*creating the supplier table*/
CREATE TABLE Sales.Supplier
(
	supplier_id INT NOT NULL,
	company_name VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Supplier PRIMARY KEY CLUSTERED(supplier_id),
	CONSTRAINT FK_Supplier_Person FOREIGN KEY(supplier_id) REFERENCES HR.Person(person_id)
);

/*creating the staff table*/
CREATE TABLE HR.Staff
(
	staff_id INT NOT NULL,
	dob DATE NOT NULL,
	salary INT DEFAULT(0),
	CONSTRAINT PK_Staff PRIMARY KEY CLUSTERED(staff_id),
	CONSTRAINT FK_Staff_Person FOREIGN KEY(staff_id) REFERENCES HR.Person(person_id),
	CONSTRAINT Check_birthdate CHECK(dob <= CURRENT_TIMESTAMP)
);

/*creating the role table*/
CREATE TABLE HR.Role
(
	role_id INT NOT NULL  IDENTITY (1,1),
	role_name VARCHAR(35) UNIQUE NOT NULL,
	CONSTRAINT PK_Role PRIMARY KEY CLUSTERED(role_id)
);

/*creating the status table*/
CREATE TABLE HR.Status
(
	status_id INT NOT NULL  IDENTITY (1,1),
	status_name VARCHAR(35) UNIQUE NOT NULL,
	CONSTRAINT PK_Status PRIMARY KEY CLUSTERED(status_id)
);

/*creating the user table*/
CREATE TABLE HR.Users
(
	user_id INT NOT NULL,
	role_id INT NOT NULL,
	status_id INT NOT NULL,
	username VARCHAR(20) UNIQUE NOT NULL,
	password VARCHAR (100) NOT NULL,
	last_loggedin DATETIME NOT NULL,
	CONSTRAINT PK_User PRIMARY KEY CLUSTERED(user_id),
	CONSTRAINT FK_User_Staff FOREIGN KEY (user_id) REFERENCES HR.Staff(staff_id),
	CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES HR.Role (role_id),
	CONSTRAINT FK_User_Status FOREIGN KEY (status_id) REFERENCES HR.Status(status_id),
	CONSTRAINT Check_last_login CHECK(last_loggedin <= CURRENT_TIMESTAMP)
);

/*creating the category table*/
CREATE TABLE Production.Category
(
	category_id INT NOT NULL IDENTITY (1,1),
	name VARCHAR(35) UNIQUE NOT NULL,
	date_created DATETIME NOT NULL,
	last_modified DATETIME NOT NULL,
	CONSTRAINT PK_Category PRIMARY KEY CLUSTERED(category_id),
	CONSTRAINT Check_category_date_created CHECK(date_created <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_category_last_modified CHECK(last_modified <= CURRENT_TIMESTAMP)
);

/*creating the stock table*/
CREATE TABLE Production.Stock
(
	stock_id INT NOT NULL IDENTITY(1,1),
	supplier_id INT NOT NULL,
	name VARCHAR(35) NOT NULL,
	quantity INT NOT NULL DEFAULT(0),
	unit_price MONEY NOT NULL DEFAULT(0),
	order_date DATE NOT NULL,
	inventory_date DATE NOT NULL,
	batch_number INT UNIQUE NOT NULL,
	transaction_date DATETIME NOT NULL,
	description VARCHAR(250) NULL,
	CONSTRAINT PK_Stock PRIMARY KEY CLUSTERED(stock_id),
	CONSTRAINT FK_Stock_Supplier FOREIGN KEY (supplier_id) REFERENCES Sales.Supplier(supplier_id),
	CONSTRAINT Check_order_date CHECK(order_date <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_inventory_date CHECK(inventory_date <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_stock_transaction_date CHECK(transaction_date <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_stock_quantity CHECK (quantity >= 0),
	CONSTRAINT Check_stock_Product_unit_price CHECK(unit_price >= 0)
);

/*creating the store table*/
CREATE TABLE Production.Store
(
	product_id INT NOT NULL IDENTITY(1,1),
	stock_id INT NOT NULL,
	batch_number INT NOT NULL,
	category_id INT NOT NULL,
	name VARCHAR(35) UNIQUE NOT NULL,
	order_point INT NOT NULL,
	warning_point INT NOT NULL,
	unit_price MONEY NOT NULL DEFAULT(0),
	quantity INT NOT NULL DEFAULT(0),
	date_created DATETIME NOT NULL,
	last_modified DATETIME NOT NULL,
	CONSTRAINT PK_Product PRIMARY KEY CLUSTERED(product_id),
	CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES Production.Category(category_id),
	CONSTRAINT FK_Product_Stock FOREIGN KEY (stock_id) REFERENCES Production.Stock(stock_id),
	CONSTRAINT Check_product_date_created CHECK(date_created <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_porduct_last_modified CHECK(last_modified <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_Product_unit_price CHECK(unit_price >= 0),
	CONSTRAINT Check_product_quantity CHECK (quantity >= 0)
);

/*creating the stock sale table*/
CREATE TABLE Sales.Customer_Product
(
	customer_id INT NOT NULL,
	user_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL DEFAULT(0),
	unit_price MONEY NOT NULL  DEFAULT(0),
	total_price MONEY NOT NULL  DEFAULT(0),
	comment VARCHAR(250) NULL,
	transaction_date DATETIME NOT NULL,
	CONSTRAINT FK_Customer_Product_Customer FOREIGN KEY (customer_id) REFERENCES Sales.Customer(customer_id),
	CONSTRAINT FK_Customer_Product_User FOREIGN KEY (user_id) REFERENCES HR.users(user_id),
	CONSTRAINT FK_Customer_Product_product FOREIGN KEY (product_id) REFERENCES Production.Store(product_id),
	CONSTRAINT Check_customer_transaction_date CHECK(transaction_date <= CURRENT_TIMESTAMP),
	CONSTRAINT Check_customer_quantity CHECK (quantity >= 0),
	CONSTRAINT Check_customer_Product_unit_price CHECK(unit_price >= 0),
	CONSTRAINT Check_total_price CHECK(total_price >= 0)
);

/*****************************************************************************************************
										TASK 2.3
******************************************************************************************************/
/*
Indexing staff salary
*/
CREATE NONCLUSTERED INDEX idx_Staff_Salary   ON HR.Staff(salary);

/*
	I am indexing the transaction date becuase i would be interested to know the amount of sales done on a particular day
	In which I will be using the transaction date to perform a search
*/
CREATE NONCLUSTERED INDEX idx_customer_product_transaction_date ON Sales.Customer_Product(transaction_date);

/*
	I index the first name becuase i will be searching for staff, customers and suppliers using their first names
*/
CREATE NONCLUSTERED INDEX idx_Person_first_name   ON HR.Person(first_name);

/*
	I index the last name becuase i will be searching for staff, customers and suppliers using their last names
*/
CREATE NONCLUSTERED INDEX idx_Person_last_name   ON HR.Person(last_name);

/*****************************************************************************************************
										TASK 2.4
******************************************************************************************************/
/*Create database*/
CREATE DATABASE AJ10972018_backup
GO

USE AJ10972018_backup
GO

/*creating schemas*/
CREATE SCHEMA HR AUTHORIZATION dbo;
GO

CREATE SCHEMA Sales AUTHORIZATION dbo;
GO

CREATE SCHEMA Production AUTHORIZATION dbo;
GO

/*CREATING TABLES*/

/*creating the person table*/
CREATE TABLE HR.PersonBackup
(
	person_id INT,
	first_name VARCHAR(35), 
	last_name VARCHAR(35),
	gender CHAR(1),
	phone VARCHAR(15),  
	email VARCHAR(100),
	addres VARCHAR(100),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);


/*creating the customer table*/
CREATE TABLE Sales.CustomerBackup
(
	customer_id INT,
	account_number VARCHAR(20),
	account_name VARCHAR(50),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the supplier table*/
CREATE TABLE Sales.SupplierBackup
(
	supplier_id INT,
	company_name VARCHAR(50),
	country VARCHAR(50),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the staff table*/
CREATE TABLE HR.StaffBackup
(
	staff_id INT,
	dob DATE,
	salary INT,
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the role table*/
CREATE TABLE HR.RoleBackup
(
	role_id INT,
	role_name VARCHAR(35),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the status table*/
CREATE TABLE HR.StatusBackup
(
	status_id INT,
	status_name VARCHAR(35),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the user table*/
CREATE TABLE HR.UsersBackup
(
	user_id INT,
	role_id INT,
	status_id INT,
	username VARCHAR(20),
	password VARCHAR (100),
	last_loggedin DATETIME,
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the category table*/
CREATE TABLE Production.CategoryBackup
(
	category_id INT,
	name VARCHAR(35),
	date_created DATETIME,
	last_modified DATETIME,
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the stock table*/
CREATE TABLE Production.StockBackup
(
	stock_id INT,
	supplier_id INT,
	name VARCHAR(35),
	quantity INT,
	unit_price MONEY,
	order_date DATE,
	inventory_date DATE,
	batch_number INT,
	transaction_date DATETIME,
	description VARCHAR(250),
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the store table*/
CREATE TABLE Production.StoreBackup
(
	product_id INT,
	stock_id INT,
	batch_number INT,
	category_id INT,
	name VARCHAR(35),
	order_point INT,
	warning_point INT,
	unit_price MONEY,
	quantity INT,
	date_created DATETIME,
	last_modified DATETIME,
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*creating the stock sale table*/
CREATE TABLE Sales.Customer_ProductBackup
(
	customer_id INT,
	user_id INT,
	product_id INT,
	quantity INT,
	unit_price MONEY,
	total_price MONEY,
	comment VARCHAR(250),
	transaction_date DATETIME,
	audit_activity VARCHAR(200),
	audit_time DATETIME
);

/*USING MY ACTUAL DATABASE*/
USE AJ10972018
GO

/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON STOCK TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE STOCK TABLE*/

CREATE TRIGGER insertStockTrigger ON 
Production.Stock 
FOR INSERT
AS 
	declare @stock_id INT;
	declare @supplier_id INT;
	declare @name VARCHAR(35);
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @order_date DATE;
	declare @inventory_date DATE;
	declare @batch_number INT;
	declare @transaction_date DATETIME;
	declare @description VARCHAR(250);
	declare @activity VARCHAR(200);

	Select @stock_id = s.stock_id FROM inserted s;
	Select @supplier_id = s.supplier_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @order_date = s.order_date FROM inserted s;
	Select @inventory_date = s.inventory_date FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s; 
	Select @description =  s.description FROM inserted s;

	set @activity = 'Record inserted in Stock Table';

	INSERT INTO AJ10972018_backup.Production.StockBackup(
	stock_id, supplier_id, name, quantity, unit_price, order_date, inventory_date, batch_number, transaction_date,description,audit_activity,
	audit_time)
	VALUES(@stock_id, @supplier_id, @name, @quantity, @unit_price, @order_date, @inventory_date, @batch_number, @transaction_date,@description, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE STOCK TABLE*/
CREATE TRIGGER updateStockTrigger ON 
Production.Stock 
FOR UPDATE
AS 
	declare @stock_id INT;
	declare @supplier_id INT;
	declare @name VARCHAR(35);
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @order_date DATE;
	declare @inventory_date DATE;
	declare @batch_number INT;
	declare @transaction_date DATETIME;
	declare @description VARCHAR(250);
	declare @activity VARCHAR(200);

	Select @stock_id = s.stock_id FROM inserted s;
	Select @supplier_id = s.supplier_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @order_date = s.order_date FROM inserted s;
	Select @inventory_date = s.inventory_date FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s;
	Select @description = s.description FROM inserted s;

	if update(supplier_id)	
		set @activity = 'Updated Stock supplier ID';
	if update(name)	
		set @activity = 'Updated Stock name';
	if update(quantity)	
		set @activity = 'Updated Stock quantity';
	if update(unit_price)	
		set @activity = 'Updated Stock unit price';
	if update(order_date)	
		set @activity = 'Updated Stock order date';
	if update(inventory_date)	
		set @activity = 'Updated Stock inventory date';
	if update(batch_number)	
		set @activity = 'Updated Stock batch number';
	if update(transaction_date)	
		set @activity = 'Updated Stock transaction date';
	if update(description)	
		set @activity = 'Updated Stock description';

	INSERT INTO AJ10972018_backup.Production.StockBackup(
	stock_id, supplier_id, name, quantity, unit_price, order_date, inventory_date, batch_number, transaction_date,description,audit_activity,
	audit_time)
	VALUES(@stock_id, @supplier_id, @name, @quantity, @unit_price, @order_date, @inventory_date, @batch_number, @transaction_date,@description, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a row in the stock table'
	GO
GO

/* A TRIGGER FOR DELETING A RECORD FROM THE STOCK TABLE*/
CREATE TRIGGER deleteStockTrigger ON 
Production.Stock 
FOR DELETE
AS 
	declare @stock_id INT;
	declare @supplier_id INT;
	declare @name VARCHAR(35);
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @order_date DATE;
	declare @inventory_date DATE;
	declare @batch_number INT;
	declare @transaction_date DATETIME;
	declare @description VARCHAR(250);
	declare @activity VARCHAR(200);

	Select @stock_id = s.stock_id FROM inserted s;
	Select @supplier_id = s.supplier_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @order_date = s.order_date FROM inserted s;
	Select @inventory_date = s.inventory_date FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s;
	Select @description = s.description FROM inserted s;

	set @activity = 'Deleted a stock record';
	
	INSERT INTO AJ10972018_backup.Production.StockBackup(
	stock_id, supplier_id, name, quantity, unit_price, order_date, inventory_date, batch_number, transaction_date,description,audit_activity,
	audit_time)
	VALUES(@stock_id, @supplier_id, @name, @quantity, @unit_price, @order_date, @inventory_date, @batch_number, @transaction_date,@description, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='Deleted a record from the stock table'
	GO
GO

/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON PERSON TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE PERSON TABLE*/
CREATE TRIGGER insertPersonTrigger ON 
HR.Person 
FOR INSERT
AS 
	declare @person_id INT;
	declare @first_name VARCHAR(35); 
	declare @last_name VARCHAR(35);
	declare @gender CHAR(1);
	declare @phone VARCHAR(15);  
	declare @email VARCHAR(100);
	declare @addres VARCHAR(100);
	declare @activity VARCHAR(200);

	Select @person_id = s.person_id FROM inserted s;
	Select @first_name = s.first_name FROM inserted s;
	Select @last_name = s.last_name FROM inserted s;
	Select @gender = s.gender FROM inserted s;
	Select @phone = s.phone FROM inserted s;
	Select @email = s.email FROM inserted s;
	Select @addres = s.addres FROM inserted s;

	set @activity = 'Record inserted in Person Table';

	INSERT INTO AJ10972018_backup.HR.PersonBackup(
	person_id, first_name, last_name, gender, phone, email, addres,audit_activity,audit_time)
	VALUES(@person_id, @first_name, @last_name, @gender, @phone, @email, @addres, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE PERSON TABLE*/
CREATE TRIGGER updatePersonTrigger ON 
HR.Person 
FOR UPDATE
AS 
	declare @person_id INT;
	declare @first_name VARCHAR(35); 
	declare @last_name VARCHAR(35);
	declare @gender CHAR(1);
	declare @phone VARCHAR(15);  
	declare @email VARCHAR(100);
	declare @addres VARCHAR(100);
	declare @activity VARCHAR(200);

	Select @person_id = s.person_id FROM inserted s;
	Select @first_name = s.first_name FROM inserted s;
	Select @last_name = s.last_name FROM inserted s;
	Select @gender = s.gender FROM inserted s;
	Select @phone = s.phone FROM inserted s;
	Select @email = s.email FROM inserted s;
	Select @addres = s.addres FROM inserted s;

	if update(first_name)	
		set @activity = 'Updated Person first name';
	if update(last_name)	
		set @activity = 'Updated Person last name';
	if update(gender)	
		set @activity = 'Updated Person gender';
	if update(phone)	
		set @activity = 'Updated Person phone';
	if update(email)	
		set @activity = 'Updated Person email';
	if update(addres)	
		set @activity = 'Updated Person address';
	
	INSERT INTO AJ10972018_backup.HR.PersonBackup(
	person_id, first_name, last_name, gender, phone, email, addres,audit_activity,audit_time)
	VALUES(@person_id, @first_name, @last_name, @gender, @phone, @email, @addres, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a person record in the person table'
	GO
GO

/* A TRIGGER FOR DELETING A RECORD FROM THE PERSON TABLE*/
CREATE TRIGGER deletePersonTrigger ON 
HR.Person
FOR DELETE
AS 
	declare @person_id INT;
	declare @first_name VARCHAR(35); 
	declare @last_name VARCHAR(35);
	declare @gender CHAR(1);
	declare @phone VARCHAR(15);  
	declare @email VARCHAR(100);
	declare @addres VARCHAR(100);
	declare @activity VARCHAR(200);

	Select @person_id = s.person_id FROM inserted s;
	Select @first_name = s.first_name FROM inserted s;
	Select @last_name = s.last_name FROM inserted s;
	Select @gender = s.gender FROM inserted s;
	Select @phone = s.phone FROM inserted s;
	Select @email = s.email FROM inserted s;
	Select @addres = s.addres FROM inserted s;

	set @activity = 'Deleted a Person record';
	
	INSERT INTO AJ10972018_backup.HR.PersonBackup(
	person_id, first_name, last_name, gender, phone, email, addres,audit_activity,audit_time)
	VALUES(@person_id, @first_name, @last_name, @gender, @phone, @email, @addres, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='Deleted a person record from the person table'
	GO
GO


/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON STORE TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE STORE TABLE*/
CREATE TRIGGER insertProductTrigger ON 
Production.Store 
FOR INSERT
AS 
	declare @product_id INT;
	declare @stock_id INT;
	declare @batch_number INT;
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @order_point INT;
	declare @warning_point INT;
	declare @unit_price MONEY;
	declare @quantity INT;
	declare @date_created DATE;
	declare @last_modified DATE;
	declare @activity VARCHAR(200);

	Select @product_id = s.product_id FROM inserted s;
	Select @stock_id = s.stock_id FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @order_point = s.order_point FROM inserted s;
	Select @warning_point = s.warning_point FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;

	set @activity = 'Record inserted in Store Table';

	INSERT INTO AJ10972018_backup.Production.StoreBackup(
	product_id, stock_id, batch_number, category_id, name, order_point, warning_point, unit_price, quantity, date_created, last_modified,audit_activity,
	audit_time)
	VALUES(@product_id, @stock_id, @batch_number, @category_id, @name, @order_point, @warning_point, @unit_price, @quantity,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE STORE TABLE*/
CREATE TRIGGER updateProductTrigger ON 
Production.Store 
FOR UPDATE
AS 
	declare @product_id INT;
	declare @stock_id INT;
	declare @batch_number INT;
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @order_point INT;
	declare @warning_point INT;
	declare @unit_price MONEY;
	declare @quantity INT;
	declare @date_created DATE;
	declare @last_modified DATE;
	declare @activity VARCHAR(200);

	Select @product_id = s.product_id FROM inserted s;
	Select @stock_id = s.stock_id FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @order_point = s.order_point FROM inserted s;
	Select @warning_point = s.warning_point FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;

	if update(stock_id)	
		set @activity = 'Updated  store stock ID';
	if update(batch_number)	
		set @activity = 'Updated store batch number';
	if update(category_id)	
		set @activity = 'Updated store Category ID';
	if update(name)	
		set @activity = 'Updated store name';
	if update(order_point)	
		set @activity = 'Updated store order point';
	if update(warning_point)	
		set @activity = 'Updated store warning point';
	if update(unit_price)	
		set @activity = 'Updated store unit price';
	if update(quantity)	
		set @activity = 'Updated store quantity';
	if update(last_modified)	
		set @activity = 'Updated store last modified date';

	INSERT INTO AJ10972018_backup.Production.StoreBackup(
	product_id, stock_id, batch_number, category_id, name, order_point, warning_point, unit_price, quantity, date_created, last_modified,audit_activity,
	audit_time)
	VALUES(@product_id, @stock_id, @batch_number, @category_id, @name, @order_point, @warning_point, @unit_price, @quantity,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a record in the store table'
	GO
GO

/* A TRIGGER FOR DELETING A RECORD FROM THE STORE TABLE*/
CREATE TRIGGER deleteProductTrigger ON 
Production.Store 
FOR DELETE
AS 
	declare @product_id INT;
	declare @stock_id INT;
	declare @batch_number INT;
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @order_point INT;
	declare @warning_point INT;
	declare @unit_price MONEY;
	declare @quantity INT;
	declare @date_created DATE;
	declare @last_modified DATE;
	declare @activity VARCHAR(200);

	Select @product_id = s.product_id FROM inserted s;
	Select @stock_id = s.stock_id FROM inserted s;
	Select @batch_number = s.batch_number FROM inserted s;
	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @order_point = s.order_point FROM inserted s;
	Select @warning_point = s.warning_point FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;

	set @activity = 'Deleted a store record';
	
	INSERT INTO AJ10972018_backup.Production.StoreBackup(
	product_id, stock_id, batch_number, category_id, name, order_point, warning_point, unit_price, quantity, date_created, last_modified,audit_activity,
	audit_time)
	VALUES(@product_id, @stock_id, @batch_number, @category_id, @name, @order_point, @warning_point, @unit_price, @quantity,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='deleted a record from the store table'
	GO
GO

/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON ROLE TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE ROLE TABLE*/
CREATE TRIGGER insertRoleTrigger ON 
HR.Role 
FOR INSERT
AS 
	declare @role_id INT;
	declare @role_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @role_id = s.role_id FROM inserted s;
	Select @role_name = s.role_name FROM inserted s;
	
	set @activity = 'Record inserted in Role Table';

	INSERT INTO AJ10972018_backup.HR.RoleBackup(
	role_id, role_name, audit_activity,audit_time)
	VALUES(@role_id, @role_name, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE ROLE TABLE*/
CREATE TRIGGER updateRoleTrigger ON 
HR.Role 
FOR UPDATE
AS 
	declare @role_id INT;
	declare @role_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @role_id = s.role_id FROM inserted s;
	Select @role_name = s.role_name FROM inserted s;

	if update(role_name)	
		set @activity = 'Updated  Role name';
	
	INSERT INTO AJ10972018_backup.HR.RoleBackup(
	role_id, role_name, audit_activity,audit_time)
	VALUES(@role_id, @role_name, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a record in the role table'
	GO
GO

/* A TRIGGER FOR DELETING FROM THE ROLE TABLE*/
CREATE TRIGGER deleteRoleTrigger ON 
HR.Role 
FOR DELETE
AS 
	declare @role_id INT;
	declare @role_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @role_id = s.role_id FROM inserted s;
	Select @role_name = s.role_name FROM inserted s;

	set @activity = 'Deleted a Role record';
	
	INSERT INTO AJ10972018_backup.HR.RoleBackup(
	role_id, role_name, audit_activity,audit_time)
	VALUES(@role_id, @role_name, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='deleted a record from the role table'
	GO
GO

/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON STATUS TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE STATUS TABLE*/
CREATE TRIGGER insertStatusTrigger ON 
HR.Status 
FOR INSERT
AS 
	declare @status_id INT;
	declare @status_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @status_id = s.status_id FROM inserted s;
	Select @status_name = s.status_name FROM inserted s;
	
	set @activity = 'Record inserted in Status Table';

	INSERT INTO AJ10972018_backup.HR.StatusBackup(
	status_id, status_name, audit_activity,audit_time)
	VALUES(@status_id, @status_name, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE STATUS TABLE*/
CREATE TRIGGER updateStatusTrigger ON 
HR.Status 
FOR UPDATE
AS 
	declare @status_id INT;
	declare @status_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @status_id = s.status_id FROM inserted s;
	Select @status_name = s.status_name FROM inserted s;

	if update(status_name)	
		set @activity = 'Updated  Status name';
	
	INSERT INTO AJ10972018_backup.HR.StatusBackup(
	status_id, status_name, audit_activity,audit_time)
	VALUES(@status_id, @status_name, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a record in the status table'
	GO
GO


/* A TRIGGER FOR DELETING A RECORD FROM THE STATUS TABLE*/
CREATE TRIGGER deleteStatusTrigger ON 
HR.Status 
FOR DELETE
AS 
	declare @status_id INT;
	declare @status_name VARCHAR(35);
	declare @activity VARCHAR(200);


	Select @status_id = s.status_id FROM inserted s;
	Select @status_name = s.status_name FROM inserted s;

	set @activity = 'Deleted a Status record';
	
	INSERT INTO AJ10972018_backup.HR.StatusBackup(
	status_id, status_name, audit_activity,audit_time)
	VALUES(@status_id, @status_name, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='deleted a record from the status table'
	GO
GO


/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON CATEGORY TABLE
******************************************************************************************************************/
/*A TRIGGER FOR INSERTING INTO THE CATEGORY TABLE*/
CREATE TRIGGER insertCategoryTrigger ON 
Production.Category 
FOR INSERT
AS 
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @date_created DATETIME;
	declare @last_modified DATETIME;
	declare @activity VARCHAR(200);

	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;
	
	set @activity = 'Record inserted in Category Table';

	INSERT INTO AJ10972018_backup.Production.CategoryBackup(
	category_id, name, date_created,last_modified, audit_activity,audit_time)
	VALUES(@category_id, @name,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE CATEGORY TABLE*/
CREATE TRIGGER updateCategoryTrigger ON 
Production.Category 
FOR UPDATE
AS 
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @date_created DATETIME;
	declare @last_modified DATETIME;
	declare @activity VARCHAR(200);

	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;

	if update(name)	
		set @activity = 'Updated  Category name';
	if update(date_created)	
		set @activity = 'Updated  Category date created';
	if update(last_modified)	
		set @activity = 'Updated  Category last modified date';
	
	INSERT INTO AJ10972018_backup.Production.CategoryBackup(
	category_id, name, date_created,last_modified, audit_activity,audit_time)
	VALUES(@category_id, @name,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a record from the category table'
	GO
GO


/* A TRIGGER FOR DELETING A RECORD FROM THE CATEGORY TABLE*/
CREATE TRIGGER deleteCategoryTrigger ON 
Production.Category 
FOR DELETE
AS 
	declare @category_id INT;
	declare @name VARCHAR(35);
	declare @date_created DATETIME;
	declare @last_modified DATETIME;
	declare @activity VARCHAR(200);

	Select @category_id = s.category_id FROM inserted s;
	Select @name = s.name FROM inserted s;
	Select @date_created = s.date_created FROM inserted s;
	Select @last_modified = s.last_modified FROM inserted s;

	set @activity = 'Deleted a Category record';
	
	INSERT INTO AJ10972018_backup.Production.CategoryBackup(
	category_id, name, date_created,last_modified, audit_activity,audit_time)
	VALUES(@category_id, @name,@date_created,@last_modified, @activity, CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='deleted a record from the Category table'
	GO
GO

/*****************************************************************************************************************
/							ADD, EDIT AND DELETE TRIGGERS ON CUSTOMER_PRODUCT TABLE
******************************************************************************************************************/
/*
	NOTE: I created add, edit and delete triggers on the customer_product table (weak entity) also known as the sales table
			because i want to backup any sales transactions that occur in the database system. Besides, I want to know of any updates
			and deletes that happen on this table as they occure. 
*/
/*A TRIGGER FOR INSERTING INTO THE CUSTOMER PRODUCT TABLE*/
CREATE TRIGGER insertCustomerProductTrigger ON 
Sales.Customer_Product
FOR INSERT
AS 
	declare @customer_id INT;
	declare @user_id INT;
	declare @product_id INT;
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @total_price MONEY;
	declare @comment VARCHAR(250);
	declare @transaction_date DATETIME;
	declare @activity VARCHAR(200);

	Select @customer_id = s.customer_id FROM inserted s;
	Select @user_id = s.user_id FROM inserted s;
	Select @product_id = s.product_id FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @total_price = s.total_price FROM inserted s;
	Select @comment = s.comment FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s;
	
	set @activity = 'Record inserted in Customer Product Table';

	INSERT INTO AJ10972018_backup.Sales.Customer_ProductBackup(
	customer_id, user_id, product_id, quantity, unit_price, total_price, comment, transaction_date, audit_activity, audit_time)
	VALUES(@customer_id, @user_id, @product_id, @quantity, @unit_price, @total_price, @comment, @transaction_date, @activity,CURRENT_TIMESTAMP)
GO

/* A TRIGGER FOR UPDATING THE CUSTOMER PRODUCT TABLE*/
CREATE TRIGGER updateCustomerProductTrigger ON 
Sales.Customer_Product
FOR UPDATE
AS 
	declare @customer_id INT;
	declare @user_id INT;
	declare @product_id INT;
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @total_price MONEY;
	declare @comment VARCHAR(250);
	declare @transaction_date DATETIME;
	declare @activity VARCHAR(200);

	Select @customer_id = s.customer_id FROM inserted s;
	Select @user_id = s.user_id FROM inserted s;
	Select @product_id = s.product_id FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @total_price = s.total_price FROM inserted s;
	Select @comment = s.comment FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s;

	if update(customer_id)	
		set @activity = 'Updated  Customer Product customer Id';
	if update(user_id)	
		set @activity = 'Updated  Customer Product user Id';
	if update(product_id)	
		set @activity = 'Updated  Customer Product product Id';
	if update(quantity)	
		set @activity = 'Updated  Customer Product quantity';
	if update(unit_price)	
		set @activity = 'Updated  Customer Product unit price';
	if update(total_price)	
		set @activity = 'Updated  Customer Product total price';
	if update(comment)	
		set @activity = 'Updated  Customer Product comment';
	if update(transaction_date)	
		set @activity = 'Updated  Customer Product transaction date';
	
	INSERT INTO AJ10972018_backup.Sales.Customer_ProductBackup(
	customer_id, user_id, product_id, quantity, unit_price, total_price, comment, transaction_date, audit_activity, audit_time)
	VALUES(@customer_id, @user_id, @product_id, @quantity, @unit_price, @total_price, @comment, @transaction_date, @activity,CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Update',
		@body ='updated a record in the Customer_Product table also known as the sales table'
	GO
GO


/* A TRIGGER FOR DELETING A RECORD FROM THE CUSTOMER PRODUCT TABLE*/
CREATE TRIGGER deleteCustomerProductTrigger ON 
Sales.Customer_Product
FOR DELETE
AS 
	declare @customer_id INT;
	declare @user_id INT;
	declare @product_id INT;
	declare @quantity INT;
	declare @unit_price MONEY;
	declare @total_price MONEY;
	declare @comment VARCHAR(250);
	declare @transaction_date DATETIME;
	declare @activity VARCHAR(200);

	Select @customer_id = s.customer_id FROM inserted s;
	Select @user_id = s.user_id FROM inserted s;
	Select @product_id = s.product_id FROM inserted s;
	Select @quantity = s.quantity FROM inserted s;
	Select @unit_price = s.unit_price FROM inserted s;
	Select @total_price = s.total_price FROM inserted s;
	Select @comment = s.comment FROM inserted s;
	Select @transaction_date = s.transaction_date FROM inserted s;

	set @activity = 'Deleted a Customer Product record';
	
	INSERT INTO AJ10972018_backup.Sales.Customer_ProductBackup(
	customer_id, user_id, product_id, quantity, unit_price, total_price, comment, transaction_date, audit_activity, audit_time)
	VALUES(@customer_id, @user_id, @product_id, @quantity, @unit_price, @total_price, @comment, @transaction_date, @activity,CURRENT_TIMESTAMP)

	/*SENDS EMAIL*/
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name ='MailProfile',
		@recipients ='james@example.com',
		@subject ='Delete',
		@body ='Deleted a record from the Customer_Product table also known as the sales table'
	GO
GO

/*
/							CREATING VIEWS ON THE TABLES
*/

/*CREATING A VIEW ON THE STOCK TABLE*/
CREATE VIEW Production.StockView AS  
SELECT supplier_id, name, quantity, unit_price, order_date, inventory_date,batch_number,transaction_date,description 
FROM Production.Stock
GO

/*CREATING A VIEW ON THE PERSON TABLE*/
CREATE VIEW HR.PersonView AS  
SELECT person_id, first_name, last_name, gender, phone, email, addres
FROM HR.Person
GO

/*CREATING A VIEW ON THE STORE TABLE*/
CREATE VIEW Production.StoreView AS  
SELECT product_id, stock_id, batch_number, category_id, name, order_point, warning_point, unit_price, quantity   
FROM Production.Store
GO

/*CREATING A VIEW ON THE ROLE TABLE*/
CREATE VIEW HR.RoleView AS  
SELECT role_id, role_name 
FROM HR.Role
GO

/*CREATING A VIEW ON THE STATUS TABLE*/
CREATE VIEW HR.StatusView AS  
SELECT status_id, status_name 
FROM HR.Status
GO

/*CREATING A VIEW ON THE CATEGORY TABLE*/
CREATE VIEW Production.CategoryView AS  
SELECT category_id, name
FROM Production.Category
GO

/*CREATING A VIEW ON THE CUSTOMER PRODUCT TABLE*/
/*
	NOTE: This view is created from a weak entity. I need this view because the people handling sales would want to 
			see information about all sales made in a period of time. This view is called customerProductView and it
			serves as the sales table of the database. 
*/
CREATE VIEW Sales.customerProductView AS  
SELECT customer_id, user_id, product_id, quantity, unit_price, total_price, comment,transaction_date 
FROM Sales.Customer_Product
GO

/*****************************************************************************************************
										TASK 2.5
******************************************************************************************************/
/*
*	stored procedure for inserting a record in the person table
*/
CREATE PROCEDURE insertPerson
@first_name VARCHAR(35),
@last_name VARCHAR(35),
@gender VARCHAR(1),
@phone VARCHAR(15),
@email VARCHAR(100),
@addres VARCHAR(100)
AS 
BEGIN 
	INSERT INTO HR.Person(first_name, last_name, gender, phone, email, addres)
	VALUES(@first_name, @last_name, @gender, @phone, @email, @addres)
END
GO

/*
*	stored procedure for inserting a record in the Customer table
*/
CREATE PROCEDURE insertCustomer
@customer_id INT,
@account_number VARCHAR(20),
@account_name VARCHAR(50)
AS 
BEGIN 
	INSERT INTO Sales.Customer(customer_id, account_number, account_name)
	VALUES(@customer_id, @account_number, @account_name)
END
GO

/*
*	stored procedure for inserting a record in the Supplier table
*/
CREATE PROCEDURE insertSupplier
@supplier_id INT,
@company_name VARCHAR(50),
@country VARCHAR(50)
AS 
BEGIN 
	INSERT INTO Sales.Supplier(supplier_id, company_name, country)
	VALUES(@supplier_id, @company_name, @country)
END
GO

/*
*	stored procedure for inserting a record in the Staff table
*/
CREATE PROCEDURE insertStaff
@staff_id INT,
@dob DATE,
@salary INT
AS 
BEGIN 
	INSERT INTO HR.Staff(staff_id, dob, salary)
	VALUES(@staff_id, @dob, @salary)
END
GO

/*
*	stored procedure for inserting a record in the Role table
*/
CREATE PROCEDURE insertRole
@role_name VARCHAR(35)
AS 
BEGIN 
	INSERT INTO HR.Role(role_name)
	VALUES(@role_name)
END
GO

/*
*	stored procedure for inserting a record in the Status table
*/
CREATE PROCEDURE insertStatus
@staus_name VARCHAR(35)
AS 
BEGIN 
	INSERT INTO HR.Status(status_name)
	VALUES(@staus_name)
END
GO

/*
*	stored procedure for inserting a record in the Users table
*/
CREATE PROCEDURE insertUser
@user_id INT,
@role_id INT,
@status_id INT,
@username VARCHAR(20),
@password VARCHAR (100)
AS 
BEGIN 
	INSERT INTO HR.Users(user_id,role_id,status_id,username,password,last_loggedin)
	VALUES(@user_id,@role_id,@status_id,@username,@password,CURRENT_TIMESTAMP)
END
GO

/*
*	stored procedure for inserting a record in the Category table
*/
CREATE PROCEDURE insertCategory
@name VARCHAR(35)
AS 
BEGIN 
	INSERT INTO Production.Category(name,date_created,last_modified)
	VALUES(@name,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
END
GO

/*
*	stored procedure for inserting a record in the Stock table
*/
CREATE PROCEDURE insertStock
@supplier_id INT,
@name VARCHAR(35),
@quantity INT,
@unit_price MONEY,
@order_date DATE,
@inventory_date DATE,
@batch_number INT,
@description VARCHAR(250)
AS 
BEGIN 
	INSERT INTO Production.Stock(supplier_id,name,quantity,unit_price,order_date,inventory_date,batch_number,transaction_date,description)
	VALUES(@supplier_id,@name,@quantity,@unit_price,@order_date,@inventory_date,@batch_number,CURRENT_TIMESTAMP,@description)
END
GO

/*
*	stored procedure for inserting a record in the store table
*/
CREATE PROCEDURE insertProduct
@stock_id INT,
@batch_number INT,
@category_id INT,
@name VARCHAR(35),
@order_point INT,
@warning_point INT,
@unit_price MONEY,
@quantity INT
AS 
BEGIN 
	-- Fetch total stock in hand
	DECLARE @totalStockAmount INT
	SET  @totalStockAmount = (SELECT quantity FROM Production.Stock WHERE  stock_id=@stock_id)
	
	-- Checks if the total stock quantity is less than the order amount
	IF @totalStockAmount < @quantity
	BEGIN
		PRINT 'Sorry! insufficient quantity'
		RETURN -1
	END
	ELSE
	BEGIN
		/* update the Stock table*/
		UPDATE Production.Stock SET quantity = quantity - @quantity WHERE stock_id=@stock_id

		/*insert in to the store table*/
		INSERT INTO Production.Store(stock_id,batch_number,category_id,name,order_point,warning_point,unit_price,quantity,date_created,last_modified)
		VALUES(@stock_id,@batch_number,@category_id,@name,@order_point,@warning_point,@unit_price,@quantity,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
	END
END
GO


/*
*	stored procedure for inserting a record in the Sale table
*/
CREATE PROCEDURE insertSale
@customer_id INT,
@user_id INT,
@product_id INT,
@quantity INT,
@unit_price MONEY,
@comment VARCHAR(250)
AS 
BEGIN 
	-- Fetch total stock in hand
	DECLARE @totalStockAmount INT
	SET  @totalStockAmount = (SELECT quantity FROM Production.Store WHERE product_id = @product_id)
	
	-- Checks if the total stock quantity is less than the order amount
	IF @totalStockAmount < @quantity
	BEGIN
		PRINT 'Sorry! insufficient quantity'
		RETURN -1
	END
	ELSE
	BEGIN
		declare @total_price MONEY;
		set @total_price = @quantity*@unit_price;

		/* update the store table*/
		UPDATE Production.Store SET quantity = quantity - @quantity WHERE product_id = @product_id

		/*insert in to the sales table*/
		INSERT INTO Sales.Customer_Product(customer_id,user_id,product_id,quantity,unit_price,total_price,comment,transaction_date)
		VALUES(@customer_id,@user_id,@product_id,@quantity,@unit_price,@total_price,@comment,CURRENT_TIMESTAMP)
	END
END
GO


/*
* inserting in the person table
*/
EXEC insertPerson 'Alieu', 'Jallow', 'M','0572274469','alieujallow93@gmail.com','1 university Avenue';
GO
EXEC insertPerson 'David', 'Sampah', 'M','0579974469','sampah@gmail.com','Berekuso';
GO
EXEC insertPerson 'James', 'Smith', 'M','0272274467','smith@gmail.com','Adenta';
GO
EXEC insertPerson 'Josephine', 'Gomez', 'F','0588986547','josephine@gmail.com','Accra';
GO
EXEC insertPerson 'Maria', 'Dacosta', 'F','0598986597','maria@gmail.com','Tamale';
GO

EXEC insertPerson 'Joseph', 'Wukpan', 'M','0513474469','wukpan@gmail.com','Circle';
GO
EXEC insertPerson 'Isic', 'Boateng', 'M','0279974468','boateng@gmail.com','Adenkrebi';
GO
EXEC insertPerson 'Francis', 'Gatsi', 'M','0273376667','gatsi@gmail.com','East Legon';
GO
EXEC insertPerson 'Ruth', 'Smith', 'F','0298981111','ruths@gmail.com','Kitasse';
GO
EXEC insertPerson 'Suzan', 'Dacosta', 'F','0533336597','suzan@gmail.com','Takoradi';
GO

EXEC insertPerson 'Prince', 'Boateng', 'M','0512344469','prince@gmail.com','Kwabenya';
GO
EXEC insertPerson 'Brandon', 'Wachira', 'M','0279972222','brandong@gmail.com','Adenkrebi';
GO
EXEC insertPerson 'Musa', 'Barry', 'M','0273777667','musa@gmail.com','James town';
GO
EXEC insertPerson 'Yvet', 'Secka', 'F','0558988989','yvet@gmail.com','Kitasse';
GO
EXEC insertPerson 'Linda', 'Bamuda', 'F','0533887951','bamuda@gmail.com','Takoradi';
GO

EXEC insertPerson 'Ebrima', 'Sowe', 'M','0111117951','ebrima@gmail.com','londonCorner, Gambia';
GO
EXEC insertPerson 'Hariet', 'Damaras', 'F','0533822222','damaras@yahoo.com','stoke city, UK';
GO

/*
/ inserting in the customer table
*/
EXEC insertCustomer 1,'5105105105105100','Alieu Jallow'
GO
EXEC insertCustomer 2,'5105225105105100','David Sampah'
GO
EXEC insertCustomer 3,'5105105105105111','James Smith'
GO
EXEC insertCustomer 4,'5105102225105100','Josephine Gomez'
GO
EXEC insertCustomer 5,'5107788105105100','Youth Mobilization'
GO

/*
/ inserting in the supplier table
*/
EXEC insertSupplier 6,'gomez enterprise','Ghana'
GO
EXEC insertSupplier 7,'Urban Farmers','Gambia'
GO
EXEC insertSupplier 8,'Harvesters','Ghana'
GO
EXEC insertSupplier 9,'The 3 brothers','Kenya'
GO
EXEC insertSupplier 10,'Fresh Farm','Senegal'
GO

/*
/ inserting in the staff table
*/
EXEC insertStaff 11,'1992-10-10',8000
GO
EXEC insertStaff 12,'1991-09-10',5000
GO
EXEC insertStaff 13,'1980-09-09',5500
GO
EXEC insertStaff 14,'1985-10-11',6200
GO
EXEC insertStaff 15,'1993-11-11',3400
GO
EXEC insertStaff 16,'1964-01-02',16400
GO
EXEC insertStaff 17,'1970-11-12',13500
GO

/*
/ inserting in the role table
*/
EXEC insertRole 'Admin'
GO
EXEC insertRole 'Data Entry Clerk'
GO
EXEC insertRole 'Guest'
GO
EXEC insertRole 'Auditor'
GO
EXEC insertRole 'Normal User'
GO

/*
/ inserting in the status table
*/
EXEC insertStatus 'Active'
GO
EXEC insertStatus 'Suspended'
GO
EXEC insertStatus 'Pending'
GO
EXEC insertStatus 'Deleted'
GO
EXEC insertStatus 'On Review'
GO

/*
/ inserting in the user table
*/
EXEC insertUser 11,1,1,'princeB','1234'
GO
EXEC insertUser 12,2,1,'brandonW','2222'
GO
EXEC insertUser 13,3,2,'musaB','1235'
GO
EXEC insertUser 14,4,3,'yvetS','1111'
GO
EXEC insertUser 15,5,4,'lindaB','3333'
GO

/*
/ inserting in the Category table
*/
EXEC insertCategory 'Grains'
GO
EXEC insertCategory 'Tubers'
GO
EXEC insertCategory 'Vegetables'
GO
EXEC insertCategory 'Nuts'
GO
EXEC insertCategory 'Pastes'
GO

/*
/ inserting in the Stock table
*/
EXEC insertStock 6,'Rice',150,5,'2015-09-10','2015-09-10',0001,'Pure and White'
GO
EXEC insertStock 7,'Cassava',250,2,'2016-09-10','2016-09-11',0002,'Very Fresh'
GO
EXEC insertStock 8,'Onion',500,3,'2017-08-11','2017-08-12',0003,'Red onions'
GO
EXEC insertStock 9,'Groundnut',1000,7,'2018-02-11','2018-02-12',0004,'It has big grains'
GO
EXEC insertStock 10,'GroundnutPaste',2000,10,'2018-03-11','2018-03-13',0005,'very smooth'
GO
EXEC insertStock 10,'Yam',280,6,'2018-02-11','2018-03-13',0006,'sweet'
GO
EXEC insertStock 9,'Cassava',380,7,'2018-01-11','2018-02-13',0007,'White and Very Fresh'
GO
EXEC insertStock 7,'CocoYam',820,5.5,'2018-01-11','2018-02-15',0008,'need to be preprocessed before selling'
GO

/*
/ inserting in the store table
*/
EXEC insertProduct 1,0001,1,'Rice',50,75,5,150
GO
EXEC insertProduct 2,0002,2,'Cassava',100,125,2,250
GO
EXEC insertProduct 3,0003,3,'Onion',150,200,3,500
GO
EXEC insertProduct 4,0004,4,'Groundnut',250,500,7,1000
GO
EXEC insertProduct 5,0005,5,'GroundnutPaste',400,700,10,2000
GO

/*
/ inserting in the Sale Table
*/
EXEC insertSale 1,11,1,5,5,'sold out to customer'
GO
EXEC insertSale 2,12,2,10,2,'need to return change to customer'
GO
EXEC insertSale 3,13,3,15,3,'product is good'
GO
EXEC insertSale 4,14,4,20,7,'nice product'
GO
EXEC insertSale 5,15,5,25,10,'customer needs more'
GO

EXEC insertSale 1,12,1,5,5,'customer impressed'
GO
EXEC insertSale 1,12,1,10,5,'customer is happy'
GO
EXEC insertSale 2,13,3,15,3,'customer will come tomorrow for more'
GO
EXEC insertSale 2,13,4,20,7,'product will soon expire'
GO
EXEC insertSale 1,14,5,25,10,'product is running out of stock'
GO

/*****************************************************************************************************
										TASK 2.6
******************************************************************************************************/
/*stored procedure that prints the list of customers and the total amount the have ever spent on goods in descing order*/
CREATE PROCEDURE getCustomersTotalPurchase
AS 
BEGIN 
	WITH CustomerPurchase (cid, totalAmount)
	AS
	(
		SELECT Sales.Customer_Product.customer_id AS cid, SUM(Sales.Customer_Product.total_price) AS totalAmount
		FROM Sales.Customer_Product 
		GROUP BY Sales.Customer_Product.customer_id
	)
	SELECT p.first_name, p.last_name, p.gender, cp.totalAmount
	FROM HR.Person p
	INNER JOIN CustomerPurchase cp
		ON p.person_id=cp.cid
	ORDER BY cp.totalAmount DESC
END
GO

/*A stored procedure that list the product and the amount of sales made on each product*/
CREATE PROCEDURE getProductSales
AS
BEGIN
	WITH ProductSales (pid,totalQuantity,totalSale)
	AS
	(
		SELECT Sales.Customer_Product.product_id AS pid,SUM(Sales.Customer_Product.quantity) AS totalQuantity, SUM(Sales.Customer_Product.total_price) AS totalSale
		FROM Sales.Customer_Product 
		GROUP BY Sales.Customer_Product.product_id
	)
	SELECT p.name,ps.totalQuantity,ps.totalSale
	FROM Production.Store p
	INNER JOIN ProductSales ps
		ON p.product_id = ps.pid
	ORDER BY ps.totalSale DESC
END
GO

/*A store procedure that list products thatare in stock but not in the selling store*/
CREATE PROCEDURE getProductsNotInStore
AS
BEGIN
	SELECT s.name,s.order_date,s.quantity,sp.company_name, sp.country
	FROM Production.Stock s, Sales.Supplier sp
	WHERE s.stock_id NOT IN (SELECT p.stock_id FROM Production.Store p) 
	AND sp.supplier_id = s.supplier_id
END
GO

/*Lists all users of the system based on the given status*/
CREATE PROCEDURE getUsers
@status_id INT
AS
BEGIN
	SELECT u.username, r.role_name as role, s.status_name as status
	FROM HR.Users u, HR.Role r, HR.Status s
	WHERE u.role_id = r.role_id AND u.status_id = s.status_id AND  s.status_id = @status_id 
END
GO

/*List all sales of a particular date*/
CREATE PROCEDURE getSales
@date DATE
AS
BEGIN
	SELECT u.username as seller, p.first_name as customer,Pr.name as product,s.quantity,s.unit_price,s.total_price,s.comment,s.transaction_date
	FROM HR.Person p, Production.Store pr, HR.Users u, Sales.Customer_Product s
	WHERE s.user_id=u.user_id AND p.person_id=s.customer_id AND pr.product_id=s.product_id AND CONVERT(date,s.transaction_date)=@date
END
GO


/* A stored procedure that lists all the staff with their first name last name gender salary and age*/
CREATE PROCEDURE getAllStaff
AS
BEGIN
	SELECT  first_name, last_name,gender, salary,
    CASE
		WHEN DATEADD(YY,DATEDIFF(yy,dob,GETDATE()),dob)<GETDATE() 
		THEN DATEDIFF(yy,dob,GETDATE())
		ELSE DATEDIFF(yy,dob,GETDATE())-1 
    END AS age
	FROM HR.Staff s, HR.Person p
	WHERE s.staff_id=p.person_id
	ORDER BY dob
END
GO

EXEC getSales'2018-04-08'
GO
EXEC getUsers 1
GO
EXEC getProductsNotInStore
GO
EXEC getProductSales
GO
EXEC getCustomersTotalPurchase
GO
EXEC getAllStaff
GO