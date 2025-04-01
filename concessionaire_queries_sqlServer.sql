/*
Analysis of Current Bad Practices:
Use of SELECT *: Selecting all columns without specifying only the necessary ones can cause excessive data transfer, negatively impacting query performance and efficiency.
Stack Overflow in Spanish
Implicit JOIN Syntax: Using the old comma syntax for joins (FROM Customers, Sales, Vehicles, Vendors, Maintenance) instead of explicit JOIN clauses decreases code readability and can lead to errors that are difficult to detect.
Lack of Aliases for Tables: Not assigning aliases to tables forces them to be referred to with full names, which makes the query longer and less clear.
Inefficient Use of LIKE with Leading Wildcards: The Vehicles.Brand LIKE '%Toyota%' condition uses a leading wildcard (%), which prevents indexes from being used efficiently and results in slower searches.​
LoadView
Application of Functions on Columns in the WHERE Clause: The expression YEAR(Sales.SaleDate) = 2025 applies a function to each row in the SalesDate column, which can prevent the use of indexes and degrade query performance.
Lack of Outer Join to Include All Records: By not using a Left or Right Join, vehicles without maintenance records are excluded from the results, which can lead to an incomplete view of the data.

Conclusion:
This query incorporates multiple bad practices that negatively affect its performance, clarity, and maintainability. It is essential to adopt good practices when writing SQL queries to ensure efficient and maintainable systems.
*/

-- Query that retrieves detailed information on sales, customers, vehicles, vendors, and maintenance
-- with multiple bad practices that affect performance and code clarity.
SELECT *
FROM Customers, Sales, Vehicles, Vendors, Maintenance
WHERE Customers.CustomerID = Sales.CustomerID
AND Sales.VehicleID = Vehicles.VehicleID
AND Sales.VendedorID = Vendors.VendedorID
AND Vehicles.VehicleID = Maintenance.VehicleID
AND Vehicles.Brand LIKE '%Toyota%'
AND YEAR(Sales.SalesDate) = 2025
ORDER BY Sales.SalesDate DESC;

/*
Best Practices Applied:
Specific Column Selection: Only the necessary columns are selected, avoiding the use of SELECT *, which improves performance and reduces resource consumption.
Use of Descriptive Aliases: Aliases are used for both tables and columns, improving code readability and maintainability.
Proper Joins: INNER JOIN is used to ensure that only matching records are included, and LEFT JOIN is used to include records that may not match, as needed for the analysis.
Logical Ordering: The ORDER BY clause organizes the results coherently, facilitating data interpretation.
This query provides a comprehensive view of the dealership's sales operations, allowing for an efficient and structured analysis of the relationship between customers, vehicles, salespeople, and maintenance.
*/

-- Query that retrieves sales details, including customer information,
-- vehicle, salesperson, and associated maintenance records.
SELECT
C.CustomerID,
C.FirstName AS CustomerName,
C.LastName AS CustomerLastName,
C.Email AS CustomerEmail,
V.VehicleID,
V.Make,
V.Model,
V.Year,
V.Type,
V.Price AS VehiclePrice,
Ven.SaleID,
Ven.SalesDate,
Ven.SalesPrice,
Ven.SalespersonID,
Vend.FirstName AS SalespersonName,
Vend.LastName AS SalespersonLastName,
M.MaintenanceID,
M.MaintenanceDate,
M.Description AS MaintenanceDescription,
M.Cost AS MaintenanceCost
FROM
Customers AS C
INNER JOIN Sales AS Ven ON C.CustomerID = Ven.CustomerID
INNER JOIN Vehicles AS V ON Ven.VehicleID = V.VehicleID 
INNER JOIN Vendors AS Vend ON Ven.SellerID = Vend.SellerID 
LEFT JOIN Maintenance AS M ON V.VehicleID = M.VehicleID
ORDER BY 
C.ClientID, 
Ven.DateSale, 
M.MaintenanceDate;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Analysis of Current Bad Practices:

