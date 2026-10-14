-- Project: Retail Sales and Customer Analytics
-- Database: retail_analytics
-- Table: online_retail
-- Tool: MySQL Workbench

-- 1. DATABASE AND TABLE SETUP
CREATE DATABASE retail_analytics;
USE retail_analytics;

CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(100)
);

-- 2. DATA EXPLORATION

-- Check available databases and tables
SHOW DATABASES;
SHOW TABLES;

-- Total number of records
SELECT COUNT(*) 
FROM online_retail;


-- Preview records
SELECT *
FROM online_retail
LIMIT 10;

-- Check table structure
DESCRIBE online_retail;

-- Count unique full-row combinations
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT InvoiceNo, StockCode, Description, Quantity,
           InvoiceDate, UnitPrice, CustomerID, Country) AS unique_rows
FROM online_retail;

-- 3. DATA QUALITY CHECKS

-- Check NULL values in each column
SELECT
    COUNT(*) AS total_rows,
    SUM(InvoiceNo IS NULL) AS missing_invoice,
    SUM(StockCode IS NULL) AS missing_stockcode,
    SUM(Description IS NULL) AS missing_description,
    SUM(Quantity IS NULL) AS missing_quantity,
    SUM(InvoiceDate IS NULL) AS missing_date,
    SUM(UnitPrice IS NULL) AS missing_price,
    SUM(CustomerID IS NULL) AS missing_customer,
    SUM(Country IS NULL) AS missing_country
FROM online_retail;

-- Find duplicate full-row records
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Count negative quantities 
SELECT
    COUNT(*) AS negative_quantity_records
FROM online_retail
WHERE Quantity < 0;

-- Inspect examples of negative quantities
SELECT *
FROM online_retail
WHERE Quantity < 0
LIMIT 10;

-- Count cancellation invoices
SELECT COUNT(*) AS cancellation_records
FROM online_retail
WHERE InvoiceNo LIKE 'C%';

-- Count zero or negative prices
SELECT COUNT(*) AS invalid_price_records
FROM online_retail
WHERE UnitPrice <= 0;

-- Inspect examples of invalid prices
SELECT *
FROM online_retail
WHERE UnitPrice <= 0
LIMIT 10;


-- Count blank or NULL descriptions
SELECT COUNT(*) AS blank_descriptions
FROM online_retail
WHERE Description IS NULL
   OR TRIM(Description) = '';
   
-- Count missing or blank customer IDs
   SELECT COUNT(*) AS missing_customer_records
FROM online_retail
WHERE CustomerID IS NULL
   OR TRIM(CustomerID) = '';
   
   
 -- Number of records by country  
   SELECT
    Country,
    COUNT(*) AS total_records
FROM online_retail
GROUP BY Country
ORDER BY total_records DESC;  

   
  -- 4. SALES ANALYSIS
  
  -- Total sales
  SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM
    online_retail
WHERE
    Quantity > 0 AND UnitPrice > 0
        AND InvoiceNo NOT LIKE 'C%';
  
-- Monthly sales  
  SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Yearly sales
SELECT
    YEAR(InvoiceDate) AS sales_year,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY YEAR(InvoiceDate)
ORDER BY sales_year;


-- Top 10 Products by Sales
SELECT
    StockCode,
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY StockCode, Description
ORDER BY total_sales DESC
LIMIT 10;

--  Top 10 Countries by Sales
SELECT
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY Country
ORDER BY total_sales DESC
LIMIT 10;

--  Top 10 Customers by Sales
SELECT
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail
WHERE CustomerID IS NOT NULL
  AND TRIM(CustomerID) <> ''
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_sales DESC
LIMIT 10;

--  Monthly Order Count
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

--  Average Order Value (AOV)
SELECT
    ROUND(
        SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_order_value
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%';
  
-- Repeat Customers Count
  SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT CustomerID
    FROM online_retail
    WHERE CustomerID IS NOT NULL
      AND TRIM(CustomerID) <> ''
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) AS customer_orders;

-- One-Time Customers Count
SELECT
    COUNT(*) AS one_time_customers
FROM (
    SELECT CustomerID
    FROM online_retail
    WHERE CustomerID IS NOT NULL
      AND TRIM(CustomerID) <> ''
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) = 1
) AS customer_orders;

--  Repeat Customer Percentage
    SELECT
    ROUND(
        COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail
    WHERE CustomerID IS NOT NULL
      AND TRIM(CustomerID) <> ''
      AND Quantity > 0
      AND UnitPrice > 0
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
) AS customer_summary;

--  Country-wise Sales Percentage
SELECT
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales,
    ROUND(
        SUM(Quantity * UnitPrice) * 100.0 /
        (
            SELECT SUM(Quantity * UnitPrice)
            FROM online_retail
            WHERE Quantity > 0
              AND UnitPrice > 0
              AND InvoiceNo NOT LIKE 'C%'
        ),
        2
    ) AS sales_percentage
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY Country
ORDER BY total_sales DESC
LIMIT 10;


-- Total Quantity Sold
SELECT
    SUM(Quantity) AS total_quantity_sold
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%';
  
  --  Top 10 Products by Quantity Sold
  SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold
FROM online_retail
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
ORDER BY total_quantity_sold DESC
LIMIT 10;


