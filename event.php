<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');
$truncNym = (
	substr_count($getNym,'.') > 1
	? substr($getNym,0,strrpos($getNym,'.'))
	: $getNym
);
$documents = getValueFromQuery("
	SELECT COUNT(id) FROM `documents` WHERE ExtractValue(xml, '/document/body//event/@nym') LIKE '%$truncNym%'
");

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'eventList/eventListItem[@nym=\'$truncNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='eventList.xml'
	"))
	->set('content',
		xmlToHtml(
			INDEX_FOLDER.'eventList.xml',
			XSL_FOLDER.'event.xsl',
			array(
				'nym' => $truncNym
			)
		).
		($documents > 0 ?
			buildElement('div','#documents',
				buildElement('h2',
					getValueFromQuery("
						SELECT
							IF (COUNT(id) > 0, COUNT(id), 'keine') AS total
						FROM `documents`
						WHERE ExtractValue(xml, '/document/body//event/@nym') LIKE '%$truncNym%'
					").
					' Dokument'.($documents > 1 ? 'e' : '').' zu diesem Ereignis'
				).
				buildUlFromQuery("
					SELECT
						filename,
						ExtractValue(xml,'document/header/title') AS title
						FROM `documents`
						WHERE ExtractValue(xml, '/document/body//event/@nym') LIKE '%$truncNym%'
						ORDER BY pubDate
					",
					'<a href="document?fn={filename}&highlight='.$truncNym.'">{title}</a>'
				)
			)
		: '')
	)
	->cast();

?>