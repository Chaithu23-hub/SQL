
 -- This table contains logs of the dates that users visited a certain retailer.
-- Assume today’s date is '2021-1-1'.

-- Write an SQL query that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).
-- Return the result table ordered by user_id.

-- 𝐓𝐚𝐛𝐥𝐞 
CREATE TABLE UserVisits (
 user_id INT,
 visit_date DATE
);

-- 𝐈𝐧𝐬𝐞𝐫𝐭 𝐭𝐡𝐞 𝐝𝐚𝐭𝐚 
INSERT INTO UserVisits (user_id, visit_date)
VALUES 
(1, '2020-11-28'),(1, '2020-10-20'),
(1, '2020-12-03'),(2, '2020-10-05'),
(2, '2020-12-09'),(3, '2020-11-11');
 
 
with cte as 
(select user_id,visit_date,lead(visit_date,1,'2021-01-01') over (partition by user_id order by visit_date) as next_visit 
from uservisits) 
,cte2 as 
(select user_id ,timestampdiff(day,visit_date,next_visit) as day_diff 
from cte)
,cte3 as (select user_id,day_diff,row_number() over (partition by user_id order by day_diff desc) as rnk 
from cte2)
select user_id, day_diff 
from cte3
where rnk=1;


/* OUTPUT
user_id 	day_diff
  1	       39
  2	       65
  3	       51
