use ashevilleairbnbanalysis;

-- Active Listings per Neighborhood
select neighbourhood, count(*) active_listing
from `listing-analysis-clean2`
group by neighbourhood
order by active_listing desc;