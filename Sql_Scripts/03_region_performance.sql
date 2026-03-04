-- ============================================================================================
-- REGION PERFORMANCE ANALYSIS
-- ============================================================================================

-- Region wise monthly performance

;with region_performance as (

select 
	region,
	count(*) as total_orders,
	sum(amount) as total_revenue,
	sum(cost) as total_cost,
	ROUND(sum(amount) - sum(cost),2) as gross_profit,
	CONCAT(ROUND( 
		(sum(amount) - sum(cost)) * 100.0 
		/ nullif(sum(amount), 0), 
		2
	),' %') as gross_margin_percentage,
	count(distinct customer_id) as unique_customers
from sales
where sale_date >= '2023-01-01' and sale_date < '2023-02-01'
group by region

)
select * from region_performance
order by total_revenue desc

