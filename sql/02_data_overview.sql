/*
0. Create a copy table with formatted Date (from dd-mm-yyyy to yyyy-mm-dd): 
- adding new column, updating that column, deleting old column, and renaming the new column
*/
DROP TABLE IF EXISTS copy_sales;

CREATE TABLE copy_sales AS
    SELECT * FROM sales;

ALTER TABLE copy_sales ADD COLUMN "new_date" TEXT;

UPDATE copy_sales SET "new_date" = DATE(
    SUBSTRING(Date, 7, 4) ||'-'||
    SUBSTRING(Date, 4, 2) ||'-'||
    SUBSTRING(Date, 1, 2)
);

ALTER TABLE copy_sales DROP COLUMN "Date";

ALTER TABLE copy_sales RENAME COLUMN "new_date" TO "Date";

/*
1. How many unique stores there are, and how many rows/inputs they have, how many of them have Holiday_Flag = 1 in this dataset?
What is the date range of the dataset
*/
SELECT Store, COUNT(*) FROM copy_sales GROUP BY Store;
-- There are 45 stores, each have 143 inputs.

/*
2. What are the average sales, average holiday sales of each store, and how much the sales increase during holiday?
*/
WITH overall AS (
    SELECT Store, AVG(Weekly_Sales) AS avg_sales FROM copy_sales GROUP BY 1
), holiday AS (
    SELECT Store, AVG(Weekly_Sales) AS holiday_avg_sales FROM copy_sales WHERE Holiday_Flag = 1 GROUP BY 1
)
SELECT Store, avg_sales, holiday_avg_sales, 
    ROUND((holiday_avg_sales - avg_sales)/avg_sales * 100, 2) AS holiday_percentage_increase
FROM overall JOIN holiday USING (Store);

/*
3. What are the distributions of Temperature, Fuel_Price, CPI, Unemployment (min, max, avg)?
*/
SELECT 
    'Weekly_Sales' AS parameter, 
    ROUND(AVG(Weekly_Sales), 2) AS average, 
    ROUND(MIN(Weekly_Sales), 2) AS minimum, 
    ROUND(MAX(Weekly_Sales), 2) AS maximum
FROM copy_sales
UNION 
    SELECT 
        'Temperature', ROUND(AVG(Temperature), 2), ROUND(MIN(Temperature), 2), ROUND(MAX(Temperature), 2)
    FROM copy_sales
UNION 
    SELECT
        'Fuel_Price', ROUND(AVG(Fuel_Price), 2), ROUND(MIN(Fuel_Price), 2), ROUND(MAX(Fuel_Price), 2)
    FROM copy_sales
UNION 
    SELECT
        'CPI', ROUND(AVG(CPI), 2), ROUND(MIN(CPI), 2), ROUND(MAX(CPI), 2)
    FROM copy_sales
UNION  
    SELECT
        'Unemployment', ROUND(AVG(Unemployment), 2), ROUND(MIN(Unemployment), 2), ROUND(MAX(Unemployment), 2)
    FROM copy_sales;

/*
4. Top 10 stores by overall sales and holiday sales?
*/
WITH overall AS (
    SELECT 
        RANK() OVER(ORDER BY SUM(Weekly_Sales) DESC) AS rank,
        Store
    FROM copy_sales
    GROUP BY Store
),
holiday AS (
    SELECT
        RANK() OVER(ORDER BY SUM(Weekly_Sales) DESC) AS rank,
        Store
    FROM copy_sales
    WHERE Holiday_Flag = 1
    GROUP BY Store
)
SELECT overall.rank AS rank, overall.Store AS general_sales_store, holiday.Store AS holiday_sales_store
FROM overall JOIN holiday USING (rank)
ORDER BY rank
LIMIT 10

/*
5. What are the averages of Temperature, Fuel_Price, CPI, Unemployment for each store?
*/
SELECT
    Store,
    ROUND(AVG(Temperature), 2) AS avg_temp,
    ROUND(AVG(Fuel_Price), 2) AS avg_fuel,
    ROUND(AVG(CPI), 2) AS avg_cpi,
    ROUND(AVG(Unemployment), 2) AS avg_unemployment
FROM copy_sales
GROUP BY Store