<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Orte')
	->set('content',
		buildElement('div','#tools',
			'Ansicht: '.
			'<span class="icon"><a href="places">Ortsnamen</a></span>'.
			'<span class="icon"><a href="places?order=structure">Hierarchie</a></span>'.
			'<span class="icon"><a href="placesMap">Landkarte</a></span>'
		).
		buildElement('div','#basicMap','')
	)
	->set('markers','')
	->set('events',
		xmlToHtml(
			INDEX_FOLDER.'placeList.xml',
			XSL_FOLDER.'placesMap.xsl'
		)
	)
	->cast();

?>