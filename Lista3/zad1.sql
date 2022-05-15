CREATE DATABASE IF NOT EXISTS db_spis;
USE db_spis;

DROP TABLE IF EXISTS Ludzie;
DROP TABLE IF EXISTS Zawody;
DROP TABLE IF EXISTS Pracownicy;
DROP FUNCTION IF EXISTS pesel_last_digit;
DROP PROCEDURE IF EXISTS data_generator;
DROP PROCEDURE IF EXISTS jobs_generator;

CREATE TABLE IF NOT EXISTS Ludzie (
    ID              INT AUTO_INCREMENT,
    PESEL           VARCHAR(11) NOT NULL,
    imie            VARCHAR(30) NOT NULL,
    nazwisko        VARCHAR(30) NOT NULL,
    data_urodzenia  DATE NOT NULL,
    plec            ENUM('K', 'M') NOT NULL,
    PRIMARY KEY (ID));

CREATE TABLE IF NOT EXISTS Zawody (
    zawod_id        INT AUTO_INCREMENT,
    nazwa           VARCHAR(50),
    pensja_min      FLOAT CHECK ( pensja_min > 0 ),
    pensja_max      FLOAT CHECK ( pensja_max > 0 ),
    PRIMARY KEY (zawod_id),
    CONSTRAINT CHK_pensja CHECK ( pensja_max > pensja_min ));

CREATE TABLE IF NOT EXISTS Pracownicy (
    ID              INT,
    zawod_id        INT,
    pensja          FLOAT CHECK ( pensja > 0 ),
    FOREIGN KEY (ID) REFERENCES Ludzie (ID),
    FOREIGN KEY (zawod_id) REFERENCES Zawody (zawod_id));

CREATE TABLE IF NOT EXISTS Men (
    name            VARCHAR(20),
    surname         VARCHAR(20));

CREATE TABLE IF NOT EXISTS Women (
    name            VARCHAR(20),
    surname         VARCHAR(20));

INSERT INTO Men (name, surname) VALUES
    ('Piotr', 'Nowak'),
    ('Krzysztof', 'Kowalski'),
    ('Andrzej', 'Wiśniewski'),
    ('Tomasz', 'Kowalczyk'),
    ('Paweł', 'Kamiński'),
    ('Jan', 'Lewandowski'),
    ('Michał', 'Zieliński'),
    ('Marcin', 'Szymański'),
    ('Jakub', 'Woźniak'),
    ('Adam', 'Dąbrowski'),
    ('Stanisław', 'Kozłowski'),
    ('Marek', 'Mazur'),
    ('Łukasz', 'Jankowski'),
    ('Grzegorz', 'Kwiatkowski'),
    ('Mateusz', 'Wójcik');

INSERT INTO Women (name, surname) VALUES
    ('Anna', 'Pawłowska'),
    ('Maria', 'Michalska'),
    ('Katarzyna', 'Zając'),
    ('Małgorzata', 'Król'),
    ('Agnieszka', 'Wieczorek'),
    ('Barbara', 'Jabłońska'),
    ('Ewa', 'Wróbel'),
    ('Krystyna', 'Nowakowska'),
    ('Magdalena', 'Majewska'),
    ('Elżbieta', 'Adamczyk'),
    ('Joanna', 'Jaworska'),
    ('Aleksandra', 'Malinowska'),
    ('Zofia', 'Stępień'),
    ('Monika', 'Dudek'),
    ('Teresa', 'Górska');


DELIMITER $$
CREATE FUNCTION pesel_last_digit ( pesel VARCHAR(11) )
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE result INT DEFAULT 0;
    DECLARE weight INT;

    WHILE i < 10 DO
        SET weight = (SELECT ELT((i +1), 1, 3, 7, 9, 1, 3, 7, 9, 1, 3));
        SET result = result + (substr(pesel, i + 1, 1) * weight) % 10;
        SET i = i + 1;
    END WHILE;
    RETURN ((10 - (result % 10)) % 10);
END $$


