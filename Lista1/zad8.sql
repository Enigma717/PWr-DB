USE sakila;

SELECT title
FROM film
WHERE rating LIKE '%R%'
ORDER BY length DESC LIMIT 5;