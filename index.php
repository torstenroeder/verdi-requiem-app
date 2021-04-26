<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','verdi-requiem.de')
	->set('content',
		buildElement('h2','Willkommen!').
		buildElement('p','Diese Website präsentiert Quellen zu Giuseppe Verdis „Messa da Requiem“ im deutschsprachigen Raum 1874–1878.').
		buildElement('p','Die Erschließung der Texte ist in Arbeit und der Zugang derzeit noch beschränkt.').
		buildElement('p','Der Einstieg kann über die Volltextsuche oder über eines der Register erfolgen.')
	)
	->cast();

?>