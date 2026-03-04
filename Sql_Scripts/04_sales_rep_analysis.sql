-- =============================================================================================
-- SALES REPRESENTATIVE PERFORMANCE ANALYSIS 
-- =============================================================================================


-- sales rep performance 

;with sales_rep_performance as (
select
	sales_rep,
	count(order_id) as deal_closed,
	sum(amount) as total_revenue,
	sum(amount) - sum(cost) as gross_profit,
	ROUND(avg(amount),2) as avg_order_value
from sales
where sale_date >= '2024-06-01' and sale_date < '2024-07-01'
group by sales_rep
),
avg_revenue as(
	select 
		avg(total_revenue) as avg_rep_revenue 
	from sales_rep_performance
)
select	
	s.sales_rep,
	s.deal_closed,
	s.total_revenue,
	s.gross_profit,
	s.avg_order_value
from sales_rep_performance s
cross join avg_revenue a
where s.total_revenue > a.avg_rep_revenue
order by s.total_revenue desc

