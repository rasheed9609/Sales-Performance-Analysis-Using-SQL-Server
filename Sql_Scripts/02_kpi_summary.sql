-- ============================================================================================
-- KPI SUMMARY
-- MONTHLY REVENUE, PROFIT AND MARGIN ANALYSIS
-- ============================================================================================

-- Management wants to see current month performance summary
;with current_month as (
select 
	count(*) as total_orders,
	sum(amount) as total_revenue,
	sum(cost) as total_cost
from sales
where sale_date >='2023-01-01' and sale_date < '2023-02-01'
)
select 
	total_orders,
	Round(total_revenue,2) as total_revenue,
	ROUND(total_cost,2) as total_cost,
	Round(total_revenue - total_cost,2) as gross_profit,
	concat(ROUND(
		(total_revenue - total_cost) * 100.0 / nullif(total_revenue, 0),
		2
	),'%') as Gross_Margin_Percentage
from current_month

-- ============================================================================================
--2. MONTH OVER MONTH REVENUE GROWTH
-- ============================================================================================

-- Month-Over-Month revenue comparison

;with current_month as (
select 
	sum(amount) as current_revenue
from sales
where sale_date >= '2023-02-01' and sale_date < '2023-03-01'
),

previous_month as(
select 
	sum(amount) as previous_revenue
from sales
where sale_date >= '2023-01-01' and sale_date < '2023-02-01'
)

select 
	c.current_revenue,
	p.previous_revenue,
	CONCAT(ROUND(
			(c.current_revenue - p.previous_revenue) * 100.0 
			/ nullif(p.previous_revenue,0),
			2
	),' %') as revenue_growth_percentage
from current_month c
cross join previous_month p
