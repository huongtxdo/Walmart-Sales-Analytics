-- We check the performance of every store

/*
1. Let's get the average monthly sales of each store for every year!
*/
SELECT 
    Store, 
    strftime("%m", Date) AS month,
    strftime("%Y", Date) AS year,
    ROUND(AVG(weekly_sales), 2) AS avg_sales 
FROM copy_sales 
GROUP BY store, year, month;

-------------------------------------------------------------------------------------------------------------------

/*
2. The dataset spans from 2010-02-05 till 2012-10-26, 
   let's see how the stores perform over the year by comparing the sales of October 2010 with that of October 2012
*/
WITH oct_2010 AS (
    SELECT 
        Store, 
        Date,
        strftime("%m", Date) AS month,
        strftime("%Y", Date) AS year,
        ROUND(AVG(weekly_sales), 2) AS sales_2010 
    FROM copy_sales 
    WHERE month = "10" AND year = "2010"
    GROUP BY store, year, month
),
oct_2012 AS (
    SELECT 
        Store, 
        Date,
        strftime("%m", Date) AS month,
        strftime("%Y", Date) AS year,
        ROUND(AVG(weekly_sales), 2) AS sales_2012 
    FROM copy_sales 
    WHERE month = "10" AND year = "2012"
    GROUP BY store, year, month
) 
SELECT
    Store,
    sales_2010,
    sales_2012,
    ROUND((sales_2012 - sales_2010) / sales_2010 * 100, 2) AS percent_increase
FROM oct_2010 LEFT JOIN oct_2012 USING (Store)
ORDER BY percent_increase DESC;
/* REMARKS:
- Store 38 has the highest increases in sales over 2 years at 25.9%, followed by store 39 and 23 at 23.3% and 22.8%, respectively.
- There are 8 stores whose sales decreased in 2012 compared to 2010, with the most significant decrease at 33.5% being store 36.
*/

-------------------------------------------------------------------------------------------------------------------

/*
3. Changes in sales should be considered together with a store's previous sales so that we can get a better picture of a store's performance
   i.e. A slight decrease in sales of stores with previously high sales may not be that concerning. Or
   stores with previously low sales tend to easily have high increase percentage even with slight increase in sales. 
=> Let's rank their 2010's sales and percentage sales increase in 2012! The combination of them will give us the stores with best performance and growth. 
*/
WITH oct_2010 AS (
    SELECT 
        Store, 
        Date,
        strftime("%m", Date) AS month,
        strftime("%Y", Date) AS year,
        ROUND(AVG(weekly_sales), 2) AS sales_2010 
    FROM copy_sales 
    WHERE month = "10" AND year = "2010"
    GROUP BY store, year, month
),
oct_2012 AS (
    SELECT 
        Store, 
        Date,
        strftime("%m", Date) AS month,
        strftime("%Y", Date) AS year,
        ROUND(AVG(weekly_sales), 2) AS sales_2012 
    FROM copy_sales 
    WHERE month = "10" AND year = "2012"
    GROUP BY store, year, month
) 
SELECT
    Store,
    RANK() OVER(ORDER BY sales_2010 DESC) AS sales_ranking,
    RANK() OVER(ORDER BY ROUND((sales_2012 - sales_2010) / sales_2010 * 100, 2) DESC) AS percent_increase_ranking,
    RANK() OVER(ORDER BY sales_2010 DESC) + RANK() OVER(ORDER BY ROUND((sales_2012 - sales_2010) / sales_2010 * 100, 2) DESC) AS overall_ranking
FROM oct_2010 LEFT JOIN oct_2012 USING (Store)
ORDER BY overall_ranking
/* REMARKS:
- Store 4 and 39 top the chart with high overall rankings of 13 and 14, respectively.
- Store 4 has high original sales and its growth ranking in the first quartile, while store 39 has the opposite position (high growth, first quartile-original sales).
- Store 30 and 36 are at the bottom at 79 and 85 ranking, respectively. They are on the last quartile of both performance and growth. 
**The order may change depends on how much weight one decides to put on different categories. Here, I use equal weight for previous sales and sales increase.
*/
