/***
 * 			
 * 			Initialize tables in analytics schema schanl
 * 			
 *  
 */

USE DATABASE WCD_EDU;
CREATE SCHEMA IF NOT EXISTS schanl;


 ---------- /*CREATE TABLES IN THE ANALYTICS ZONE schanl*/
CREATE OR REPLACE TABLE schanl.course	 (
course_id	int,
course_name	varchar(30),
course_desc	varchar(150),
gov_code	varchar(10),
full_time	boolean,
hours	int,
program_name	varchar(30),
program_desc	varchar(150),
pm_name	varchar(30),
program_start_date	date,
category_name	varchar(30),
category_desc	varchar(150),
director_name	varchar(30),
category_start_date	date,
active_flg	boolean
);

CREATE OR REPLACE TABLE schanl.cohort	 (
cohort_id	int,
cohort_name	varchar(30),
start_dt	date,
end_dt	date
);

CREATE OR REPLACE TABLE schanl.students	 (
stu_id	int,
stu_name	varchar(100),
emp_type_id	int,
title	date,
birthday	int,
home_address	varchar(300),
postal_code	varchar(30),
city_name	varchar(100),
provn_name	varchar(100),
cntry_name	varchar(100),
phone_num	int,
email	varchar(100),
active_flg	boolean
);

CREATE OR REPLACE TABLE schanl.calendar (
cal_dt	date,
day_of_wk_num 	int,
day_of_wk_desc	varchar(30),
yr_num	integer,
wk_num	integer,
yr_wk_num	integer,
mnth_num	integer,
yr_mnth_num	 integer
);

CREATE OR REPLACE TABLE schanl.transaction (
trans_dt	date,
stu_id	int,
course_id	int,
cohort_id	int,
full_price	NUMERIC,
discount_rate	NUMERIC,
payment_amount	NUMERIC,
full_paid	boolean,
avg_cohort_discount_rate	NUMERIC,
avg_discount_rate	NUMERIC
);
