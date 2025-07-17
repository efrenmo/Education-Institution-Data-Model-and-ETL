/**
 *  Dim DML  
 * 		Step 1: Populate dim tables in schanl from schlnd
 * 
 * */


USE DATABASE wcd_lecture;
USE WAREHOUSE COMPUTE_WH;

---- STEP 1: Dim Tables
-------------- 1.1 course : need join the previous course(c) table with category(ca), program(p), employee(em) tables
TRUNCATE TABLE IF EXISTS schanl.course;
INSERT INTO schanl.course (
course_id,
course_name,
course_desc,
gov_code,
hours,
program_name,
program_desc,
pm_name,
program_start_date,
category_name,
category_desc,
director_name,
category_start_date,
active_flg)
SELECT 
	c.course_id,
	c.course_name,
	c.course_desc,
	c.gov_code,
	c.hours,
	p.program_name,
	p.program_desc,
	em.emp_name AS pm_name,
	p.start_date AS program_start_dt,
	ca.category_name,
	ca.category_desc,
	emp.emp_name AS director_name,
	ca.start_date AS category_start_dt,
	c.active_flg
FROM schlnd.course c
INNER JOIN   schlnd.program p ON c.program_id = p.program_id
INNER JOIN  schlnd.category ca ON p.category_id = ca.category_id
INNER JOIN schlnd.employee em ON p.pm_id = em.emp_id
INNER JOIN schlnd.employee emp ON ca.director_id = emp.emp_id;
		

-------------- 1.2 cohort : copy the previous cohort table.
TRUNCATE TABLE IF EXISTS schanl.cohort;
INSERT INTO schanl.cohort (
cohort_id,
cohort_name,
start_dt,
end_dt)
SELECT 
	cohort_id,
	cohort_name,
	start_dt,
	end_dt
FROM schlnd.cohort;

-------------- 1.3 student : previous students(s) table join the city(c) table.
TRUNCATE TABLE IF EXISTS schanl.students;
INSERT INTO schanl.students (
stu_id,
stu_name,
title,
birthday,
home_address,
postal_code,
city_name,
provn_name,
cntry_name,
phone_num,
email,
active_flg)
SELECT 
	s.stu_id,
	s.stu_name,
	s.title,
	s.birthday,
	s.home_address,
	s.postal_code,
	c.city_name,
	c.provn_name,
	c.cntry_name,
	s.phone_num,
	s.email,
	s.active_flg
FROM schlnd.students s
INNER JOIN schlnd.city c ON s.city_id = c.city_id;



