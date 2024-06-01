-- Retrieve all records from the 'supply_chain' table
SELECT * FROM supply_chain;

-- Count the number of items for each SKU in the 'supply_chain' table and label the count as 'SKU_COUNT'
SELECT SKU, COUNT(*) as SKU_COUNT FROM supply_chain GROUP BY SKU;

-- Select SKUs from 'supply_chain' where any of the specified fields are null (indicating incomplete data)
SELECT SKU
FROM supply_chain
WHERE Product_type IS NULL OR
      SKU IS NULL OR
      Price IS NULL OR
      Availability IS NULL OR
      Number_of_products_sold IS NULL OR
      Revenue_generated IS NULL OR
      Customer_demographics IS NULL OR
      Stock_levels IS NULL OR
      Lead_times IS NULL OR
      Order_quantities IS NULL OR
      Shipping_times IS NULL OR
      Shipping_carriers IS NULL OR
      Shipping_costs IS NULL OR
      Supplier_name IS NULL OR
      Location IS NULL OR
      Lead_time IS NULL OR
      Production_volumes IS NULL OR
      Manufacturing_lead_time IS NULL OR
      Manufacturing_costs IS NULL OR
      Inspection_results IS NULL OR
      Defect_rates IS NULL OR
      Transportation_modes IS NULL OR
      Routes IS NULL OR
      Costs IS NULL;

-- Retrieve SKUs for products that are not categorized as 'haircare', 'skincare', or 'cosmetics'
SELECT SKU FROM supply_chain WHERE Product_type NOT IN ('haircare', 'skincare', 'cosmetics');

-- Retrieve SKUs for products not transported by 'Road', 'Air', 'Sea', or 'Rail'
SELECT SKU FROM supply_chain WHERE Transportation_modes NOT IN ('Road', 'Air', 'Sea', 'Rail');

-- Retrieve SKUs where inspection results are not 'Fail', 'Pass', or 'Pending'
SELECT SKU FROM supply_chain WHERE Inspection_results NOT IN ('Fail', 'Pass', 'Pending');

-- Retrieve SKUs that do not contain the substring 'SKU'
SELECT SKU FROM supply_chain WHERE SKU NOT LIKE '%SKU%';

-- Select SKUs where converting certain text fields to integers is possible, implying incorrect data types
SELECT SKU
FROM supply_chain
WHERE TRY_CAST(Supplier_name AS INT) IS NOT NULL OR
      TRY_CAST(Shipping_carriers AS INT) IS NOT NULL OR
      TRY_CAST(Location AS INT) IS NOT NULL OR
      TRY_CAST(Inspection_results AS INT) IS NOT NULL OR
      TRY_CAST(Transportation_modes AS INT) IS NOT NULL OR
      TRY_CAST(Routes AS INT) IS NOT NULL OR
      TRY_CAST(Customer_demographics AS INT) IS NOT NULL;

-- Retrieve SKUs where numeric fields have negative values, which may indicate data entry errors
SELECT SKU
FROM supply_chain
WHERE Price < 0 OR
      Availability < 0 OR
      Number_of_products_sold < 0 OR
      Revenue_generated < 0 OR
      Stock_levels < 0 OR
      Lead_times < 0 OR
      Order_quantities < 0 OR
      Shipping_times < 0 OR
      Shipping_costs < 0 OR
      Lead_time < 0 OR
      Production_volumes < 0 OR
      Manufacturing_lead_time < 0 OR
      Manufacturing_costs < 0 OR
      Defect_rates < 0 OR
      Costs < 0;

-- Count the number of products for each product type and order them in descending order of count
SELECT Product_type, COUNT(*) AS Product_Count
FROM supply_chain
GROUP BY Product_type
ORDER BY Product_Count DESC;

-- Retrieve all records from the 'supply_chain' table for a comprehensive view
SELECT * FROM supply_chain;

-- Calculate the total number of products sold for each product type and order them in descending order of sales
SELECT Product_type, SUM(Number_of_products_sold) AS Num_Sold
FROM supply_chain
GROUP BY Product_type
ORDER BY Num_Sold DESC;

-- Count purchases by gender for each product type, providing insights into gender-based preferences
SELECT Product_type, Customer_demographics, COUNT(*) AS Gender_Purchase
FROM supply_chain
GROUP BY Product_type, Customer_demographics
ORDER BY Gender_Purchase DESC;

-- Count the number of products supplied by each supplier per product type, useful for supplier analysis
SELECT Product_type, Supplier_name, COUNT(*) AS Supplier_ProductType
FROM supply_chain
GROUP BY Product_type, Supplier_name
ORDER BY Supplier_ProductType DESC;

-- Analyze the count of transportation modes used for each product type, indicating logistics preferences
SELECT Product_type, Transportation_modes, COUNT(*) AS TransportationType_ProductType
FROM supply_chain
GROUP BY Product_type, Transportation_modes
ORDER BY TransportationType_ProductType DESC;

-- Count how often different routes are used for shipping each product type, useful for logistics optimization
SELECT Product_type, Routes, COUNT(*) AS RoutesTaken_by_ProductType
FROM supply_chain
GROUP BY Product_type, routes
ORDER BY RoutesTaken_by_ProductType DESC;

