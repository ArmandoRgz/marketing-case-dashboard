select id, name, price, case when price < 50 then 'Low' when price between 50 and 200 then 'Medium' else 'High' end as price_category from products order by price desc;

select x.id, name, email, gender, age, country, city from customers x left join geography y on geography_id = y.id;

create or replace table clean_customer_reviews as select id, customer_id, product_id, review_date, rating, trim(regexp_replace(comment, '\s+', ' ', 'g')) as comment from customer_reviews;

select id, content_id, replace(upper(substr(type, 1, 1)) || lower(substr(type, 2)),'Socialmedia','Social Media') as type, likes, engagement_date, campaign_id, product_id, regexp_extract(views_clicks, '^[^-]+') as views, regexp_extract(views_clicks,'([^-]*)$') as clicks from engagement_data;

create or replace table clean_engagement_data as select id, content_id, replace(upper(substr(type, 1, 1)) || lower(substr(type, 2)),'Socialmedia','Social Media') as type, likes, engagement_date, campaign_id, product_id, cast(replace(regexp_extract(views_clicks, '^[^-]+'),'Oct','10') as int64) as views, cast(regexp_extract(views_clicks,'([^-]*)$') as int64) as clicks from engagement_data;

create or replace table clean_customer_journey as with cleaned as (select *, row_number() over (partition by id) times from customer_journey qualify times < 2 order by id) select id, customer_id, product_id, visit_date, stage, action, cast(replace(duration,'NULL','0') as int64) as duration from cleaned;

copy clean_customer_reviews to 'clean_customer_reviews.csv' (header, delimiter ',');