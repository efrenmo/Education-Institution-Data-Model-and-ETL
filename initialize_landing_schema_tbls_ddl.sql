/***
 * 			
 * 			Initialize tables in landing schema schlnd
 * 			
 *  
 */

USE DATABASE WCD_EDU;
CREATE SCHEMA IF NOT EXISTS schlnd; -- creating schema FOR raw DATA FROM SYSTEM landing;


-- /*CREATE TABLES IN THE LANING ZONE schlnd*/
CREATE OR REPLACE TABLE schlnd.course (
course_id	int,
course_name	varchar(30),
course_desc	varchar(150),
gov_code	varchar(10),
full_time	boolean,
hours	int,
program_id	int,
active_flg	boolean
);


CREATE OR REPLACE TABLE schlnd.cohort (
cohort_id	int,
cohort_name	varchar(30),
start_dt	date,
end_dt	 date
);

CREATE OR REPLACE TABLE schlnd.program (
program_id	int,
program_name	varchar(30),
program_desc	varchar(150),
pm_id	int,
start_date	date,
active_flg	boolean,
category_id	int
);

CREATE OR REPLACE TABLE schlnd.category (
category_id	int,
category_name	varchar(30),
category_desc	varchar(150),
director_id	int,
start_date	date,
active_flg	boolean
);

CREATE OR REPLACE TABLE schlnd.employee (
emp_id	int,
emp_name	varchar(100),
emp_type_id	int,
status	varchar(30),
city_id	 int,
birthday	int,
title	date,
manager_id	boolean,
home_address	varchar(300),
phone_num	int,
email	varchar(100),
active_flg	boolean
);

CREATE OR REPLACE TABLE schlnd.students (
stu_id	int,
stu_name	varchar(100),
emp_type_id	int,
title	date,
birthday	int,
home_address	varchar(300),
postal_code	varchar(30),
city_id	 int,
phone_num	int,
email	varchar(100),
active_flg	boolean
);

CREATE OR REPLACE TABLE schlnd.city (
city_id	 int,
city_name	varchar(100),
provn_id 	int,
provn_name	varchar(100),
cntry_id	int,
cntry_name	varchar(100)
);

CREATE OR REPLACE TABLE schlnd.discount_type (
discount_type_id	int,
discount_type_name	varchar(30),
discount_rate	numeric
);


CREATE OR REPLACE TABLE schlnd.enrollment (
enrl_id	int,
enrl_date	date,
stu_id	int,
course_id	int,
cohort_id	int
);

CREATE OR REPLACE TABLE schlnd.transaction	 (
trans_id	int,
trans_dt	date,
enrl_id	int,
pymt_type_id	int,
full_price	NUMERIC,
discount_type_id	int,
payment_amount	NUMERIC,
full_paid	boolean
);
