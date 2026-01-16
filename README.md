# SQL + Power BI: Walmart Holiday Sales Analysis and Strategy Recommendations

With a sales dataset containing information such as holiday flag, temperature, and fuel price, we aim to figure out how Walmart can optimize its sales strategy during the holidays to maximize its revenue across different stores. 

SQL is used to clean and extract data, while Power BI is used for visualization purposes. 

## Data Info

The dataset can be found on [Kaggle](https://www.kaggle.com/datasets/mikhail1681/walmart-sales/data). The dataset contains weekly sales inputs of various Walmart stores, as well as other economic and environment indicators shown in the schema below:

| Column Name     | Description      |
| ------------- | ------------- |
| Store | Store number |
| Date | The date that marks the start of a week |
| Weekly_Sales | Total sales of the week starting from Date |
| Holiday_Flag | Mark whether that week has a holiday (=1) or not (=0) |
| Temperature | Air temperature where the store is located |
| Fuel_Price | Fuel cost where the store is located |
| CPI | Consumer price index |
| Unemployment | Unemployment rate |

## Business Questions

Prior to coming up with a suitable strategy to boost holiday sales, we aim to answer the following questions:

1. Is there any change in sales during holiday weeks compared to normal weeks?

2. Which stores have the best overall performance and growth?

3. What are the impacts (negative/positive) of external factors (temperature, fuel price, CPI, unemployment rate) on sales? (e.g. Which stores are more sensitive/resistent to those factors?)

## Key Insights

1. Holiday weeks in November generate significant sales so stores should increase their staff count and ensure sufficient inventory during those weeks. December's holiday weeks accounts for only 15% of the month's sales, however December having the highest monthly sales means 1/the whole month is busy, and 2/people actually shop less on the holiday weeks; therefore, stores should increase their staff count for the whole month, probably focus more on weeks prior other than/prior to the holiday. 

2. Stores 4 and 39 have the best performance and growth, while stores 30 and 36 are at the bottom. Store 36 especially needs much work, given the significant decrease of 33.5% in 2012 sales comapred to 2010.

3.  Store 36 is highly vulnerable to external factors: high costs and inflation will lower sales; however, even with a low unemployment rate, the customers being cautious about spending indicates the store's failure to attract customers. Store 4 and 39 is more resistant and having both good pricing and customer loyalty. Store 38 and 44 currently have low sales, but their potentials are high with good pricing during inflation and high customer attraction even when economy is good. 

## Strategy Recommendations

1. Resources (inventory/staff) planning
2. in-store promotions targetted to each store (e.g. increase promotions where there's high unemployment)
3. increase advertisement budgets for stores with high potentials.

## Project Structure

```
├── data/                # Raw dataset 
│   └── Walmart_Sales.csv
├── scripts/             # Necessary scripts for connecting csv with sqlite, and load to Power BI
│   ├── csv_to_sqlite.py
│   └── load_to_powerbi.sql
├── sql/                 # SQL queries used for analysis
│   ├── 01_data_validation.sql
│   ├── 02_data_overview.sql
│   ├── 03_data_preprocessing.sql
│   ├── q1_holiday_vs_normal.sql
│   ├── q2_store_ranking.sql
│   └── q3_external_factor_impact.sql
├── powerbi/             # PBIX file 
├── images/              # Dashboard screenshots
└── README.md            
```