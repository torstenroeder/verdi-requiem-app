<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Bibliographie')
	->set('content',
		xmlToHtml(
			INDEX_FOLDER.'documentList.xml',
			XSL_FOLDER.'biblio.xsl'
		).
		buildElement('h2','Verwendete Abkürzungen').
		buildElement('h3','Personengeschichte').
		buildElement('p','DBEM 2003 = B. Jahn (Hrsg.), Deutsche biographische Enzyklopädie der Musik, München: Saur, 2003.').
		buildElement('p','Ehrlich 1895 = A. Ehrlich (Hrsg.), Berühmte Sängerinnen der Vergangenheit und Gegenwart, Leipzig: Payne, 1895.').
		buildElement('p','Kutsch/Riemens 2000 = K. J. Kutsch / L. Riemens, Großes Sängerlexikon, Berlin: Directmedia, 2000.').
		buildElement('h3','Geographie').
		buildElement('p','Brockhaus 1892').
		buildElement('p','Meyer 1893').
		buildElement('p','Andree 1881 =  Richard Andree’s Allgemeiner Handatlas, Bielefeld und Leipzig: Velhagen & Klasing, 1881.').
		buildElement('p','Volkszählung 1875 = ...')
		
	)
	->cast();

?>