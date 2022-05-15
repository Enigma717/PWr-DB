USE sakila;

ALTER TABLE language
    ADD COLUMN films_no INT after last_update;

UPDATE language
SET films_no =
    (SELECT COUNT(language_id)
    FROM film AS f
    WHERE language.language_id = f.language_id);