-- Aggregate price and units sold data to get the minimum, average, and maximum prices, as well as total and average units sold
SELECT 
    MIN(Price) AS Min_Price, 
    AVG(Price) AS Average_Price, 
    MAX(Price) AS Max_Price, 
    SUM(Number_of_products_sold) AS Total_Units_Sold,
    AVG(Number_of_products_sold) AS Average_Units_Sold
FROM supply_chain;

-- Calculate the total revenue generated by each product type using a common table expression and order by revenue in descending order
WITH REV AS (
    SELECT Product_type, SUM(Revenue_generated) AS Revenue_EACH_TYPE
    FROM supply_chain
    GROUP BY Product_type
)
SELECT Product_type, Revenue_EACH_TYPE
FROM REV
ORDER BY Revenue_EACH_TYPE DESC;

-- Compute the total costs associated with each product type using a common table expression and order by costs in descending order
WITH COST AS (
    SELECT Product_type, SUM(Costs) AS Costs_EACH_TYPE
    FROM supply_chain
    GROUP BY Product_type
)
SELECT Product_type, Costs_EACH_TYPE
FROM COST
ORDER BY Costs_EACH_TYPE DESC;

-- Determine the total manufacturing costs for each product type using a common table expression and order by manufacturing costs in descending order
WITH MANUCOST AS (
    SELECT Product_type, SUM(Manufacturing_costs) AS Manu_Costs_EACH_TYPE
    FROM supply_chain
    GROUP BY Product_type
)
SELECT Product_type, Manu_Costs_EACH_TYPE
FROM MANUCOST
ORDER BY Manu_Costs_EACH_TYPE DESC;
------------------------------------------

-- Remove the COST table if it exists to prevent errors on recreation
DROP TABLE IF EXISTS COST;

-- Create a new table to store total costs by product type
CREATE TABLE COST (
    Product_type VARCHAR(255),
    Costs_EACH_TYPE DECIMAL(10,2)
);

-- Populate the COST table with aggregated cost data from the supply chain
INSERT INTO COST
SELECT Product_type, SUM(Costs) AS Costs_EACH_TYPE
FROM supply_chain
GROUP BY Product_type;

-- Remove the MANUCOST table if it exists to ensure fresh data setup
DROP TABLE IF EXISTS MANUCOST;

-- Create a table to store manufacturing costs by product type
CREATE TABLE MANUCOST (
    Product_type VARCHAR(255),
    Manu_Costs_EACH_TYPE DECIMAL(10,2)
);

-- Populate the MANUCOST table with aggregated manufacturing cost data
INSERT INTO MANUCOST
SELECT Product_type, SUM(Manufacturing_costs) AS Manu_Costs_EACH_TYPE
FROM supply_chain
GROUP BY Product_type;

-- Remove the REV table if it exists to prevent duplication issues
DROP TABLE IF EXISTS REV;

-- Create a table to store revenue data by product type
CREATE TABLE REV (
    Product_type VARCHAR(255),
    Revenue_EACH_TYPE DECIMAL(10,2)
);

-- Populate the REV table with aggregated revenue data
INSERT INTO REV
SELECT Product_type, SUM(Revenue_generated) AS Revenue_EACH_TYPE
FROM supply_chain
GROUP BY Product_type;

-- Remove the FINANCIALS table if it exists to avoid conflicts on creation
DROP TABLE IF EXISTS FINANCIALS;

-- Create a comprehensive financial table that includes costs, manufacturing costs, and revenue
CREATE TABLE FINANCIALS (
    Product_Type VARCHAR(255),
    COSTS DECIMAL(10,2),
    Manufacturing_Costs DECIMAL(10,2),
    Revenue DECIMAL(10,2),
    Profits DECIMAL(10,2)
);

-- Populate the FINANCIALS table with financial data by joining the cost and revenue tables
INSERT INTO FINANCIALS
SELECT 
    C.Product_type, 
    C.Costs_EACH_TYPE, 
    M.Manu_Costs_EACH_TYPE, 
    R.Revenue_EACH_TYPE,
    (R.Revenue_EACH_TYPE - (C.Costs_EACH_TYPE + M.Manu_Costs_EACH_TYPE)) AS Profits
FROM 
    COST C
    LEFT JOIN MANUCOST M ON C.Product_type = M.Product_type
    LEFT JOIN REV R ON C.Product_type = R.Product_type
ORDER BY 
    C.Product_type;

-- Display all records from the FINANCIALS table for review
SELECT * FROM FINANCIALS;

-- Analyze average costs by transportation modes, rounded to two decimal places
SELECT Transportation_modes, ROUND(AVG(COSTS),2) AS COST_ROAD_TYPE
FROM supply_chain
GROUP BY Transportation_modes
ORDER BY COST_ROAD_TYPE DESC;

-- Analyze average costs by routes taken, useful for cost management
SELECT Routes, ROUND(AVG(COSTS),2) AS COST_ROAD_TAKEN
FROM supply_chain
GROUP BY Routes
ORDER BY COST_ROAD_TAKEN DESC;

