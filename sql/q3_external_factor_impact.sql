-- What are the impacts (negative/positive) of external factors (temperature, fuel price, CPI, unemployment rate) on sales? 
-- (e.g. Which stores are more sensitive/resistant to those factors?)

/*
   1. Rather than calculate the correlation between sales and external factors of all stores,
   it's more beneficial to calculate it separately for every store because their performance differs
*/

SELECT
    Store, 
    -- Weekly_Sales vs Temperature
    ROUND((AVG(Weekly_Sales * Temperature)
     - AVG(Weekly_Sales) * AVG(Temperature))
    /
    (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
     * 
     sqrt(AVG(Temperature * Temperature) - AVG(Temperature) * AVG(Temperature))
    ), 2) AS corr_sales_temp,
    -- Weekly_Sales vs Fuel Price
    ROUND((AVG(Weekly_Sales * Fuel_Price)
     - AVG(Weekly_Sales) * AVG(Fuel_Price))
    /
    (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
     * 
     sqrt(AVG(Fuel_Price * Fuel_Price) - AVG(Fuel_Price) * AVG(Fuel_Price))
    ), 2) AS corr_sales_fuel,
    -- Weekly_Sales vs CPI
    ROUND((AVG(Weekly_Sales * CPI)
     - AVG(Weekly_Sales) * AVG(CPI))
    /
    (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
     * 
     sqrt(AVG(CPI * CPI) - AVG(CPI) * AVG(CPI))
    ), 2) AS corr_sales_cpi,
    -- Weekly_Sales vs Unemployment
    ROUND((AVG(Weekly_Sales * Unemployment)
     - AVG(Weekly_Sales) * AVG(Unemployment))
    /
    (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
     * 
     sqrt(AVG(Unemployment * Unemployment) - AVG(Unemployment) * AVG(Unemployment))
    ), 2) AS corr_sales_unemployment
FROM copy_sales 
GROUP BY Store;
/* REMARKS:
- There's not a significant correlation between any store's sales and the outdoor temperature.
- The correlation coefficients do not explain every store, but some stores' stories can be told coherently. 
- Combining with the performance ranking, growth ranking and overall rankings, one 
*/

/* Worst performance and growth - STORE 36'S REMARKS:
- Store 36 has the lowest overall rating in term of performance and growth, and it also has
    corr_sales_fuel = -0.73, corr_sales_cpi = -0.92, and corr_sales_unemployment = 0.83.
- The 3 coefficients of store 36 are either the lowest or highest of each category,
    and have, interestingly, a high gap between them and the next in-place coefficients. 
=> Store 36 has had declining sales over 2010-2012, which reasonably correlates with high fuel price and CPI. 
   However, when unemployment was low, their sales did not recover, which signals customers'
   overall negative spending habits toward this particular store.
=> Store 36 is highly vulnerable to external factors: high costs overall will lower sales, 
    and even with a lower unemployment rate, the customers being cautious about spending 
    indicates the store's failure to attract customers and lose out in the competition against other stores/brands. 
*/

/* Best performance and growth - STORES 4 & 39'S REMARKS:
- Both stores have low coefficients, indicating more resistance against external factors. 
- They both performed quite well when inflation and employment rise, 
    through which we may intepret as them having both good pricing and attraction toward customers
*/

/* High potentials - STORE 38 & 44'S REMARKS:
- Both stores's sales are highly impacted by fuel price, CPI, and unemployment rate, but in a good way.
- Both stores perform well when there's high inflation, indicating good pricing.
    When unemployment rate is lowered, their sales remain high so customers still choose them even when economy improves
    => customer loyalty is high.
- Checking their rankings shows that they both have high potential rankings with store 38 at rank 1 and store 44 and rank 4.
    Their overall rankings are low due to their total sales being low. 
    => They have high potentials to become bigger with their current strategies.
*/
WITH corr_table AS (
    SELECT
        Store, 
        -- Weekly_Sales vs Temperature
        ROUND((AVG(Weekly_Sales * Temperature)
        - AVG(Weekly_Sales) * AVG(Temperature))
        /
        (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
        * 
        sqrt(AVG(Temperature * Temperature) - AVG(Temperature) * AVG(Temperature))
        ), 2) AS corr_sales_temp,
        -- Weekly_Sales vs Fuel Price
        ROUND((AVG(Weekly_Sales * Fuel_Price)
        - AVG(Weekly_Sales) * AVG(Fuel_Price))
        /
        (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
        * 
        sqrt(AVG(Fuel_Price * Fuel_Price) - AVG(Fuel_Price) * AVG(Fuel_Price))
        ), 2) AS corr_sales_fuel,
        -- Weekly_Sales vs CPI
        ROUND((AVG(Weekly_Sales * CPI)
        - AVG(Weekly_Sales) * AVG(CPI))
        /
        (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
        * 
        sqrt(AVG(CPI * CPI) - AVG(CPI) * AVG(CPI))
        ), 2) AS corr_sales_cpi,
        -- Weekly_Sales vs Unemployment
        ROUND((AVG(Weekly_Sales * Unemployment)
        - AVG(Weekly_Sales) * AVG(Unemployment))
        /
        (sqrt(AVG(Weekly_Sales * Weekly_Sales) - AVG(Weekly_Sales) * AVG(Weekly_Sales))
        * 
        sqrt(AVG(Unemployment * Unemployment) - AVG(Unemployment) * AVG(Unemployment))
        ), 2) AS corr_sales_unemployment
    FROM copy_sales 
    GROUP BY Store    
) SELECT