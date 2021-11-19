USE sakila;

SELECT last_name
FROM actor AS a
WHERE (SELECT COUNT(*)
    FROM film_actor AS fa
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
    AND fa.actor_id = a.actor_id)
    >
      (SELECT COUNT(*)
    FROM film_actor AS fa
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
    AND fa.actor_id = a.actor_id);
