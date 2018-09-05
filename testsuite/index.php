<!DOCTYPE html>
<!-- Find the template for this website here: https://github.com/pheek/HTMLTemplate  -->

<!-- Insert description of your website here... -->
<html lang="de" xmlns="http://www.w3.org/1999/xhtml">

	<head>
	<title>testsuite</title>

	<meta   charset = "utf-8" />
	<!-- change author and date -->
	<meta   name    = "author"
	        content = "Philipp Gressly Freimann philipp.gressly@santismail.ch" />
	<meta   name    = "date"
	        content = "2018-05-16" /> <!-- Non standard attribute. (ev. remove) -->
	<meta   name    = "description"
	        content = "Tests der Datenbank und PHP Funktionen" />
	<meta   name    = "keywords"
	        content = "Santisplanung, Tests" />

	<link   rel     = "stylesheet"
	        href    = "layout/css/testsuite.css" />
	</head>

	<body>
		<h1>Testsuite</h1>

		<table>
      <tr><th>Test</th><th>Beschreibung</th></tr>	                                
			<tr><td><a href='unittests/index.php'>Unit Tests</a>          </td><td>Vorgegebene Unit-Tests. Diese liefern "grün=OK" oder "rot=fail".           </td></tr>
	    <tr><td><a href='analyse/index.php'  >Table Analysis</a>      </td><td>Zeige die Abhängigkeiten der Tabellen durch ihre Fremdschlüsselbeziehungen.</td></tr>
			<tr><td><a href='sqls/index.php'     >Given SQL Statements</a></td><td>Alle vorgesehenen SQL Statements können hier einfach geprüft werden.       </td></tr>
			<tr><td><a href='filltest/index.php'>Füllstand</a>           </td><td>Zeige den aktuellen Füllstand der Tabellen. Je mehr Daten, umso besser.</td></tr>
		</table>
	</body>

</html>
