use ashevilleairbnbanalysis;

-- Active Listings per Neighborhood
select neighbourhood, count(calculated_host_listings_count) active_listing
from `listing-analysis-clean2`
group by neighbourhood;