DELIMITER $$
CREATE PROCEDURE data_generator ( IN iterations INT, IN min_age INT, IN max_age INT )
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE gen_name VARCHAR(20);
    DECLARE gen_surname VARCHAR(20);
    DECLARE gen_gender VARCHAR(1);
    DECLARE gen_date DATE;
    DECLARE gen_pesel VARCHAR(11);
    DECLARE min_year DATE DEFAULT current_date() - INTERVAL min_age YEAR;
    DECLARE max_year DATE DEFAULT current_date() - INTERVAL max_age YEAR;
    DECLARE pesel_date_digits VARCHAR(6);
    DECLARE pesel_random_digits VARCHAR(3);
    DECLARE pesel_gender_digit INT;

    WHILE i < iterations DO
        SET gen_date =  TIMESTAMPADD(DAY, FLOOR(RAND() * TIMESTAMPDIFF(DAY, min_year, max_year)), min_year);

        SET pesel_random_digits = CONCAT(FLOOR(RAND() * 10), FLOOR(RAND() * 10), FLOOR(RAND() * 10));
        SET pesel_gender_digit = ELT((FLOOR(1 + RAND() * 5)), '1', '3', '5', '7', '9');

        IF ((DATE_FORMAT(gen_date, '%Y') > 1999)) THEN
            SET pesel_date_digits = CONCAT(DATE_FORMAT(gen_date, '%y'), DATE_FORMAT(gen_date, '%m') + 20, DATE_FORMAT(gen_date, '%d'));
        ELSE
            SET pesel_date_digits = CONCAT(DATE_FORMAT(gen_date, '%y'), DATE_FORMAT(gen_date, '%m'), DATE_FORMAT(gen_date, '%d'));
        END IF;

        IF ((FLOOR(1 + RAND() * 2) % 2) = 0) THEN
            SET gen_name = (SELECT name FROM Men ORDER BY RAND() LIMIT 1);
            SET gen_surname = (SELECT surname FROM Men ORDER BY RAND() LIMIT 1);
            SET gen_gender = 'M';
            SET gen_pesel = CONCAT(pesel_date_digits, pesel_random_digits, pesel_gender_digit);
        ELSE
            SET gen_name = (SELECT name FROM Women ORDER BY RAND() LIMIT 1);
            SET gen_surname = (SELECT surname FROM Women ORDER BY RAND() LIMIT 1);
            SET gen_gender = 'K';
            SET gen_pesel = CONCAT(pesel_date_digits, pesel_random_digits, (pesel_gender_digit - 1));
        END IF;

        SET gen_pesel = CONCAT(gen_pesel, pesel_last_digit(gen_pesel));

        INSERT INTO Ludzie(PESEL, imie, nazwisko, data_urodzenia, plec) VALUES
            (gen_pesel, gen_name, gen_surname, gen_date, gen_gender);

        SET i = i + 1;
    END WHILE;
END $$

CALL data_generator(5, 0, 18);
CALL data_generator(45, 18, 60);
CALL data_generator(5, 60, 100);


INSERT INTO Zawody(nazwa, pensja_min, pensja_max) VALUES
        ('polityk', 10000, 20000),
        ('nauczyciel', 1000, 6000),
        ('lekarz', 15000, 30000),
        ('informatyk', 6000, 15000);


DELIMITER $$
CREATE PROCEDURE jobs_generator ()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE birth_date DATE;
    DECLARE age INT;
    DECLARE gender VARCHAR(1);
    DECLARE temp_id INT;
    DECLARE temp_jobs_id INT;
    DECLARE min_salary FLOAT;
    DECLARE max_salary FLOAT;
    DECLARE final_salary FLOAT;

    DECLARE jobs_cursor CURSOR FOR SELECT ID FROM Ludzie;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN jobs_cursor;

    read_data: LOOP
        FETCH jobs_cursor INTO temp_id;
        IF done THEN
            LEAVE read_data;
        END IF;

        SET birth_date = (SELECT data_urodzenia FROM Ludzie WHERE ID = temp_id);
        SET age = TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE());
        SET gender = (SELECT plec FROM Ludzie WHERE ID = temp_id);

        IF (age >= 18) THEN
            IF ((age >= 65 AND gender = 'M') OR (age >= 60 AND gender = 'K')) THEN
                SET temp_jobs_id = ELT(FLOOR(1 + RAND() * 3), 1, 2, 4);
            ELSE
                SET temp_jobs_id = FLOOR(1 + RAND() * 4);
            END IF;

        SET min_salary = (SELECT pensja_min FROM Zawody WHERE zawod_id = temp_jobs_id);
        SET max_salary = (SELECT pensja_max FROM Zawody WHERE zawod_id = temp_jobs_id);
        SET final_salary = FLOOR(min_salary + RAND() * (max_salary - min_salary));

        INSERT INTO Pracownicy(ID, zawod_id, pensja) VALUES
            (temp_id, temp_jobs_id, final_salary);
        END IF;
    END LOOP;
    CLOSE jobs_cursor;
END $$

CALL jobs_generator();