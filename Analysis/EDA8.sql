-- Customer payment behavior
SELECT * FROM customers;
SELECT * FROM payments;
SELECT * FROM orders;
--  We shall examine the data for any relationship between credit limit and total_orders
SELECT 
	customers.customerName,
    customers.country,
    customers.creditLimit,
	SUM(payments.amount) total_order_value,
    COUNT(orders.orderNumber) AS total_orders
    FROM customers
    JOIN payments ON customers.customerNumber = payments.customerNumber
    JOIN orders on customers.customerNumber =orders.customerNumber
    GROUP BY customers.customerName,
    customers.country,
    customers.creditLimit
	ORDER BY total_order_value DESC LIMIT 20;
-- Euro+ Shopping Channel has the maximum available credit limit with most number of orders 
-- Examining the data for least credit limit utilisation by a customer based on the amount of payment made by the customer.
WITH t AS
(
SELECT 
	customers.customerName,
    customers.country,
    customers.creditLimit,
    payments.paymentDate,
    payments.amount,
    COUNT(orders.orderNumber) AS total_orders
    FROM customers
    JOIN payments ON customers.customerNumber = payments.customerNumber
    JOIN orders on customers.customerNumber =orders.customerNumber
    GROUP BY customers.customerName,
    customers.country,
    customers.creditLimit,
    payments.paymentDate,
    payments.amount
    ORDER BY customers.creditLimit DESC
 )
 SELECT 
	t.customerName,
	t.creditLimit/t.amount AS Credit_util
    FROM 
    t
    WHERE 
    t.creditLimit/t.amount < 1
    GROUP BY t.customerName, t.creditLimit,t.amount;
    
     -- As evident from the results of the query Dragon Souveniers,Ltd has  a credit utilisation of less than 1 which means they are barely utilising the available credit limit and 
     -- may be contacted for further assistance in order to prevent customer churn 
    
