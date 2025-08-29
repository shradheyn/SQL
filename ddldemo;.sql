# DDL Commands - CREATE, ALTER, DROP, TRUNCATE, RENAME

/*Data Definition Language actually consists of the SQL commands that can be used to define the database schema. 
It simply deals with descriptions of the database schema and is used to create and modify the structure of database objects in the database.
DDL is a set of SQL commands used to create, modify, and delete database structures but not data. */

/*Create a db -- Follow normalization -- reduce rendundacy

1NF - Atomicity (Single Value), Primary Key

2NF - 1NF , Functional Dependency, Foreign Key

3NF - 2NF, No transive Dependency */

-- Create Database


CREATE DATABASE coforgedb;
USE coforgedb;


-- create table


CREATE TABLE USER(id INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(25),
email VARCHAR(25));

CREATE TABLE department(deptid INT PRIMARY KEY AUTO_INCREMENT,
deptname VARCHAR(25) NOT NULL ,
fees FLOAT NOT NULL,
email VARCHAR(25) NOT NULL );

-- Display structure of Table

DESCRIBE USER;


-- create table & set primary key at field level
CREATE TABLE student(rollno INT(10) PRIMARY KEY,
firstname VARCHAR(25) NOT NULL,
middlename VARCHAR(25),
lastname VARCHAR(25) NOT NULL,
dob DATE NOT NULL,
did INT NOT NULL);




DESC student;
SHOW TABLES;

# ALTER Table
-- The MySQL ALTER TABLE statement is used to add, modify, or drop/delete columns 
-- in a table. The MySQL ALTER TABLE statement is also used to rename a table.

/* Syntax:  Add column in table
 ALTER TABLE table_name
  ADD new_column_name column_definition
    [ FIRST | AFTER column_name ];  */
    
-- Add new column city  
ALTER TABLE student ADD city VARCHAR(20) NOT NULL AFTER dob;


-- Modify column in a table

	ALTER TABLE student MODIFY city VARCHAR(25) NULL;
DESC student;

-- Rename column in a table
	ALTER TABLE student CHANGE COLUMN middlename midname VARCHAR(20) NULL;

# drop a column in table
ALTER TABLE student DROP COLUMN midname;


# rename table


ALTER TABLE department RENAME TO course;
SHOW TABLES;
-- Create a new Table copy from existing Table
CREATE TABLE studentcopy AS SELECT * FROM student;
DESC studentcopy;

-- Delete table
DROP TABLE studentcopy;


/* MySql Constraints:

The constraint in MySQL is used to specify the rule that allows or restricts what values/data will be stored in the table. 
They provide a suitable method to ensure data accuracy and integrity inside the table. 
It also helps to limit the type of data that will be inserted inside the table.
*/
# DEFAULT constraint - Specifies a default value when specified none for this column

/*
#Check constraint - It is an integrity constraint that controls the value in a particular column. 
It ensures the inserted or updated value in a column must be matched with the given condition.
*/

/*
#AUTO_INCREMENT Constraint
This constraint automatically generates a unique number whenever we insert a new record into the table. 
Generally, we use this constraint for the primary key field in a table.
*/

CREATE TABLE staff(id INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(25),
email VARCHAR(25),
city VARCHAR(20) DEFAULT 'bangalore',
doj DATETIME default NOW());

DESC staff;

	
-- Inserting data into staff table which has auto_increment & default values	
	INSERT INTO staff(name,email)VALUES('raj','raj@training.com');
		INSERT INTO staff(name,email)VALUES('mike','mike@training.com');
		INSERT INTO staff(name,email)VALUES('mary','mary@training.com');
	
	SELECT * FROM staff;
	


-- insert data into default columns

	INSERT INTO staff(name,email,city)VALUES('navin','navin@training.com','mumbai');
	
	INSERT INTO staff(name,email,city,doj)VALUES('harry','harry@training.com','noida','2017-06-01');
	
-- set the new seed value for AUTO_INCREMENT
ALTER TABLE staff auto_increment=100
	INSERT INTO staff(name,email,city,doj)VALUES('manoj','manoj@training.com','mumbai','2015-12-15');

	INSERT INTO staff(name,email,city,doj)VALUES('mahesh','mahesh@training.com','chennai',CURRENT_DATE );
-- # Check Constraint
-- CHECK constraint to ensure that values stored in a column or group of 
-- columns satisfy a Boolean expression.
ALTER TABLE staff ADD  salary DOUBLE(10,2) CHECK (salary>10000) AFTER doj;
ALTER TABLE staff MODIFY salary DOUBLE(10,2) CHECK (salary>10000) AFTER doj;
ALTER TABLE staff modify gender CHAR(10) CHECK (gender IN ('male','female')) AFTER doj;


