-- Exploring Customers and Sales Patterns and the top 50 Customers in terms of Revenue generated from Sales
USE mintclassics;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM orderdetails;
SELECT * FROM products;
-- Order value by customer
SELECT 
	    customers.customerName,
		orders.orderDate,
	orderDetails.productCode,
	orderDetails.quantityOrdered,
	orderDetails.priceEach,
    orderDetails.quantityOrdered*orderDetails.priceEach AS Product_order_value 
    FROM orders
	JOIN customers  ON  orders.customerNumber = customers.customerNumber
    JOIN orderDetails ON orders.orderNumber = orderDetails.orderNumber
    GROUP BY customers.customerName, orders.orderDate,
	orderDetails.productCode,
	orderDetails.quantityOrdered,
	orderDetails.priceEach
    ORDER BY Product_order_value DESC LIMIT 50;
-- grouping Product_order_value by customerName,productCode 
with t as
(
SELECT 
	    customers.customerName,
		orderDetails.productCode,
		orderDetails.quantityOrdered*orderDetails.priceEach AS Product_order_value
    FROM orders
	JOIN customers  ON  orders.customerNumber = customers.customerNumber
    JOIN orderDetails ON orders.orderNumber = orderDetails.orderNumber
    GROUP BY customers.customerName, 
	orderDetails.productCode,
	orderDetails.quantityOrdered,
	orderDetails.priceEach
    ORDER BY Product_order_value ASC
    )
    SELECT t.productCode,t.Product_order_value ,products.productName
    FROM t
    JOIN products ON t.productCode = products.productCode
    WHERE t.Product_order_value < 2000 
    GROUP BY t.productCode,t.Product_order_value
    ORDER BY t.Product_order_value ASC  ;
    
 -- As evident from the results of the query products with total customer orders below 2000 are to be identified as a target audience for Product Promotions

 
