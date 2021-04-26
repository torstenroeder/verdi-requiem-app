<?php

require_once 'start/ini.php';
require_once 'lib/url.php';

if (
	(isset($_SERVER['HTTP_REFERER']))
	&& (
		stripos($_SERVER['HTTP_REFERER'],'http://'.$_SERVER['SERVER_NAME']) === 0
		|| 
		stripos($_SERVER['HTTP_REFERER'],'http://www.'.$_SERVER['SERVER_NAME']) === 0
		)
	) {
	$redirect_url = $_SERVER['HTTP_REFERER'];
}
else {
	$redirect_url = 'index.php';
}

if (isUrlParameter('indexOff')) {
	$session->set('index',false);
}
if (isUrlParameter('indexOn')) {
	$session->set('index',true);
}
if (isUrlParameter('variantsOff')) {
	$session->set('variants',false);
}
if (isUrlParameter('variantsOn')) {
	$session->set('variants',true);
}
if (isUrlParameter('destroy')) {
	$session->destroy();
}

header('Location: '.$redirect_url);

?>