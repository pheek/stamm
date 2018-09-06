-- Stammbaum online
-- 2018-08-17 phi@gress.ly


USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';


CREATE TABLE IF NOT EXISTS `EreignisTyp` (
  `ID` INTEGER /* PRIMARY */ KEY
, `Beschreibung` TEXT NOT NULL
);

-- Stammdaten

INSERT INTO `EreignisTyp`
(`ID`, `Beschreibung`) VALUES
(   1, 'Geburt'      ),
(   2, 'Gestorben'   ),
(   3, 'Getauft'     ),
(   4, 'Gefallen'    ),
(   5, 'Verschollen' );



CREATE TABLE `BeziehungsTyp` (
  `ID`             INTEGER /* PRIMARY */ KEY
, `TypBezeichnung` Text
) COMMENT 'Beziehungen wie verheiratet, Adotpiert, Pate, ...)';

-- Stammdaten
INSERT INTO `BeziehungsTyp`
(`ID`, `TypBezeichnung`) VALUES
(   1, 'Verheiratet'),
(   2, 'Geschieden' ),
(   3, 'Konkubinat' ),
(   4, 'Getrennt'   ),
(   5, 'Adoptiert'  ),
(   6, 'Pate/Patin' );
-- --------------------------------------------------------

CREATE TABLE `Ort` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name`       TEXT NOT NULL
);


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
-- Tabellenstruktur für Tabelle `Person`
--

CREATE TABLE `Person` (
  `ID`                 INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
,	`Geschlecht`         ENUM ('w', 'm', '?')
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
  `ID`          INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Jahr`        INTEGER NOT NULL
, `Monat`       INTEGER NOT NULL
, `Tag`         INTEGER NOT NULL
, `Kalender_fk`	INTEGER
, FOREIGN KEY (`Kalender_fk`) REFERENCES `Kalender` (`ID`)
) COMMENT 'Manchmal ist nur das Jahr bekannt, manchmal nur Monat, Tag. Je nachdem, was noch lesbar ist.';


CREATE TABLE `EinpersonenEreignis` (
  `ID`             INTEGER KEY AUTO_INCREMENT
, `EreignisTyp_fk` INTEGER NOT NULL
, `Person_fk`      INTEGER NOT NULL
, `Teildatum_fk`   INTEGER
, `Ort_fk`         INTEGER
, `Bemerkung`      TEXT
, FOREIGN KEY (`EreignisTyp_fk`) REFERENCES `EreignisTyp` (`ID`)
, FOREIGN KEY (`Person_fk`     ) REFERENCES `Person`      (`ID`)
, FOREIGN KEY (`Teildatum_fk`  ) REFERENCES `Teildatum`   (`ID`)
, FOREIGN KEY (`Ort_fk`        ) REFERENCES `Ort`         (`ID`)
) COMMENT 'Ein Ereignis, das eine einzelne Person zu einem bestimmten Datum haben kann. Beispiel Geburt';


CREATE TABLE `BeziehungsEreignis` (
  `ID`               INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `BeziehungsTyp_fk` INTEGER NOT NULL
, `Person1_fk`       INTEGER NOT NULL
, `Person2_fk`       INTEGER NOT NULL
, `Teildatum_fk`     INTEGER           COMMENT 'Zeitpunkt oder Startzeitpunkt'
, `Ort_fk`           INTEGER
, `Bemerkung`        TEXT
, FOREIGN KEY (`BeziehungsTyp_fk`) REFERENCES `BeziehungsTyp` (`ID`)
, FOREIGN KEY (`Person1_fk`      ) REFERENCES `Person`        (`ID`)
, FOREIGN KEY (`Person2_fk`      ) REFERENCES `Person`        (`ID`)
, FOREIGN KEY (`Teildatum_fk`    ) REFERENCES `Teildatum`     (`ID`)
, FOREIGN KEY (`Ort_fk`          ) REFERENCES `Ort`           (`ID`)
) COMMENT 'Ein Ereignis, das zwei Personen miteinander verbindet: Heirat, Scheidung, Konkubinat, ...';
