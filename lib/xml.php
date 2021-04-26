<?php

function xmlToHtml ($xml_file,$xslt_file,$parameters) {
	$xml_content = NULL;
	//$html_doctype = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" />';
	if (file_exists($xml_file)) {
		$xml = new DomDocument();
		$xml->load($xml_file);
		if(!$xml) {
			die ("xml document error");
		}
		$xslt = new DomDocument();
		$xslt->load($xslt_file);
		if(!$xslt) {
			die ("xslt document error");
		}
		$xsltproc = new XsltProcessor();
		if(!$xsltproc) {
			die ("xslt processor error");
		}
		$xsltproc->importStylesheet($xslt);
		if (!empty($parameters)) {
			//print_r($parameters);
			foreach ($parameters as $param_name => $param_value) {
				$xsltproc->setParameter('','GET_'.strtoupper($param_name),$param_value);
			}
		}
		$xml_content = $xsltproc->transformToXml($xml);
	} else {
		exit ("file not found error: ".$xml_file);
	}
	return $html_doctype.$xml_content;
}

?>