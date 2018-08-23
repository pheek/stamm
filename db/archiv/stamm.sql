-- Stammbaum online
-- 2018-08-17 phi@gress.ly

DROP   DATABASE IF EXISTS `Stamm`;
CREATE DATABASE           `Stamm`;
ALTER  DATABASE           `Stamm` DEFAULT CHARACTER SET 'utf8' DEFAULT COLLATE 'utf8_general_ci';

USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';

CREATE USER IF NOT EXISTS 'stammPHP'@'localhost';

GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE  ON `Stamm`.* TO 'stammPHP' IDENTIFIED BY '123';


-- CHANGE the DB Name, then change both!
SET @dbSchemaName_global = 'Stamm'; -- used in table _PROGRAM_PARAMETER_



CREATE TABLE `_SQL_STATEMENTS_` (
  `ID`              INT(11)            NOT NULL PRIMARY KEY AUTO_INCREMENT
, `Command`         VARCHAR(50) UNIQUE NOT NULL COMMENT 'Kurzbeschreibung der Aktion: Beispiel RaumListe'
, `SQL`             TEXT               NOT NULL COMMENT 'volles SQL Statement'
, `AnzahlParameter` INT(11)            NOT NULL COMMENT 'Wie viele verschiedene Paramter können dem Statement mitgegeben werden.'
, `Beschreibung`    TEXT               NOT NULL COMMENT 'Beschreibe auch die Parameter' 
) COMMENT 'SQL Abfragen direkt in der DB speichern. Sie enthalten Parameter in der Form ${n}, wobei die Parameter mehrfach auftreten können und in beliebeger Reihenfolge auftreten dürfen.';


-- -------------------------------
CREATE TABLE `_PROGRAM_PARAMETER_` (
  `ID`   INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT
, `Name` TEXT    NOT NULL COMMENT 'Name der Variable'
, `Wert` TEXT    NOT NULL COMMENT 'Wert der Variable'
-- , PRIMARY KEY (`ID`)
) COMMENT 'Beispiele wie Main URL, Bildverzeichnis, Pre- und Postfixe, ...';

INSERT INTO `_PROGRAM_PARAMETER_`
(`Name`                 , `Wert`              ) VALUES
('DB_SCHEMA_NAME_GLOBAL', @dbSchemaName_global);

-- -------------------------------
CREATE TABLE `_SESSION_VARIABLE_` (
  `ID`           INT(11) NOT NULL PRIMARY KEY
, `Name`         TEXT    NOT NULL COMMENT 'Name der Session Variable'
, `Beschreibung` TEXT    NOT NULL COMMENT 'Beschreibung der Variable' 
) COMMENT 'Welche User-Interface-Seiten existieren. Dies ist wichtig für die Berechtigungen.';

-- -------------------------------
CREATE TABLE `_LOGIN_` (
 `ID`           INT(11)      NOT NULL PRIMARY KEY
,`LoginName`    VARCHAR(99)  NOT NULL                           COMMENT 'Evtl. besser Loginname unique und primary key, dann brauchts die "ID" gar nicht. Wäre auch einfacher zur Fehlersuche.'
,`SALT`         VARCHAR(  6) NOT NULL                           COMMENT 'Wird am Ende des Passwortes (vor dem Hash-Prozess) angefügt und ist für jedes Passwort individuell. Pepper wird am Anfang des Passwortes angefügt.'
,`sha512`       VARCHAR(128) NOT NULL                           COMMENT 'Hex representation of SHA512 (Gehasht wird der zusammengesetzte String: [PEPPER][Passwolt][SALT])'
,`registerTS`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registrierungszeitpunkt'
, UNIQUE      (`LoginName`)
) COMMENT 'Welche Loginnamen existieren. Diese sind nur "lose" mit den Personen verknüfpt. Es kann Personen geben, welche kein Login aufweisen und es kann Personen geben, welche mehrere login-Rollen haben. Daher ist hier einzig der Login-Name relevant';


