<?php

require_once 'start/ini.php';
require_once 'lib/filesystem.php';

function scanFolder($path,$table) {
	
	$file_extension = 'xml';
	
	$files = get_file_names ($path);
	$folders = get_folder_names ($path);
	
	foreach ($files as $filename) {
		$content = file_get_contents($path.'/'.$filename);
		$content = addslashes($content);
		$content_txt = preg_replace('#<[^>]*>#','',$content);
		// check whether file was already inserted
		$qs = 'SELECT id, filename FROM '.$table.' WHERE filename = "'.$filename.'"';
		$q = mysql_query ($qs);
		if ($document = mysql_fetch_object($q)) {
			// if so, overwrite existing entry
			$qs = 'UPDATE '.$table.' SET xml="'.$content.'", txt="'.$content_txt.'" WHERE id = '.$document->id;
			if ($q = mysql_query($qs)) {
				//echo $filename.' erfolgreich aktualisiert.'.PHP_EOL;
			}
			else {
				echo $filename.' konnte nicht aktualisiert werden.'.PHP_EOL;
			}
		}
		else {
			// if not, create new entry
			$qs = 'INSERT INTO '.$table.' (filename,xml,txt) VALUES ("'.$filename.'","'.$content.'","'.$content_txt.'")';
			if ($q = mysql_query($qs)) {
				//echo $filename.' erfolgreich eingefügt.'.PHP_EOL;
			}
			else {
				echo $filename.' konnte nicht eingefügt werden.'.PHP_EOL;
			}
		}
	}
}

function updateMetadata() {
	mysql_query('
		UPDATE
			documents
		SET
			title = ExtractValue(xml, "/document/header/title"),
			length = LENGTH(xml),
			origDate = IF (
				ExtractValue(xml, "//history/origin/date[1]/@when"),
				ExtractValue(xml, "//history/origin/date[1]/@when"),
				ExtractValue(xml, "//history/publication[1]/date[1]/@when")
			),
			origPlace = ExtractValue(xml, "//history/origin/place[1]/@nym"),
			origPerson = ExtractValue(xml, "//history/origin/person[1]/@nym"),
			pubDate = IF (
				ExtractValue(xml, "//history/publication[1]/date[1]/@when"),
				ExtractValue(xml, "//history/publication[1]/date[1]/@when"),
				ExtractValue(xml, "//history/origin[1]/date[1]/@when")
			),
			pubPlace = IF (
				ExtractValue(xml, "//history/publication[1]/place[1]/@when"),
				ExtractValue(xml, "//history/publication[1]/place[1]/@nym"),
				ExtractValue(xml, "//history/origin[1]/place[1]/@nym")
			)
	');
}

echo '<pre>';
echo 'Der Aktualisierungsprozess startet ...'.PHP_EOL;
scanFolder(INDEX_FOLDER,'indices');
scanFolder(XML_FOLDER,'documents');
updateMetadata();
echo 'Der Prozess ist abgeschlossen.'.PHP_EOL;
echo '<a href="system">OK</a>'.PHP_EOL;
echo '</pre>';

?>