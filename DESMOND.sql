-- =============================================
-- Pine Valley Furniture Company Database
-- Complete SQL Script
-- =============================================

-- PART 1: DATA DEFINITION LANGUAGE (DDL)
-- =============================================

-- 1. Database Creation
CREATE DATABASE PineValleyFC;
USE PineValleyFC;

-- 2. Create Tables with Constraints
-- Parent table first
CREATE TABLE Customer_T (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerCity VARCHAR(50),
    CustomerState VARCHAR(50)
);

-- Parent table
CREATE TABLE Product_T (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    ProductFinish VARCHAR(50) CHECK (ProductFinish IN ('Natural Ash', 'Red Oak', 'Cherry', 'White Oak')),
    ProductStandardPrice DECIMAL(10,2) CHECK (ProductStandardPrice > 0)
);

-- Child table referencing Customer_T
CREATE TABLE Order_T (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer_T(CustomerID)
);

-- Child table referencing both Order_T and Product_T
CREATE TABLE OrderLine_T (
    OrderID INT,
    ProductID INT,
    OrderedQuantity INT CHECK (OrderedQuantity > 0),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Order_T(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product_T(ProductID)
);

-- 3. Schema Modification
ALTER TABLE Customer_T
ADD CustomerEmail VARCHAR2(50);

-- 4. Create Index
CREATE INDEX idx_product_price ON Product_T(ProductStandardPrice);

-- PART 2: DATA MANIPULATION LANGUAGE (DML)
-- =============================================

-- 1a. Insert Records
INSERT INTO Customer_T (CustomerID, CustomerName, CustomerCity, CustomerState) VALUES
(1100, 'John Mensah', 'Accra', 'Greater Accra'),
(1101, 'Jane Asante', 'Kumasi', 'Ashanti'),
(1102, 'Alice Boateng', 'Accra', 'Greater Accra'),
(1103, 'Bob Owusu', 'Kumasi', 'Ashanti'),
(1104, '[YOUR_FIRSTNAME]', 'Accra', 'Greater Accra'); -- Replace with your firstname

INSERT INTO Order_T (OrderID, OrderDate, CustomerID) VALUES
(1001, '2024-01-15', 1100),
(1002, '2024-02-20', 1101),
(1003, '2024-03-10', 1102),
(1004, '2024-04-05', 1103),
(1005, '2024-05-12', 1104);

INSERT INTO Product_T (ProductID, ProductName, ProductFinish, ProductStandardPrice) VALUES
(101, 'Office Desk', 'Natural Ash', 500.00),
(102, 'Ergonomic Chair', 'Red Oak', 350.00),
(103, 'Coffee Table', 'Cherry', 650.00),
(104, 'Bookcase', 'White Oak', 450.00),
(105, 'Bed Frame', 'Natural Ash', 750.00);

INSERT INTO OrderLine_T (OrderID, ProductID, OrderedQuantity) VALUES
(1001, 101, 5),
(1001, 102, 10),
(1002, 103, 8),
(1003, 104, 12),
(1004, 105, 15);

-- 1b. Insert Cherry Dining Table
INSERT INTO Product_T (ProductID, ProductName, ProductFinish, ProductStandardPrice)
VALUES (106, 'Cherry Dining Table', 'Cherry', 800.00);

-- 2a. Filtering & Sorting
SELECT CustomerName, CustomerCity, CustomerState
FROM Customer_T
WHERE CustomerCity IN ('Accra', 'Kumasi')
ORDER BY CustomerName;

-- 2b. Aggregate Functions
SELECT 
    MAX(ProductStandardPrice) AS Max_Price,
    MIN(ProductStandardPrice) AS Min_Price,
    AVG(ProductStandardPrice) AS Avg_Price
FROM Product_T;

-- 2c. Inner Join
SELECT O.OrderID, C.CustomerName
FROM Order_T O
INNER JOIN Customer_T C ON O.CustomerID = C.CustomerID;

-- 2d. Group By & Having
SELECT ProductID, SUM(OrderedQuantity) AS TotalQuantityOrdered
FROM OrderLine_T
GROUP BY ProductID
HAVING SUM(OrderedQuantity) > 10;

-- 3. Update Statement
UPDATE Customer_T
SET CustomerCity = 'Koforidua'
WHERE CustomerID = 1;

-- 4. Delete Statement
DELETE FROM Order_T
WHERE OrderDate < '2023-01-01';

-- PART 3: DATA CONTROL LANGUAGE (DCL)
-- =============================================

-- 1. Grant Permissions
GRANT SELECT, INSERT ON Order_T TO Sales_Clerk;

-- 2. Revoke Permissions
REVOKE DELETE ON Product_T FROM Sales_Clerk;

-- Verify Data
SELECT * FROM Customer_T;
SELECT * FROM Product_T;
SELECT * FROM Order_T;
SELECT * FROM OrderLine_T;