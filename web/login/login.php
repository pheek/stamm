<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE html>
<!-- Find the template for this website here: https://github.com/pheek/HTMLTemplate  -->

<!-- Insert description of your website here... -->
<html lang="de" xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>SANTIS Planung</title>   

		<meta   charset = "utf-8" />
		<!-- change author and date -->
		<meta   name    = "author"
		        content = "Philipp Gressly Freimann philipp.gressly@santismail.ch" />
		<meta   name    = "date"
		        content = "2018-05-21" /> <!-- Non standard attribute. (ev. remove) -->
		<meta   name    = "description"
		        content = "SANIS Planungswerkzeug: loginseite" />
		<meta   name    = "keywords"
		        content = "Login zur Raumplanung, Kursplanung, Anwesenheitslisten, ..." />

		<link   rel     = "stylesheet"
		        href    = "layout/css/main.css" />
	</head>

	<body>
		<h1>Login</h1>
		<form action='logincheck.php'>
			<table>
				<tr><td>Username</td><td><input type='text' /><td></tr> 
				<tr><td>Passwort</td><td><input type='text' /><td></tr> 
				<tr><td></td><td><input type='submit' /><td></tr> 
			</table>
		</form>
	</body>
</html>
