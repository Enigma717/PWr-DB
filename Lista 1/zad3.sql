USE sakila;

SELECT title, l.name
FROM film
JOIN language l ON film.language_id = l.language_id
WHERE description LIKE '%Documentary%';