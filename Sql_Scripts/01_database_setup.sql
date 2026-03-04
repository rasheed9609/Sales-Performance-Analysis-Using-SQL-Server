create database sales_performance
use sales_performance

  
-- Create table
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    customer_id INT,
    sales_rep VARCHAR(50),
    product_category VARCHAR(50),
    region VARCHAR(50),
    quantity INT,
    amount DECIMAL(10,2),
    cost DECIMAL(10,2),
    payment_method VARCHAR(30),
    sale_date DATE
);


-- Generate 5000 rows
;WITH Numbers AS (
    SELECT TOP (5000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO sales (
    order_id,
    customer_id,
    sales_rep,
    product_category,
    region,
    quantity,
    amount,
    cost,
    payment_method,
    sale_date
)
SELECT
    10001 + n AS order_id,

    -- 600 unique customers (120 high frequency)
    CASE 
        WHEN n % 5 = 0 THEN 1000 + (n % 120)
        ELSE 1120 + (n % 480)
    END AS customer_id,

    -- 8 sales reps
    CASE 
        WHEN n % 8 = 0 THEN 'Amit Sharma'
        WHEN n % 8 = 1 THEN 'Priya Nair'
        WHEN n % 8 = 2 THEN 'Rahul Verma'
        WHEN n % 8 = 3 THEN 'Sneha Iyer'
        WHEN n % 8 = 4 THEN 'Arjun Mehta'
        WHEN n % 8 = 5 THEN 'Neha Kapoor'
        WHEN n % 8 = 6 THEN 'Vikram Singh'
        ELSE 'Karan Malhotra'
    END AS sales_rep,

    -- Categories
    CASE 
        WHEN n % 5 = 0 THEN 'Electronics'
        WHEN n % 5 = 1 THEN 'Furniture'
        WHEN n % 5 = 2 THEN 'Clothing'
        WHEN n % 5 = 3 THEN 'Grocery'
        ELSE 'Accessories'
    END AS product_category,

    -- Regions
    CASE 
        WHEN n % 4 = 0 THEN 'North'
        WHEN n % 4 = 1 THEN 'West'
        WHEN n % 4 = 2 THEN 'South'
        ELSE 'East'
    END AS region,

    -- Quantity logic
    CASE 
        WHEN n % 5 = 0 THEN 1 + (n % 3)        -- Electronics
        WHEN n % 5 = 1 THEN 1 + (n % 2)        -- Furniture
        WHEN n % 5 = 2 THEN 2 + (n % 7)        -- Clothing
        WHEN n % 5 = 3 THEN 5 + (n % 26)       -- Grocery
        ELSE 1 + (n % 5)                       -- Accessories
    END AS quantity,

    -- Amount calculation
    CASE 
        WHEN n % 5 = 0 THEN (1 + (n % 3)) * (300 + (n % 1700))
        WHEN n % 5 = 1 THEN (1 + (n % 2)) * (500 + (n % 2500))
        WHEN n % 5 = 2 THEN (2 + (n % 7)) * (20 + (n % 130))
        WHEN n % 5 = 3 THEN (5 + (n % 26)) * (5 + (n % 35))
        ELSE (1 + (n % 5)) * (15 + (n % 185))
    END AS amount,

    -- Cost based on margins
    CASE 
        WHEN n % 5 = 0 THEN ((1 + (n % 3)) * (300 + (n % 1700))) * 0.85
        WHEN n % 5 = 1 THEN ((1 + (n % 2)) * (500 + (n % 2500))) * 0.80
        WHEN n % 5 = 2 THEN ((2 + (n % 7)) * (20 + (n % 130))) * 0.65
        WHEN n % 5 = 3 THEN ((5 + (n % 26)) * (5 + (n % 35))) * 0.92
        ELSE ((1 + (n % 5)) * (15 + (n % 185))) * 0.70
    END AS cost,

    -- Payment method distribution
    CASE 
        WHEN n % 20 < 8 THEN 'Credit Card'
        WHEN n % 20 < 14 THEN 'UPI'
        WHEN n % 20 < 17 THEN 'Debit Card'
        WHEN n % 20 < 19 THEN 'Cash'
        ELSE 'Net Banking'
    END AS payment_method,

    -- Date distribution (2023–2024)
    CASE 
        WHEN n < 2500 THEN DATEADD(DAY, n % 365, '2023-01-01')
        ELSE DATEADD(DAY, n % 365, '2024-01-01')
    END AS sale_date

FROM Numbers;
