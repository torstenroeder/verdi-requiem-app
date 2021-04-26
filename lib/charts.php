<?php

function buildGoogleTreemap ($elementId,$data,$properties) {
	return '
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    	<script type="text/javascript">
      		google.load("visualization", "1", {packages:["treemap"]});
      		google.setOnLoadCallback(drawChart);
		function drawChart() {
			var data = google.visualization.arrayToDataTable([
			'.$data.'
        ]);

        tree = new google.visualization.TreeMap(document.getElementById("'.$elementId.'"));

        tree.draw(data, {
			'.$properties.'
        });

      }
    </script>
    ';
}

?> 