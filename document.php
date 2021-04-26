<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

//$getDocumentId = getUrlParameter('id',0);
$getDocumentFilename = getUrlParameter('fn',0);

$qs = '
	SELECT
		*,
		ExtractValue(xml,"document/header/title") AS title,
		ExtractValue(xml,"document/header/history/publication/date/@when") AS publicationDate
	FROM `documents` WHERE filename = "'.$getDocumentFilename.'"';

if ($results = mysql_query ($qs)) {
	if ($document = mysql_fetch_object($results)) {
		// alles gut
	}
	else {
		// kein Dokument mit dieser ID
		header ('location: documents');
	}
}
else {
	// Fehler in der Abfrage
	header ('location: documents');
}

$layout
	->set('title',$document->title)
	->set('content',
		//schoenerSperrsatz(
			xmlToHtml(
				XML_FOLDER.$document->filename,
				XSL_FOLDER.'document.xsl',
				$_GET + array(
					'filename' => $document->filename,
					'index' => $session->get('index'),
					'variants' => $session->get('variants')
				)
			)
		//)
	)
	->cast();

?>