<?php
// autor: phi@gress.ly
// datum: 6. 6. 18

require_once '../../web/inc/db/dbMeta.fct.php';
require_once 'sql.class.php';

$ALL_STATEMENTS;

function loadStatementList() {
	global $ALL_STATEMENTS;
	$ALL_STATEMENTS = array();
	$allInResultset = getMetaResultset('getAllSQLStatements');
	$fetched = $allInResultset->fetchall();
	foreach($fetched as $SQLStatementID => $SQL_Statement) {
		$stmt = new SQLStatement();
		$stmt->setStatementName     ($SQL_Statement['Command'        ]);
		$stmt->setSQLStatement      ($SQL_Statement['SQL'            ]);
		$stmt->setNumberOfParameters($SQL_Statement['AnzahlParameter']);
		$stmt->setBeschreibung      ($SQL_Statement['Beschreibung'   ]);

		$stmt->parseParameterList();

		$ALL_STATEMENTS[$SQL_Statement['Command']] = $stmt;
//		echo "StatementName: " . $stmt->getStatementName() . "<br/>\n";
	}
}
// call:
loadStatementList();

function showSQLStatementList() {
	global $ALL_STATEMENTS;
	foreach($ALL_STATEMENTS as $name => $statement) {
		echo "<option value='".$name."'>". $name . "(".$statement->getNumberOfParameters().", ".$statement->getBeschreibung().")"."</option>\n";
	}
}

function createSQLStatementRows() {
	global $ALL_STATEMENTS;
	foreach($ALL_STATEMENTS as $name => $statement) {
		createSQLStatementRow($name, $statement);
	}
}

function createSQLStatementRow($name, $statement) {
	echo "<tr><form action='execSQLQuery.php'>"   ;
	echo "<td>".$name."</td>";
	echo "<td>"; createParameterList($statement); echo "</td>";
	echo "<td><input type='hidden' name='QUERY_NAME' value='".$name."'/><input type='submit'/></td>";
	echo "<td>".$statement->getBeschreibung() ."</td>";
	echo "<td>".$statement->getSQLStatement() . "</td>";
	echo "</form></tr>\n";
}

function createParameterList($stmt) {
	if($stmt->getNumberOfParameters() < 1) return;
	echo "<table>";
	foreach($stmt->getParameterNames() as $paramName) {
		echo "<tr><td>" . $paramName . "</td><td>" . "<input type='text' name='".$paramName."'/>" ."</td></tr>\n";
	}
	echo "</table>\n"; 
}

?>