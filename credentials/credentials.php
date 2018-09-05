<?php
// autor: phi@gress.ly
// datum: 2018-05
//
// Diese Credentials werden zwar auch in Github eingecheckt. Dennoch:
//  A) Die Credentials dürfen nicht im /var/www-Verzeichnis liegen
//  B) Die Credentials enthalten nur ein Dummy-Passwort und ein Dummy-Pepper

$_CREDENTIALS_HOST_   = 'localhost';
$_CREDENTIALS_DB_     = 'Stamm'    ;
$_CREDENTIALS_PASS_   = '123'      ;
$_CREDENTIALS_USER_   = 'stammPHP' ;

// Add before users password (e.g. see demodata.sql -> Login).
$_CREDENTIALS_PEPPER_ = '1234567890'   ;
?>