-- Calculate the average defect rates by product type, rounded to two decimal places
SELECT Product_type, ROUND(AVG(Defect_rates),2) AS AVG_DEFECT_PRODUCTTYPE
FROM supply_chain
GROUP BY Product_type
ORDER BY AVG_DEFECT_PRODUCTTYPE DESC;

-- Calculate the average defect rates by inspection results to identify quality issues
SELECT Inspection_results, ROUND(AVG(Defect_rates),2) AS AVG_DEFECT_INSPECTION_RESULT
FROM supply_chain
GROUP BY Inspection_results
ORDER BY AVG_DEFECT_INSPECTION_RESULT DESC;

-- Calculate the average defect rates by product type and inspection results
SELECT Product_type, Inspection_results, ROUND(AVG(Defect_rates),2) AS AVG_DEFECT_INSPECTION_PRODUCT_TYPE
FROM supply_chain
GROUP BY Inspection_results, Product_type
ORDER BY AVG_DEFECT_INSPECTION_PRODUCT_TYPE DESC;

-- Calculate the average defect rates by supplier, important for supplier quality assessment
SELECT Supplier_name, ROUND(AVG(Defect_rates), 2) AS AVG_DEFECT_Supplier
FROM supply_chain
GROUP BY Supplier_name
ORDER BY AVG_DEFECT_Supplier DESC;

-- Create a common table expression to find suppliers with the highest defect rates by product type
WITH AVG_DEFECTS AS (
    SELECT 
        Product_type,
        Supplier_name,
        ROUND(AVG(Defect_rates), 2) AS AVG_DEFECT_Supplier_Product_type
    FROM supply_chain
    GROUP BY Supplier_name, Product_type
)
-- Select the highest defect rate suppliers for each product type
SELECT 
    AD.Product_type, 
    AD.Supplier_name, 
    AD.AVG_DEFECT_Supplier_Product_type
FROM AVG_DEFECTS AD
WHERE AD.AVG_DEFECT_Supplier_Product_type = (
    SELECT MAX(AD2.AVG_DEFECT_Supplier_Product_type)
    FROM AVG_DEFECTS AD2
    WHERE AD2.Product_type = AD.Product_type
)
ORDER BY AD.Product_type;

-- Retrieve all records from the supply chain for a complete overview
SELECT * FROM supply_chain;

-- Calculate total revenue generated by each supplier
SELECT Supplier_name, ROUND(SUM(Revenue_generated), 2) AS Revenue_Supplier
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Revenue_Supplier DESC;

-- Calculate total costs incurred by each supplier including manufacturing costs
SELECT Supplier_name, ROUND(SUM(Costs)+SUM(Manufacturing_costs), 2) AS Total_cost_Supplier
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Total_cost_Supplier DESC;

-- Calculate profits by each supplier by subtracting total costs from revenue generated
SELECT Supplier_name, ROUND(SUM(Revenue_generated), 2) - ROUND(SUM(Costs)+SUM(Manufacturing_costs), 2) AS Profit_Supplier
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Profit_Supplier DESC;

-- Aggregate price statistics for each supplier, providing insights into pricing strategies and variability
SELECT 
    Supplier_name, 
    MIN(Price) AS Min_Price, 
    MAX(Price) AS Max_Price, 
    AVG(Price) AS Avg_Price, 
    STDEV(Price) AS StdDev_Price, 
    COUNT(*) AS Product_Count,
    SUM(Number_of_products_sold) AS Total_Products_Sold
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Supplier_name;

SELECT * FROM supply_chain

--  The maximum lead and shipping times for each supplier
SELECT Supplier_name, 
       MAX(Lead_Times) AS Max_Lead_Times,
       MAX(Shipping_times) AS Max_Shipping_Times
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Max_Lead_Times DESC;

-- The average lead and shipping times for each supplier
SELECT Supplier_name, 
       AVG(Lead_Times) AS Avg_Lead_Times,
       AVG(Shipping_times) AS Avg_Shipping_Times
FROM supply_chain
GROUP BY Supplier_name
ORDER BY Avg_Lead_Times DESC;

--Find Average Production volume across each supplier 
SELECT Supplier_name,AVG(Production_volumes) AS AVERAGE_PRODUCTION
FROM supply_chain
GROUP BY Supplier_name
ORDER BY AVERAGE_PRODUCTION DESC;


-- Find the supplier with the maximum number of "Pass" inspection results
SELECT TOP 1 Supplier_name, COUNT(*) AS Max_Pass_Count
FROM supply_chain
WHERE Inspection_results = 'Pass'
GROUP BY Supplier_name
ORDER BY Max_Pass_Count DESC;

-- Find the supplier with the maximum number of "Fail" inspection results
SELECT TOP 1 Supplier_name, COUNT(*) AS Max_Fail_Count
FROM supply_chain
WHERE Inspection_results = 'Fail'
GROUP BY Supplier_name
ORDER BY Max_Fail_Count DESC;

ORDER BY Fail_Count DESC
LIMIT 1;

