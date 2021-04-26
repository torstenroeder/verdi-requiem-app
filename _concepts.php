<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');

$layout
	->set('title','Begriffe')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'conceptList.xml',
			XSL_FOLDER.'concepts.xsl',
			array(
				'order' => $getOrder
			)
		)
	)
	->cast();

?>