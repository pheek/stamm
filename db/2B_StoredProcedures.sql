-- Stored Procedures
-- @author φ
-- @date  2018-09-05

USE `Stamm`;



-- 2018-08-07 phi@gress.ly
--
-- Insert values into dynamic table.
-- If the element already existed, nothing will be inserted, but the old
-- id is "returned" (OUT-Param).
-- If "_reuse_if_exists" is unset (FALSE), then a new element is
-- generated anyway
-- Otherwise a new row is generated.
DELIMITER //
CREATE PROCEDURE SP_insert_and_get_ID
( IN  _tabellenName    TEXT
, IN  _attributName    TEXT
, IN  _attributWert    TEXT
, IN  _reuse_if_exists BOOLEAN
, OUT _id              INT
)
MODIFIES SQL DATA
BEGIN
	SET @tmpID    := -1; -- Any number which is not in the DB.
	
	SET @tmpQuery := CONCAT('SELECT `ID` INTO @tmpID',
	                        ' FROM ' , _tabellenName,
	                        ' WHERE ', _attributName, ' = "', _attributWert, '"', " LIMIT 1" );
	PREPARE stmt FROM @tmpQuery;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	-- -1 != @tmpID means: an entry has been found. So, -1 = @tmpID means: INSERT anyway
	-- IF not found or "create new" (wher "create new" is identical to "NOT reuse").
	IF ((-1 = @tmpID) OR (NOT _reuse_if_exists)) THEN
		SET @tmpQuery := CONCAT('INSERT INTO ', '`', _tabellenName , '`',
		                        '(`', _attributName, '`) VALUES',
		                        '("', _attributWert, '")'
		                       );
		PREPARE stmt FROM @tmpQuery;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SET @tmpID := LAST_INSERT_ID();
	END IF;

	SET _id := @tmpID;
END; //
DELIMITER ;

-- ----------------------------------------------------
-- @author φ
-- @date 2018-09-05
-- Procedure to create a person and add some main attributes as
-- name and sex.
--
-- Aufruf Beispiel
-- CALL SP_createPerson('peter', 'hans', 'm', 5, 5, @dummy); SELECT @dummy;

DROP PROCEDURE IF EXISTS SP_createPerson;
DELIMITER //
CREATE PROCEDURE SP_createPerson (
   IN  _familienname TEXT
 , IN  _vorname      TEXT
 , IN  _geschlecht   CHAR(1)
 , IN  _mutterID     INTEGER
 , IN  _vaterID      INTEGER
 , OUT _createdID    INTEGER
)
MODIFIES SQL DATA
BEGIN
  DECLARE tmpPersonID  INTEGER;
	DECLARE tmpNameID    INTEGER;

	INSERT INTO Person (Geschlecht) VALUES
	(_geschlecht);
	SET tmpPersonID = LAST_INSERT_ID();

	CALL SP_insert_and_get_ID('Name', 'Name', _familienname, TRUE, tmpNameID);

	INSERT INTO `Geburts_Familienname`
	(`Person_fk`, `Name_fk`, `Laufnummer`) VALUES
	(tmpPersonID, tmpNameID, 1);

	SELECT CONCAT("DEBUG: tmpNameID " , tmpNameID);

	CALL SP_insert_and_get_ID('Name', 'Name', _vorname, TRUE, tmpNameID);

	INSERT INTO `Geburts_Vorname`
	(`Person_fk`, `Name_fk`, `Laufnummer`) VALUES
	(tmpPersonID, tmpNameID, 1);
	
	IF(_mutterID > 0) THEN
		INSERT INTO `Mutter`
		       (`Mutter_fk`, `Kind_fk`)
		VALUES (_mutterID  , tmpPersonID);
	END IF;

	IF(_vaterID > 0) THEN
		INSERT INTO `Vater`
		       (`Vater_fk`, `Kind_fk`)
		VALUES (_vaterID  , tmpPersonID);
	END IF;

	SET _createdID = tmpPersonID;
END; //
DELIMITER ;

