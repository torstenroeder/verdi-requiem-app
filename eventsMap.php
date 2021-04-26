<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Ereignisse')
	->set('content',
		buildElement('div','#tools',
			'Ansicht: '.
			'<span class="icon"><a href="events">Zeitleiste</a></span>'.
			'<span class="icon"><a href="events?order=table">Kalender</a></span>'.
			'<span class="icon"><a href="events?order=place">Ortsliste</a></span>'.
			'<span class="icon"><a href="eventsMap">Landkarte</a></span>'
		).
		buildElement('div','#basicMap','')
	)
	->set('markers','')
	->set('events',
		xmlToHtml(
			INDEX_FOLDER.'eventList.xml',
			XSL_FOLDER.'eventsMap.xsl'
		)
	)
	->cast();

?>