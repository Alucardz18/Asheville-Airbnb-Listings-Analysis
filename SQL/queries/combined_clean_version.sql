USE ashevilleairbnbanalysis;

/*    CLEAN BASE */
CREATE OR REPLACE VIEW listings_clean AS
SELECT *
FROM `listing-analysis-clean2`
WHERE price IS NOT NULL
  AND neighbourhood IS NOT NULL;

/*    DESCRIPTIVE ANALYSIS */

-- Overall average & median nightly price
CREATE OR REPLACE VIEW overall_avg_median_price AS
WITH ordered AS (
  SELECT price,
         ROW_NUMBER() OVER (ORDER BY price) AS rn,
         COUNT(*)    OVER ()                AS cnt
  FROM `listing-analysis-clean2`
  WHERE price IS NOT NULL
)
SELECT
  ROUND(AVG(price), 2) AS average_price,
  ROUND(AVG(CASE WHEN rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2)) THEN price END), 2) AS median_price
FROM ordered;

-- Room type distribution (count & %)
CREATE OR REPLACE VIEW room_type_distribution AS
WITH base AS (
  SELECT id, room_type
  FROM listings_clean
  WHERE room_type IS NOT NULL
),
tot AS ( SELECT COUNT(DISTINCT id) AS total_listings FROM base )
SELECT
  b.room_type,
  COUNT(DISTINCT b.id) AS total_room_type,
  ROUND(100.0 * COUNT(DISTINCT b.id) / NULLIF(t.total_listings,0), 2) AS percentage
FROM base b
CROSS JOIN tot t
GROUP BY b.room_type, t.total_listings;

-- Active listings per neighborhood (unique listings)
CREATE OR REPLACE VIEW active_listings_by_neighborhood AS
SELECT neighbourhood,
       COUNT(DISTINCT id) AS active_listings
FROM listings_clean
GROUP BY neighbourhood;

/*    PRICING INSIGHTS */

-- Average price by neighborhood
CREATE OR REPLACE VIEW avg_price_by_neighborhood AS
SELECT neighbourhood,
       ROUND(AVG(price), 2) AS average_price
FROM listings_clean
GROUP BY neighbourhood;

-- Top 5 most expensive neighborhoods (dense-ranked)
CREATE OR REPLACE VIEW top5_neighborhoods AS
WITH avg_neigh AS (
  SELECT neighbourhood, ROUND(AVG(price), 2) AS average_price
  FROM listings_clean
  GROUP BY neighbourhood
),
ranked AS (
  SELECT neighbourhood,
         average_price,
         DENSE_RANK() OVER (ORDER BY average_price DESC) AS rank_num
  FROM avg_neigh
)
SELECT rank_num, neighbourhood, average_price
FROM ranked
WHERE rank_num <= 5;

-- Avg & median nightly price BY minimum_nights
CREATE OR REPLACE VIEW avg_median_price_by_min_nights AS
WITH ordered AS (
  SELECT minimum_nights,
         price,
         ROW_NUMBER() OVER (PARTITION BY minimum_nights ORDER BY price) AS rn,
         COUNT(*)    OVER (PARTITION BY minimum_nights)                 AS cnt
  FROM listings_clean
  WHERE minimum_nights IS NOT NULL
)
SELECT minimum_nights,
       ROUND(AVG(price), 2) AS average_price,
       ROUND(AVG(CASE
         WHEN rn IN (FLOOR((cnt + 1)/2), CEIL((cnt + 1)/2)) THEN price
       END), 2) AS median_price
FROM ordered
GROUP BY minimum_nights;

-- Does minimum_nights affect average price? (bucketed)
CREATE OR REPLACE VIEW min_nights_vs_price AS
SELECT
  CASE
    WHEN minimum_nights BETWEEN 1  AND 2  THEN '1–2 nights'
    WHEN minimum_nights BETWEEN 3  AND 4  THEN '3–4 nights'
    WHEN minimum_nights BETWEEN 5  AND 7  THEN '5–7 nights'
    WHEN minimum_nights BETWEEN 8  AND 14 THEN '8–14 nights'
    WHEN minimum_nights BETWEEN 15 AND 30 THEN '15–30 nights'
    ELSE '31+ nights'
  END AS stay_length,
  ROUND(AVG(price), 2) AS avg_price,
  COUNT(*)             AS listing_count
FROM listings_clean
WHERE minimum_nights IS NOT NULL
GROUP BY stay_length;

/*    REVIEW & DEMAND ANALYSIS */

-- Total reviews per listing (prefer SUM of total column)
CREATE OR REPLACE VIEW total_reviews_per_listing AS
SELECT id,
       SUM(number_of_reviews) AS total_reviews
FROM `listing-analysis-clean2`
WHERE id IS NOT NULL
GROUP BY id;

-- Average reviews per month by YYYY-MM of last_review
CREATE OR REPLACE VIEW avg_reviews_per_month AS
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
SELECT DATE_FORMAT(last_review_dt, '%Y-%m') AS review_month,
       ROUND(AVG(reviews_per_month), 2)     AS avg_monthly_reviews
FROM parsed
WHERE last_review_dt IS NOT NULL AND reviews_per_month IS NOT NULL
GROUP BY DATE_FORMAT(last_review_dt, '%Y-%m');

-- Neighborhoods with most guest activity (total reviews)
CREATE OR REPLACE VIEW neighborhood_total_reviews AS
SELECT neighbourhood,
       SUM(number_of_reviews) AS total_reviews
FROM `listing-analysis-clean2`
WHERE neighbourhood IS NOT NULL
GROUP BY neighbourhood;

/*  HOST ANALYSIS  */

-- Hosts with the most listings
CREATE OR REPLACE VIEW top_hosts_by_listing_count AS
SELECT host_id, host_name, COUNT(DISTINCT id) AS listings_count
FROM `listing-analysis-clean2`
GROUP BY host_id, host_name;

-- Do multi-listing hosts charge more?
CREATE OR REPLACE VIEW host_scale_vs_price AS
SELECT calculated_host_listings_count,
       ROUND(AVG(price), 2) AS avg_price,
       COUNT(*) AS listing_count
FROM `listing-analysis-clean2`
WHERE price IS NOT NULL AND calculated_host_listings_count IS NOT NULL
GROUP BY calculated_host_listings_count;


