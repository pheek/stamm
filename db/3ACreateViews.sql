USE `Stamm`;

CREATE VIEW `V_Personen` AS
SELECT `Person` .`ID`   AS PersonID
,       Vorname .`Name` AS VornameAusgeschrieben
,			  Nachname.`Name` AS NachnameAusgeschrieben
  FROM `Person`, `Name` AS Vorname, `Name` AS Nachname, `Geburts_Vorname`, `Geburts_Familienname`
 WHERE `Geburts_Vorname`     .`Person_fk` = `Person`  .`ID`
   AND `Geburts_Vorname`     .`Name_fk`   =  Vorname  .`ID`
	 AND `Geburts_Familienname`.`Person_fk` = `Person`  .`ID`
	 AND `Geburts_Familienname`.`Name_fk`   =  Nachname .`ID`
;


CREATE VIEW `V_Eltern` AS

SELECT
  Person.ID        AS PersonID
, Mutter.Mutter_fk AS MutterFK
, Vater .Vater_fk  AS VaterFK
FROM `Person`
LEFT JOIN `Mutter` ON `Person`.`ID` = `Mutter`.`Kind_fk`
LEFT JOIN Vater ON Vater.`Kind_fk` = `Person`.`ID`;

SELECT * FROM `V_Eltern`
