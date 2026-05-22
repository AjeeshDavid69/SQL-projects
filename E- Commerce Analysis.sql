CREATE TABLE Users (
    "row" INT,
    event_id INT,
    user_id INT,event_type TEXT,
    event_date TIMESTAMP,
    product_id INT,
    amount DECIMAL,
    traffic_source TEXT
);
SELECT event_date FROM public.users;
SELECT event_date FROM public.users 
ORDER BY event_date ASC;

--overview of the table
SELECT * FROM public.users LIMIT 1000;

-- the funnel stage
WITH funnel_stage AS(
  SELECT
   count( DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage_1_views,
   count( DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage_2_carts,
   count( DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage_3_checkouts,
   count( DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage_4_payments,
   count( DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage_5_purchase
  FROM public.users
  WHERE event_date >='2025-01-01'
  AND event_date<'2026-02-02'
  )
   
   SELECT  * FROM funnel_stage;
   
   
 -- coversion rate through funnel
 
 WITH funnel_stage AS(
  SELECT
   count( DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage_1_views,
   count( DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage_2_carts,
   count( DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage_3_checkouts,
   count( DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage_4_payments,
   count( DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage_5_purchase
  FROM public.users
  WHERE event_date >='2025-01-01'
  AND event_date<'2026-02-02'
  )
   
  SELECT  
   stage_1_views,
   stage_2_carts,
   stage_3_checkouts,
   stage_4_payments,
   stage_5_purchase,
   stage_2_carts * 100/ stage_1_views AS view_to_cart_ratio,
   stage_3_checkouts * 100/ stage_2_carts AS cart_to_chechout_ratio,
   stage_4_payments* 100/stage_3_checkouts AS check_to_payment_ratio,
   stage_5_purchase* 100/stage_4_payments AS payment_to_purchase_ratio,
   stage_5_purchase* 100/stage_1_views AS overall_ratio
   
 FROM funnel_stage;  
 
 -- traffic funnel
 
 WITH traffic_funnel AS(
 SELECT
 traffic_source,
   count( DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS total_views,
   count( DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS total_carts,
   count( DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS total_purchase
  FROM public.users
  WHERE event_date >='2025-01-01'
  AND event_date<'2026-02-02'
 GROUP BY traffic_source)
 SELECT
 traffic_source,
   total_views,
   total_carts,
   total_purchase,
   total_views * 100/ total_carts AS view_to_cart_ratio,
   total_carts* 100/total_purchase AS cart_to_purchase_ratio,
   total_purchase* 100/total_views AS overall_ratio
   FROM traffic_funnel
   ORDER BY total_purchase DESC;
   
   -- reveune funnel analytics
   
WITH funnel_revunue AS(
 SELECT
 
   count( DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS total_visitors,
   count( DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS total_buyers,
   sum( CASE WHEN event_type='purchase' THEN amount END) AS total_revenue,
   count(CASE WHEN event_type='purchase' THEN 1 END) AS total_orders
  FROM public.users
  WHERE event_date >='2025-01-01'
  AND event_date<'2026-02-02')
 
 SELECT 
 total_visitors,
 total_buyers,
 total_revenue,
 total_orders,
 total_revenue/total_orders AS avg_value_order,
 total_revenue/total_buyers AS revenue_per_buyer,
 total_revenue/total_visitors AS revenue_per_visitor
 
 FROM funnel_revunue;


   

  
  
  
  
  
  
  
  
  
  
   