-- --------------------------------------------------------------------------------------------

-- Stammbaum online
-- 2018-08-17 phi@gress.ly


-- --------------------------------------------------------------------------------------------
-- CREATE DATABASE AND USER

SET @dbSchemaName_global = 'Stamm'; -- used in table _PROGRAM_PARAMETER_
DROP   DATABASE IF EXISTS `Stamm`;
CREATE DATABASE           `Stamm`;
ALTER  DATABASE           `Stamm`
	DEFAULT CHARACTER SET 'utf8'
	DEFAULT COLLATE 'utf8_general_ci';

USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';

-- CREATE USER IF NOT EXISTS 'stammPHP'@'localhost';

GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE  ON `Stamm`.* TO 'stammPHP' IDENTIFIED BY '123';

-- ---------------------------------------------------------------------------------------------

CREATE TABLE `_SQL_STATEMENTS_` (
  `ID`              INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Command`         VARCHAR(50) UNIQUE NOT NULL COMMENT 'Kurzbeschreibung der Aktion: Beispiel RaumListe'
, `SQL`             TEXT               NOT NULL COMMENT 'volles SQL Statement'
, `AnzahlParameter` INTEGER            NOT NULL COMMENT 'Wie viele verschiedene Paramter können dem Statement mitgegeben werden.'
, `Beschreibung`    TEXT               NOT NULL COMMENT 'Beschreibe auch die Parameter' 
) COMMENT 'SQL Abfragen direkt in der DB speichern. Sie enthalten Parameter in der Form ${n}, wobei die Parameter mehrfach auftreten können und in beliebeger Reihenfolge auftreten dürfen.';


-- -------------------------------
CREATE TABLE `_PROGRAM_PARAMETER_` (
  `ID`   INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name` TEXT    NOT NULL COMMENT 'Name der Variable'
, `Wert` TEXT    NOT NULL COMMENT 'Wert der Variable'
) COMMENT 'Beispiele wie Main URL, Bildverzeichnis, Pre- und Postfixe, ...';

INSERT INTO `_PROGRAM_PARAMETER_`
(`Name`                 , `Wert`              ) VALUES
('DB_SCHEMA_NAME_GLOBAL', @dbSchemaName_global);


-- -------------------------------
INSERT INTO `_PROGRAM_PARAMETER_`
(`Name`              , `Wert`      ) VALUES
('URL-Postfix'       , ''          ),
('DB Server IP'      , 'localhost' ),
('Maintenance_MODE'  , 'FALSE'     ), -- falls TRUE: Die Webseite "Maintenance.php" erscheint vor dem Login
('Login max. Minutes', '720'       );


