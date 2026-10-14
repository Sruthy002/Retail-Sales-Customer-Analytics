# Retail Sales and Customer Analytics

**Tools:** MySQL, SQL, Power BI

## Overview

This project explores online retail transaction data to understand sales performance, product demand, and customer purchasing patterns. SQL was used to query and analyze the data, and Power BI was used to present the findings through interactive dashboards.

## Dashboard

### Sales Overview
![Sales Overview](Sales-Overview.png)

### Product Analysis
![Product Analysis](Product-Analysis.png)

### Customer and Country Analysis
![Customer and Country Analysis](Customer-Country-Analysis.png)

## Analysis

The project covers the following areas:

- Overall sales and monthly sales trends
- Top 10 products by sales
- Top 10 products by quantity sold
- Country-wise sales performance
- Top customers by sales
- Monthly order count
- Average Order Value (AOV)
- Repeat and one-time customer analysis
- Total quantity sold

## Data Preparation

For sales analysis, transactions with non-positive quantities, non-positive unit prices, and cancellation invoices beginning with `C` were excluded.

Customer-specific analysis excludes records with missing or blank Customer IDs.

## Tools Used

- **MySQL:** Database management
- **SQL:** Data querying, filtering, and aggregation
- **Power BI:** Dashboard creation and visualization

## Project Files

| File | Description |
|---|---|
| `Retail_Sales_Analysis.sql` | SQL queries used for the analysis |
| `Online Retail Analysis.pbix` | Power BI report |

## How to Run

1. Import the retail dataset into MySQL.
2. Select the `retail_analytics` database.
3. Run the queries in `Retail_Sales_Analysis.sql`.
4. Open `Online Retail Analysis.pbix` in Power BI Desktop.

The original dataset is not included in this repository.

## Skills Applied

SQL querying, data cleaning, sales analysis, customer analysis, KPI calculation, and Power BI visualization.

## Author

**Sruthy S.S**

Aspiring Data Analyst  
[GitHub Profile](https://github.com/Sruthy002)
