<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$querystring = "
	SELECT
		filename,
		title,
		origDate,
		pubDate
	FROM
		documents
	WHERE
		ExtractValue(xml, 'count(//image)') > 0
	ORDER BY
		pubDate
";

$layout
	->set('title','Abbildungen')
	->set('content',
		buildElement('div','#status',
			buildElement('span','icon',
				getValueFromQuery("SELECT COUNT(*) FROM documents WHERE ExtractValue(xml, 'count(//image)') > 0").
				' Dokumente mit Abbildungen'
			)
		).
		buildUlFromQuery(
			'#documents',
			$querystring,
			'<a href="document?fn={filename}">{title}</a>'
		)
	)
	->cast();

?>