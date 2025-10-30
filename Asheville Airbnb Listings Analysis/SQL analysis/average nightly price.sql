use ashevilleairbnbanalysis;

--  average and median nightly price
with ranks as( 
	select minimum_nights, price,
		ROW_NUMBER() over(partition by minimum_nights order by price) as ranking,
        count(*) over(partition by minimum_nights) as total_number
	from `listing-analysis-clean2`
    where price is not null
)
select minimum_nights,
round(avg(price),2) as average_price,
round(avg(case
			when ranking in (
            floor((total_number + 1)/2), 
            ceil((total_number + 1)/2)) then price end), 2) as median_price
from ranks
GROUP BY minimum_nights
;
