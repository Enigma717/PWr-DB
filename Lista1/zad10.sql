USE sakila;

SELECT DISTINCT customers.customer_id
FROM (SELECT r.customer_id, COUNT(*) as customers_count
    FROM rental AS r
    GROUP BY r.customer_id) customers
JOIN (SELECT COUNT(*) AS peter_count
    FROM rental AS r
    WHERE r.customer_id
    IN (SELECT c.customer_id
        FROM customer AS c
        WHERE c.email = 'PETER.MENARD@sakilacustomer.org')) peter
WHERE customers.customers_count > peter.peter_count;
