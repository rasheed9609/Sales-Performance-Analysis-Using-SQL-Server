-- =============================================================================================
-- CUSTOMER REVENUE ANALYSIS 
-- =============================================================================================

-- TOP 3 CUSTOMERS BY REVENUE


;with top_customers as (
select	
	customer_id,
	sum(amount) as total_revenue
from sales
group by customer_id
),

top_three_customers as (
	select *, row_number() over(order by total_revenue desc ) as rnk 
	from top_customers
)
select * from top_three_customers
where rnk <= 3


-- TOP 3 CUSTOMERS PER REGION

;with top_cust_region as (
select 
	region,
	customer_id,
	sum(amount) as total_revenue
from sales
group by region,customer_id
)
select * from(
select 
	region,
	customer_id,
	total_revenue,
	ROW_NUMBER() over(partition by region order by total_revenue desc) rnk
from top_cust_region
)t
where rnk <=3
