<?php

// generic functions

function buildElement () {
	$args = func_get_args();
	switch (func_num_args()) {
		
		case 2: // 0:name, 1:content
			$html .= '<'.$args[0].'>'.PHP_EOL;
			$html .= $args[1];
			$html .= '</'.$args[0].'>'.PHP_EOL;
			return $html;
		
		case 3: // 0:name, 1:class/id, 2:content
			$html .= '<'.$args[0];
			$html .=
				($args[1][0] == '#'
					? (strpos($args[1], ' ') === false
						? ' id="'.substr($args[1],1).'"'
						: ' id="'.substr($args[1],1,strpos($args[1], ' ')-1).'" class="'.substr($args[1],strpos($args[1], ' ')+1).'"'
					)
					: ' class="'.$args[1].'"'
				).
				'>'.PHP_EOL;
			$html .= $args[2];
			$html .= '</'.$args[0].'>'.PHP_EOL;
			return $html;
		
		default: return false;
	}
}

function buildListFromQuery($listElementName, $querystring, $string) {
	$result = mysql_query($querystring);
	if ($result) {
		$html = NULL;
		while ($row = mysql_fetch_object($result)) {
			// ersetzt jedes {x} durch $row->x
			$listElementContent = preg_replace('/(\{(\w*)\})/e',"\$row->$2",$string);
			$html .= '<'.$listElementName.'>'.$listElementContent.'</'.$listElementName.'>'.PHP_EOL;
		}
		return $html;
	}
	else return 'invalid query';
}

function buildGroupedListFromQuery($listSeparatorName, $listElementName, $querystring, $groupCol, $mask) {
	$result = mysql_query($querystring);
	if ($result) {
		$html = NULL;
		$lastGroup = NULL;
		// start first group
		$html .= '<'.$listSeparatorName.'>'.PHP_EOL;
		while ($row = mysql_fetch_object($result)) {
			// start new group?
			if ($lastGroup != $row->$groupCol && $lastGroup != NULL) {
				// insert separating tags
				$html .= '</'.$listSeparatorName.'>'.PHP_EOL.'<'.$listSeparatorName.'>';
			}
			// ersetzt jedes {x} durch $row->x
			$listElementContent = preg_replace('/(\{(\w*)\})/e',"\$row->$2",$mask);
			$html .= '<'.$listElementName.'>'.$listElementContent.'</'.$listElementName.'>'.PHP_EOL;
			$lastGroup = $row->$groupCol;
		}
		// end last group
		$html .= '</'.$listSeparatorName.'>'.PHP_EOL;
		return $html;
	}
	else return 'invalid query';
}

function getValueFromQuery($querystring) {
	$result = mysql_query($querystring);
	if ($result) {
		// nur erste Zeile, erste Zelle
		$row = mysql_fetch_array($result,MYSQL_NUM);
		return $row[0];
	}
	else return 'invalid query';
}

function getJsonListFromQuery($querystring,$mask) {
	$result = mysql_query($querystring);
	if ($result) {
		$rows = array();
		while ($row = mysql_fetch_object($result)) {
			// ersetzt jedes {x} durch $row->x
			$rows[] = '['.preg_replace('/(\{(\w*)\})/e',"\$row->$2",$mask).']';
		}
		return implode(',',$rows);
	}
	else return 'invalid query';
}

// specific functions

function buildUlFromQuery () {
	$args = func_get_args();
	switch (func_num_args()) {
		
		case 2: // 0:querystring, 1:string
			return buildElement(
				'ul',
				buildListFromQuery(
					'li',
					$args[0],
					$args[1]
				)
			);
		
		case 3: // 0:class/Id, 1:querystring, 2:string
			return buildElement(
				'ul',
				$args[0],
				buildListFromQuery(
					'li',
					$args[1],
					$args[2]
				)
			);
		
		default: return false;
	}
	
}

function buildOlFromQuery () {
	$args = func_get_args();
	switch (func_num_args()) {
		
		case 2: // 0:querystring, 1:string
			return buildElement('ol',
				buildListFromQuery('li',$args[0],$args[1])
			);
		
		case 3: // 0:class/Id, 1:querystring, 2:string
			return buildElement('ol',$args[0],
				buildListFromQuery('li',$args[1],$args[2])
			);
		
		default: return false;
	}
	
}

function buildGroupedUlFromQuery () {
	$args = func_get_args();
	switch (func_num_args()) {
		
		case 3: // 0:querystring, 1:groupCol, 2:mask
			return buildElement('ul',
				buildGroupedListFromQuery('ul','li',$args[0],$args[1],$args[2])
			);
		
		case 4: // 0:class/Id, 1:querystring, 2:groupCol, 3:mask
			return buildElement('ul',$args[0],
				buildGroupedListFromQuery('ul','li',$args[1],$args[2],$args[3])
			);
		
		default: return false;
	}
	
}

?>