<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'layout/default.php';

// Get Data

$getDate = getUrlParameter('date');

// 1. fetch biographical information on this person

$xml_file = 'indices/eventList.xml';
$xslt_file = 'stylesheets/event.xsl';
$dataSheet = xmlToHtml ($xml_file,$xslt_file,array('nym' => $getDate));

// 2. select all texts with references to this person
$qs = '
	SELECT id, filename, xml
	FROM `documents`
	WHERE ExtractValue(xml, "/document/body//date[@nym=\''.$getDate.'\']") <> ""
';

if (!($documents = mysql_query($qs))) die (ERROR_BAD_QUERY);

// Compose Content

$body = '';

$body .= $dataSheet;

$body .= '<div class="documents">'.PHP_EOL;
if (mysql_num_rows($documents) > 0) {
	$body .= '<p>Dokumente zu diesem Datum: '.mysql_num_rows($documents).'</p>'.PHP_EOL;
	$body .= '<ol>'.PHP_EOL;
	while ($result = mysql_fetch_object($documents)) {
		$body .= '<li><a href="document?id='.$result->id.'&highlight='.$getDate.'">'.$result->filename.'</a></li>'.PHP_EOL;
	}
	$body .= '</ol>'.PHP_EOL;
}
else {
	$body .= '<p>Keine Dokumente zu dieser Person gefunden.</p>'.PHP_EOL;
}
$body .= '</div>'.PHP_EOL;

// Layout

$layout->set('title','Ereignis');
$layout->set('body',$body);
$layout->cast();

?>