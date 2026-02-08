create database nyc_open_data_analyze;


select * from nyc_open_data_analyze.air_qual;

ALTER TABLE nyc_open_data_analyze.air_qual
CHANGE COLUMN `indicator name` `indicator_name` VARCHAR(255);



ALTER TABLE nyc_open_data_analyze.query
drop `:updated_at`;

-- Let's clean the data first.

-- first, let's create a NEW table for analysis, and keep the old one here.

create table REAL_QUER as
select * from nyc_open_data_analyze.air_qual;


-- Then, let's try and clean the table up and make it ready for analysis.

select * from real_quer;


alter table real_quer
rename column `start_date` to `clean_start_date`;

update real_quer
set `clean_start_date` = substring_index(clean_start_date, 'T', 1);
-- Now our data is ready for analysis.

select * from real_quer;

-- How has the value of a specific air quality changed over time in NYC?

select * from real_quer
where indicator_name = 'Fine particles (PM 2.5)' and geo_type_name = 'Citywide'
order by clean_start_date asc;

-- Answer: It decreases overtime.


-- Question 2: Which NYC borough or neighborhood shows the highest aerage air pollution level for a selected indicator?

select indicator_name, geo_place_name, avg(data_value) as average_thing
from real_quer
group by indicator_name, geo_place_name;

-- this could owkr, but lets do a single indicator and place.

select geo_place_name, avg(data_value) as average_thing
from real_quer
where indicator_name = 'OZONE (O3)'
and geo_place_name = 'West Queens'
group by indicator_name, geo_place_name;

select * from real_quer;


-- What places have ozone 03?

select count(geo_place_name) as amount, avg(data_value) as avthing, geo_place_name from real_quer
where indicator_name = 'Ozone (O3)'
group by geo_place_name
order by avthing desc;


select * from real_quer
where geo_place_name = 'Rockaway and Broad Channel (CD14)';
-- For the indicator of Ozone (O3), the place that has the most is 'Rockaway and Broad Channel (CD14)'

-- What places have ozone No2?

select count(geo_place_name) as amount, avg(data_value) as avthing, geo_place_name from real_quer
where indicator_name = 'Nitrogen dioxide (NO2)'
group by geo_place_name
order by avthing desc;

-- For the indicator of Nitrogen Dioxide (NO2), the place that has the highest average value is 'Midtown (CD5)'

select count(geo_place_name) as amount, avg(data_value) as avthing, geo_place_name from real_quer
where indicator_name = 'Fine particles (PM 2.5)'
group by geo_place_name
order by avthing desc;

-- For the indicator of Fine Particles (PM 2.5), the place that has the highest average value is 'Midtown (CD5)'


-- So for our question: Which NYC borough or neighborhood shows the highest aerage air pollution level for a selected indicator?
-- For the indicator of Ozone (O3), the place that has the most is 'Rockaway and Broad Channel (CD14)'
-- For the  For the indicators of Fine Particles (PM 2.5) and NO2, the place that has the highest average value is 'Midtown (CD5)'

-- Indicator types --> Ozone, Nitrogen Dioxide, Fine Particles
select * from real_quer;

select geo_type_name, count(geo_place_name) from real_quer
where indicator_name = 'Nitrogen Dioxide (NO2)'
group by geo_type_name;

-- Question 3: Are there noticable air quality measurements between different geography types? 


-- FOR OZONE
select * from real_quer;
select geo_type_name, avg(data_value) as btm
from real_quer
where indicator_name = 'Ozone (O3)'
group by geo_type_name
order by btm desc;


-- FOR Nitrogeen
select * from real_quer;
select geo_type_name, avg(data_value) as ttm
from real_quer
where indicator_name = 'Nitrogen Dioxide (NO2)'
group by geo_type_name
order by ttm desc;

-- For P.M
select * from real_quer;
select geo_type_name, avg(data_value) as pptm
from real_quer
where indicator_name = 'Fine particles (PM 2.5)'
group by geo_type_name
order by pptm desc;

-- Fine particles seem to have lower averages, than the others, while Ozone tends to have higher average values. 


-- In Ozone, Citywide tends to have higher averages.
-- In Nitrogen Dioxide, CD tends to have higher averages.
-- In Fine Particles CD tends to havehigher averages.


-- Question 4:  During which tyime period does the dataset show the worst air quality for a given indicator, and what is it values?

select * from real_quer;

select time_period, data_value from real_quer
where indicator_name = 'Ozone (O3)'
order by data_value desc
limit 1;

-- For Ozone 3, it was in the Summer 2023
-- 

select time_period, data_value from real_quer
where indicator_name = 'Nitrogen dioxide (NO2)'
order by data_value desc
limit 1;

-- For Nitrogen dioxide --> Winter 2013-14

select time_period, data_value from real_quer
where indicator_name = 'Fine particles (PM 2.5)'
order by data_value desc
limit 1;

-- For Fine particles, --> Winter 2013-14.


-- So for Ozone 3, it was in the Summer 2023. And for both fine particles and nitrogen dioxide it was 2013-14.alter





-- Question 5: How consistent or reliable are the data values, based on the messages or notes associated with the measurements. 


select message, count(message) as msg_count
from real_quer
where message is not null
and not message = ''
group by message
order by msg_count;

-- They are reliable. 


-- QUestion 6: How does air quaulity for a selected indicator change over time across different boroughs or neighborhoods?


