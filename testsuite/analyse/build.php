<?php

/** 
 * 1. Lese zunächst alle Tabellen und fülle ein globales Array aller Tabellen.
 *    Am Einfachsten ein Assoziatives Array mit TabellenName als Key
 *    und "Tabelle"-Objekt als Value.
 * 2. Setzte bei jedem visited auf FALSE und Level auf "Infinity" (z. B. -1)
 * 3. Lese nun für jede Tabelle via untenstehendem SQL die Referenzierten
 *    Tabellen.
 *    Diese können nun Via Array in die Tabellen (mit addReferencedTable)
 *    gesetzt werden.
 * 4. Berechne Level aller Tabellen 
      z. B. rekursiv oder via DynamicProgramming, Tabellenmethode ...
*/


require_once '../../web/inc/db/dbMeta.fct.php';
require_once 'table.class.php';
$alleTablesAssoc = array();

/**
 * Important to unselect VIEWS from the SHOW TABLES command.
 * The "SHOW TABLES" Command also includes "views".
 * But, when I only want to select the Tables, without the views, I have to
 * test every table, if it is an "InnoDB" (Views have NULL as "Engine").
 */
function isInnoDB($tblName) {
	$tableStatus = getMetaResultset("getTableStatus", ['tableName' => $tblName]);
	return "InnoDB" == $tableStatus->fetch()["Engine"];
}


function calcAllForeignKeys() {
	global $alleTablesAssoc;
	global $_CREDENTIALS_DB_;
	$tableNamesResultset = getMetaResultset("getTables");

	// Alle Tabellen Lesen und Assoc Array aufbauen : $alleTablesAssoc, falls keine Views:
	while($name = $tableNamesResultset->fetch()) {
		$tblName = array_values($name)[0];
		if(isInnoDB($tblName)) {
			$tabelle = new MysqlTable($tblName);
			$tabelle->setVisited(false);
			$tabelle->setLevel(PHP_INT_MAX); 
			$alleTablesAssoc[$tblName] = $tabelle;
		}
	}

	// Alle Foreign Keys pro Tabelle suchen und den
	// Tabellen als weiteren Assoc-Array anfügen
	foreach($alleTablesAssoc as $key => $tabelle) {
		$fcLect = getMetaResultset("getForeignKeyTables", ['tableName' => $key, 'schemaName' => $_CREDENTIALS_DB_]);
		while($actForeignKey = $fcLect->fetch()) {
			$fkTableName = array_values($actForeignKey)[0];
			$fkTabelle   = $alleTablesAssoc[$fkTableName];
			$tabelle->addReferencedTable($fkTabelle);
		}
	}

	// All foreign-Keys Level berechnen
	$changes = 1; // anything > 0
	while($changes > 0) {
		$changes = 0;

		foreach($alleTablesAssoc as $key => $tabelle) {
			$allReferenced = $tabelle->getReferencedTablesOrNULL();
			if(NULL == $allReferenced && ($tabelle->getLevel() > 0)) {
				$tabelle->setLevel(0);
				$changes ++;
			} else if (NULL != $allReferenced) {
				$maxReferencedTableLevel = -1;

				foreach($allReferenced as $rName => $rTable) {
					if($rTable->getLevel() > $maxReferencedTableLevel) {
						$maxReferencedTableLevel = $rTable->getLevel();
					}
				}
				if($maxReferencedTableLevel < PHP_INT_MAX) {
					if($tabelle->getLevel() != ($maxReferencedTableLevel + 1)) {
						$tabelle->setLevel($maxReferencedTableLevel + 1);
						$changes ++;
					}
				} 
			} // end if NULL/!NULL == allReferenced Tables.
		} // for each table
	} // end while
} // end function calcAllForeignKeys()

// obige Funktion aufrufen, damit alles berechnet wird,
// und damit die globale Variable au$alleTablesAssoc gesetzt ist.
calcAllForeignKeys();



function getNumberOfTables() {
	global $alleTablesAssoc;
	return count($alleTablesAssoc);
}


function printReferencedTableNames($tbl) {
	$references = $tbl->getReferencedTablesOrNULL();
	if(NULL == $references) return;
	$cnt = 1;
	foreach($references as $rTblName => $rTbl) {
		echo $rTblName;
		if($cnt < count($references)) {
			echo ", ";
		}
		$cnt ++;
	}
}


 /**
 * Calculate the reverse of the referenced tables:
 * Which tables are dependent of a given Table.
 * Returns an empty array, if no tables are dependent.
 */
function getDependentTables($aTable) {
		global $alleTablesAssoc;  
		$dependencies = array();
		foreach($alleTablesAssoc as $key => $tabelle) {
			if($tabelle->getTableName() != $aTable->getTableName()) {
				if(NULL != $tabelle->getReferencedTablesOrNULL()) {
					if(in_array($aTable, $tabelle->getReferencedTablesOrNULL())) {
						array_push($dependencies, $tabelle->getTableName());  
					}
				} 
			}
		}
		return $dependencies; 
	}
 


function printDependentTabelNames($tbl) {
	$deps = getDependentTables($tbl);
	if(NULL == $deps       ) return;
	if(   0 == count($deps)) return;
	$cnt = 1;
	foreach($deps as $dTbl) {
		echo $dTbl;
		if($cnt < count($deps)) {
			echo ", ";
		}
		$cnt ++;
	}
}


function sortiertAusgeben() {
	global $alleTablesAssoc;
	$actLevel = 0;
	do {
		if(0 == $actLevel) {
			echo "<h3>Unabhängige Tabellen (Level 0)</h3>\n";
		} else {
			echo "<h3>Tabellen mit Level $actLevel</h3>\n";
		}
		echo "<table class='analyse-tabelle'>";
		echo "<tr><td>Übergeordnete Tabelle(n)</td><td>Tabellenname</td><td>Abhängige Tabelle(n)</td></tr>\n";
		$tableOfActLevelFound = false;
		foreach($alleTablesAssoc as $tblName => $tabelle) {
			if($actLevel == $tabelle->getLevel()) {
				$tableOfActLevelFound = true;
				echo "<tr><td>";
				if($actLevel > 0) {
					printReferencedTableNames($tabelle);
				}
				echo "</td><td><b>$tblName</b></td><td>";
				printDependentTabelNames($tabelle);
				echo "</td></tr>\n";
			}
		}
		echo "</table>\n";
		$actLevel++;
	} while($tableOfActLevelFound);
}

?>