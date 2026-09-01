create or replace table customer_journey as select * from read_csv('raw_data/customer_journey.csv');

create or replace table customer_reviews as select * from read_csv('raw_data/customer_reviews.csv');

create or replace table customers as select * from read_csv('raw_data/customers.csv');

create or replace table engagement_data as select * from read_csv('raw_data/engagement_data.csv');

create or replace table geography as select * from read_csv('raw_data/geography.csv');

create or replace table products as select * from read_csv('raw_data/products.csv');

create or replace table clean_customer_reviews as select id, customer_id, product_id, review_date, rating, trim(regexp_replace(comment, '\s+', ' ', 'g')) as comment from customer_reviews;

create or replace table clean_engagement_data as select id, content_id, replace(upper(substr(type, 1, 1)) || lower(substr(type, 2)),'Socialmedia','Social Media') as type, likes, engagement_date, campaign_id, product_id, cast(replace(regexp_extract(views_clicks, '^[^-]+'),'Oct','10') as int64) as views, cast(regexp_extract(views_clicks,'([^-]*)$') as int64) as clicks from engagement_data;

create or replace table clean_customer_journey as with cleaned as (select *, row_number() over (partition by id) times from customer_journey qualify times < 2 order by id) select id, customer_id, product_id, visit_date, stage, action, cast(replace(duration,'NULL','0') as int64) as duration from cleaned;

copy clean_customer_reviews to 'clean_data/clean_customer_reviews.csv' (header, delimiter ',');

copy clean_engagement_data to 'clean_data/clean_engagement_data.csv' (header, delimiter ',');

copy clean_customer_journey to 'clean_data/clean_customer_journey.csv' (header, delimiter ',');

copy products to 'clean_data/products.csv' (header, delimiter ',');

copy geography to 'clean_data/geography.csv' (header, delimiter ',');

copy customers to 'clean_data/customers.csv' (header, delimiter ',');