--1 What was the total quantity sold for all products?
	SELECT details.product_name,
    SUM(sales.qty) AS sales_counts
    FROM sales INNER JOIN product_details as details 
    ON sales.prod_id = details.product_id
    GROUP BY details.product_name
    order by sales_counts DESC;
    
--2 What is the total generated revenue for all products before discounts?
	SELECT sum(price*qty) as no_disc_revenue
    from sales;
    
   --3 What was the total discount amount for all products?
     select sum(price*qty*discount)/100 as Total_Desconto
     from sales; 
    
    --4 How many unique transactions were there?
     select count(DISTINCT txn_id) as trans_unica
     from sales;
  
  --5 What are the average unique producst purchased in each transaction?
  	with cte_transaction_products as(
    select txn_id,
      count(distinct prod_id) as product_count
    from sales
    group by txn_id)
    select round(avg(product_count)) as media_prod_unico 
    from cte_transaction_products;
    
    --6 What is the average discount value per transaction?
    with cte_transaction_discount as(
    select txn_id,
      sum(price*qty*discount)/100 as desconto_total
    from sales
    group by txn_id)
    select round(avg(desconto_total)) as media_desconto
    from cte_transaction_discount;
    
    --7 What is the average revenue for member transactions and non-members transactions?
    with cte_member_revenue as(
      select member, txn_id, sum(price*qty) as revenue
    from sales
    group by member,txn_id)
    SELECT member,round(avg(revenue),2) avg_revenue
    from cte_member_revenue
    group by member;
    
  --8 What are the top 3 products by total revenue before discount?
   select details.product_name, sum(qty*sales.price) as n_desconto
   from sales 
   		inner join product_details as details
   on sales.prod_id = details.product_id
   group by details.product_name
   order by n_desconto DESC
   limit 3;
   
   --9 What are the total qty, revenue and discout for each segment?
  SELECT details.segment_id,
   details.segment_name,
   sum(sales.qty) as qty_total,
   sum(sales.qty * sales.price) as total_imposto,
   sum(sales.qty * sales.price * sales.discount) / 100 as total_desconto
FROM sales
INNER JOIN product_details AS details
   ON sales.prod_id = details.product_id
GROUP BY details.segment_id, details.segment_name;

--10 What is the top selling product for each segment?
SELECT details.segment_id,
       details.segment_name,
       details.product_name,
       SUM(sales.qty) as qty_produto
FROM sales 
INNER JOIN product_details as details
    ON sales.prod_id = details.product_id
GROUP BY details.segment_id, details.segment_name, details.product_name
order by qty_produto desc 
LIMIT 5;

--11 What are the total qty, revenue and discount for each category?
 SELECT details.category_id,
   details.category_name,
   sum(sales.qty) as qty_total,
   sum(sales.qty * sales.price) as total_imposto,
   sum(sales.qty * sales.price * sales.discount) / 100 as total_desconto
FROM sales
INNER JOIN product_details AS details
   ON sales.prod_id = details.product_id
GROUP BY details.category_id, details.category_name;

--12 What is the top selling product for each category? 
   SELECT details.category_id,
       details.category_name,
       details.product_name,
       SUM(sales.qty) as qty_produto
FROM sales 
INNER JOIN product_details as details
    ON sales.prod_id = details.product_id
GROUP BY details.category_id, details.category_name, details.product_name
order by qty_produto desc 
LIMIT 5;
 