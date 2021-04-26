<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');

$documents = getValueFromQuery('
	SELECT COUNT(id) FROM `documents` WHERE ExtractValue(xml, "/document/body//opus[@nym=\''.$getNym.'\']/@nym") <> ""'
);

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'opusList//opusListItem[@nym=\'$getNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='opusList.xml'
	"))
	->set('content',
		xmlToHtml(
			INDEX_FOLDER.'opusList.xml',
			XSL_FOLDER.'opus.xsl',
			array(
				'nym' => $getNym
			)
		).
		($documents > 0 ?
			buildElement('div','#documents',
				buildElement('h2',
					'Erwähnt in '.
					getValueFromQuery('
						SELECT
							IF (COUNT(id) > 1, COUNT(id), IF (COUNT(id) = 1, "einem", "keinem")) AS total
						FROM `documents` WHERE ExtractValue(xml, "/document/body//opus[@nym=\''.$getNym.'\']") <> ""'
					).
					' Dokument'.($documents > 1 ? 'en' : '')
				).
				buildUlFromQuery(
					'SELECT
						filename,
						ExtractValue(xml,"document/header/title") AS title
						FROM `documents`
						WHERE ExtractValue(xml, "/document/body//opus[@nym=\''.$getNym.'\']") <> ""
						ORDER BY pubDate
					',
					'<a href="document?fn={filename}&highlight='.$getNym.'">{title}</a>'
				)
			)
		: '')
	)
	->cast();

?>