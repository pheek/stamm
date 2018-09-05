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
		        content = "Philipp Gressly Freimann philipp.gressly@santismail.ch" />
		<meta   name    = "date"
		        content = "2018-05-16" /> <!-- Non standard attribute. (ev. remove) -->
		<meta   name    = "description"
		        content = "Tests der Datenbank und PHP Funktionen" />
		<meta   name    = "keywords"
		        content = "Santisplanung, Tests" />

		<link   rel     = "stylesheet"
		        href    = "../layout/css/testsuite.css" />
	</head>

	<?php require_once 'db_test.php'; ?>

	<body>
		<a href="../index.php">Home</a>

		<h2>Unit-Tests</h2>
		<table>
			<tr><th>TestName</th><th>Testresultat</th></tr>
<!-- Connection -->	                                
			<?php _testResultRow('connectionEstablished'); ?>

<!-- Logins -->	                                
			<?php _testResultRow('noSuchUser'           ); ?>
			<?php _testResultRow('loginTest'            ); ?>
			<?php _testResultRow('notLoginTest'         ); ?>
			<?php _testResultRow('loginTest2'           ); ?>
			<?php _testResultRow('loginTest3'           ); ?>
		</table>

	</body>

</html>
