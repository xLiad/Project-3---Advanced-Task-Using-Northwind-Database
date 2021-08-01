-- The Marketing Manager of the company want the company to refund a sum of money at the end of every year to the customers based on the following rules:

--------------------------------------------------------------------------------
-- SECTION A) Quantity of purchases made by the worst customer
--------------------------------------------------------------------------------

-- The sum of refund will be based on contribution of the worst customer (customer = Company Name),
-- and he is the customer with lowest quantity of purchases in ALL 3 diffrent years (1996, 1997, 1998).

-- 1)
-- In case there is no customer who answers this condition the worst customer is a customer with lowest quantity of purchases in 2 diffrent years. 

-- 2)
-- In case there is no customer who answers this condition the worst customer is the customer with lowest quantity of purchases TOTAL in all 3 years.

-- 3)
-- The quantity found, the contribution of the worst customer, the value of lowest quantity of purchases whether its the same customer in all 3 years, 2 diffrent years
-- or just the worst customer total in all 3 years - that value will be used to calculate the refund percentage later on.

--------------------------------------------------------------------------------
-- SECTION B) Average quantity of purchases made by the best customer
--------------------------------------------------------------------------------

-- Find the best customer (customer = Company Name) in all 3 years, the customer that has the highest quantity of purchases in all 3 years total.
-- after finding the best customer find the Average quantity of purchases he made in all 3 diffrent years - that value will be used to calculate the refund percentage.

--------------------------------------------------------------------------------
-- SECTION C) Percentage of Refund
--------------------------------------------------------------------------------

-- The Percentage of Refund is the value found in section A divide by the value found in section B ( A / B ).

--------------------------------------------------------------------------------
-- SECTION D) Condition for a Refund
--------------------------------------------------------------------------------

-- A customer is eligible for a refund only if:
-- in one of the years 1996, 1997, 1998 he made at least 5 orders AND the revenue sum of all his orders was bigger than 15,000.

--------------------------------------------------------------------------------
-- SECTION E) Final Results
--------------------------------------------------------------------------------

-- Final Result:
-- Show the customers (Company Name) that are eligible for a refund, show the revenue sum of their purchases and refund sum.
-- (refund sum = revenue sum * the percentage of refund)

---------------------------------------
--ANSWER:
---------------------------------------
-- * Its just one query so you can run it by simple clicking F5.
-- * There are comments showing the relevent values found for the exercise in the Messages tab

USE NORTHWIND
;
-------------------------------------------------------
-- Declaring variables that will hold the relevent values
-------------------------------------------------------
DECLARE @WorstCustomer INT,
        @BestCustomer VARCHAR(MAX),
		@BestCustomerAVG INT,
		@RefundPerc DECIMAL
;
--------------------------------------------------------------------------------------------------------------------------
-- Worst customer in all the 3 diffrent years / worst customer in 2 diffrent years / worst customer in 3 years total
--------------------------------------------------------------------------------------------------------------------------
WITH CTE_Worst_Customer
AS
(
SELECT TOP 1 C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
GROUP BY C.CompanyName
ORDER BY [Quantity of products ordered] 
)
SELECT @WorstCustomer = CTE_Worst_Customer.[Quantity of products ordered]
FROM CTE_Worst_Customer
ORDER BY CTE_Worst_Customer.[Quantity of products ordered]
;
------------------------------------------------------------------------------------------
-- Finding the best customer in 3 years
-------------------------------------------------------------------------------------------
WITH CTE_Best_Customer
AS
(
SELECT  C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
GROUP BY C.CompanyName
)
SELECT TOP 1 @BestCustomer = CTE_Best_Customer.CompanyName
FROM CTE_Best_Customer
ORDER BY CTE_Best_Customer.[Quantity of products ordered] DESC
;

-------------------------------------------------------------
-- Avg quantity of the best customer in 3 years
-------------------------------------------------------------
WITH CTE_Best_Customer_AVG
AS
(
SELECT  C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1996)
GROUP BY C.CompanyName
UNION ALL
SELECT C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1997)
GROUP BY C.CompanyName
UNION ALL
SELECT C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1998)
GROUP BY C.CompanyName
)
SELECT @BestCustomerAVG = AVG (CTE_Best_Customer_AVG.[Quantity of products ordered])
FROM CTE_Best_Customer_AVG
;

------------------------------------------------------------------
-- Setting value of refund percentage based on the conditions made
------------------------------------------------------------------

SET @RefundPerc = (@WorstCustomer / @BestCustomerAVG)

-------------------------------------------------------------------
-- Printing messages with the results found so far
-------------------------------------------------------------------

PRINT '----------------------------------------------------------'
PRINT ('The quantitiy ordered by the worst customer in 3 year:')
PRINT @WorstCustomer
PRINT '----------------------------------------------------------'
PRINT ('The best customer in 3 years:')
PRINT @BestCustomer
PRINT '----------------------------------------------------------'
PRINT ('The Avg quantity ordered in 3 years by the best customer:')
PRINT @BestCustomerAVG
PRINT '----------------------------------------------------------'
PRINT ('The Refund Percentage:')
PRINT ('0.6 %')
PRINT '----------------------------------------------------------'
;

-------------------------------------------------------
-- Customer that are eligible for money return
-------------------------------------------------------
WITH CTE_Eligible_Customers
AS
( 
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1996 
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND 
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
UNION 
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1997
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND 
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
UNION
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1998 
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
)
SELECT CTE_Eligible_Customers.[Eligible Customer],
       FORMAT (CTE_Eligible_Customers.[Orders Sum],'#,#0') AS "Revnue Sum",
	   FORMAT (CTE_Eligible_Customers.[Orders Sum] * 0.006, '#,#0') AS "Refund Sum"
FROM CTE_Eligible_Customers
;


