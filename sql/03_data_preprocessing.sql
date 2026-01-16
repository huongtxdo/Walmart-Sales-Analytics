-- PREPROCESSING DATA AND DEFINING VIEWS --

/* POWER BI DASHBOARD
SALES OVERVIEW: 
    sales trend (line chart)
    top 10 store sales (bar chart), top 10 store growth (bar chart)
        - or store sales and growth matrix
    
    External impact matrix (high, low)
SINGLE STORE'S EXTERNAL IMPACT: 
    Month + Year slicer for sales, avg temp, fuel price, cpi and unemployment.

*/

/* 
Correlation strength was interpreted using standard statistical conventions, 
where |r| < 0.3 is considered weak, 0.3–0.5 moderate, 0.5–0.7 strong, 0.7-0.9 very strong, and values above 0.9 extremely strong/
*/

DROP VIEW IF EXISTS correlation_strength;
CREATE VIEW correlation_strength AS
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

/*
View of global electricity types
*/

DROP VIEW IF EXISTS electricity_types;
CREATE VIEW electricity_types AS
    SELECT 
        country_name, date_key, country_name || '_' || date_key AS country_date_key,
        ROUND(SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Electricity' THEN value ELSE 0 END), 3) AS total_production,
        ROUND(SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Total Renewables (Hydro, Geo, Solar, Wind, Other)' THEN value ELSE 0 END)
            + SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Nuclear' THEN value ELSE 0 END), 3) AS total_renewables,
        ROUND(SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Total Combustible Fuels' THEN value ELSE 0 END) 
            - SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Combustible Renewables' THEN value ELSE 0 END), 3) AS total_non_renewable,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Not Specified' THEN value ELSE 0 END) AS not_specified,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Other Renewables' THEN value ELSE 0 END) AS other_renewables
   FROM new_electricity_production
   GROUP BY 1, 2;
SELECT * FROM electricity_types;

DROP VIEW IF EXISTS renewables_types;
CREATE VIEW renewables_types AS
    SELECT 
        country_name, date_key, country_name || '_' || date_key AS country_date_key,
        ROUND(SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Total Renewables (Hydro, Geo, Solar, Wind, Other)' THEN value ELSE 0 END)
            + SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Nuclear' THEN value ELSE 0 END), 3) AS total_renewables,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Combustible Renewables' THEN value ELSE 0 END) AS combustible_renewables,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Hydro' THEN value ELSE 0 END) AS hydro,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Geothermal' THEN value ELSE 0 END) AS geothermal,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Solar' THEN value ELSE 0 END) AS solar,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Wind' THEN value ELSE 0 END) AS wind,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Other Renewables' THEN value ELSE 0 END) AS other_renewables,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Nuclear' THEN value ELSE 0 END) AS nuclear
    FROM new_electricity_production
   GROUP BY 1, 2;

DROP VIEW IF EXISTS non_renewables_types;
CREATE VIEW non_renewables_types AS
    SELECT 
        country_name, date_key, country_name || '_' || date_key AS country_date_key,
        ROUND(SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Total Combustible Fuels' THEN value ELSE 0 END) 
            - SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Combustible Renewables' THEN value ELSE 0 END), 3) AS total,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Oil and Petroleum Products' THEN value ELSE 0 END) AS oil_petroleum,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Coal, Peat and Manufactured Gases' THEN value ELSE 0 END) AS coal_peat_gases,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Natural Gas' THEN value ELSE 0 END) AS natural_gas,
        SUM(CASE WHEN parameter = 'Net Electricity Production' AND product = 'Other Combustible Non-Renewable' THEN value ELSE 0 END) AS other_non_renewabless
    FROM new_electricity_production
    GROUP BY 1, 2;