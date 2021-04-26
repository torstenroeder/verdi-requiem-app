<?php 

// a small class for session operations within a specific session namespace

class phpSession {

	var $namespace;
	
	public function __construct ( $namespace, $defaults = array() ) {
		$this->namespace = $namespace;
		if (!isset($_SESSION[$namespace])) {
			$_SESSION[$namespace] = $defaults;
		}
	}
	
	public function ini ($varName,$default = NULL) {
		$_SESSION[$this->namespace][$varName]
			= isset($_SESSION[$this->namespace][$varName])
				? $_SESSION[$this->namespace][$varName]
				: $default;
	}
	
	public function set ($varName,$value = NULL) {
		$_SESSION[$this->namespace][$varName] = $value;
	}
	
	public function get ($varName) {
		return $_SESSION[$this->namespace][$varName];
	}
	
	public function destroy () {
		unset ($_SESSION[$this->namespace]);
	}

}

?>