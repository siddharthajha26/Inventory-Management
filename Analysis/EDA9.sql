SELECT * FROM employees;
SELECT * FROM customers;
SELECT * FROM orderdetails;
SELECT * FROM orders;

-- Examining the data for highest order value by sales rep for recognition and rewards to boost employee performance


with t as
(
SELECT 
	employees.employeeNumber,
    employees.lastName,
    employees.firstName,
    employees.jobTitle,
    customers.customerName,
    orders.orderDate,
    orders.orderNumber
    -- orderdetails.productCode,
--     orderdetails.quantityOrdered*orderdetails.priceEach AS sales
    FROM customers
    JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
    JOIN orders ON orders.customerNumber = customers.customerNumber
    )
SELECT 
    t.employeeNumber,
    t.lastName,
    t.firstName,
    t.jobTitle,
    t.customerName,
    t.orderDate,
    orderdetails.quantityOrdered * orderdetails.priceEach AS order_value_sales_rep
    FROM orderdetails
    JOIN t ON t.orderNumber = orderdetails.orderNumber
    ORDER BY order_value_sales_rep DESC LIMIT 10;
    
-- The top performer across the range of orderDate is Larry Bott on 08-04-2005 of total order value 11503.14
    
    
    
    