-- Profitability of Products
-- Not all SKUs are equally profitable.
-- Low-margin items consuming space should be deprioritized.
USE mintclassics;
SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered * od.priceEach) AS revenue,
    SUM(od.quantityOrdered * p.buyPrice) AS cost,
    (SUM(od.quantityOrdered * od.priceEach) - SUM(od.quantityOrdered * p.buyPrice)) AS profit,
    ROUND(SUM(od.quantityOrdered * od.priceEach) - SUM(od.quantityOrdered * p.buyPrice))/(SUM(od.quantityOrdered * od.priceEach))*100 AS profitperc
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
HAVING profit < 10000
ORDER BY profit ASC;

-- Insights: Product with low or negative profits should be the potential candidates for rationalisation.
-- As a result of query we indentify 1939 Chevrolet Delux Coupe as the potential candidate to be dropped considering the profit margins. 