-- -------------------------------
CREATE TABLE `_ROLLENTYP_` (
  `ID`               INT(11) NOT NULL PRIMARY KEY
, `Typenbezeichnung` TEXT    NOT NULL COMMENT 'Bezeichnung der Mitarbeiter-Rolle: Lehrling, HR, ...'
) COMMENT 'Rollen der Login-User: Admin, Gast, Geschäftsleitung, ....';


-- -------------------------------
CREATE TABLE `_USER_INTERFACE_` (
  `ID`           INT(11) NOT NULL PRIMARY KEY
, `Page`         TEXT    NOT NULL COMMENT 'Name des URL-Teils'
, `Beschreibung` TEXT    NOT NULL COMMENT 'Beschreibe auch die Parameter' 
) COMMENT 'Welche User-Interface-Seiten existieren. Dies ist wichtig für die Berechtigungen.';


-- -------------------------------------------------------
-- Abhängigkeit erster Ordnung von Tabellen des Frameworks
-- -------------------------------------------------------

CREATE TABLE `_SESSION_` (
  `ID`            INT(11)   NOT NULL PRIMARY KEY AUTO_INCREMENT
, `Login_fk`      INT(11)   NOT NULL
, `LoginTS`       DATETIME  DEFAULT CURRENT_TIMESTAMP 
, `LoginSuccess`  BOOLEAN   DEFAULT FALSE
, `LogoutTS`      DATETIME  NULL DEFAULT NULL
, `LogoutSuccess` BOOLEAN   DEFAULT FALSE
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_` (`ID`)
) COMMENT 'Logins/Logouts aller aktiven User. Jedes Login fuellt Login_fk und LoginTS. Erfolgreiche Logins setzen zudem SoginSuccess auf true. LogoutTS wird beim Logout gesetzt, ebenso LogoutSuccess, sofern der Logout innerhalb einer vorgegebenen Frist stattgefunden hat (z. B. 12 Stunden = 720 Min.).';


-- -------------------------------
CREATE TABLE `_LOGIN_RESET_EMAIL_` (
  `ID`       INT(11) NOT NULL PRIMARY KEY
, `Login_fk` INT(11) NOT NULL
, `email`    TEXT    NOT NULL
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_` (`ID`)
) COMMENT 'Zum Rücksetzen des Passwortes per E-Mail ist eine solche nötig.';


