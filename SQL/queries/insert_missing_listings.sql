-- Adds the 4 listings missing from the table (their names start with a double quote)
INSERT INTO `listing-analysis-clean2`
(`id`, `name`, `host_id`, `host_name`, `neighbourhood`, `latitude`, `longitude`, `room_type`, `price`, `minimum_nights`, `number_of_reviews`, `last_review`, `reviews_per_month`, `calculated_host_listings_count`, `availability_365`, `number_of_reviews_ltm`, `id - Copy`)
VALUES
(942934, '"ZenShe" ... Very Clean, Quiet and Convenient', 5100332, 'Pat', 28806, 35.57244, -82.58949, 'Private room', 66, 2, 697, '6/2/2025', 4.67, 1, 171, 27, 942934),
(29003338, '"Birds & Bidets", 10min DT+ Biltmore, Hot Tub, EV', 161304476, 'James', 28803, 35.55336761, -82.46253967, 'Entire home/apt', 275, 2, 206, '5/27/2025', 2.57, 1, 332, 17, 29003338),
(52827301, '"White Cottage Inn" Charming, Cozy & Convenient!', 396623834, 'Christina', 28704, 35.45257, -82.50495, 'Entire home/apt', 161, 2, 27, '4/27/2025', 0.61, 1, 364, 4, 52827301),
(1073350000000000000, '"Magical, One of a Kind" Mirror House + Hot Tub', 142697419, 'Bryan Austin', 28804, 35.62004753, -82.51433791, 'Entire home/apt', 302, 1, 33, '6/13/2025', 7.67, 1, 279, 33, 1073350000000000000);
