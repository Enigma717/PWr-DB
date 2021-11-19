DROP TRIGGER IF EXISTS nieznany_producent;

DELIMITER $$
CREATE TRIGGER nieznany_producent
    BEFORE INSERT ON Aparat
    FOR EACH ROW
BEGIN
    IF
        NEW.producent NOT IN
        (SELECT ID FROM Producent) THEN
            INSERT INTO Producent(id, nazwa, kraj) VALUES
                (NEW.producent, NULL, NULL);
    END IF;
END $$

INSERT INTO Aparat(model, producent, matryca, obiektyw, typ) VALUES
    ('ABC1234', 16, 102, 10, 'lustrzanka');