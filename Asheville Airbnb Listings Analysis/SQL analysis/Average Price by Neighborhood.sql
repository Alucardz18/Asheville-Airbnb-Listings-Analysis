-- Average price by neighbourhood
SELECT 
    neighbourhood, ROUND(AVG(price), 2) average_price
FROM
    `listing-analysis-clean2`
GROUP BY 1
ORDER BY 2 DESC;
