<?php

/**
 * Class to represent a MYSQL Table. 
 * It contains the important information of the dependency level.
 */


class MysqlTable {
	private $tableName;
	public function setTableName($tableName_) {
		$this->tableName = $tableName_;
	}
	public function getTableName() {
		return $this->tableName;
	}

	private $visited = false;
	public function setVisited($visited_) {
		$this->visited = $visited_;
	}
	public function isVisited() {
		return $this->visited;
	}

	private $level = PHP_INT_MAX;
	public function setLevel($level_) {
		$this->level = $level_;
	}
	public function getLevel() {
		return $this->level;
	}

	private $referencedTables = NULL; // assoc array of referenced tables
	public  function addReferencedTable($fkTable_) {
		if(NULL == $this->referencedTables) {
			$this->referencedTables = array();
		}
		$this->referencedTables[$fkTable_->getTableName()] = $fkTable_;
	}
	public function getReferencedTablesOrNULL() {
		return $this->referencedTables;
	}

	public function __construct($tableName_) {
		$this->setTableName($tableName_);
	}

} // end Class MysqlTable

?>