# Project - 3 Advanced Task Using Northwind Database


The Marketing Manager of the company want the company to refund a sum of money at the end of every year to the customers based on the following rules:

--------------------------------------------------------------------------------
 SECTION A) Quantity of purchases made by the worst customer
--------------------------------------------------------------------------------

 The sum of refund will be based on contribution of the worst customer (customer = Company Name),
 and he is the customer with lowest quantity of purchases in ALL 3 diffrent years (1996, 1997, 1998).

 1)
In case there is no customer who answers this condition the worst customer is a customer with lowest quantity of purchases in 2 diffrent years. 

2)
In case there is no customer who answers this condition the worst customer is the customer with lowest quantity of purchases TOTAL in all 3 years.

3)
The quantity found, the contribution of the worst customer, the value of lowest quantity of purchases whether its the same customer in all 3 years, 2 diffrent years
or just the worst customer total in all 3 years - that value will be used to calculate the refund percentage later on.

--------------------------------------------------------------------------------
SECTION B) Average quantity of purchases made by the best customer
--------------------------------------------------------------------------------

Find the best customer (customer = Company Name) in all 3 years, the customer that has the highest quantity of purchases in all 3 years total.
after finding the best customer find the Average quantity of purchases he made in all 3 diffrent years - that value will be used to calculate the refund percentage.

--------------------------------------------------------------------------------
SECTION C) Percentage of Refund
--------------------------------------------------------------------------------

The Percentage of Refund is the value found in section A divide by the value found in section B ( A / B ).

--------------------------------------------------------------------------------
SECTION D) Condition for a Refund
--------------------------------------------------------------------------------

A customer is eligible for a refund only if:
in one of the years 1996, 1997, 1998 he made at least 5 orders AND the revenue sum of all his orders was bigger than 15,000.

--------------------------------------------------------------------------------
SECTION E) Final Results
--------------------------------------------------------------------------------

Final Result:
Show the customers (Company Name) that are eligible for a refund, show the revenue sum of their purchases and refund sum.
(refund sum = revenue sum * the percentage of refund)
