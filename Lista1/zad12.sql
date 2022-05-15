USE sakila;

CREATE OR REPLACE VIEW filmswb AS
    SELECT DISTINCT film_id
    FROM film
    WHERE title LIKE 'B%';

SELECT last_name
FROM actor AS a
LEFT JOIN (SELECT actor_id
    FROM filmswb AS fwb, film_actor AS fa
    WHERE fwb.film_id = fa.film_id) castactors
ON a.actor_id = castactors.actor_id
WHERE castactors.actor_id IS NULL;

