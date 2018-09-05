<?php
  // SQL Abfragen (Fachklassen)
  // 2013-06-25 phi@wintigo.org

require_once 'db.test.fct.php'                        ; // functions not for production
require_once '../../web/inc/model/modelLayer.fct.php'; // production function

function _testResultRow($testName) {
	echo '<tr><td>' . $testName . '</td>';

	$passed = false;
	     if('connectionEstablished' == $testName) $passed =  db_connectionTest();
	else if('loginTest'             == $testName) $passed =  db_match_user('ge.gl', '123'                  );
	else if('notLoginTest'          == $testName) $passed = !db_match_user('ge.gl','xyz'                   );
	else if('loginTest2'            == $testName) $passed =  db_match_user('ma.mu','123'                   );
	else if('noSuchUser'            == $testName) $passed = !db_match_user('guguuseli_mich_gits_noed','xyz');
	else if('loginTest3'            == $testName) $passed =  db_match_user('admin','123');
	// weitere Tests hier:
	// ...

	if($passed) {
		$text = 'passed'    ;
		$col  = '#0c0'      ;
	} else {
		$text = 'NOT passed';
		$col  = '#c00'      ;
	}

	echo '<td style="background-color: ' . $col . ';">' . $text . '</td>';

	echo "</tr>\n";
} // end function _testResultRow

?>