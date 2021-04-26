<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');

$documents = getValueFromQuery('
	SELECT COUNT(id) FROM `documents` WHERE
		ExtractValue(xml, "/document/body//place[@nym=\''.$getNym.'\']/@nym") <> ""'
);

$events = getValueFromQuery('
	SELECT COUNT(id) FROM `indices` WHERE filename="eventList.xml" AND
		ExtractValue(xml, "/eventList/eventListItem/place[@nym=\''.$getNym.'\']/eventSeries/eventListItem") <> ""'
);
$imageUrl = 'indices/places/'.str_replace('.','_',$getNym).'.png';

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'placeList/placeListItem[@nym=\'$getNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='placeList.xml'
	"))
	->set('content',
		// Portrait
		(file_exists($imageUrl) ? '<img class="portrait" src="'.$imageUrl.'"/>': NULL).
		// Kurzbeschreibung
		xmlToHtml(
			INDEX_FOLDER.'placeList.xml',
			XSL_FOLDER.'place.xsl',
			array(
				'nym' => $getNym
			)
		).
		// list of documents which refer to this place
		($documents > 0 ?
			buildElement('div','#documents',
				buildElement('h2',
					'Erwähnungen dieses Ortes <span class="plain">('.$documents.')</span>'
					//$documents.' Erwähnung'.($documents > 1 ? 'en' : '').' dieses Ortes'
				).
				buildUlFromQuery(
					'SELECT
						filename,
						ExtractValue(xml,"document/header/title") AS title,
						ExtractValue(xml,"/document/body//place[@nym=\''.$getNym.'\']") AS `fulltext`
						FROM `documents`
						WHERE ExtractValue(xml, "/document/body//place[@nym=\''.$getNym.'\']") <> ""
						ORDER BY pubDate
					',
					'<a href="document?fn={filename}&highlight='.$getNym.'">{title}</a>'
				)
			)
		: '')
		)
	->cast();

?>