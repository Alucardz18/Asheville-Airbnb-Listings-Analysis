use ashevilleairbnbanalysis;

-- Active Listings per Neighborhood
select neighbourhood, count(distinct id) active_listing
from `listing-analysis-clean2`
group by neighbourhood
order by active_listing desc;