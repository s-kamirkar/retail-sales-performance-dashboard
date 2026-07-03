import pandas as pd
import mysql.connector

# -------------------------------
# Load CSV
# -------------------------------
df = pd.read_csv("Sample - Superstore.csv", encoding="latin1")

# -------------------------------
# Clean column names
# -------------------------------
df.columns = (
    df.columns
      .str.strip()
      .str.replace(" ", "_")
      .str.replace("-", "_")
)

# -------------------------------
# Convert dates
# -------------------------------
df["Order_Date"] = pd.to_datetime(df["Order_Date"], format="%m/%d/%Y")
df["Ship_Date"] = pd.to_datetime(df["Ship_Date"], format="%m/%d/%Y")

# -------------------------------
# Connect to MySQL
# -------------------------------
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="password",      # <-- Replace this
    database="retail_sales_analysis"
)

cursor = conn.cursor()

# -------------------------------
# SQL Insert Query
# -------------------------------
query = """
INSERT INTO sales (
    Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode,
    Customer_ID, Customer_Name, Segment, Country, City,
    State, Postal_Code, Region, Product_ID, Category,
    Sub_Category, Product_Name, Sales, Quantity,
    Discount, Profit
)
VALUES (
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s,
    %s, %s, %s, %s,
    %s, %s
)
"""

# -------------------------------
# Insert rows
# -------------------------------
for row in df.itertuples(index=False):
    cursor.execute(query, tuple(row))

conn.commit()

print(f"Inserted {cursor.rowcount} rows.")

cursor.close()
conn.close()