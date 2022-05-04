/********************** PART 2 *****************************/

-- 1 a) The number of daily active users per device
SELECT activity_device_id, COUNT(DISTINCT(activity_user_id)) active_users, date(activity_timestamp) active_date 
FROM activities
GROUP BY activity_device_id, active_date
ORDER BY active_date DESC;

/* 1 b) What kind of issue could occur, when using this result for further analysis, e.g. for calculating
the total number o f daily active users? How would you adjust the query to fix it? */
/*Because we won't be grouping by activity_device_id anymore, you just need to delete the activity_device_id from the group by.
 The only thing to keep in considerations is that the user repeats in the activities table, but you just need it once, so use a DISTINCT*/
SELECT COUNT(DISTINCT(activity_user_id)) active_users, date(activity_timestamp) active_date 
FROM activities
GROUP BY active_date
ORDER BY active_date DESC;



-- 2a)The total pay_amount per city for sales in 2019 
SELECT u.user_city, SUM(p.pay_amount) sales_total_amount  FROM payments p
JOIN sales s ON p.pay_sale_id = s.sale_id 
JOIN users u ON s.sale_user_id = u.user_id
WHERE year(s.sale_timestamp)=2019
GROUP BY u.user_city;


/* 2 b) The number of users, for whom the last activity was done with device_name = “phone”,
 but who have also at least one additional activity with another device */

SELECT COUNT(a.activity_user_id) number_of_users
FROM activities a
JOIN devices d ON a.activity_device_id = d.device_id
WHERE a.activity_is_last = TRUE 
AND d.device_name = 'phone'
AND EXISTS(
	SELECT b.activity_user_id
    FROM activities b
    JOIN devices e ON b.activity_device_id= e.device_id
    WHERE b.activity_user_id = a.activity_user_id
    AND e.device_id <> d.device_id);

/*Alternative:*/
    
WITH last_activity AS(
	SELECT a.activity_user_id, a.activity_device_id
	FROM activities a
	JOIN devices d ON a.activity_device_id = d.device_id
	WHERE a.activity_is_last = TRUE 
	AND d.device_name = 'phone'
) 
SELECT COUNT(DISTINCT(c.activity_user_id)) number_of_users
FROM last_activity b
JOIN activities c ON b.activity_user_id = c.activity_user_id
JOIN devices e ON b.activity_device_id = e.device_id
WHERE e.device_id <> c.activity_device_id ;

 
-- 2 c) Per day in 2019 the number of page visits and registrations
-- Number of page visits in 2019
SELECT DATE(info_timestamp) info_date, SUM(info_page_visits) page_visits
FROM informations
WHERE YEAR(info_timestamp)= 2019
GROUP BY info_date
ORDER BY info_date;

-- number of registrations in 2019
SELECT DATE(user_registration_timestamp) registration_date, COUNT(user_id) users_registered
FROM users
WHERE YEAR(user_registration_timestamp) = 2019
GROUP BY registration_date;

-- registered users and page visits per day in 2019
select d.period_date, count(u.user_id) users_registered, SUM(coalesce(i.info_page_visits,0)) page_visits
from (select @rownum:=@rownum+1 no, date('2019-01-01') + interval (@rownum-1) day period_date from
	(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5
    union all select 6 union all select 7 union all select 8 union all select 9) t,
	(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5
    union all select 6 union all select 7 union all select 8 union all select 9) t2,
	(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5
    union all select 6 union all select 7 union all select 8 union all select 9) t3,
	(SELECT @rownum:=0) r WHERE @rownum < DATEDIFF('2020-01-01','2019-01-01')) d
LEFT JOIN users u ON date(u.user_registration_timestamp) = date(d.period_date)
LEFT JOIN informations i ON DATE(i.info_timestamp) = date(d.period_date)
GROUP BY d.period_date
ORDER BY d.period_date;

/*An this is a another way to do it*/
SET @start_date= str_to_date('01-01-2019','%d-%m-%Y');
SET @end_date = str_to_date('31-12-2019','%d-%m-%Y');

WITH RECURSIVE 
calendar (ddate) AS
(
SELECT @start_date
union all
SELECT date_add(ddate,interval 1 day) from calendar where ddate <= @end_date 
)
SELECT c.ddate, count(u.user_id) users_registered, SUM(coalesce(i.info_page_visits,0)) page_visits
FROM calendar c
LEFT JOIN users u ON date(u.user_registration_timestamp) = c.ddate
LEFT JOIN informations i ON DATE(i.info_timestamp) = c.ddate
GROUP BY c.ddate
ORDER BY c.ddate;



/* 3 a) Per registration date and last device the number of users and the number of sales done by
users within 3 days after the registration */
SELECT date(u.user_registration_timestamp) registration_date, COUNT(a.activity_device_id) number_of_users, 
		COUNT(s.sale_id) number_of_sales
FROM users u
JOIN sales s ON s.sale_user_id = u.user_id
JOIN activities a ON a.activity_user_id = u.user_id 
WHERE a.activity_is_last = true
AND DATE(s.sale_timestamp) between DATE(u.user_registration_timestamp) 
AND DATE_ADD(u.user_registration_timestamp, INTERVAL 3 DAY)
GROUP BY registration_date;




/* 3 b) Per visit day in 2019 the number of page visits and registrations
Explain in writing: What would be measured with 2 c) and what with this result?  */
SELECT DATE(i.info_timestamp) info_date, SUM(i.info_page_visits) page_visits , 
		COUNT(u.user_id) users_registered
FROM informations i
 LEFT JOIN users u ON (date(i.info_timestamp) = date(u.user_registration_timestamp))
WHERE YEAR(i.info_timestamp)= 2019
GROUP BY info_date
ORDER BY info_date DESC;

/* The query from 2c) measures which dates from 2019 were preferred or not preferred for the people to visit the pages and register.
The query from 3b) measures how likely was per visit to get a user registration and how much did they visit.
*/