Using SELECT *: Selecting all columns without specifying only the necessary ones can cause excessive data transfer, negatively affecting query performance and efficiency.​
Implicit JOIN Syntax: Using the old comma syntax for joins (FROM Customers AS C, Sales AS V, ...) instead of explicit JOIN clauses decreases code readability and can lead to errors that are difficult to detect.
Lack of Aliases in Join Conditions: Not using aliases in join conditions can create ambiguity and make code difficult to read and maintain.
Using Functions on Columns in the WHERE Clause: The expression YEAR(V.SalesDate) = 2025 applies a function to each row in the SalesDate column, which can prevent the use of indexes and degrade query performance.
Inefficient Use of LIKE with Leading Wildcards: The VH.Marca LIKE '%Toyota%' condition uses a leading wildcard (%), which prevents indexes from being used efficiently and results in slower searches.
Sort By Expression Instead of Column: Sorting by DATEPART(yy, V.DateSale) instead of by the column itself can impact performance, as a function is applied to each row during sorting.

Conclusion:
This query incorporates multiple bad practices that negatively impact its performance, clarity, and maintainability. Adopting good practices when writing SQL queries is essential to ensure efficient and maintainable systems.
*/

-- Use of SELECT * to return all columns from the tables involved
SELECT *
FROM Customers AS C
-- Use of implicit JOIN instead of explicit JOIN
, Sales AS S
, Vehicles AS V
, Salespersons AS SP
, MaintenanceRecords AS M
WHERE
-- Lack of aliases in join conditions
C.CustomerID = S.CustomerID
AND S.VehicleID = V.VehicleID
AND S.SalespersonID = SP.SalespersonID
AND V.VehicleID = M.VehicleID
-- Use of column functions in the WHERE clause
AND YEAR(S.SalesDate) = 2025
-- Use of LIKE with leading wildcards
AND V.Brand LIKE '%Toyota%'
ORDER BY
-- Ordering by an expression instead of a column
DATEPART(yy, S.SalesDate) DESC;

/*
Best Practices Applied:

Use of CTEs: Common Table Expressions improve query readability and modularity, allowing complex operations to be broken down into more manageable parts.
Specific Column Selection: Only the necessary columns are selected, avoiding the use of SELECT *, which improves performance and reduces resource consumption.
Descriptive Aliases: Aliases are used for both tables and columns, improving code clarity and maintainability.
Proper Joins: INNER JOIN is used to ensure only matching records are included, and LEFT JOIN is used to include records that may not match, as needed for the analysis.
Logical Ordering: The ORDER BY clause organizes the results coherently, facilitating data interpretation.
This query provides a comprehensive view of the dealership's operations, allowing for an efficient and structured analysis of the relationship between customers, vehicles, salespeople, and maintenance.
*/

-- Common Table Expression (CTE) to calculate total sales per customer
WITH TotalSalesPerCustomer AS (
    SELECT
        s.CustomerID,
        COUNT(s.SaleID) AS TotalPurchases,
        SUM(s.SalePrice) AS TotalAmountSpent
    FROM
        Sales s
    GROUP BY
        s.CustomerID
)
-- Main query that joins multiple tables and uses the CTE
SELECT
    c.CustomerID,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    c.Email AS CustomerEmail,
    tv.TotalPurchases,
    tv.TotalAmountSpent,
    v.VehicleID,
    v.Make,
    v.Model,
    v.Year,
    v.Type,
    v.Price AS VehiclePrice,
    s.SaleID,
    s.SaleDate,
    s.SalePrice,
    s.SalespersonID,
    sp.FirstName AS SalespersonFirstName,
    sp.LastName AS SalespersonLastName,
    m.MaintenanceID,
    m.MaintenanceDate,
    m.Description AS MaintenanceDescription,
    m.Cost AS MaintenanceCost
FROM
    Customers c
    INNER JOIN TotalSalesPerCustomer tv ON c.CustomerID = tv.CustomerID
    INNER JOIN Sales s ON c.CustomerID = s.CustomerID
    INNER JOIN Vehicles v ON s.VehicleID = v.VehicleID
    INNER JOIN Salespersons sp ON s.SalespersonID = sp.SalespersonID
    LEFT JOIN Maintenance m ON v.VehicleID = m.VehicleID
ORDER BY
    c.CustomerID,
    s.SaleDate,
    m.MaintenanceDate;

