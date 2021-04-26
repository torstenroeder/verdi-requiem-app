<?php

switch ($_SERVER['SERVER_NAME']) {
	case 'verdi-requiem.de': {
		//echo 'Server good!'.PHP_EOL;
		$db_host = '****';
		$db_user = '****';
		$db_pass = '****';
		$db_name = '****';
		break;
	}
	default: {
		echo 'Sorry. The server name is not enlisted in the DBI configuration: '.$_SERVER['SERVER_NAME'];
		die;
	}
}

if (!($db_conn = mysql_connect($db_host,$db_user,$db_pass))) {
	echo 'Sorry. The connection to the database could not be established.';
	die;
} else {
	//echo 'Database good!'.PHP_EOL;
	if (!function_exists('mysql_set_charset')) {
		function mysql_set_charset($charset,$db_conn) {
			return mysql_query("set names $charset",$db_conn);
		}
	}
	mysql_select_db($db_name);
	mysql_set_charset('utf8');
}

?>