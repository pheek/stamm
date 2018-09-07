-- Stammbaum online
-- 2018-08-17 phi@gress.ly


USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';


-- -----------------------------------------
-- Der ganze Stammbaum ist an den Personen aufgehängt.
-- Jede Person hat eine eindeutige ID, welche
-- nicht verändert wird.
-- Geschlecht ist in den meisten Fällen bekannt.


CREATE TABLE `Person` (
  `ID`         INTEGER /*PRIMARY*/ KEY
, `Geschlecht` ENUM ('w', 'm', 'x', '?') -- '?' Unbekannt, 'x' weder noch.
) COMMENT 'Eine Person ist einfach mal da und hat sicher ein Geschlecht.
           Das Geschlecht kann meist über Kind-Beziehungen erschlossen werden.
           Namen, Geburtstadten, Eltern ..., sind oft nicht bekannt,
           daher in eigenen Tabellen...';

-- --------------------------------------------------------

--
-- Für die Identifikation sind Personen mit Namen versehen.
-- Die Namenstabelle unterscheidet nicht zwischen Vorname und
-- Familienname. Somit kann z. b. "Peter" sowohl Familienname,
-- wie auch Vorname sein.
--


CREATE TABLE `Name` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name` TEXT NOT NULL
);

-- --------------------------------------------------------


CREATE TABLE `Mutter` (
  `ID`        INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
, `Mutter_fk` INTEGER
, `Kind_fk`   INTEGER
, FOREIGN KEY (`Mutter_fk`) REFERENCES `Person` (`ID`)
, FOREIGN KEY (`Kind_fk`)   REFERENCES `Person` (`ID`)
, UNIQUE (`Mutter_fk`, `Kind_fk`)
);


CREATE TABLE `Vater` (
  `ID`        INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
, `Vater_fk`  INTEGER
, `Kind_fk`   INTEGER
, FOREIGN KEY (`Vater_fk`) REFERENCES `Person`     (`ID`)
, FOREIGN KEY (`Kind_fk`)  REFERENCES `Person`     (`ID`)
, UNIQUE (`Vater_fk`, `Kind_fk`)
);


CREATE TABLE `Geburts_Vorname` (
  `ID`         INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
, `Person_fk`  INTEGER
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
(   2, 'Julianischer Kalender'   ),
(   3, 'Mohamedanischer Kalender'),
(   4, 'Buddhistischer Kalender' );


CREATE TABLE `Teildatum` (
  `ID`          INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Jahr`        INTEGER NOT NULL
, `Monat`       INTEGER NOT NULL
, `Tag`         INTEGER NOT NULL
, `Kalender_fk`	INTEGER
, FOREIGN KEY (`Kalender_fk`) REFERENCES `Kalender` (`ID`)
) COMMENT 'Manchmal ist nur das Jahr bekannt, manchmal nur Monat, Tag. Je nachdem, was noch lesbar ist.';


-- -------------------------------------------------------

-- --------------------------------------------------------
-- Ereignisse werden in drei Kategorien eingeteilt:
-- * Ereignis  = Eine    Person.  (z. B. Geburt, ...)
-- * Beziehung = Zwei    Personen (z. B. Heirat, Trennung, ...)
-- * Gruppe    = Mehrere Personen (z. B. Familie, Sippe, Wohngruppe, Waisenhaus, ...)
CREATE TABLE `EreignisTyp` (
  `ID`             INTEGER /* PRIMARY */ KEY
, `TypBezeichnung` TEXT NOT NULL
);
-- Stammdaten
INSERT INTO `EreignisTyp`
(`ID`, `TypBezeichnung`) VALUES
(   1, 'Geburt'      ),
(   2, 'Gestorben'   ),
(   3, 'Getauft'     ),
(   4, 'Gefallen'    ),
(   5, 'Verschollen' );


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


-- ---------------------------
CREATE TABLE `BeziehungsTyp` (
  `ID`             INTEGER /* PRIMARY */ KEY
, `TypBezeichnung` Text
) COMMENT 'Beziehungen wie verheiratet, Adotpiert, Pate, ...)';
-- Stammdaten
INSERT INTO `BeziehungsTyp`
(`ID`, `TypBezeichnung`) VALUES
(   1, 'Verheiratet'     ),
(   2, 'Geschieden'      ),
(   3, 'Konkubinat'      ),
(   4, 'Getrennt'        ),
(   5, 'Adoptiert'       ),
(   6, 'Pate/Patin'      );



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

