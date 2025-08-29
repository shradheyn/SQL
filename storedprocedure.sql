#Stored Procedure

/*A stored procedure is a set of Structured Query Language (SQL) statements with an 
assigned name, which are stored in a relational database management system (RDBMS) 
as a group, so it can be reused and shared by multiple programs.

Stored procedures can access or modify data in a database, but it is not tied to a 
specific database or object, which offers a number of advantages.
*/

-- Normally Queries are not saved
-- If you want to save any query on the database server for execution later, one way 
-- to do it is to use a stored procedure.

USE classicmodels;

SELECT 
    customerName, 
    city, 
    state, 
    postalCode, 
    country
FROM
    customers
ORDER BY customerName;

/*The following CREATE PROCEDURE statement creates a new stored procedure that 
 wraps the query above: */

-- Create Stored Procedure

delimiter $$
CREATE PROCEDURE getmycustomers()
	begin
		SELECT 
	    customerName, 
	    city, 
	    state, 
	    postalCode, 
	    country
			FROM
	    customers
			ORDER BY customerName;
	END$$
	
delimiter;

-- invoke stored procedure

CALL getmycustomers();

SELECT * FROM employyes;
SELECT * FROM offices;

delimiter  $$
CREATE PROCEDURE getmyemployees()
	BEGIN
	
		SELECT e.employeeNumber,CONCAT(lastName,' ',firstName),
		email, jobTitle, ofc.city,ofc.country
		 FROM employees e 
			INNER JOIN offices ofc
			ON e.officeCode=ofc.officeCode;
	END$$
delimiter ;

CALL getmyemployees();


delimiter //

CREATE PROCEDURE getofficebycountry (IN countryname VARCHAR(255))
BEGIN 
	SELECT *
	FROM offices
	WHERE country = countryname;
END //
delimiter ;

-- call sp with in parameter 
CALL getofficebycountry('usa');
CALL getofficebycountry('france');

/*OUT parameters
The value of an OUT parameter can be changed inside the stored procedure 
and its new value is passed back to the calling program.

Notice that the stored procedure cannot access the initial value of the 
OUT parameter when it starts.*/

-- stored procedure returns the number of orders by order status.

delimiter $$
CREATE PROCEDURE GetOrderCountByStatus (
	IN orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE STATUS = orderStatus;
END $$

delimiter ;

SELECT * FROM orders ORDER BY status;

CALL GetOrderCountByStatus('Shipped', @total);
SELECT @total AS TotalShipped;

CALL GetOrderCountByStatus('Cancelled', @total);
SELECT @total AS TotalCancelled;

CALL GetOrderCountByStatus('In Process', @total);
SELECT @total AS InProcess;

CALL GetOrderCountByStatus('Disputed', @total);
SELECT @total AS Dispute;

/*
 The stored procedure SetCounter() accepts one INOUT parameter ( counter ) 
 and one IN parameter ( inc ). 
 It increases the counter ( counter ) by the value specified by the inc parameter.*/
 
 -- inout parameter
 
 delimiter $$
 CREATE PROCEDURE setcounter(
 INOUT counter INT,
 IN inc int
 )
 BEGIN 
 SET counter=counter+inc;
 END$$
 delimiter ;
 
 -- call the setcounter stored procedure
 SET @counter = 1;
 CALL SETcounter(@counter,1); -- 2
 SELECT @counter;
 
 CALL SETcounter(@counter,1); -- 3
 SELECT @counter;
 
 CALL SETcounter(@counter,5); -- 8
 SELECT @counter;
 
 -- Listing Stored Procedures

-- Shows all stored procedures in the current MySQL server:
SHOW PROCEDURE STATUS;

-- lists all stored procedures in the sample database classicmodels:
SHOW PROCEDURE STATUS WHERE db = 'classicmodels';
   