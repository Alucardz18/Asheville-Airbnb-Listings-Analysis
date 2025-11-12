-- 5 most expensive neighbourhood
select 
	DENSE_RANK() over(order by avg(price) desc) as Ranks,
    neighbourhood, 
    round(avg(price),2) average_price     
from `listing-analysis-clean2`
GROUP BY neighbourhood 
limit 5;