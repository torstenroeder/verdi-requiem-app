<?php

// initialize session
require_once 'start/ini_session.php';

// database connection settings
require_once 'start/ini_database.php';

// load layout
require_once 'layout/definition.php';

// directories
define('XML_FOLDER','docs/');
define('XSL_FOLDER','transformers/');
define('INDEX_FOLDER','indices/');

?>