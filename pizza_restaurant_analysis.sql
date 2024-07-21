create database pizza_runner;
use pizza_runner;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);

INSERT INTO runners
(runner_id, registration_date)
VALUES
(1, '2021-01-01'),
(2, '2021-01-03'),
(3, '2021-01-08'),
(4, '2021-01-15');

CREATE TABLE customer_orders (
order_id INTEGER,
customer_id INTEGER,
pizza_id INTEGER,
exclusions VARCHAR(20),
extras VARCHAR(20),
order_time TIMESTAMP
);
INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);

INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
-- How many pizzas were ordered?
select 
	count(*) as 'pizza_ordered'
from customer_orders;

-- How many unique customer orders were made?
select count(distinct(order_id)) as customer_ordered from customer_orders;

-- How many successful orders were delivered by each runner?
select 
	runner_id ,
    count(distinct(customer_orders.order_id)) 
from customer_orders
join runner_orders 
on customer_orders.order_id = runner_orders.order_id
where runner_orders.pickup_time <> 'null'
group by runner_id;

-- How many of each type of pizza was delivered?
select 
    t3.pizza_name,
    count(t3.pizza_name) as 'pizza_delivered'
from
runner_orders  t1
join customer_orders t2 
	on t1.order_id = t2.order_id
join pizza_names t3 
	on t2.pizza_id = t3.pizza_id 
where t1.pickup_time <> 'null'
group by t3.pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?

select
	t1.customer_id,
	t2.pizza_name,
	count(t1.customer_id)
from customer_orders t1
join pizza_names t2
on t1.pizza_id = t2.pizza_id
group by t1.customer_id , t2.pizza_name
order by t1.customer_id asc ;
    
-- What was the maximum number of pizzas delivered in a single order?

select 
	t1.customer_id,
	t1.order_id ,
    count(pizza_id) as 'pizza_orderd'
from customer_orders  t1 
join runner_orders t2
on t1.order_id = t2.order_id
where pickup_time <> 'null'
group by t1.order_id ,t1.customer_id
order by pizza_orderd desc
limit 1 ;

-- What was the total volume of pizzas ordered for each hour of the day?
select 
	t1.order_time,
	hour(t1.order_time) as 'hour_time',
    sum(t1.order_id) as 'per_hour_order'
from 
customer_orders t1
join runner_orders t2
	on t1.order_id = t2.order_id
group by hour_time ,t1.order_time;

-- What was the volume of orders for each day of the week?
select
	weekday(t1.order_time) as 'order_per_day_of_week',
    sum(t1.order_id) as 'total_orders_per_Day'
from customer_orders t1
group by order_per_day_of_week;

-- How many pizzas were delivered that had both exclusions and extras?
select * from customer_orders where exclusions <>'null' and extras <>'null' ;

--                     B. Runner and Customer Experience
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select count(runner_id)as 'total_runnes_signed' , week(registration_date) as 'week' from runners group by week ;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select * from runner_orders ;

select 
	runner_id,
    sum(minute(pickup_time)) as 'total_minutes',
    round(sum(minute(pickup_time))/count(minute(pickup_time)),2) as 'avg_total_minutes'
from runner_orders 
where pickup_time  is not null
group by runner_id;


-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT 
    t1.order_id,
    TIMESTAMPDIFF(minute , t1.order_time, t2.pickup_time) AS prep_time_minutes
from customer_orders t1
join runner_orders t2 
on t1.order_id = t2.order_id
where t2.pickup_time IS NOT NULL AND t1.order_time IS NOT NULL;

-- What was the average distance travelled for each customer?
select
	t1.customer_id,
    round(sum(t2.distance)/count(t1.customer_id),2) as 'avg_distance'
from customer_orders t1
join runner_orders t2
on t1.order_id = t2.order_id 
group by t1.customer_id;


-- What was the difference between the longest and shortest delivery times for all orders?
select 
	max(timestampdiff(minute , t1.order_time , t2.pickup_time)) as 'max_differ',
    min(timestampdiff(minute , t1.order_time , t2.pickup_time)) as 'min_differ',
    max(timestampdiff(minute , t1.order_time , t2.pickup_time)) - min(timestampdiff(minute , t1.order_time , t2.pickup_time)) as 'difference between max_time & min_time'
from customer_orders t1
join runner_orders t2
on t1.order_id = t2.order_id

















