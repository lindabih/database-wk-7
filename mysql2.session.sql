USE bidb;
/*Question 1 Achieving 1NF (First Normal Form).In the table above, the Products column contains multiple values, which violates 1NF.
Write an SQL query to transform this table into 1NF, ensuring that each row represents a single product for an order.*/ 
/*First, create the original ProductDetail table and insert the sample data:*/
CREAT TABLE productdetail (
OrderID INT,
CustomerName VARCHAR(50),
Products VARCHAR(100)
);
INSERT INTO productdetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

/*To achieve 1NF and ensure each row contains only one product per order, use the following SQL (assuming support for recursive CTEs, e.g., MySQL 8+, SQL Server, or PostgreSQL):*/

WITH RECURSIVE SplitProducts AS (
SELECT
OrderID,
CustomerName,
TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
CASE WHEN Products LIKE '%,%' THEN
SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2)
ELSE NULL END AS Rest
FROM ProductDetail
UNION ALL
SELECT
OrderID,
CustomerName,
TRIM(SUBSTRING_INDEX(Rest, ',', 1)),
CASE WHEN Rest LIKE '%,%' THEN
SUBSTRING(Rest, LENGTH(SUBSTRING_INDEX(Rest, ',', 1)) + 2)
ELSE NULL END
FROM SplitProducts
WHERE Rest IS NOT NULL AND Rest != ''
)
SELECT OrderID, CustomerName, Product
FROM SplitProducts
WHERE Product IS NOT NULL AND Product != '';
/*This query transforms the ProductDetail table into 1NF, producing a result where each row represents a single product for an order.*/

/*Question 2 Achieving 2NF (Second Normal Form) 🧩
You are given the following table OrderDetails, which is already in 1NF but still contains partial dependencies:*/
/*Create the original OrderDetails table and insert sample data*/

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerName VARCHAR(100)
);
-- Create the OrderDetails table with a composite primary key
CREATE TABLE OrderDetails (
OrderID INT,
ProductName VARCHAR(100),
Quantity INT,
Price DECIMAL(10,2),
PRIMARY KEY (OrderID, ProductName),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Example of inserting data into Orders
INSERT INTO Orders (OrderID, CustomerName)
VALUES (101, 'John Doe'),
(103, 'Jane Smith');
-- Example of inserting data into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductName, Quantity, Price)
VALUES (101, 'Mouse', 1, 10.00),
(103, 'Monitor', 1, 120.00);
This design ensures that each non-key attribute in both tables is fully functionally dependent on the entire primary key, thus achieving 2NF.

-- Create a separate Orders table to remove partial dependency of CustomerName on OrderID
CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerName VARCHAR(100)
);
-- Create OrderDetails table with OrderID and Product as the composite key
CREATE TABLE OrderDetails (
OrderID INT,
Product VARCHAR(100),
Quantity INT,
PRIMARY KEY (OrderID, Product),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Insert data into Orders
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');
-- Insert data into OrderDetails
INSERT INTO OrderDetails (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);


