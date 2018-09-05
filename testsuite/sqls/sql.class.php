<?php

/**
 * @autor: phi@gress.ly
 * @datum: 6.6.18
 *
 * Class to represent a SQL-Statement.
 */
require_once '../../web/inc/db/dbMeta.fct.php';

class SQLStatement {
	private $statementName = "";
	public function setStatementName($statementName_) {
		$this->statementName = $statementName_;
	}
	public function getStatementName() {
		return $this->statementName;
	}

	private $sqlStatement = "";
	public function setSQLStatement($statement_) {
		$this->sqlStatement = $statement_;
	}
	public function getSQLStatement() {
		return $this->sqlStatement;
	}

	private $sqlNumParams = "";
	public function setNumberOfParameters($numParams_) {
		$this->sqlNumParams = $numParams_;
	}
	public function getNumberOfParameters() {
		return $this->sqlNumParams;
	}

	private $beschreibung = "";
	public function setBeschreibung($beschreibung_) {
		$this->beschreibung = $beschreibung_;
	}
	public function getBeschreibung() {
		return $this->beschreibung;
	}

	
	private $sqlParamValues = array();
	public function addParamValue($param, $valaue) {
		$this->sqlParamValues[$param] = $value;
	}
	private $sqlParamNames = array();
	public function getParameterNames() {
		return $this->sqlParamNames;
	}
	public function parseParameterList() {
		$matches_out = array();
		if(preg_match_all("(:[a-zA-Z][0-9a-zA-Z]*)", $this->getSQLStatement(), $matches_out)) {
			$keys = array_unique($matches_out[0]);
			foreach($keys as $param) {
				$this->sqlParamNames[] = substr($param, 1);
			}
		}
	}
	
	/**
	 * Returns a PDO result, which ist fetchable.
	 */
	public function executeSQLStatement() {
		if(count($sqlParamValues) != $this->getNumberOfParameters()) {
			echo "ERROR sql.class.php : SQLStatement.executeSQLStatement: ";
			echo "Requires " . $this->getNumberOfParameters();
			echo " Parameters, but only ";
			echo count($sqlParamValues) . " where given!<br />\n";
			die();
		}
		$result = getMetaResultset($this->statementName, $sqlParamValues);
		return $result;
	} // end method execurteSQLStatement

} // end Class MysqlTable

?>