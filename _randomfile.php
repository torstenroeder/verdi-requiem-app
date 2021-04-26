<?php
$dir = 'start';
$files = glob($dir . '/*.php');
while (in_array($file = array_rand($files),array('ini.php')));
echo $files[$file];
?>