DROP FUNCTION IF EXISTS licznik_modeli;

CREATE FUNCTION licznik_modeli(given_matryca INT)
    RETURNS INT DETERMINISTIC
    RETURN (
        SELECT COUNT(*)
        FROM Aparat as a
        WHERE a.matryca = given_matryca);

SELECT licznik_modeli(112);