USE ashevilleairbnbanalysis;

/*  REVIEW HISTORY ANALYSIS: one row per review from reviews.csv  */

-- Reviews table: listing ID and review date
CREATE TABLE IF NOT EXISTS reviews (
  listing_id  BIGINT,
  review_date DATE
);

-- Loads reviews.csv into the reviews table (commented out)
-- LOAD DATA LOCAL INFILE 'Data/Raw/reviews.csv'
-- INTO TABLE reviews
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (listing_id, review_date);

-- Total reviews per year (2025 data ends in June)
CREATE OR REPLACE VIEW reviews_by_year AS
SELECT YEAR(review_date) AS review_year,
       COUNT(*)          AS total_reviews
FROM reviews
GROUP BY YEAR(review_date)
ORDER BY review_year;

-- Total reviews per calendar month, 2021 to 2024
CREATE OR REPLACE VIEW reviews_by_month_2021_2024 AS
SELECT MONTH(review_date)     AS month_num,
       MONTHNAME(review_date) AS month_name,
       COUNT(*)               AS total_reviews
FROM reviews
WHERE YEAR(review_date) BETWEEN 2021 AND 2024
GROUP BY MONTH(review_date), MONTHNAME(review_date)
ORDER BY month_num;

-- Number and share of reviews per day of the week
CREATE OR REPLACE VIEW reviews_by_weekday AS
SELECT DAYNAME(review_date) AS weekday,
       COUNT(*)             AS total_reviews,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM reviews), 1) AS percentage
FROM reviews
GROUP BY DAYNAME(review_date)
ORDER BY total_reviews DESC;
