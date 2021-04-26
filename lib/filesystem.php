<?php

function isServerScriptName ($string) {
	return basename($_SERVER['SCRIPT_NAME']) == $string; 
}

function get_file_names ($path) {
	$names = array();
	$handle = opendir($path);
	
	while (true == ($file = readdir($handle))) {
		if (is_file($path.'/'.$file)) {
			$names[] = $file;
		}
	}
	closedir($handle);
	return $names;
}

function get_folder_names ($path) {
	$names = array();
	$handle = opendir($path);
	
	while (true == ($file = readdir($handle))) {
		if ($file != '.' && $file != '..' && is_dir($path.'/'.$file)) {
			$names[] = $file;
		}
	}
	closedir($handle);
	return $names;
}

?>