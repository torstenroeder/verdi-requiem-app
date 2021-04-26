<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'conceptList/conceptListItem[@nym=\'$getNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='conceptList.xml'
	"))
	->set('content',
		xmlToHtml(
			INDEX_FOLDER.'conceptList.xml',
			XSL_FOLDER.'concept.xsl',
			array(
				'nym' => $getNym
			)
		).
		buildElement('div','#documents',
			buildElement('h2','Dokumente zu diesem Begriff').
			buildUlFromQuery(
				'SELECT
					id,
					ExtractValue(xml,"document/header/title") AS title
					FROM `documents`
					WHERE ExtractValue(xml, "document/body//concept[@nym=\''.$getNym.'\']") <> ""
					ORDER BY pubDate
				',
				'<a href="document?id={id}&highlight='.$getNym.'">{title}</a>'
			)
		)
	)
	->cast();

?>