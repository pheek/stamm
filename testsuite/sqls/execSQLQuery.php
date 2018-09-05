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
		        content = "Philipp Gressly Freimann phi@gress.ly" />
		<meta   name    = "date"
		        content = "2018-06-14" /> <!-- Non standard attribute  -->
		<meta   name    = "description"
		        content = "Tests der Datenbank und PHP Funktionen" />
		<meta   name    = "keywords"
		        content = "Santisplanung, Tests" />

		<link   rel     = "stylesheet"
		        href    = "../layout/css/testsuite.css" />
		<link   rel     = "stylesheet"
		        href    = "css/css.css" />
	</head>

	<body>
		<a href='..'>Home</a>
		<h2>SQL Query</h2>

		<p><a href='index.php'>Execute another Query</a></p>

<?php
require_once "../../web/inc/db/dbMeta.fct.php";

$qName = $_REQUEST['QUERY_NAME'];
$params=array();
// every HTTP-Parameter is an argument for the
// SQL query. Exception: 'QUERY_NAME', which
// represents the ID of the SQL-Query itselfs.
foreach($_REQUEST as $key => $value) {
	if('QUERY_NAME' != $key) {
		$params[$key] = $value;
	}
}

$result = getMetaResultset($qName, $params);
$fetched = $result->fetchall();
$firstrow = true;
echo "			<table>\n";
foreach($fetched as $key => $value) {
	echo "				<tr>";
	if($firstrow) {
		$firstrow = false;
		foreach($value as $vKey => $vValue) {
			echo "<th>" . $vKey .  "</th>";
		}
		echo "</tr>\n				<tr>";
	}
	foreach($value as $vKey => $vValue) {
		echo "<td>";
		echo $vValue;
		echo "</td>";
	}
	echo   "</tr>\n";
} // end foreach fetched row.
echo "			</table>\n";
?>

		<p><a href='index.php'>Execute another Query</a></p>

	</body>
</html>
