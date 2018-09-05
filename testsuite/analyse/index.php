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
		        content = "2018-05-16" /> <!-- Non standard attribute. (ev. remove) -->
		<meta   name    = "description"
		        content = "Tests der Datenbank und PHP Funktionen" />
		<meta   name    = "keywords"
		        content = "Stammbaum, Tests" />

		<link   rel     = "stylesheet"
		        href    = "../layout/css/testsuite.css" />
		<link   rel     = "stylesheet"
		        href    = "css/css.css" />
	</head>

	<?php require_once 'build.php'; ?>
	<body>
		<a href="../index.php">Home</a>
		<h2>DB Analyse</h2>
		<p>Es hat total <?php echo getNumberOfTables(); ?>
		Tabellen in der Datenbank.</p>

		<h2>Tabellen nach Level</h2>
		<?php  sortiertAusgeben(); ?>
	</body> 
</html>
