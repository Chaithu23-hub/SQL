use interview_que;
CREATE TABLE order_details (orderid INT PRIMARY KEY,custid INT,
city VARCHAR(50),order_date DATE,del_partner VARCHAR(50),
 order_time TIME,deliver_time TIME,predicted_time INT,
aov DECIMAL(10, 2)
);
INSERT INTO order_details 
VALUES
(1, 101, 'Bangalore', '2024-01-01', 'PartnerA', '10:00:00', '11:30:00', 60, 100.00),
(2, 102, 'Chennai', '2024-01-02', 'PartnerB', '12:00:00', '13:15:00', 45, 200.00),
(3, 103, 'Bangalore', '2024-01-03', 'PartnerA', '14:00:00', '15:45:00', 60, 300.00),
(4, 104, 'Chennai', '2024-01-04', 'PartnerB', '16:00:00', '17:30:00', 90, 400.00);


select * from order_details;

#Write a SQL query to determine the count of delayed orders for each delivery partner#

with delayed_partners as
 (select del_partner,
timestampdiff(minute,order_time,deliver_time) as actual_deliver_time,
 predicted_time
 from order_details),

delayed_cnts as (
select del_partner,sum(case when actual_deliver_time>predicted_time then 1 end)as delayed_orders_cnt
 from delayed_partners
 group by del_partner)
 select * from delayed_cnts;


OUTPUT
+-------------+--------------------+
| del_partner | delayed_orders_cnt |
+-------------+--------------------+
| PartnerA    | 2                  |
| PartnerB    | 1                  |
+-------------+--------------------+

 