-- ---------------------------------------------------
CREATE TABLE `SippenTyp` (
  `ID` INTEGER KEY
, `TypBezeichnug` TEXT
) COMMENT 'Familie, ...';
-- Stammdaten
INSERT INTO `GruppenTyp`
(`ID`, `TypBezeichnug`   ) VALUES
(   1, 'Familie'         ),
(   2, 'Sippe'           ),
(   3, 'Wohngruppe'      ),
(   4, '3er Kiste'       ),
(   5, 'Waisenhausgruppe');


CREATE TABLE Sippe (
  `ID` INTEGER KEY AUTO_INCREMENT
, `SippenTyp_fk` INTEGER NOT NULL
, `SippenNummer` INTEGER NOT NULL
, `AbDatum`      DATE
, FOREIGN KEY (`SippenTyp_fk`) REFERENCES `SippenTyp` (`ID`)
) COMMENT 'Sippen werden mit Personen über die Tabelle "Sippenzugehörigkeit" verbunden.';

CREATE TABLE `Sippenzugehoerigkeit` (
  `ID` INTEGER KEY AUTO_INCREMENT
, `Person_fk` INTEGER NOT NULL
, `Sippe_fk`  INTEGER NOT NULL
, FOREIGN KEY (`Person_fk`) REFERENCES `Person` (`ID`)
, FOREIGN KEY (`Sippe_fk` ) REFERENCES `Sippe`  (`ID`)
) COMMENT 'Familien, 3er Kisten, Wohngruppen, ...';

-- ------------------------------------------------------------
-- Weitere Kennzeichen wie Ort, Adresse, Bemerkungen, Quellenangabe
--

CREATE TABLE `Ort` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name`       TEXT NOT NULL
);


CREATE TABLE `Adresse` (
  `ID`          INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Ort_fk`      INTEGER
, `Bezeichnung` TEXT NOT NULL -- Beispiel "Ludoweg 18"
, `PLZ`         VARCHAR(15) -- Wird bei älteren Adressen NULL sein
, FOREIGN KEY `Ort_fk` REFERENCES `Ort` (`ID`)
);


CREATE TABLE `BemerkungPerson` (
  `ID`        INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Bemerkung` TEXT
);

CREATE TABLE `KontaktTyp` (
  `ID`             INTEGER /* PRIMARY */ KEY
, `TypBezeichnung` TEXT NOT NULL
);
-- Stammdaten
INSERT INTO `KontaktTyp`
(`ID`, `TypBezeichnung`) VALUES
(   1, 'Telephon privat'  ),
(   2, 'Telephon Geschäft'),
(   3, 'Mobil privat'     ),
(   4, 'Mobil Geschäft'   ),
(   5, 'E-Mail privat'    ),
(   6, 'E-Mail Geschäft'  ),
(   7, 'Facebook'         ),
(   8, 'Whatsapp'         ),
(   9, 'Skype'            );


CREATE TABLE `Kontaktangabe`(
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Person_fk` INTEGER
, `KontaktTyp_fk INTEGER
, `Wert` TEXT
, FOREIGN KEY `Person_fk`     REFERENCES `Person`     (`ID`)
, FOREIGN KEY `KontkatTyp_fk` REFERENCES `KontaktTyp` (`ID`)
);


CREATE TABLE `Quelle` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Quellenbezeichnung` TEXT
) COMMENT 'Beispiele: Wikipedia, Mormonen, Bibel, Museum xyz, ....';


CREATE TABLE `Quellenangabe` (
  `ID` INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Person_fk`  INTEGER
, `Quelle_fk`  INTEGER
, `Externe_ID` TEXT  -- evtl. varchar, aber erst mal Daten sammeln
, `Bemerkung`  TEXT
, FOREIGN KEY `Person_fk` REFERENCES `Person` (`ID`)
, FOREIGN KEY `Quelle_fk` REFERENCES `Quelle` (`ID`)
);
