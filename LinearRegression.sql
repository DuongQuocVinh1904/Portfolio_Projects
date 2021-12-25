select date, new_cases from dbo.vietnam$
where date >'2021-12-15'
--                                             MATH
-- The linear regression line: y= mx+b with m: slope and b: intercept
-- Calculate the averages of x and y (new_cases) for all rows
with cte as(
	select date, new_cases, ROW_NUMBER() over (order by date) as x from dbo.vietnam$
	where date >'2021-12-15')

-- Calculate the term: [Xi-average(x)][Yi-average(y)] with SLOPE AND INTERCEPT
, cte2 as (select	 x,      avg(x) over () as x_bar,
			new_cases, avg(new_cases) over () as y_bar
				from cte)
, cte3 as (	select sum((x-x_bar)*(new_cases-y_bar))/sum((x-x_bar)*(x-x_bar)) as slope,
			max(x_bar) as x_bar_max
			,max(y_bar) as y_bar_max
			from cte2)
	select slope, (y_bar_max - x_bar_max)*slope as intercept
	from cte3
-- Visualize the REGRESSION LINE
with cte as(
	select date, new_cases, ROW_NUMBER() over (order by date) as x from dbo.vietnam$
	where date >'2021-12-15')
select x, new_cases, x*-2348.60526315789+-44070403.4605263 as y_fit from 
		(select x, new_cases from cte) s

