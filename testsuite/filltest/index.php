<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE html>
<!-- Find the template for this website here: https://github.com/pheek/HTMLTemplate  -->

<!-- Insert description of your website here... -->
<html lang="de" xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>testsuite</title>   

		<meta   charset = "utf-8" />
		<!-- change author and date -->
		<meta   name    = "author"
		        content = "Ph.Gressly Freimann phi@gress.ly" />
		<meta   name    = "date"
		        content = "2018-05-16" /> <!-- Non standard attribute. -->
		<meta   name    = "description"
		        content = "Tests der Datenbank und PHP Funktionen" />
		<meta   name    = "keywords"
		        content = "Santisplanung, Tests" />

		<link   rel     = "stylesheet"
		        href    = "../layout/css/testsuite.css" />
	</head>

	<body>
		<a href="../index.php">Home</a>

		<h2>Zeige für alle Tabellen den Füllstand (Anzahl gefüllte Zeilen in der Tabelle)</h2>
		<table>
		<tr><th>Tabelle</th><th>Füllstand (anz. Datensätze)</th></tr>

<?php
	                                
require_once '../../web/inc/db/dbConnect.class.php';
require_once '../../web/inc/db/dbMeta.fct.php';

function colorFromCount($cnt) {
	if($cnt <  1) return  "#F00";
	if($cnt <  5) return  "#F40";
	if($cnt < 10) return  "#F80";
	if($cnt < 15) return  "#FC0";
	if($cnt < 20) return  "#FF0";
	if($cnt < 25) return  "#CF0";
	if($cnt < 30) return  "#8F0";
	if($cnt < 35) return  "#4F0";
	return "#0F0";
}

function printColoredCount($cnt) {
	$breite = $cnt;
	if($cnt >  100) $breite = 100;
	if($cnt >  500) $breite = 150;
	if($cnt > 1000) $breite = 200;
	if($cnt > 2000) $breite = 250;
	echo "<td style='background-color: #ddd;'>";
	echo "<div style='width: ".($breite+20)."px; background-color: ".colorFromCount($cnt).";'>";
	echo $cnt;
	echo "</div>";
	echo "</td>";
}

$allTables = getMetaResultset('getTables');
foreach($allTables as $key => $value) {
	foreach($value as $vKey => $vValue) {
		echo "<tr><td>".$vValue."</td>";
		$pdo  = ConnectionSingleton::getThePDO();
		$sql  = "SELECT count(*) as count FROM " . $vValue . " WHERE 1";
		$stmt = $pdo->prepare($sql);
		$stmt->execute();
		$arr = $stmt->fetch();
		$cnt = $arr["count"];
		printColoredCount($cnt);
		echo "</tr>\n";
	}
}
?>
		</table>

	</body>

</html>
