USE db_spis;

DROP PROCEDURE IF EXISTS salary_raise;

DELIMITER $$
CREATE PROCEDURE salary_raise (IN job_name VARCHAR(30))
BEGIN
    START TRANSACTION;

    UPDATE Pracownicy p
    JOIN Zawody z ON p.zawod_id = z.zawod_id
    SET p.pensja = p.pensja * 1.05
    WHERE z.nazwa = job_name;

    SELECT @max_salary_after_raise := max(p.pensja)
    FROM Pracownicy p
    JOIN Zawody z ON p.zawod_id = z.zawod_id
    WHERE z.nazwa = job_name;

    SELECT @max_possible_salary := z.pensja_max
    FROM Zawody z
    WHERE nazwa = job_name;

    IF (@max_salary_after_raise < @max_possible_salary) THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END $$

call salary_raise('polityk');
call salary_raise('nauczyciel');
call salary_raise('lekarz');
call salary_raise('informatyk');
