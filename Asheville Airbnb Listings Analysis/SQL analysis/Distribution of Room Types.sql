use ashevilleairbnbanalysis;
-- Distribution of Room Types
SELECT 
    room_type,
    COUNT(*) AS totalRoomType,
    ROUND((100.0 * COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    `listing-analysis-clean2`)),
            1) AS percentage
FROM
    `listing-analysis-clean2`
GROUP BY room_type;