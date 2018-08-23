-- Stammbaum online
-- 2018-08-17 phi@gress.ly



USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';


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

CREATE TABLE `Name` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name` TEXT NOT NULL
);


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `person`
--

CREATE TABLE `Person` (
  `ID`                 INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Geschlecht_fk`      INTEGER
, FOREIGN KEY (`Geschlecht_fk`) REFERENCES `Geschlecht` (`ID`)
);

-- COMMENT 'Eine Person ist einfach mal da. Namen, Geburtstadten, Eltern ..., sind Glücksache...';


CREATE TABLE `Mutter` (
  `ID`        INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Mutter_fk` INTEGER
, `Kind_fk`   INTEGER
, FOREIGN KEY (`Mutter_fk`) REFERENCES `Person` (`ID`)
, FOREIGN KEY (`Kind_fk`)   REFERENCES `Person` (`ID`)
, UNIQUE (`Mutter_fk`, `Kind_fk`)
);


CREATE TABLE `Vater` (
  `ID`        INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Vater_fk`  INTEGER
, `Kind_fk`   INTEGER
, FOREIGN KEY (`Vater_fk`) REFERENCES `Person`     (`ID`)
, FOREIGN KEY (`Kind_fk`)  REFERENCES `Person`     (`ID`)
, UNIQUE (`Vater_fk`, `Kind_fk`)
);

CREATE TABLE `Geburts_Vorname` (
  `ID`         INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Person_fk`  INTEGER
, `Name_fk`    INTEGER
, `Laufnummer` INTEGER DEFAULT 1
, FOREIGN KEY (`Person_fk`) REFERENCES `Person` (`ID`)
, FOREIGN KEY (`Name_fk`)   REFERENCES `Name`   (`ID`)
);

CREATE TABLE `Geburts_Familienname` (
  `ID`         INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Person_fk`  INTEGER
, `Name_fk`    INTEGER
, `Laufnummer` INTEGER DEFAULT 1
, FOREIGN KEY (`Person_fk`) REFERENCES `Person` (`ID`)
, FOREIGN KEY (`Name_fk`)   REFERENCES `Name`   (`ID`)
);


CREATE TABLE `Kalender` (
  `ID` INTEGER KEY AUTO_INCREMENT
, `Bezeichnung` TEXT
) COMMENT 'In welchem Kalender ist das Datum erfasst worden';

INSERT INTO `Kalender`
(`ID`, `Bezeichnung`) VALUES
(   1, 'Gregorianischer Kalender'),
(   2, 'Julianischer Kalender'),
(   3, 'Mohamedanischer Kalender'),
(   4, 'Buddhistischer Kalender');

CREATE TABLE `Teildatum` (
  `ID`    INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Jahr`  INTEGER NOT NULL
, `Monat` INTEGER NOT NULL
, `Tag`         INTEGER NOT NULL
, `Kalender_fk`	INTEGER
, FOREIGN KEY (`Kalender_fk`) REFERENCES `Kalender` (`ID`)
) COMMENT 'Manchmal ist nur das Jahr bekannt, manchmal nur Monat, Tag. Je nachdem, was noch lesbar ist.';

