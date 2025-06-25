 use interview_que;
/* Write an SQL query to find the confirmation rate of each user.
The confirmation rate of a user is the number of 'confirmed' 
messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places. */

-- 𝐓𝐚𝐛𝐥𝐞 -𝟏 
CREATE TABLE Signups (user_id INT PRIMARY KEY, time_stamp
DATETIME );

-- 𝐈𝐧𝐬𝐞𝐫𝐭 𝐭𝐡𝐞 𝐝𝐚𝐭𝐚 
INSERT INTO Signups (user_id, time_stamp)
VALUES (3, '2020-03-21 10:16:13'),(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),(6, '2020-12-09 10:39:37');

-- 𝐓𝐚𝐛𝐥𝐞 - 𝟐
CREATE TABLE Confirmations (user_id INT,time_stamp DATETIME,
action VARCHAR(10) CHECK (action IN ('confirmed', 'timeout')),
PRIMARY KEY (user_id, time_stamp),
FOREIGN KEY (user_id) REFERENCES Signups(user_id) );

-- 𝐈𝐧𝐬𝐞𝐫𝐭 𝐭𝐡𝐞 𝐝𝐚𝐭𝐚 
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');



with cte1 as 
(select user_id,sum(case when action='confirmed' then 1 else 0 end) as count_of_confirmations, count(*) as total_req
 from confirmations
 group by user_id),
 cte2 as (select user_id,round(count_of_confirmations/total_req,2) as con_rate from cte1 
 group by user_id)
 select a.user_id,coalesce(b.con_rate,0) as con_rate from signups a left join cte2 b on a.user_id=b.user_id 
 group by a.user_id;
 
 
/* OUTPUT
 
 user_id	con_rate
  2	        0.5
  3	        0
  6        	0
  7	        1
