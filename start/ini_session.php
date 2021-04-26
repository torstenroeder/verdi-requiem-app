<?php

// required by start/ini.php

// configure session
ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 1);
ini_set('session.gc_maxlifetime', 1800); // Session-Dauer in Sekunden
session_start();

require_once 'lib/session.php';

// create session interface
$session = new phpSession('verdi-requiem');
$session->ini('variants',true);
$session->ini('index',true);

?>