<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';
require_once 'lib/charts.php';

$layout
	->set('title','Treemap der Dokumente')
	->set('content',
		buildElement('div','#tools',
			'<span class="icon"><a href="places">A-Z</a></span>'.
			'<span class="icon"><a href="placesMap">Karte</a></span>'
		).
		buildGoogleTreemap('treemap',
		"
			['Title', 'Parent', 'Value A', 'Value B'],
			['Global',null,0,0],".
			getJsonListFromQuery(
				'SELECT id, title, length FROM documents',
				'{v:{id},f:"{title}"}, "Global", {length},0'
			)
		,"
			minColor: '#f00',
			midColor: '#ddd',
			maxColor: '#0d0',
			headerHeight: 15,
			fontColor: 'black'
		").
		buildElement('div','#treemap','')
	)
	->cast();

?>
