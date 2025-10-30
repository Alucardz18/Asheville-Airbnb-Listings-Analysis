-- Does minimum_nights affect average price?
SELECT 
  CASE
    WHEN minimum_nights BETWEEN 1 AND 2 THEN '1–2 nights'
    WHEN minimum_nights BETWEEN 3 AND 4 THEN '3–4 nights'
    WHEN minimum_nights BETWEEN 5 AND 7 THEN '5–7 nights'
    WHEN minimum_nights BETWEEN 8 AND 14 THEN '8–14 nights'
    WHEN minimum_nights BETWEEN 15 AND 30 THEN '15–30 nights'
    ELSE '31+ nights'
  END AS stay_length,
  ROUND(AVG(price), 2) AS avg_price,
  COUNT(*) AS listing_count
FROM `listing-analysis-clean2`
WHERE price IS NOT NULL
GROUP BY stay_length_category
ORDER BY avg_price DESC;

