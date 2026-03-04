-- =============================================================================================
-- PRODUCT CATEGORY REVENUE CONTRIBUTION ANALYSIS
-- =============================================================================================

-- what is the percentage of total monthly revenue comes from each product category?

;with category_revenue as (

select 
	product_category,
	sum(amount) as total_revenue
from sales
where sale_date >= '2024-06-01' and sale_date < '2024-07-01'
group by product_category
),
total_monthly_revenue as (
select 
	sum(total_revenue) overall_revenue
from category_revenue
)

select 
	c.product_category,
	c.total_revenue,
	round(c.total_revenue * 100.0 / nullif(t.overall_revenue,2),0) as revenue_percentage
from category_revenue c
cross join total_monthly_revenue t
order by revenue_percentage DESC
