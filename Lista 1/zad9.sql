USE sakila;

CREATE OR REPLACE VIEW custstaff AS
    SELECT DISTINCT customer_id, staff_id
    FROM payment
    ORDER BY customer_id;

SELECT DISTINCT c.first_name, c.last_name
FROM customer AS c, custstaff AS cs
GROUP BY c.customer_id
HAVING COUNT(cs.staff_id) > 1

