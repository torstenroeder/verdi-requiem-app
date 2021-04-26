<?php

require_once 'start/ini.php';
require_once 'lib/filesystem.php';

function emptyDatabase() {
	mysql_query('TRUNCATE `documents`');
	mysql_query('TRUNCATE `indices`');
}

echo '<pre>';
echo 'Die Datenbank wird geleert ...'.PHP_EOL;
emptyDatabase();
echo 'Der Prozess ist abgeschlossen.'.PHP_EOL;
echo '<a href="system">OK</a>'.PHP_EOL;
echo '</pre>';

?>