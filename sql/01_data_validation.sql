-- 0. Check the schema 
SELECT * FROM pragma_table_info('sales');
-- The Date column needs formatting

-- 1. Check for NULL values
SELECT * FROM sales
WHERE Store IS NULL
OR Date IS NULL
OR Weekly_Sales IS NULL
OR Holiday_Flag IS NULL
OR Temperature IS NULL
OR Fuel_Price IS NULL
OR CPI IS NULL
OR Unemployment IS NULL;

-- 2. Check for duplicates in Store-Date pair, i.e. each store only have 1 record for each sales date
SELECT Store, Date FROM sales
GROUP BY Store, Date
HAVING COUNT(*) > 1;

-- 3. Check if there's negative value in Weekly_sales, Fuel_Price, CPI and Unemployment
SELECT * FROM sales
WHERE Weekly_Sales < 0
OR Fuel_Price < 0
OR CPI < 0
OR Unemployment < 0;

-- 4. Check if Holiday_Flag has any value other than 0 (false) and 1 (true)
SELECT * FROM sales
WHERE Holiday_Flag != 0 AND Holiday_Flag != 1;

-- 5. Check for outliers by checking each column in ascending and descending orders, e.g.
SELECT Weekly_Sales from sales
ORDER BY Weekly_Sales ASC;
