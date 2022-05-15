DROP PROCEDURE IF EXISTS max_matryca;

DELIMITER $$
CREATE PROCEDURE max_matryca(IN given_ID INT)
BEGIN
    SELECT a.model
    FROM Aparat AS a
    JOIN Matryca AS m ON a.matryca = m.ID
    WHERE a.producent = given_ID
    ORDER BY m.przekatna DESC LIMIT 1;
END;

CALL max_matryca(5);