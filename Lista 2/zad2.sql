CREATE TABLE IF NOT EXISTS Producent (
    ID      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa   VARCHAR(50),
    kraj    VARCHAR(20),
    PRIMARY KEY (ID));

CREATE TABLE IF NOT EXISTS Matryca (
    ID              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    przekatna       DECIMAL(4,2) NOT NULL CHECK (przekatna > 0),
    rozdzielczosc   DECIMAL(3,1) NOT NULL CHECK (rozdzielczosc > 0),
    typ VARCHAR(10) NOT NULL,
    PRIMARY KEY (ID)) AUTO_INCREMENT = 100;

CREATE TABLE IF NOT EXISTS Obiektyw (
    ID              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    model           VARCHAR(30) NOT NULL,
    minPrzeslona    FLOAT NOT NULL CHECK (minPrzeslona > 0),
    maxPrzeslona    FLOAT NOT NULL CHECK (maxPrzeslona > 0),
    CONSTRAINT CHK_Przeslona CHECK (minPrzeslona < Obiektyw.maxPrzeslona),
    PRIMARY KEY (ID));

CREATE TABLE IF NOT EXISTS Aparat (
    model     VARCHAR(30)  NOT NULL,
    producent INT UNSIGNED NOT NULL,
    matryca   INT UNSIGNED NOT NULL,
    obiektyw  INT UNSIGNED NOT NULL,
    typ       ENUM ('kompaktowy', 'lustrzanka', 'profesjonalny', 'inny'),
    PRIMARY KEY (model),
    CONSTRAINT fk_matryca_id FOREIGN KEY (matryca) REFERENCES Matryca (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_obiektyw_id FOREIGN KEY (obiektyw) REFERENCES Obiektyw (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_producent_id FOREIGN KEY (producent) REFERENCES Producent (ID)
        ON DELETE CASCADE ON UPDATE CASCADE);