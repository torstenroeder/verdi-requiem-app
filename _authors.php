<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');
$getGroup = getUrlParameter('group');

$layout
	->set('title','Autoren')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'personList.xml',
			XSL_FOLDER.'authors.xsl',
			array(
				'order' => $getOrder,
				'group' => $getGroup
			)
		)
	)
	->cast();

?>