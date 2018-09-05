<?php

/**
 * 2013-06-25 phi@wintigo.or
 * 2018-05-19 philipp.gressly@santismail.ch
 * Helper-Functions to connect to db and use SQL
 *
 * The main difference between ordinal queries is the fact, that
 * META-Queries get the SQL-Statements out of the database itselfs.
 * If you woud normally write something like:
 *
 *  SELECT * FROM `Person` WHERE `Name` = "Max"
 *
 * you will only write the following, when using META-Queries:
 *
 *  getMetaResultset('person', ['nm'=>'Max']);
 *
 * while the Select-Statement is stored in the database itself:
 *
 *  SELECT * FROM `Person` WHERE `Name` = :nm
 */


/**
 * Executes a query out of the prepared query list in the
 * _SQL_STATEMELS_TABLE_NAME_.
 * @param "statementName" is the name-Attribute in the mentioned db-table.
 * @param "params" are varargs. Array of Strings or many strings.
 *                 Those will be replaced while the prepared select statement is
 *                 executed. 
 *                 The to-be-replaced strings have the PDO-Syntax:
 *                 ":xyz", ":abc" (without the quotes).
 */
function getMetaResultset($statementName, $paramsAssoc=[]) {
	return MetaResultSetClass::getMetaResultset($statementName, $paramsAssoc);
}


/**
 * Wie getMetaResultset, aber nur ein Resultat in einer Spalte.
 */
function getMetaAtomicResult($statementName, $paramsAssoc=[]) {
	return MetaResultSetClass::getMetaAtomicResult($statementName, $paramsAssoc);
}


 /**
  * Same as "getMetaResultset()", but this time only the
  * number of lines is relevant.
  */
function getMetaResultsetCount($statementName, $paramsAssoc=[]) {
	return MetaResultSetClass::getMetaResultsetCount($statementName, $paramsAssoc);
}


//////////////////////////// Implementation //////////////////////////////////////////

/**
 * This class is only for encapsulating private methods.
 * ... and for code beautyfiing.
 * It contains all above mentioned methods as public methods.
 */

require_once "dbConnect.class.php";
//require_once "dbHelper.fct.php"   ;

class MetaResultSetClass {

	private static $_SQL_STATEMENTS_TABLE_NAME_ = '_SQL_STATEMENTS_';


	public static function getMetaResultset($statementName, $paramsAssoc) {
		$sql = MetaResultSetClass::get_sql_statement($statementName, $paramsAssoc);
		$pdo  = ConnectionSingleton::getThePDO();
		$stmt = $pdo->prepare($sql);
		$stmt->execute($paramsAssoc);
		return $stmt;
	}


	public function getMetaAtomicResult($statementName, $paramsAssoc=[]) {
		$stmt = MetaResultSetClass::getMetaResultset($statementName, $paramsAssoc);
		return MetaResultSetClass::getAtomicResultFromPODStmt($stmt);
	} // end method "getMetaAtomicResult"


	public static function getMetaResultsetCount($statementName, $paramsAssoc=[]) {
		$stmt = MetaResultSetClass::getMetaResultset($statementName, $paramsAssoc);
        $nrs = $stmt->fetchColumn();
        return $nrs;
	} // end method "getMetaResultsetCount"


	/**
	 * Get a single atomar result from a SELECT-query giving one 
	 * row with one column. This is not a META-Resultset.
	 * If no result is found, "null" is returned.
	 *
	 * Can also be used for inserts, updates, deletes, if the
	 * result is not used.
	 */
	private static function getAtomicResult($statement) {
		$pdo = ConnectionSingleton::getThePDO();
		$stmt = $pdo->query($statement);
		return MetaResultSetClass::getAtomicResultFromPODStmt($stmt);
	}

	private static function getAtomicResultFromPODStmt($stmt) {
		//echo "<br /><br />\nSTMT:";
		//var_dump($stmt);
		//echo "<br />\n";
		$row = $stmt->fetch();
		//$row = $stmt->fetch(PDO::FETCH_ASSOC);
		//echo "Row:";
		//var_dump($row);
		$rowCount = 0;
		if(false == $row) {
			echo 'FATAL ERROR in dbMeta.fct.php::getAtomicResultFromPODStmt(';
			var_dump ($stmt);
			echo ') has no atomic result!<br/>';
			die();
		}
		foreach($row as $key => $value) {
			//echo "<br/>forech: ";
			//var_dump($row);
			//echo " key: $key, value: $value<br/>\n";
			$rowCount ++;
			$result = $value;
		}
		if(1 != $rowCount) {
			echo 'debug in dbMeta.fct.php::getAtomicResult(';
			var_dump($stmt);
			echo ') has no atomic result!<br/>';
			die();
		}
		return $result;
	}


/**
	 * Call this function to get the resultset of the named query.
	 * Names are given in the meta-table called "_SQL_Statements".
	 * Sometiemes the sql-statements contain replacements like ${1}, ${2},
	 *  and so on;
	 * these params will be replaced by "variable params" which are
	 * given to this function as a string-array ($params):
	 */
	private static function get_sql_statement($statementName, $params) {
		$sqlSQL = 'SELECT `SQL` FROM `' .
		           MetaResultSetClass::$_SQL_STATEMENTS_TABLE_NAME_ .
		           '` WHERE `Command`="'.$statementName.'"';
		$result = MetaResultSetClass::getAtomicResult($sqlSQL);
		if(null == $result) {
			echo "ERROR dbMeta.fct.php::get_sqlStatement $statementName no result!!";
			return; // not found!
		}
		//$result = $result['SQL'];

		$sqlNumParams = 'SELECT `AnzahlParameter` FROM `'.
		                MetaResultSetClass::$_SQL_STATEMENTS_TABLE_NAME_ .
		                '` WHERE `Command`="'.$statementName.'"';
		$numOfParams = MetaResultSetClass::getAtomicResult($sqlNumParams);

		if(count($params) != $numOfParams) {
			die("<br />dbMeta.fct.php:get_sql_statement(): SQL Statement uses wrong number of arguments: «" . $statementName . "» requires ".	$numOfParams . " Parameter(s), but " . (func_num_args() - 1) . " is/where given.<br/>");
		}

		return $result;
	} // end of private method 'get_sql_staement'

} // end of class MetaResultSetClass
?>