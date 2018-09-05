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
		        content = "2018-05-16" /> <!-- Non standard attribute  -->
		<meta   name    = "description"
		        content = "Tests der Datenbank und PHP Funktionen" />
		<meta   name    = "keywords"
		        content = "Santisplanung, Tests" />

		<link   rel     = "stylesheet"
		        href    = "../layout/css/testsuite.css" />
		<link   rel     = "stylesheet"
		        href    = "css/css.css" />
	</head>

	<?php include_once 'sql_statements.php' ?>
	<body>
		<a href='..'>Home</a>
		<h2>Wähle SQL-Statements nach Name</h2>
		<table>
		<tr>
			<th>SQL Stmt ID</th>
			<th>Parameter</th>
			<th>Submit</th>
			<th>Beschreibung</th>
			<th>Explicit Statement</th>
		</tr>
		<?php createSQLStatementRows(); ?>
		</table>
	</body>
</html>
