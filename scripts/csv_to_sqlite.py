import pandas as pd
import sqlite3
from pathlib import Path

project_root = Path(__file__).resolve().parent.parent
csv_path = project_root / "data" / "Walmart_Sales.csv"
db_path = project_root / "walmart_sales.db"

df = pd.read_csv(csv_path)
conn = sqlite3.connect(db_path)
df.to_sql("sales", conn, index=False, if_exists='replace')

print("Table created with columns: ", df.columns.tolist())
conn.close