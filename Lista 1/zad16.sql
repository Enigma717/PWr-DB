USE sakila;

CREATE OR REPLACE VIEW nick AS
    SELECT DISTINCT actor_id
    FROM actor
    WHERE first_name = 'NICK' AND last_name = 'WAHLBERG';

UPDATE film
SET language_id = 4
WHERE title = 'WON DARES';

UPDATE film
SET language_id = 6
WHERE film_id
IN (SELECT DISTINCT film_id
    FROM film_actor AS fa, nick
    WHERE fa.actor_id = nick.actor_id);