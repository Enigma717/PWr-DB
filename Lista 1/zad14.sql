USE sakila;

SELECT DISTINCT first_name, last_name
FROM customer AS c
JOIN (SELECT AVG(amount) AS avg_amount
    FROM payment AS p
    WHERE p.payment_date BETWEEN '2005-07-07' AND '2005-07-08') avg_rental
JOIN (SELECT customer_id, AVG(amount) AS customer_amount
    FROM payment AS p
    GROUP BY customer_id) customer_rental
WHERE c.customer_id = customer_rental.customer_id
AND customer_rental.customer_amount > avg_rental.avg_amount;