SELECT
  Warehouse.warehouse_id,
  --warehouse_name-
  CONCAT(Warehouse.state, ': ', Warehouse.warehouse_alias) AS warehouse_name,
  --num_of_orders-
  COUNT(Orders.order_id) AS number_of_orders,
  --total_orders-
  (SELECT 
  COUNT(*) 
  FROM `evident-ratio-425610-a2.warehouse_orders.orders` AS Orders) AS total_orders,
  --fulfillment-
  CASE
    WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM `evident-ratio-425610-a2.warehouse_orders.orders` AS Orders) <= 0.20
    THEN 'Fulfilled 0-20% of Orders'
    WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM `evident-ratio-425610-a2.warehouse_orders.orders` AS Orders) > 0.20
    AND COUNT(Orders.order_id)/(SELECT COUNT(*) FROM `evident-ratio-425610-a2.warehouse_orders.orders` AS Orders) <= 0.60
    THEN 'Fulfilled 21-60% of Orders'
    ELSE 'Fulfilled more than 60% of Orders'
  END AS fulfillment_summary
  --merge and create temporary tables-
FROM `evident-ratio-425610-a2.warehouse_orders.warehouse` AS Warehouse
LEFT JOIN `evident-ratio-425610-a2.warehouse_orders.orders` AS Orders
ON Orders.warehouse_id = Warehouse.warehouse_id
GROUP BY
  Warehouse.warehouse_id,
  warehouse_name
HAVING
  COUNT(Orders.order_id) > 0