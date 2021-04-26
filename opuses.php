<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');

$layout
	->set('title','Werke')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'opusList.xml',
			XSL_FOLDER.'opuses.xsl',
			array(
				'order' => $getOrder
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','Es sind ausschließlich Werke der Musik erfasst.').
			buildElement('li','Neben konkreten Werken sind auch Werkgruppen (z.B. »Symphonien von X«) und nicht-individualisierte Werke (z.B. »ein Quartett«) erfasst.').
			buildElement('li','Den Werken sind z.T. auch Szenen und Figuren zugeordnet.')
		)
	)
	->cast();

?>