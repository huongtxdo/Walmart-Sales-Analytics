/* 
Is there any change in sales during holiday weeks compared to normal weeks? 
(e.g. How much sales increase on average? What percentage is it of the annual sales?) 
*/

 
/*
1. First, we compare the holiday sales against the overall sales, 
    and what percentage of the weeks are holiday weeks
*/
WITH temp_table AS (
    SELECT 
        SUM(Weekly_Sales) AS overall_sales, 
        (SELECT SUM(Weekly_Sales) FROM copy_sales WHERE Holiday_Flag = 1) AS holiday_sales,
        COUNT(*) AS weeks,
        (SELECT COUNT(*) FROM copy_sales WHERE Holiday_Flag = 1) AS holiday_weeks,
        (SELECT AVG(Weekly_Sales) FROM copy_sales WHERE Holiday_Flag = 0) AS avg_non_holiday_sales,
        (SELECT AVG(Weekly_Sales) FROM copy_sales WHERE Holiday_Flag = 1) AS avg_holiday_sales
    FROM copy_sales
)
SELECT  
    ROUND(holiday_weeks * 1.0/weeks * 100, 2) AS holiday_weeks_percentage,
    ROUND(holiday_sales/overall_sales * 100, 2) AS holiday_sales_percentage,
    ROUND((avg_holiday_sales - avg_non_holiday_sales)/avg_non_holiday_sales * 100, 2) AS holiday_sales_increase
FROM temp_table;
/* REMARKS:
6.99% of the sales inputs fall on holidays yet they account for 7.5% of the total sales.
On average, the holiday sales is 7.84% higher than non-holiday sales.
*/

-------------------------------------------------------------------------------------------------------------------

/*
2. Which stores have the highest holiday sales' increases?
*/
WITH store_normal_sales AS (
    SELECT
        Store,
        AVG(Weekly_Sales) AS normal_avg
    FROM copy_sales
    WHERE Holiday_Flag = 0
    GROUP BY Store
),
store_holiday_sales AS (
    SELECT
        Store,
        AVG(Weekly_Sales) AS holiday_avg
    FROM copy_sales
    WHERE Holiday_Flag = 1
    GROUP BY Store
)
SELECT 
    Store,
    ROUND((holiday_avg - normal_avg)/normal_avg * 100, 2) AS holiday_sales_increases
FROM store_normal_sales JOIN store_holiday_sales USING (Store)
ORDER BY holiday_sales_increases DESC;
/* REMARKS:
The sales increases depend on many factors, both internally (e.g. stores having lower normal sales ) and externally (e.g. location's economic situation).
Most stores have their sales increased during holidays: Store 7 and 35 have their sales increased by almost 20 per cent.
Stores 30, 38, 36, 37, 44, however, have lower sales during holidays.
*/

-------------------------------------------------------------------------------------------------------------------

/*
3. Let's dive deeper into the percentage of holiday weeks in a month, their monthly average sales, and how much of them are during holiday weeks.
*/
WITH monthly_holidays AS (
    SELECT 
        strftime('%m', Date) AS month,
        SUM(Holiday_Flag) AS holiday_inputs,
        ROUND(SUM(weekly_sales), 2) AS holiday_sales
    FROM copy_sales
    WHERE Holiday_Flag = 1
    GROUP BY month
),
monthly_total AS (
    SELECT 
        strftime('%m', Date) AS month,
        COUNT(*) AS total_inputs,
        ROUND(AVG(weekly_sales), 2) AS avg_monthly_sales,
        ROUND(SUM(weekly_sales), 2) AS monthly_sales
    FROM copy_sales
    GROUP BY month
)
SELECT 
    month,
    COALESCE(ROUND(holiday_inputs * 1.0 / total_inputs * 100, 2), 0) AS monthly_holidays_percent,
    avg_monthly_sales,
    COALESCE(ROUND(holiday_sales/monthly_sales * 100, 2), 0) AS holiday_sales_percent
FROM monthly_total LEFT JOIN monthly_holidays USING (month) 
ORDER BY avg_monthly_sales DESC

/* REMARKS:
The holidays are only reported in February, September, November and December, with 1-2 weeks being holidays.
December generates the most sales while having the lowest percentage of holidays among the four holiday months. 
- Overall people shop more in December as the sales during holiday week accounts for 15% of the total December sales.
November and February have the second and fourth highest sales, respectively.
- Nearly a third of sales in November coming from holiday, together with the high average monthly sales means this month's holiday weeks are the busiest 
=> More resources should be allocated here and sufficient inventory should be maintained.
- The holiday sales percentage of February is actually on par with the percentage of holidays week in the month.
September has the second lowest average sales. 
- Nearly 25% of September sales comes from the holiday week, which is also on par with the percentage of holiday weeks being 23% of the whole month.
Though having no holiday, June is still a busy month that stores should pay attention to.
*/

