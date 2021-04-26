<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');
$getGroup = getUrlParameter('group');

$layout
	->set('title','Körperschaften')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'orgList.xml',
			XSL_FOLDER.'orgs.xsl',
			array(
				'order' => $getOrder,
				'group' => $getGroup
			)
		).
		buildElement('h3','Anmerkungen').
		buildElement('ul',
			buildElement('li','Als Körperschaften gelten sowohl Periodika als auch musikalische Vereinigungen.').
			buildElement('li','Geht der Sitz nicht aus dem Namen hervor, wird dieser in eckigen Klammern hintenan gestellt.')
		)
	)
	->cast();

?>