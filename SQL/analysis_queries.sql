-- =====================================================
-- Query 1 - Monthly Revenue Trend
-- =====================================================

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS month,
    ROUND(SUM(Sales), 2) AS total_revenue,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY month;


-- =====================================================
-- Query 2 - Top 10 Products by Revenue
-- =====================================================

SELECT
    Product_Name,
    ROUND(SUM(Sales), 2) AS revenue,
    SUM(Quantity) AS units_sold
FROM sales
GROUP BY Product_Name
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- Query 3 - Revenue and Profit by Region
-- =====================================================

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM sales
GROUP BY Region
ORDER BY revenue DESC;


-- =====================================================
-- Query 4 - Category-wise Profit Margin
-- =====================================================

SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_pct
FROM sales
GROUP BY Category, Sub_Category
ORDER BY margin_pct ASC
LIMIT 10;


-- =====================================================
-- Query 5 - Discount vs Profit Relationship
-- =====================================================

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.2 THEN 'Low (0-20%)'
        WHEN Discount <= 0.4 THEN 'Medium (20-40%)'
        ELSE 'High (40%+)'
    END AS discount_band,
    COUNT(*) AS num_orders,
    ROUND(AVG(Profit), 2) AS avg_profit,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY discount_band
ORDER BY avg_profit DESC;


-- =====================================================
-- Query 6 - Customer Order Frequency
-- =====================================================

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS num_orders,
    ROUND(SUM(Sales), 2) AS total_spend
FROM sales
GROUP BY Customer_ID, Customer_Name
ORDER BY total_spend DESC
LIMIT 20;


-- =====================================================
-- Query 7 - Year-over-Year Growth
-- =====================================================

WITH yearly_sales AS (
    SELECT
        YEAR(Order_Date) AS year,
        SUM(Sales) AS revenue
    FROM sales
    GROUP BY YEAR(Order_Date)
)

SELECT
    year,
    ROUND(revenue,2) AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY year),2) AS prev_year_revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY year)
        ) * 100 /
        LAG(revenue) OVER (ORDER BY year),
        2
    ) AS yoy_growth_pct
FROM yearly_sales;


-- =====================================================
-- Query 8 - Shipping Delay Analysis
-- =====================================================

SELECT
    Ship_Mode,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)),1) AS avg_days_to_ship,
    COUNT(*) AS num_orders
FROM sales
GROUP BY Ship_Mode
ORDER BY avg_days_to_ship DESC;