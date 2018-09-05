<?php
/**
 * date: 2017-05-19
 * autor: philipp.gressly@santismail.ch
 */


/**
 * Is user matching password?
 * Pepper is added here, so the password is not "peppered".
 * Returns true, if username and password match
 * a username and the hashed password in the database.
 */
function db_match_user($username, $password) {
	global $_CREDENTIALS_PEPPER_;
	$result = getMetaAtomicResult("LoginSP",
		['loginName'   => "$username",
		 'rawPassword' => "$password",
		 'pepper'      => "$_CREDENTIALS_PEPPER_"]);
//	echo "modelLayer.fct.php::db_match_user(username:" . $username . ", rawPassword:" .  $password . ", pepper:". $_CREDENTIALS_PEPPER_ .", result :" . $result . ") <br/>\n";
	return -1 < $result;
} // end of function db_match_user


?>