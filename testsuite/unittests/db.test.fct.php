<?php
/**
 * @date: 2017-05-19
 * @autor: philipp.gressly@santismail.ch
 */

require_once '../../web/inc/db/dbMeta.fct.php';

/**
 * Is db connection established?
 */
function db_connectionTest() {
	$resultCount    = getMetaResultsetCount("ConnectionTest");
	$result         = getMetaAtomicResult  ("ConnectionTest");
	return (1 == $resultCount) && ("1" == $result);
} // end of function db_connectionTest

?>