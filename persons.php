<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');
$getGroup = getUrlParameter('group');

$layout
	->set('title','Personen')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'personList.xml',
			XSL_FOLDER.'persons.xsl',
			array(
				'order' => $getOrder,
				'group' => $getGroup
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','Die Liste beinhaltet auch nicht näher individualisierbare Personen, z.B.: Sänger ohne bekannte Vornamen oder akronyme Autoren.').
			buildElement('li','Adelspersonen sind unter ihrem geläufigen Vornamen gelistet.').
			buildElement('li','Veränderte Namen (z.B. durch Heirat) sind ebenfalls aufgeführt.')
		)
	)
	->cast();

?>