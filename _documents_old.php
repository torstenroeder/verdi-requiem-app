<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

// order
$getOrder = getUrlParameter('order','pubDate');

// compose title and querystring
switch ($getOrder) {
	case 'pubDate':
		$mask = '<b>{pubDate}</b> {title}'; // en space (x2002)
		$order = 'pubDate, title';
		$group = 'pubYear';
	break;
	case 'title':
		$mask = '{title}';
		$order = 'publisher, pubDate ASC';
		$group = 'publisher';
	break;
	case 'origPerson':
		$mask = '<b>[{origPerson}]</b> {title}';
		$order = 'origPerson = "", origPerson, title, pubDate';
		$group = 'origPerson';
	break;
	case 'origPlace':
		$mask = '<b>[{origPlace}]</b> {title}';
		$order = 'origPlace = "", origPlace, title, pubDate';
		$group = 'origPlace';
	break;
	case 'length':
		$mask = '<b>[{length}]</b> {title}';
		$order = 'length DESC, title, pubDate';
		$group = 'length';
	break;
}

$querystring = "
	SELECT
		id,
		filename,
		title,
		SUBSTRING(title,1,LOCATE(',',title)) AS publisher,
		IF(length > 10000,
			TRUNCATE(length,-4),
			TRUNCATE(length,-3)
		) AS length,
		origDate,
		IF (origPlace <> '', origPlace, 'ohne bezugsort') AS origPlace,
		IF (origPerson <> '', origPerson, 'unbekannt') AS origPerson,
		pubDate,
		YEAR(pubDate) AS pubYear,
		pubPlace
	FROM
		documents
	ORDER BY
		$order
";

$layout
	->set('title','Dokumente')
	->set('content',
		buildElement('div','#tools',
			buildElement('span','icon',
				'Sortierung: '.
				'<a href="documents">Datum</a>'.
				'<a href="documents?order=title">Titel</a>'.
				'<a href="documents?order=origPerson">Autor</a>'.
				'<a href="documents?order=origPlace">Bezugsort</a>'.
				'<a href="documents?order=length">Länge</a>'
			)
		).
		buildElement('div','#status',
			buildElement('span','icon',
				getValueFromQuery('SELECT COUNT(*) FROM documents').
				' Dokumente'
			)
		).
		buildGroupedUlFromQuery(
			'#documents grouped',
			$querystring,
			$group,
			'<a href="document?id={id}">'.$mask.'</a>'
		)
	)
	->cast();

?>