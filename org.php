<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');

$documents = getValueFromQuery('
	SELECT COUNT(id) FROM `documents` WHERE ExtractValue(xml, "/document//org[contains(@nym,\''.$getNym.'\')]/@nym") <> ""'
);

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'orgList/orgListItem[@nym=\'$getNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='orgList.xml'
	"))
	->set('content',
		xmlToHtml(
			INDEX_FOLDER.'orgList.xml',
			XSL_FOLDER.'org.xsl',
			array(
				'nym' => $getNym
			)
		).
		($documents > 0 ?
			buildElement('div','#documents',
				buildElement('h2',
					$documents.' Dokument'.($documents > 1 ? 'e' : '').' zu dieser Körperschaft'
				).
				buildUlFromQuery(
					'SELECT
						filename,
						ExtractValue(xml,"document/header/title") AS title
						FROM `documents`
						WHERE ExtractValue(xml, "/document//org[contains(@nym,\''.$getNym.'\')]/@nym") <> ""
						ORDER BY pubDate
					',
					'<a href="document?fn={filename}&highlight='.$getNym.'">{title}</a>'
				)
			)
		: '')
	)
	->cast();

?>