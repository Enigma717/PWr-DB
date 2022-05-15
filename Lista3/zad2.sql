USE db_spis;

DROP INDEX gender_name_index ON Ludzie;
DROP INDEX salary_index ON Pracownicy;

CREATE INDEX gender_name_index USING BTREE ON Ludzie(imie, plec);
CREATE INDEX salary_index USING BTREE ON Pracownicy(pensja);

EXPLAIN SELECT *
FROM Ludzie
WHERE plec LIKE 'K' AND imie LIKE '%A';

EXPLAIN SELECT *
FROM Ludzie
WHERE plec LIKE 'K';

EXPLAIN SELECT *
FROM Ludzie
WHERE imie LIKE 'K%';

EXPLAIN SELECT *
FROM Pracownicy p
JOIN Ludzie l ON p.ID = l.ID
WHERE p.pensja < 2000;

EXPLAIN SELECT *
FROM Pracownicy p
JOIN Zawody z ON p.zawod_id = z.zawod_id
JOIN Ludzie l ON l.ID = p.ID
WHERE z.nazwa LIKE 'informatyk' AND l.plec LIKE 'M' AND p.pensja > 10000;

SHOW INDEX FROM Ludzie;
SHOW INDEX FROM Pracownicy;