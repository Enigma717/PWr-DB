DROP TRIGGER IF EXISTS usuwanie_matrycy;

CREATE TRIGGER usuwanie_matrycy
    AFTER DELETE ON Aparat
    FOR EACH ROW
        DELETE
        FROM Matryca AS m
        WHERE m.ID = OLD.matryca AND
              OLD.matryca NOT IN (
                  SELECT matryca
                  FROM Aparat);

DELETE
FROM Aparat
WHERE matryca = 111;