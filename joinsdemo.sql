# SQL Joins
-- A join is a method of linking data between one (self-join) or 
-- more tables based on values of the common column between the tables.

/* MySQL supports the following types of joins:

Inner join
Left join
Right join
Cross join */

-- Inner Join - Returns only matching records from 2 tables

/* SELECT
    select_list
FROM t1
INNER JOIN t2 ON join_condition1
INNER JOIN t3 ON join_condition2
...; */

-- Query to display employeeCode, firstName & city of employees
USE classicmodels;

SELECT * FROM employees;
SELECT * FROM offices;

SELECT employeenumber, firstname,city FROM employees e INNER JOIN offices o ON e.officeCode=o.officecode;
		
-- Query to display productCode and productName from the products table.
-- and  textDescription of product lines from the productlines table.

SELECT productcode, productname, textdescription FROM products p INNER JOIN productlines pr ON p.productline=pr.productline;

-- USING clause -  If joined fields of both tables have same name --Natural Join
SELECT employeenumber, firstname,city,country FROM employees  INNER JOIN offices  USING(officecode);


# Design a query to display custNo, custName, SalesRepName of the customer
SELECT customernumber,customername,CONCAT(firstname,' ',lastname) 'sales rep',email FROM customers c INNER JOIN employees e ON c.salesRepEmployeeNumber=e.employeenumber;



-- Inner join with group by clause
SELECT * FROM orders;
SELECT * FROM orderdetails;

SELECT t1.status,SUM(quantityordered*priceeach) total FROM orders t1 INNER JOIN orderdetails t2 ON t1.ordernumber=t2.ordernumber GROUP BY t1.status;

-- Join 3 Tables
USE classicmodels;
SELECT ordernumber,orderdate,orderlinenumber,productname,quantityordered,priceeach FROM orders INNER JOIN orderdetails 
	USING(ordernumber) INNER JOIN products USING(productcode)
		ORDER BY ordernumber,orderlinenumber;



-- Joins with operators
-- The following query uses a less-than ( <) join to find sales price of the 
-- product whose code is S10_1678 that is less than the manufacturer’s 
-- suggested retail price (MSRP) for that product.
SELECT * FROM products WHERE productcode='S10_1678';

SELECT * FROM orderdetails WHERE productcode='S10_1678';

SELECT orderNumber, productName, msrp, priceEach FROM products p
INNER JOIN orderdetails o ON p.productCode = o.productCode
AND p.MSRP > o.priceEach
WHERE p.productCode = 'S10_1678';



# lEFT OUTER JOIN
-- LEFT JOIN returns all rows from the left table regardless of whether a row 
-- from the left table has a matching row from the right table or not. 
-- If there is no match, the columns of the row from the right table will contain NULL.

-- This query uses the LEFT JOIN clause to find all customers and their orders:
SELECT * FROM customers;
SELECT * FROM orders;

SELECT c.customernumber,customername,ordernumber,IFNULL(STATUS,'no orders')
FROM customers c LEFT JOIN orders o ON c.customerNumber=o.customerNumber ORDER BY STATUS DESC;


-- Left Join to find customers who have no order
SELECT c.customernumber,c.customername,o.ordernumber,STATUS FROM customers c
 LEFT JOIN orders o
  ON c.customerNumber=o.customerNumber WHERE ordernumber IS NULL;


-- Query to display All OrderNumbers, and their matching
-- CustomerNo & Prdct Code of 10123

SELECT o.ordernumber,o.customernumber,d.productcode FROM orders o
 LEFT JOIN orderdetails d
  ON o.orderNumber=d.orderNumber AND o.ordernumber=10123;


		
# RIGHT JOIN
-- RIGHT JOIN returns all rows from the right table regardless of 
-- having matching rows from the left table or not.

-- Query to display all Sales Rep , customer Id & Customer Name 

SELECT c.customernumber,c.customername,e.firstname 'sales rep' FROM customers c
 RIGHT  JOIN employees e
  ON c.salesrepemployeenumber=e.employeeNumber;

SELECT c.customerNumber, e.employeeNumber
	FROM customers c
		RIGHT  JOIN employees e
			ON c.salesRepEmployeeNumber=e.employeeNumber
				ORDER BY e.employeeNumber;

#Full Outer Join

-- returns all rows from the left table (table1) and from the 
-- right table (table2).
-- MY SQL DOESNOT SUPPORT FULL JOIN.. INSTEAD USE UNION WITH LEFT/RIGHT JOINS
SELECT t1.customerNumber, customerName, orderNumber, status from 
customers t1
		LEFT JOIN orders t2
				ON t1.customerNumber=t2.customerNumber
UNION
			
SELECT c.customerNumber, customerName, orderNumber, status from 
customers c
		RIGHT JOIN orders o
				ON c.customerNumber=o.customerNumber;



#Self Join
-- The self join is often used to query hierarchical data or to compare a row 
-- with other rows within the same table.
-- Joining a table to Itself, by Creating a virtual copy of a Table
USE classicmodels;
SELECT * FROM employees;

SELECT e.employeenumber, CONCAT(e.firstname,' ',e.lastname) employee, CONCAT(m.firstname,' ',m.lastname) AS 'reportsto'
FROM employees e LEFT JOIN employees m ON e.reportsto=m.employeeNumber;
 
# ***************************************************************************

#Sub Query

-- A MySQL subquery is a query that is nested inside another query.
-- A MySQL subquery is called an inner query while the query that contains the 
-- subquery is called an outer query.
-- Sub query acts a criteria for Outer query.
-- Syntax: SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);


# Display Employees who work in Offices located in USA

SELECT * FROM offices;
SELECT * FROM employees;
 SELECT employeenumber, lastname, firstname FROM employees 
 WHERE officecode
 IN (SELECT officecode FROM offices WHERE country='USA');

	

-- Find customers who have not placed any Orders

SELECT * FROM orders;
SELECT * FROM customers;

SELECT customernumber,customername FROM customers WHERE customernumber NOT IN(SELECT DISTINCT customernumber FROM orders);


-- Display products with price greater than '1958 Setra Bus'

SELECT * FROM products;

SELECT buyPrice FROM products WHERE productName='1958 Setra Bus';

SELECT productname,buyprice FROM products WHERE buyprice> (SELECT buyprice FROM products WHERE productname='1958 Setra Bus');



--  find customers whose payments are greater than the average payment

SELECT * FROM payments;

SELECT AVG(amount) FROM payments;

SELECT * FROM payments WHERE amount > (SELECT AVG(amount) FROM payments) 
	ORDER BY amount desc;
	
SELECT p.*,c.customerName FROM payments p INNER JOIN customers c
	ON p.customerNumber=c.customerNumber
	AND amount > (SELECT AVG(amount) FROM payments) 
	ORDER BY amount desc;
	
SELECT p.*,c.customerName FROM payments p INNER JOIN customers c
	USING(customerNumber)
	where amount > (SELECT AVG(amount) FROM payments) 
	ORDER BY amount desc;


