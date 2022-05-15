DROP FUNCTION IF EXISTS generator;
DROP PROCEDURE IF EXISTS model_generator;

CREATE TABLE IF NOT EXISTS letters (
    ID INT UNSIGNED AUTO_INCREMENT,
    letters VARCHAR(3),
    PRIMARY KEY (ID)
    );

CREATE TABLE IF NOT EXISTS numbers (
    ID INT UNSIGNED AUTO_INCREMENT,
    numbers VARCHAR(3),
    PRIMARY KEY (ID)
    );

INSERT INTO letters(letters) VALUES
    ('YQU'), ('ZMG'), ('WZT'), ('EVW'), ('UJP'),
    ('YUE'), ('FKB'), ('UVS'), ('EHY'), ('ZMV'),
    ('JVB'), ('BHX'), ('VUM'), ('SLN'), ('IQH'),
    ('CMC'), ('ILS'), ('UVL'), ('ACV'), ('JSG'),
    ('OSA'), ('WEZ'), ('VEM'), ('XFP'), ('JDY'),
    ('KPR'), ('VRJ'), ('RFW'), ('DUX'), ('RBH'),
    ('VMA'), ('TCU'), ('RZJ'), ('DYG'), ('EZC'),
    ('ANU'), ('DDC'), ('NEE'), ('MEB'), ('RHP'),
    ('RNJ'), ('OME'), ('OTN'), ('NRP'), ('ABN'),
    ('QWT'), ('UMK'), ('GRW'), ('DYE'), ('SBD');

INSERT INTO numbers(numbers) VALUES
    ('877'), ('190'), ('706'), ('337'), ('958'),
    ('964'), ('150'), ('377'), ('569'), ('433'),
    ('420'), ('155'), ('862'), ('829'), ('534'),
    ('257'), ('461'), ('516'), ('970'), ('530'),
    ('156'), ('976'), ('422'), ('473'), ('779'),
    ('739'), ('206'), ('426'), ('611'), ('829'),
    ('770'), ('219'), ('524'), ('478'), ('986'),
    ('238'), ('907'), ('280'), ('509'), ('816'),
    ('112'), ('747'), ('971'), ('931'), ('118'),
    ('520'), ('104'), ('824'), ('441'), ('369');


CREATE FUNCTION model_generator()
    RETURNS VARCHAR(30) DETERMINISTIC
    RETURN CONCAT (
        (SELECT letters FROM letters ORDER BY RAND() LIMIT 1),
        (SELECT numbers FROM numbers ORDER BY RAND() LIMIT 1));

DELIMITER $$
CREATE PROCEDURE generator()
BEGIN
    DECLARE i INT DEFAULT 100;
    WHILE i > 0 DO
            INSERT INTO Aparat(model, producent, matryca, obiektyw, typ) VALUES (
                    (CONCAT(model_generator(), MOD(i, 10))),
                    (SELECT ID FROM Producent ORDER BY RAND() LIMIT 1),
                    (SELECT ID FROM Matryca ORDER BY RAND() LIMIT 1),
                    (SELECT ID FROM Obiektyw ORDER BY RAND() LIMIT 1),
                    (SELECT ELT(FLOOR(RAND() * 4) + 1, 'kompaktowy', 'lustrzanka', 'profesjonalny', 'inny')));
            set i = i - 1;
        END WHILE;
END $$

CALL generator();