<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getNym = getUrlParameter('nym');

$documents1 = getValueFromQuery('
	SELECT COUNT(id) FROM `documents` WHERE ExtractValue(xml, "/document/header/history//person[contains(@nym,\''.$getNym.'\')]/@nym") <> ""'
);
$documents2 = getValueFromQuery('
	SELECT COUNT(id) FROM `documents` WHERE ExtractValue(xml, "/document/body//person[contains(@nym,\''.$getNym.'\')]/@nym") <> ""'
);
$imageUrl = 'indices/persons/'.str_replace('.','_',$getNym).'.png';

$layout
	->set('title',getValueFromQuery("
		SELECT ExtractValue(xml,'personList/personListItem[@nym=\'$getNym\']/name[position() = 1]') AS name
		FROM indices WHERE filename='personList.xml'
	"))
	->set('content',
		// Portrait
		(file_exists($imageUrl) ? '<img class="portrait" src="'.$imageUrl.'"/>': NULL).
		// Kurzbeschreibung
		xmlToHtml(
			INDEX_FOLDER.'personList.xml',
			XSL_FOLDER.'person.xsl',
			array(
				'nym' => $getNym
			)
		).
		(($documents2 > 0 || $documents1 > 0)?
			buildElement('div','#documents',
				// Beteiligungen
				($documents1 > 0 ?
					buildElement('h2',
						$documents1.' Beteiligung'.($documents1 > 1 ? 'en' : '')
					).
					buildUlFromQuery(
						'SELECT
							filename,
							ExtractValue(xml,"document/header/title") AS title
							FROM `documents`
							WHERE ExtractValue(xml, "/document/header/history//person[contains(@nym,\''.$getNym.'\')]/@nym") <> ""
							ORDER BY pubDate
						',
						//ExtractValue(xml, "/document/header/history//person[contains(@nym,\''.$getNym.'\')]") AS `fulltext`
						//'<i>{fulltext}</i> <a href="document?id={id}&highlight='.$getNym.'">{title}</a>'
						'<a href="document?fn={filename}&highlight='.$getNym.'">{title}</a>'
					) : ''
				).
				// Erwähnungen
				($documents2 > 0 ?
					buildElement('h2',
						'Erwähnt in '.
						$documents2.' Dokument'.($documents2 > 1 ? 'en' : '')
					).
					buildUlFromQuery(
						'SELECT
							filename,
							ExtractValue(xml,"document/header/title") AS title
							FROM `documents`
							WHERE ExtractValue(xml, "/document/body//person[contains(@nym,\''.$getNym.'\')]/@nym") <> ""
							ORDER BY pubDate
						',
						//ExtractValue(xml, "/document/body//person[contains(@nym,\''.$getNym.'\')]") AS `fulltext`
						//'<i>{fulltext}</i> <a href="document?id={id}&highlight='.$getNym.'">{title}</a>'
						'<a href="document?fn={filename}&highlight='.$getNym.'">{title}</a>'
					) : ''
				)
			) : ''
		)
	)
	->cast();

?>