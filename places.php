<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');

$layout
	->set('title','Orte')
	->set('content',
		buildElement('div','#tools',
			'Ansicht: '.
			'<span class="icon"><a href="places">Ortsnamen</a></span>'.
			'<span class="icon"><a href="places?order=structure">Hierarchie</a></span>'.
			'<span class="icon"><a href="placesMap">Landkarte</a></span>'
		).
		xmlToHtml(
			INDEX_FOLDER.'placeList.xml',
			XSL_FOLDER.'places.xsl',
			array(
				'order' => $getOrder
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','Als Ansetzungsform gilt durchgehend der deutschsprachige Ortsname, z.B. »Florenz« statt »Firenze«.').
			buildElement('li','Der Index enthält zusätzlich sowohl zeitgenössische und heutige Namen.').
			buildElement('li','Die Zuordnung zu Staaten bildet den politischen Zustand von 1875 ab.')
		)
	)
	->cast();

?>
