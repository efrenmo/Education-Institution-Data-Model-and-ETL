/**
 *  Fact DML 
 * 		Step 2: Populate fact table in schanl from sclnd
 * 
 * */   

---- STEP 2: Fact table : to create this fact table, we need several steps, and need to create several transient tables.
----------------The atomic row is trans_dt + stu_id + course_id + cohort_id


---------------step 2.1 join the original transaction and enrollment table together, and replace discount_type_id with discount_rate. This table will be used as basic table
--------------------in the follow transformations.

TRUNCATE TABLE IF EXISTS schanl.stu_enrl;
CREATE OR REPLACE TRANSIENT TABLE schanl.stu_enrl AS 
SELECT 
	t.trans_id,
	t. trans_dt,
	e.stu_id,
	e.course_id,
	e.cohort_id,
	t.full_price,
	d.discount_rate,
	t.payment_amount,
	t.full_paid
FROM schlnd.transaction t
JOIN schlnd.enrollment e ON t.enrl_id = e.enrl_id AND t.trans_dt=e.enrl_date
JOIN schlnd.discount_type d ON t. discount_type_id = d. discount_type_id;

----------step 2.2 aggregate data on day level, because our atomic is on day rather than trans_id
---------------------step 2.2.1 aggreage the column with only simple aggregation, including  discount_rate, payment_amount, full_price
TRUNCATE TABLE IF EXISTS schanl.stu_enrl_stg1;
CREATE OR REPLACE TRANSIENT TABLE schanl.stu_enrl_stg1 AS
SELECT 
	trans_dt,
	stu_id,
	course_id,
	cohort_id,
	max(full_price) AS full_price,
	max(discount_rate) AS discount_rate,
	sum(payment_amount) AS payment_amount
FROM schanl.stu_enrl
GROUP BY 1,2,3,4;


---------------------step 2.2.2 process column "full_paid", same student_id, course_id and cohort_id if there is a full_paid = true, we will treat it as full_paid
/* the logic: for a student, if today, no matter how many transaction happens, if the a specific course (course_id + cohort_id) has a full_paid flag,
it means the student has full paid for the specific course.*/
--------------------------- |   trans_dt    |   stu_id   |    course_id   |   cohort_id   |  full_paid  |
--------------------------- |   04-18  |   289       |          21         |   2203           |     False     |
--------------------------- |   04-18  |   289       |          21         |   2203           |     False     |
--------------------------- |   04-18  |   289       |          21         |   2203           |     True      |  V
----------------------------we use window functions to label the true

TRUNCATE TABLE IF EXISTS schanl.stu_enrl_full_paid_stg;
CREATE OR REPLACE TRANSIENT TABLE schanl.stu_enrl_full_paid_stg AS
SELECT 
	trans_dt,
	stu_id,
	course_id,
	cohort_id,
	CASE WHEN full_paid_count>=1 THEN TRUE ELSE FALSE END AS full_paid
FROM 
	(SELECT 
		trans_dt,
		stu_id,
		course_id,
		cohort_id,
		sum(CASE WHEN full_paid=TRUE THEN 1 ELSE 0 end) OVER (PARTITION BY trans_dt, stu_id, course_id, cohort_id) AS full_paid_count
	FROM schanl.stu_enrl) AS t
;


---------------------step 2.2.3 calculate the average discount_Rate for each specific course in each corhort.
TRUNCATE TABLE IF EXISTS schanl.avg_course_cohort_discount_stg;
CREATE OR REPLACE TRANSIENT TABLE schanl.avg_course_cohort_discount_stg AS
SELECT 
	course_id,
	cohort_id,
	avg(discount_rate) AS avg_cohort_disctount_rate
FROM 
schanl.stu_enrl
GROUP BY 1,2;

---------------------step 2.2.4 calculate the average discount_Rate for each  course.
TRUNCATE TABLE IF EXISTS schanl.avg_course_discount_stg;
CREATE OR REPLACE TRANSIENT TABLE schanl.avg_course_discount_stg AS
SELECT 
	course_id,
	avg(discount_rate) AS avg_course_discount_rate
FROM 
schanl.stu_enrl
GROUP BY 1;


----------step 2.3 assemble all transient tables together

TRUNCATE TABLE IF EXISTS schanl.transaction_stg;
CREATE OR REPLACE TRANSIENT TABLE schanl.transaction_stg AS
SELECT 
	main.trans_dt,
	main.stu_id,
	main.course_id,
	main.cohort_id,
	main.full_price,
	main.discount_rate,
	main.payment_amount,
	fp.full_paid,
	avg1.avg_cohort_disctount_rate, 
	avg2.avg_course_discount_rate
FROM schanl.stu_enrl_stg1 AS main
INNER JOIN schanl.stu_enrl_full_paid_stg AS fp USING (trans_dt,stu_id,course_id,cohort_id)
INNER JOIN schanl.avg_course_cohort_discount_stg AS avg1 USING (course_id,cohort_id)
INNER JOIN schanl.avg_course_discount_stg AS avg2 USING (course_id)
;

----------step 2.3 update the current pysical table
TRUNCATE TABLE IF EXISTS schanl.transaction;
INSERT INTO schanl.transaction SELECT * FROM schanl.transaction_stg;