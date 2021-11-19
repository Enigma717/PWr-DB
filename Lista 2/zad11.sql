DROP TRIGGER dodawanie_modelu;
DROP TRIGGER usuwanie_modelu;
DROP TRIGGER zmiana_producenta;

ALTER TABLE Producent
    DROP COLUMN liczbaModeli;

ALTER TABLE Producent
    ADD COLUMN liczbaModeli INT
    AFTER kraj;

UPDATE Producent AS p
    SET p.liczbaModeli = (
        SELECT COUNT(*)
        FROM Aparat AS a
        WHERE a.producent = p.ID);

CREATE TRIGGER dodawanie_modelu
    AFTER INSERT ON Aparat
    FOR EACH ROW
    UPDATE Producent AS p
        SET p.liczbaModeli = p.liczbaModeli + 1
        WHERE NEW.producent = p.ID;

CREATE TRIGGER usuwanie_modelu
    AFTER DELETE ON Aparat
    FOR EACH ROW
    UPDATE Producent AS p
        SET p.liczbaModeli = p.liczbaModeli - 1
        WHERE OLD.producent = p.ID;

CREATE TRIGGER zmiana_producenta
    AFTER UPDATE ON Aparat
    FOR EACH ROW
    IF OLD.producent NOT LIKE NEW.producent THEN
        UPDATE Producent AS p
            SET p.liczbaModeli = p.liczbaModeli + 1
            WHERE NEW.producent = p.ID;

        UPDATE Producent AS p
            SET p.liczbaModeli = p.liczbaModeli - 1
            WHERE OLD.producent = p.ID;
    END IF;

DELETE
FROM Aparat
WHERE model = 'ABC1234';

INSERT INTO Aparat(model, producent, matryca, obiektyw, typ) VALUE
    ('XYZ9876', 17, 101, 2, 'kompaktowy');

