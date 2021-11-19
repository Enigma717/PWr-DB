USE sakila;

SELECT first_name, last_name
FROM actor AS a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE special_features LIKE '%Deleted Scenes%'
GROUP BY a.actor_id;
