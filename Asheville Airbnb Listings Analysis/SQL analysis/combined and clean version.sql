-- Row count
SELECT COUNT(*) AS total_rows FROM `listing-analysis-clean2`;

-- Average & Median Nightly Price
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


-- Distribution of Room Types (count & percentage)
WITH base AS (
  SELECT id, room_type
  FROM `listing-analysis-clean2`
  WHERE room_type IS NOT NULL
),
tot AS (
  SELECT COUNT(DISTINCT id) AS total_listings FROM base
)
SELECT
  b.room_type,
  COUNT(DISTINCT b.id) AS total_room_type,
  ROUND(100.0 * COUNT(DISTINCT b.id) / t.total_listings, 2) AS percentage
FROM base b
CROSS JOIN tot t
GROUP BY b.room_type, t.total_listings
ORDER BY total_room_type DESC;



-- Active Listings per Neighborhood
SELECT
  neighbourhood,
  COUNT(DISTINCT id) AS active_listings
FROM `listing-analysis-clean2`
WHERE neighbourhood IS NOT NULL
GROUP BY neighbourhood
ORDER BY active_listings DESC;


-- Average Price by Neighborhood
SELECT
  neighbourhood,
  ROUND(AVG(price), 2) AS average_price
FROM `listing-analysis-clean2`
WHERE price IS NOT NULL AND neighbourhood IS NOT NULL
GROUP BY neighbourhood
ORDER BY average_price DESC;


-- Top 5 Most Expensive Neighborhoods by Avg Price
WITH avg_neigh AS (
  SELECT
    neighbourhood,
    ROUND(AVG(price), 2) AS average_price
  FROM `listing-analysis-clean2`
  WHERE price IS NOT NULL AND neighbourhood IS NOT NULL
  GROUP BY neighbourhood
),
ranked AS (
  SELECT
    neighbourhood,
    average_price,
    DENSE_RANK() OVER (ORDER BY average_price DESC) AS rank_num
  FROM avg_neigh
)
SELECT rank_num AS ranked,
       neighbourhood,
       average_price
FROM ranked
WHERE rank_num <= 5
ORDER BY rank_num, average_price DESC;


-- Does minimum_nights affect average price?
WITH buck AS (
  SELECT
    CASE
      WHEN minimum_nights BETWEEN 1 AND 2  THEN '1–2 nights'
      WHEN minimum_nights BETWEEN 3 AND 4  THEN '3–4 nights'
      WHEN minimum_nights BETWEEN 5 AND 7  THEN '5–7 nights'
      WHEN minimum_nights BETWEEN 8 AND 14 THEN '8–14 nights'
      WHEN minimum_nights BETWEEN 15 AND 30 THEN '15–30 nights'
      ELSE '31+ nights'
    END AS stay_length,
    price
  FROM `listing-analysis-clean2`
  WHERE price IS NOT NULL AND minimum_nights IS NOT NULL
)
SELECT
  stay_length,
  ROUND(AVG(price), 2) AS avg_price,
  COUNT(*) AS listing_count
FROM buck
GROUP BY stay_length
ORDER BY avg_price DESC;



-- Total Number of Reviews per Listing
SELECT
  id,
  SUM(number_of_reviews) AS total_reviews
FROM `listing-analysis-clean2`
WHERE id IS NOT NULL
GROUP BY id
ORDER BY total_reviews DESC;


-- Average Reviews per Month (by YYYY-MM of last_review)
WITH parsed AS (
  SELECT
    CASE
      WHEN last_review REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN STR_TO_DATE(last_review, '%m/%d/%Y')
      WHEN last_review REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(last_review, '%Y-%m-%d')
      ELSE NULL
    END AS last_review_dt,
    reviews_per_month
  FROM `listing-analysis-clean2`
)
SELECT
  DATE_FORMAT(last_review_dt, '%Y-%m') AS review_month,
  ROUND(AVG(reviews_per_month), 2) AS avg_monthly_reviews
FROM parsed
WHERE last_review_dt IS NOT NULL AND reviews_per_month IS NOT NULL
GROUP BY DATE_FORMAT(last_review_dt, '%Y-%m')
ORDER BY review_month;


-- Total reviews by neighborhood
SELECT
  neighbourhood,
  SUM(number_of_reviews) AS total_reviews
FROM `listing-analysis-clean2`
WHERE neighbourhood IS NOT NULL
GROUP BY neighbourhood
ORDER BY total_reviews DESC;


-- Average reviews per month by neighborhood
SELECT
  neighbourhood,
  ROUND(AVG(reviews_per_month), 2) AS avg_reviews_per_month
FROM `listing-analysis-clean2`
WHERE neighbourhood IS NOT NULL AND reviews_per_month IS NOT NULL
GROUP BY neighbourhood
ORDER BY avg_reviews_per_month DESC;
