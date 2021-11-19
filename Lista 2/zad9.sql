CREATE OR REPLACE VIEW Dane_modeli AS
    SELECT a.model, p.nazwa,
           m.przekatna, m.rozdzielczosc,
           o.minPrzeslona, o.maxPrzeslona
    FROM Aparat AS a
        JOIN Producent AS p ON a.producent = p.ID
        JOIN Matryca AS m ON a.matryca = m.ID
        JOIN Obiektyw AS o ON a.obiektyw = o.ID
    WHERE a.typ = 'lustrzanka' AND
          p.kraj NOT LIKE 'Chiny';