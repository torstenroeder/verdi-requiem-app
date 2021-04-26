<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Dokumente')
	->set('content',
		buildElement('div','#tools',
			'Ansicht: '.
			'<span class="icon"><a href="documents">Datum</a></span>'.
			'<span class="icon"><a href="documents?order=title">Titel</a></span>'.
			'<span class="icon"><a href="documents?order=type">Typ</a></span>'.
			'<span class="icon"><a href="documentsMap?order=pubPlace">Publikationsort</a></span>'.
			'<span class="icon"><a href="documentsMap?order=origPlace">Bezugsort</a></span>'.
			'<span class="icon"><a href="documents?order=author">Autor</a></span>'.
			'<span class="icon"><a href="documents?order=length">Länge</a></span>'.
			'<span class="icon"><a href="documents?order=diagram">Diagramm</a></span>'
		).
		buildElement('div','#basicMap','')
	)
	->set('markers','')
	->set('events',
		xmlToHtml(
			INDEX_FOLDER.'documentList.xml',
			XSL_FOLDER.'documentsMap.xsl',
			array(
				'order' => getUrlParameter('order')
			)
		)
	)
	->cast();

?>