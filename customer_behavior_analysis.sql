
use [Ecommerce Customer Behavior];

select top 10 *
from customer_behavior;

--PHASE 1 — BASIC BUSINESS KPI QUERIES:-

--1. Total customers.
select count(*) as total_customers
from customer_behavior;

--2. --Total Churned Customer:
select count(*) as total_churned_customer
from customer_behavior
where churned = 1;

--3. --Churn Rate %:
select 
      round(
	       (sum(cast(churned as float)) / count(*)) * 100,2) as churn_rate_percent
from customer_behavior;

--4. Average Lifetime Value:
select round(avg(lifetime_value),2) as avg_lifetime_value
from customer_behavior;

--5. Average Order Value:
select
    round(avg(average_order_value),2) as avg_order_value
from customer_behavior;

-- PHASE 2 — CUSTOMER BEHAVIOR ANALYSIS:-

--6. Average Session Duration by Churn:
select churned,
      round(avg(session_duration_avg),2) as avg_session
from customer_behavior
group by churned;

--7. Login Frequency By churn:
select churned,
     round(avg(login_frequency),2) as avg_login_frequency
from customer_behavior
group by churned;

--8. Cart Abandonment Analysis:
select churned,
     round(avg(cart_abandonment_rate),2) as avg_cart_abandonment
from customer_behavior
group by churned;

--9. Mobile App Usage vs Churn:
select churned,
     round(avg(mobile_app_usage),2) as avg_mobile_usage
from customer_behavior
group by churned;

--10. Email_Engagement_Analysis:
select churned,
      round(avg(email_open_rate),2) as avg_email_open_rate
from customer_behavior
group by churned;

--PHASE 3 — COUNTRY & CUSTOMER SEGMENT ANALYSIS:-

--11. Country Wise Churn:
select country,
      count(*) as total_customers,
	  sum(cast(churned as int)) as churned_customers,
	  round((sum(cast(churned as float )) / count(*)) * 100, 2) as churn_rate_percent
from customer_behavior
group by country
order by churn_rate_percent desc;

--12. Gender Wise Churn:
select gender,
     count(*) as total_customers,
	 sum(cast(churned as int)) as total_churned
from customer_behavior
group by gender;

--13. Signup Quarter Analysis:
select signup_quarter,
       count(*) as total_customers,
	   sum(cast(churned as int)) as churned_customers
from customer_behavior
group by signup_quarter
order by churned_customers desc;

--PHASE 4 — HIGH VALUE CUSTOMER ANALYSIS:-
--14. Top 10 High Lifetime Customers:
select top 10 
       country,
	   gender,
	   lifetime_value,
	   total_purchases
from customer_behavior
order by lifetime_value desc;

--15. High Value Customers Who Churned:
select top 10
       lifetime_value,
	   total_purchases,
	   Average_order_value,
	   churned
from customer_behavior
where churned = 1
order by lifetime_value desc;

--PHASE 5 — ADVANCED ANALYST QUERIES:-

--16. Customer Segmentation:
select 
     case 
	     when lifetime_value < 1000 then 'Low Value'
		 when lifetime_value between 1000 and 5000 then 'Medium Value'
		 else 'High Value'
		 end as customer_segment,
     count(*) as customers
from customer_behavior
group by 
       case 
	       when lifetime_value < 1000 then 'Low Value'
		   when lifetime_value between 1000 and 5000 then 'Medium Value'
		   else 'High Value'
		   end
order by customers desc;

--17. Most Engaged Customers:
select top 20
      login_frequency,
	  session_duration_avg,
	  pages_per_session,
	  social_media_engagement_score
from customer_behavior
order by login_frequency desc;

--18. Customers at Risk of Churn:
select top 20
      login_frequency,
	  session_duration_avg,
	  days_since_last_purchase,
	  cart_abandonment_rate
from customer_behavior
where churned = 1
order by days_since_last_purchase desc; 

--Powerful Business Queries:-

--Customer Segmentation:-
--High Value vs Low Value Customers:
select country, city, total_purchases, lifetime_value,
     case 
	       when lifetime_value < 1000 then 'Low Value'
		   when lifetime_value between 1000 and 5000 then 'Medium Value'
		   else 'High Value'
		   end as customer_segment
from customer_behavior;

--Churn Analysis:-
--Which age group churns most?
SELECT 
    Age
FROM customer_behavior
WHERE TRY_CAST(Age AS FLOAT) IS NULL;

ALTER TABLE customer_behavior
ADD Age_Clean FLOAT;

UPDATE customer_behavior
SET Age_Clean = TRY_CAST(Age AS FLOAT);

SELECT 

    CASE 
        WHEN Age_Clean < 30 THEN 'Younger'
        WHEN Age_Clean BETWEEN 30 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,

    COUNT(*) AS total_customers,

    SUM(CAST(Churned AS INT)) AS churned_customers,

    ROUND(
        AVG(CAST(Churned AS FLOAT)) * 100,
        2
    ) AS churn_rate_percent

FROM customer_behavior

GROUP BY 

    CASE 
        WHEN Age_Clean < 30 THEN 'Younger'
        WHEN Age_Clean BETWEEN 30 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END

ORDER BY churn_rate_percent DESC;

--Engagement Analysis:-
--Does mobile app usage reduce churn?
select churned,
     round(avg(mobile_app_usage), 2) as avg_mobile_app_usage,
	 count(*) as total_customers
from customer_behavior
group by churned;

--Revenue Analysis:-
--Top countries by lifetime value:
select country,
	 count(*) as total_customers,
	 round(avg(lifetime_value), 2) as avg_lifetime_value,
	 round(sum(lifetime_value), 2) as total_lifetime_value,
	 round(avg(total_purchases), 2) as avg_total_purchases
from customer_behavior
group by country
order by total_lifetime_value desc;


--Retention Insights:-
--Do customers with more purchases churn less?
select churned,
     round(avg(total_purchases), 2) as avg_total_purchases,
	 count(*) as total_customers
from customer_behavior
group by churned;
















