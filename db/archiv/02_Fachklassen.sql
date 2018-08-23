-- Stammbaum online
-- 2018-08-17 phi@gress.ly

USE `Stamm`;


CREATE TABLE IF NOT EXISTS `EreignisTyp` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Beschreibung` TEXT NOT NULL
);

-- Stammdaten

INSERT INTO `EreignisTyp` (`ID`, `Beschreibung`) VALUES
(1, 'Geburt'      ),
(2, 'Gestorben'   ),
(3, 'Getauft'     ),
(4, 'Gefallen'    ),
(5, 'Heirat'      ),
(6, 'Scheidung'   ),
(7, 'Trennung'    ),
(8, 'Verschollen' );


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Geschlecht`
--

CREATE TABLE IF NOT EXISTS `Geschlecht` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Geschlecht` char(1) NOT NULL
);

-- Stammdaten

INSERT INTO `Geschlecht` (`ID`, `Geschlecht`) VALUES
(1, 'w'),
(2, 'm'),
(3, '?');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Name`
--

CREATE TABLE IF NOT EXISTS `Name` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name` TEXT NOT NULL
);


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `person`
--

CREATE TABLE IF NOT EXISTS `Person` (
  `ID`                 INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
, `Geschlecht_fk`      INTEGER NOT NULL DEFAULT 2
, `FirstFamilyName_fk` INTEGER DEFAULT NULL
, `FirstGivenName_fk`  INTEGER DEFAULT NULL
, `Mother_fk`          INTEGER DEFAULT NULL
, `Father_fk`          INTEGER DEFAULT NULL
, FOREIGN KEY `Geschlecht_fk`      REFERENCES `Geschlecht` (`ID`)
, FOREIGN KEY `FirstFamilyName_fk` REFERENCES `Name`       (`ID`)
, FOREIGN KEY `FirstGivenName_fk`  REFERENCES `Name`       (`ID`)
, FOREIGN KEY `Mother_fk`          REFERENCES `Person`     (`ID`)
, FOREIGN KEY `Father_fk`          REFERENCES `Person`     (`ID`)
);



CREATE TABLE IF NOT EXISTS `Teildatum` (
  `Jahr`  INTEGER NOT NULL,
  `Monat` INTEGER NOT NULL,
  `Tag`   INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

