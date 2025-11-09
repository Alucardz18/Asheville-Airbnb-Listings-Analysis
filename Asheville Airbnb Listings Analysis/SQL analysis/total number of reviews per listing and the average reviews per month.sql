-- total number of reviews per listing and the average reviews per month
-- reviews per listing
select id, count(number_of_reviews) total_reviews
from `listing-analysis-clean2`
GROUP BY id
order by total_reviews desc
;

-- average reviews per month
select date_format(str_to_date(last_review, '%m/%d/%Y'), '%Y/%m')as review_month, round(avg(reviews_per_month),0) avgMonthlyReviews
from `listing-analysis-clean2`
where str_to_date(last_review, '%m/%d/%Y') is not null
group by review_month
order by review_month
;