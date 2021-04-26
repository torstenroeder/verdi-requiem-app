<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','System')
	->set('content',
		buildElement('h2','Operationen').
		buildElement('ul',
			buildElement('li','<a href="scan">Neue hochgeladene Texte einlesen oder aktualisieren</a>').
			buildElement('li','<a href="empty">Datenbank leeren (danach müssen alle Texte erneut eingelesen werden)</a>')
		)
	)
	->cast();

?>