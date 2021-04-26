<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$getTerm = getUrlParameter('term');

$querystring = "
	SELECT
		filename,
		ExtractValue(xml,'document/header/title') AS title,
		ExtractValue(xml,'document/header/history/publication/date/@when') AS publicationDate
	FROM
		documents
	WHERE
		MATCH (txt) AGAINST ('$getTerm' IN BOOLEAN MODE)
";

$layout
	->set('title','Suche nach "'.$getTerm.'"')
	->set('content',(
		strlen($getTerm) > 2 ?
			buildElement('h2','Dokumente').
			buildUlFromQuery(
				'#documents',
				$querystring,
				'<a href="document?fn={filename}&highlight='.$getTerm.'">{title}</a>'
			) :
			buildElement('p','Bitte geben Sie mindestens drei Buchstaben ein.')
		)
	)
	->cast();

?>