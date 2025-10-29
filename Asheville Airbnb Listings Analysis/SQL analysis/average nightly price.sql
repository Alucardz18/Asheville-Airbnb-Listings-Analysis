use ashevilleairbnbanalysis;
SELECT * FROM ashevilleairbnbanalysis.`listing-analysis-clean2`;

--  average and median nightly price
-- average
select minimum_nights, round(avg(price),2) as average_price
from `listing-analysis-clean2`
GROUP BY 1
order by average_price desc;

-- median