-- -------------------------------
CREATE TABLE `_SESSION_VARIABLE_` (
  `ID`           INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Name`         TEXT    NOT NULL COMMENT 'Name der Session Variable'
, `Beschreibung` TEXT    NOT NULL COMMENT 'Beschreibung der Variable' 
) COMMENT 'Welche User-Interface-Seiten existieren. Dies ist wichtig für die Berechtigungen.';


-- -------------------------------
INSERT INTO `_SESSION_VARIABLE_`
(`ID`, `Name`         , `Beschreibung`                                                                 ) VALUES
(   1, 'login'        , 'ID des eingeloggten users (nicht der Person, sondern ID der _LOGIN_-Tabelle).'),
(   2, 'requestedPage', CONCAT('Welche Seite wollte ein nicht eingeloggter User ansurfen. ', 
                               'Nach korrektem Login wird ihm diese Seite angegeben.'       )          );


-- -------------------------------
CREATE TABLE `_LOGIN_` (
 `ID`           INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
,`LoginName`    VARCHAR( 99) UNIQUE NOT NULL                    COMMENT 'Evtl. besser Loginname unique und primary key, dann brauchts die "ID" gar nicht. Wäre auch einfacher zur Fehlersuche.'
,`SALT`         VARCHAR(  6) NOT NULL                           COMMENT 'Wird am Ende des Passwortes (vor dem Hash-Prozess) angefügt und ist für jedes Passwort individuell. Pepper wird am Anfang des Passwortes angefügt.'
,`sha512`       VARCHAR(128) NOT NULL                           COMMENT 'Hex representation of SHA512 (Gehasht wird der zusammengesetzte String: [PEPPER][Passwolt][SALT])'
,`registerTS`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registrierungszeitpunkt'
) COMMENT 'Welche Loginnamen existieren. Diese sind nur "lose" mit den Personen verknüfpt. Es kann Personen geben, welche kein Login aufweisen und es kann Personen geben, welche mehrere login-Rollen haben. Daher ist hier einzig der Login-Name relevant';


-- -------------------------------
CREATE TABLE `_ROLLENTYP_` (
  `ID`               INTEGER /* PRIMARY */ KEY AUTO_INCREMENT
, `Typenbezeichnung` TEXT    NOT NULL COMMENT 'Bezeichnung der Mitarbeiter-Rolle: Lehrling, HR, ...'
) COMMENT 'Rollen der Login-User: Admin, Gast, Geschäftsleitung, ....';


-- -------------------------------
CREATE TABLE `_USER_INTERFACE_` (
  `ID`           INTEGER NOT NULL PRIMARY KEY
, `Page`         TEXT    NOT NULL COMMENT 'Name des URL-Teils'
, `Beschreibung` TEXT    NOT NULL COMMENT 'Beschreibe auch die Parameter' 
) COMMENT 'Welche User-Interface-Seiten existieren. Dies ist wichtig für die Berechtigungen.';


-- -------------------------------------------------------
-- Abhängigkeit erster Ordnung von Tabellen des Frameworks
-- -------------------------------------------------------

CREATE TABLE `_SESSION_` (
  `ID`            INTEGER   /* PRIMARY */ KEY AUTO_INCREMENT
, `Login_fk`      INTEGER   NOT NULL
, `LoginTS`       DATETIME  DEFAULT CURRENT_TIMESTAMP 
, `LoginSuccess`  BOOLEAN   DEFAULT FALSE
, `LogoutTS`      DATETIME  NULL DEFAULT NULL
, `LogoutSuccess` BOOLEAN   DEFAULT FALSE
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_` (`ID`)
) COMMENT 'Logins/Logouts aller aktiven User. Jedes Login fuellt Login_fk und LoginTS. Erfolgreiche Logins setzen zudem SoginSuccess auf true. LogoutTS wird beim Logout gesetzt, ebenso LogoutSuccess, sofern der Logout innerhalb einer vorgegebenen Frist stattgefunden hat (z. B. 12 Stunden = 720 Min.).';


-- -------------------------------
CREATE TABLE `_LOGIN_RESET_EMAIL_` (
  `ID`       INTEGER /*PRIMARY*/ KEY AUTO_INCREMENT
, `Login_fk` INTEGER NOT NULL
, `email`    TEXT    NOT NULL
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_` (`ID`)
) COMMENT 'Zum Rücksetzen des Passwortes per E-Mail ist eine solche nötig.';


-- -------------------------------
CREATE TABLE `_ACCESS_LOG_ENTRY_` (
  `ID`         INTEGER   /*PRIMARY*/ KEY AUTO_INCREMENT
, `Login_fk`   INTEGER   NOT NULL                   COMMENT 'Login ID (nicht Login Name)'
, `Page_fk`    INTEGER   NOT NULL                   COMMENT 'Welche Seite wurde besucht'
, `accessType` CHAR(1)   NOT NULL                   COMMENT 'S=SELECT, I=INSERT, U=UPDATE, D=DELETE'
, `TS`         DATETIME  DEFAULT CURRENT_TIMESTAMP  COMMENT 'Wann, wurde die Seite besucht.'
, FOREIGN KEY (`Login_fk`) REFERENCES `_LOGIN_`          (`ID`)
, FOREIGN KEY (`Page_fk`)  REFERENCES `_USER_INTERFACE_` (`ID`)
) COMMENT 'Wer hat wann welche Seite besucht..';

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
RETURNS INTEGER
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
-- ( _pageID     INTEGER
-- , _loginID    INTEGER
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
RETURNS INTEGER
BEGIN
	SELECT `ID` INTO @tableID
	FROM `_SCHEMA_TABLE_NAME_`
	WHERE `TableName` = _tableName;
	return @tableID;
END; //

DELIMITER ;


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

