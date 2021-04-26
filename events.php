<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');

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
		xmlToHtml (
			INDEX_FOLDER.'eventList.xml',
			XSL_FOLDER.'events.xsl',
			array(
				'order' => $getOrder
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','EA = Erstaufführung.').
			buildElement('li','Mehrere Aufführungen, die in einem organisatorischen Zusammenhang stehen, sind zu einer Produktion gruppiert.').
			buildElement('li','Die Anzahl der Aufführungen in einer Produktion ist dahinter in Klammern gestellt.')
		)
	)
	->cast();

?>