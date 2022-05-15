CREATE OR REPLACE VIEW Dane_producenta AS
    SELECT p.nazwa, p.kraj, a.model
    FROM Producent AS p
        JOIN Aparat AS a ON a.producent = p.ID;

DELETE a
FROM Aparat AS a
    JOIN Producent p on p.ID = a.producent
WHERE p.kraj LIKE 'Chiny';