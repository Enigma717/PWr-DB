USE sakila;

SELECT DISTINCT f.title, r.rental_date
FROM film AS f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE DATE(r.rental_date) BETWEEN '2005-05-25' AND '2005-05-30'
ORDER BY f.title;