-- Unique Constraint
/* A UNIQUE constraint is an integrity constraint that ensures values in a column 
or group of columns to be unique.  
A UNIQUE constraint can be either a column constraint or a table constraint. */

ALTER TABLE staff ADD phone INT NOT NULL UNIQUE;

-- throw check constraint error for gender
DESC staff;
INSERT INTO staff VALUES (500,'raj','raj@test.com','delhi','2018-12-07',15000,'mle');

-- throw check constraint error for salary





-- throw PRIMARY KEY constraint error for ID


-- throw check constraint error for salary



-- throw unique constraint error for phone no




-- not null constraint 

INSERT INTO staff VALUES (110,'navin','navin@mail.com','blr','2012-12-07',NULL,'female');


--- Creating Foreign Key Relationship

/* The foreign key is used to link one or more than one table 
together. It is also known as the referencing key. 
A foreign key matches the primary key field of another table. 
It means a foreign key field in one table refers to the primary key 
field of the other table. */

/* 
Syntax: [CONSTRAINT constraint_name]  
    FOREIGN KEY [foreign_key_name] (col_name, ...)  
    REFERENCES parent_tbl_name (col_name,...)  
    ON DELETE referenceOption  
    ON UPDATE referenceOption  */

USE coforge;

CREATE TABLE departments(
	d_id INT PRIMARY KEY,
	dept_name VARCHAR(15)
);

CREATE TABLE employees (
	emp_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	dob DATE NOT NULL,
	STATUS TINYINT NOT NULL,
	DESCRIPTION TEXT,
	doj TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	dept_id INT NOT NULL,
	CONSTRAINT fk_empDept FOREIGN KEY(dept_id)
	REFERENCES departments(d_id)
);

INSERT INTO departments VALUES(101,'CSE');
INSERT INTO departments VALUES(102,'Mech');
INSERT INTO departments VALUES(103,'EE');
SELECT * FROM departments;



INSERT INTO employees VALUES(1001,'Raj','Mark','2012-12-12',2,'Employees Salary and 
		Client payments',CURRENT_DATE, 101);

SELECT * FROM employees;

-- foreign key error
INSERT INTO employees VALUES(1002,'Raj','Mark','2012-12-12',2,'Employees Salary and 
		Client payments',CURRENT_DATE, 105);
INSERT INTO employees VALUES(1002,'Mary','John','2012-12-12',2,'Electrician',
				CURRENT_DATE, 101);

INSERT INTO employees VALUES(1002,'Mary','John','2012-12-12',2,'Electrician',
				CURRENT_DATE, 101);

INSERT INTO employees VALUES(1001,'Jk','John','2012-12-12',2,'Electrician',
				CURRENT_DATE, 103);

SELECT * FROM employees;

delete FROM departments WHERE d_id=101;
/* CASCADE: It is used when we delete or update any row from the 
parent table, the values of the matching rows in the child table 
will be deleted or updated automatically.

RESTRICT: It is used when we delete or update any row from the parent
table that has a matching row in the reference(child) table, 
MySQL does not allow to delete or update rows in the parent table. */

SELECT * FROM departments;

SELECT * FROM employees;

DELETE FROM departments WHERE d_id=103; -- Not allows to delete a record . bcoz of fk

UPDATE  departments SET dept_name='Royal Mech' WHERE d_id=102;

UPDATE  departments SET dept_name='Electrical' WHERE d_id=103;

UPDATE employees SET dept_id=101 WHERE emp_id=1003;

-- cascade demo

CREATE TABLE departments1( -- PRIMARY table
	d_id INT PRIMARY KEY,
	dept_name VARCHAR(15)
);

CREATE TABLE employees1( -- secondary table
	emp_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	dob DATE NOT NULL,
	STATUS TINYINT NOT NULL,
	DESCRIPTION TEXT,
	doj TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	dept_id INT NOT NULL,
	CONSTRAINT fk_empDept2 FOREIGN KEY(dept_id)
	REFERENCES departments1(d_id)
	ON DELETE cascade
	ON UPDATE RESTRICT
);

DESC employees1;
desc departments1;

INSERT INTO departments1 VALUES(101,'CSE');
INSERT INTO departments1 VALUES(102,'Mech');
INSERT INTO departments1 VALUES(103,'EE');
SELECT * FROM departments1;

INSERT INTO employees1 VALUES(1001,'Raj','Mark','2012-12-12',2,'Employees Salary and 
		Client payments',CURRENT_DATE, 101);
INSERT INTO employees1 VALUES(1002,'Mary','John','2012-12-12',2,'Electrician',
				CURRENT_DATE, 102);
INSERT INTO employees1 VALUES(1003,'Jk','John','2012-12-12',2,'Electrician',
				CURRENT_DATE, 103);

DELETE FROM departments1 WHERE d_id=103;
UPDATE departments1 SET d_id=111 WHERE d_id=101;
 