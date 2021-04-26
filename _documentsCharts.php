<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getOrder = getUrlParameter('order');

$layout
	->set('title','Dokumente')
	->set('content',
		xmlToHtml (
			INDEX_FOLDER.'documentList.xml',
			XSL_FOLDER.'documentsCharts.xsl',
			array(
				'order' => $getOrder
			)
		)
	)
	->cast();

?>