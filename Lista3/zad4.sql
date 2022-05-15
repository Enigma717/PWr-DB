USE db_spis;

SET @job_name = 'lekarz';

PREPARE women_count_statement FROM
    'SELECT COUNT(plec)
     FROM Ludzie l
     JOIN Pracownicy p ON l.ID = p.ID
     JOIN Zawody z ON p.zawod_id = z.zawod_id
     WHERE plec LIKE \'K\' AND z.nazwa = ?';

EXECUTE women_count_statement USING @job_name;

DEALLOCATE PREPARE women_count_statement;