-- -------------------------------
CREATE TABLE `_ACCESS_LOG_ENTRY_` (
  `ID`         INT(11)   NOT NULL PRIMARY KEY AUTO_INCREMENT
, `Login_fk`   INT(11)   NOT NULL                   COMMENT 'Login ID (nicht Login Name)'
, `Page_fk`    INT(11)   NOT NULL                   COMMENT 'Welche Seite wurde besucht'
, `accessType` CHAR(1)   NOT NULL                   COMMENT 'S=SELECT, I=INSERT, U=UPDATE, D=DELETE'
, `TS`         DATETIME  DEFAULT CURRENT_TIMESTAMP  COMMENT 'Wann, wurde die Seite besucht.'
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_`          (`ID`)
, FOREIGN KEY (`Page_fk`)  REFERENCES `_USER_INTERFACE_` (`ID`)
) COMMENT 'Wer hat wann welche Seite besucht..';


-- -------------------------------
-- CREATE TABLE `_SEITEN_SICHTBARKEIT_` (
--  `ID`           INT(11) NOT NULL
-- , `Rollentyp_fk` INT(11) NOT NULL COMMENT 'Login Rolle'
-- , `URLPart_fk`   INT(11) NOT NULL COMMENT 'Wesentlicher URL-Teil, der für eine User-Rolle sichtbar sein darf. Entspricht «Page» aus _USER_INTERFACE_'
-- , FOREIGN KEY (`Rollentyp_fk`) REFERENCES `_ROLLENTYP_`      (`ID`)
-- , FOREIGN KEY (`URLPart_fk`)   REFERENCES `_USER_INTERFACE_` (`ID`)
-- , PRIMARY KEY (`ID`)
-- , UNIQUE      (`URLPart_fk`, `Rollentyp_fk`)
-- ) COMMENT 'Welche User-Interface Seiten sind für wen (Rolle) sichtbar.';

-- -------------------------------
CREATE TABLE `_ARBEITSBEREICH_` (
  `ID`       INT(11) NOT NULL PRIMARY KEY
, `Bereich`  TEXT    COMMENT 'Name der Abteilung oder der Arbeit (Raumverwaltung, Lehrgangsverantwortung, Trainer).'
) COMMENT 'Welche Arbeitsberiche existieren in dieser Firma.';


-- -------------------------------
CREATE TABLE `_GUI_ARBEITSBEREICH_` (
  `ID`         INT(11) NOT NULL PRIMARY KEY
, `Bereich_fk` INT(11)
, `GUI_fk`     INT(11)
, FOREIGN KEY (`Bereich_fk`) REFERENCES `_ARBEITSBEREICH_` (`ID`)
, FOREIGN KEY (`GUI_fk`    ) REFERENCES `_USER_INTERFACE_` (`ID`)
) COMMENT 'Welche GUI-Seite gehört in welchen Arbeitsbereich. Dabei kann eine GUI-Seite durchaus in mehrere Bereiche gehören (Noten ansehen).';


-- -------------------------------
CREATE TABLE `_ROLLE_ARBEITSBEREICH_` (
  `ID`         INT(11) NOT NULL NOT NULL
, `Bereich_fk` INT(11) NOT NULL
, `Rolle_fk`   INT(11) NOT NULL 
, FOREIGN KEY (`Bereich_fk`) REFERENCES `_ARBEITSBEREICH_` (`ID`)
, FOREIGN KEY (`Rolle_fk`  ) REFERENCES `_ROLLENTYP_`      (`ID`)
) COMMENT 'Welche ROLLE darf welche Arbeiten durchführen.';


-- -------------------------------
INSERT INTO `_SQL_STATEMENTS_`
(`Command`, `SQL`, `AnzahlParameter`, `Beschreibung`)
VALUES
('ConnectionTest',
 'SELECT `ID` FROM `_SQL_STATEMENTS_` WHERE `ID`=1 AND `Command`="connectionTest"',
 0,
 'Teste, ob die Connection zur Datenbank erfolgreich war. Dieses Statement muss ein atomares Resulatat ID mit ID=1 zurückgeben.'),

('getAllSQLStatements',
 'SELECT * FROM `_SQL_STATEMENTS_`',
 0,
 'Liste all dieser SQL-Statements für Testzwecke'),

('getTables',
 'SHOW TABLES',
 0,
 'Select all table names.'),

('getTableStatus',
 'SHOW TABLE STATUS WHERE Name=:tableName',
 1,
 'Show different infos about a specific table'),

('getForeignKeyTables',
 'SELECT `REFERENCED_TABLE_NAME` AS ForeignKeys FROM `INFORMATION_SCHEMA`.`KEY_COLUMN_USAGE` WHERE `TABLE_NAME` = :tableName AND `CONSTRAINT_SCHEMA`=:schemaName AND NOT (`REFERENCED_TABLE_NAME` IS NULL)',
 2,
 'Select all referenced table names for a given table.'),

('LoginSP',
 'SELECT getLoginID_OrNegative(:loginName, :rawPassword, :pepper) AS LoginID',
 3,
 'Liefert die LoginID. Bei falschem Passwort oder nicht existierendem Username liefert diese Funciton "-1" zurück.'),

('insertLogEntry',
 'CALL insertLOG_PageVisit(:pageID, :logID, :accessType)',
 3,
 'Erzeugt einen Log in der DB. Dies sollte vom Framework aufgerufen werden, wenn eine Seite angesurft wird, bzw, wenn eine Tabelle INSERT, UPDATE, ');


-- -------------------------------
INSERT INTO `_PROGRAM_PARAMETER_`
(`Name`              , `Wert`      ) VALUES
('URL-Postfix'       , ''          ),
('DB Server IP'      , 'localhost' ),
('Maintenance_MODE'  , 'FALSE'     ), -- falls TRUE: Die Webseite "Maintenance.php" erscheint vor dem Login
('Login max. Minutes', '720'       );


-- -------------------------------
INSERT INTO `_SESSION_VARIABLE_`
(`ID`, `Name`         , `Beschreibung`                                                                 ) VALUES
(   1, 'login'        , 'ID des eingeloggten users (nicht der Person, sondern ID der _LOGIN_-Tabelle).'),
(   2, 'requestedPage', CONCAT('Welche Seite wollte ein nicht eingeloggter User ansurfen. ', 
                               'Nach korrektem Login wird ihm diese Seite angegeben.'       )          );



-- --------------------------------------------------------
-- proc: getSchemaName
-- 2018-07-07
-- autor: phi@gress.ly
-- Returns the name of the SCHEMA, if correctly storede in the table
-- _PROGRAM_PARAMETER under the variable "DB_SCHEMA_NAME_GLOBAL"
--
DROP FUNCTION  IF EXISTS getSchemaName;
DELIMITER //
CREATE FUNCTION getSchemaName()
RETURNS VARCHAR(50)
BEGIN
	SET @schemaName = "";
	SELECT `Wert`
		INTO @schemaName
		FROM `_PROGRAM_PARAMETER_`
		WHERE `Name` = "DB_SCHEMA_NAME_GLOBAL";
	RETURN @schemaName;
END; //

DELIMITER ;


-- --------------------------------------------------------

-- returns LoginID, if a User can be logged in
--         Not Loged in: Liefert "-1"
-- Bem.: Das "IF NOT EXISTS" wurde erst in MariaDB 10.1.3 hinzugefügt.
-- SELECT getLoginID_OrNegative("max.muster", "ppeepppppeerr", "password")
DROP FUNCTION IF EXISTS getLoginID_OrNegative;
DELIMITER //
CREATE FUNCTION getLoginID_OrNegative
( _loginName      TEXT
, _rawPassword    TEXT
, _pepper         TEXT
)
RETURNS INT(11)
-- MODIFIES SQL DATA
BEGIN
	/* Achtung: Lokale Variable überleben die Aufrufe,
	 *          Daher immer zurücksetzen!
	 */
	SET @loginID = -1;
	
	SELECT `salt` INTO @salt
		FROM `_LOGIN_`
		WHERE `LoginName` = _loginName
		LIMIT 1;

	SELECT `ID` INTO @loginID
		FROM `_LOGIN_`
		WHERE `LoginName` = _loginName
		AND `sha512`= SHA2(CONCAT(_pepper, _rawPassword, @salt), 512)
		LIMIT 1;

	IF (0 < @loginID) THEN
		INSERT INTO `_SESSION_` (`Login_fk`,`LoginSuccess`) VALUES (@loginID, TRUE);
		RETURN @loginID;
	END IF;

	RETURN -1;
END; //

DELIMITER ;


-- --------------------------------------------------------
-- DELIMITER //

-- CREATE PROCEDURE insertLOG_PageVisit
-- ( _pageID     INT(11)
-- , _loginID    INT(11)
-- , _accessType CHAR(1)
-- )
-- BEGIN
-- 	INSERT INTO `_ACCESS_LOG_ENTRY_`
-- 	(`Login_fk`, `Page_fk`, `accessType`) VALUES
-- 	(_loginID  , _pageID  , _accessType );
-- END; //
-- DELIMITER ;

-- --------------------------------------------------------

-- phi@gress.ly 2018-07-18
-- gets the ID of a tablename from _SCHEMA_TABLE_NAME_.
DROP FUNCTION IF EXISTS `getSchemaTableNameID`;
DELIMITER //

CREATE FUNCTION getSchemaTableNameID
( _tableName   varchar(50)
)
RETURNS INT(11)
BEGIN
	SELECT `ID` INTO @tableID
	FROM `_SCHEMA_TABLE_NAME_`
	WHERE `TableName` = _tableName;
	return @tableID;
END; //

DELIMITER ;


-- --------------------------------------------------------




-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS `insert_LOG_SQL_TABLE`;
DELIMITER //

CREATE PROCEDURE insert_LOG_SQL_TABLE
( _tableName   varchar(50)
, _ModifyType  char(1)
)
BEGIN
	INSERT INTO `_SQL_LOG_ENTRY_`
	(`TableName_fk`                  , `ModifyType`) VALUES
	(getSchemaTableNameID(_tableName), _ModifyType);
END; //

DELIMITER ;


-- --------------------------------------------------------



CREATE TABLE IF NOT EXISTS `EreignisTyp` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Beschreibung` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=9 ;

--
-- Daten für Tabelle `EreignisTyp`
--

INSERT INTO `EreignisTyp` (`ID`, `Beschreibung`) VALUES
(1, 'Geburt'),
(2, 'Gestorben'),
(3, 'Getauft'),
(4, 'Gefallen'),
(5, 'Heirat'),
(6, 'Scheidung'),
(7, 'Trennung'),
(8, 'Verschollen');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Geschlecht`
--

CREATE TABLE IF NOT EXISTS `Geschlecht` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Geschlecht` char(1) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Daten für Tabelle `Geschlecht`
--

INSERT INTO `Geschlecht` (`ID`, `Geschlecht`) VALUES
(1, 'w'),
(2, 'm'),
(3, '?');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Name`
--

CREATE TABLE IF NOT EXISTS `Name` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=31 ;

--
-- Daten für Tabelle `Name`
--

INSERT INTO `Name` (`ID`, `Name`) VALUES
(1, 'Gressly'),
(2, 'Jean-Claude'),
(3, 'Thomas'),
(4, 'Müller'),
(5, 'Philippe'),
(6, 'Pascal'),
(7, 'Margrit'),
(8, 'Gille'),
(9, 'Philipp'),
(10, 'Claude'),
(11, 'Elsa'),
(12, 'Lou'),
(13, 'Kurt'),
(14, 'Maurice'),
(15, 'Rose'),
(16, 'Rémy'),
(17, 'André'),
(18, 'Yan'),
(19, 'Tanjia'),
(20, 'Elisabeth'),
(21, 'Barbara'),
(22, 'Freimann'),
(23, 'Samuel'),
(24, 'Diana'),
(25, 'René'),
(26, 'Alain'),
(27, 'Milosch'),
(28, 'Marvin'),
(29, 'Raphael'),
(30, 'Nathan');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `person`
--

CREATE TABLE IF NOT EXISTS `person` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `FK_Geschlecht` int(11) NOT NULL,
  `FK_FirstFamilyName` int(11) DEFAULT NULL,
  `FK_FirstGivenName` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `person`
--

INSERT INTO `person` (`ID`, `FK_Geschlecht`, `FK_FirstFamilyName`, `FK_FirstGivenName`) VALUES
(1, 2, 1, 5);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Teildatum`
--

CREATE TABLE IF NOT EXISTS `Teildatum` (
  `Jahr`  int(11) NOT NULL,
  `Monat` int(11) NOT NULL,
  `Tag`   int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Daten für Tabelle `Teildatum`
--

INSERT INTO `Teildatum` (`Jahr`, `Monat`, `Tag`) VALUES
(1966, 1, 18),
(   0, 1,  1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

