<?php

require_once 'lib/layout.php';

$layout = new Layout ();

$layout->declareString ('title');
$layout->declareString ('content');

switch (basename($_SERVER['SCRIPT_NAME'])) {
	case 'placesMap.php':
	case 'eventsMap.php':
	case 'documentsMap.php':
		$layout->declareString ('events');
		$layout->declareString ('markers');
		$layout->setTemplate ('layout/template.map.php');
	break;
	
	default:
		$layout->setTemplate ('layout/template.default.php');
}

?>