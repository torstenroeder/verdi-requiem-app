<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Dokumente')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'documentList.xml',
			XSL_FOLDER.'documents.xsl',
			array(
				'order' => getUrlParameter('order')
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','Datumsangaben: Für Publikationen gilt das abgedruckte Datum, für Privatschriften das Datum der Absendung. In unklaren Fällen wird hier spätestmögliche Datum angegeben.').
			buildElement('li','$ = Autor individualisiert; * = Bezugsort ist nicht Publikationsort (z.B. bei Korrespondenzen).')
		)
	)
	->cast();

?>