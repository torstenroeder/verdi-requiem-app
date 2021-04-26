<!DOCTYPE html>
<html>
	<head>
		<title><?php $this->cast('title') ?></title>
		<?php require_once 'template.meta.php' ?>
		<link rel="stylesheet" type="text/css" href="layout/stylesheets/basic.css">
		<link rel="stylesheet" type="text/css" href="layout/stylesheets/document.css">
		<link rel="stylesheet" type="text/css" href="layout/stylesheets/icons.css">
		<!--<link rel="icon" href="images/favicon.png" type="image/png">-->
		<script src="OpenLayers-2.13.1/OpenLayers.js"></script>
		<script type="text/javascript">
		
		function initMap() {
			
			var lon = 10.80; // geographische Länge  = O/W-Richtung
			var lat = 48.40; // geographische Breite = N/S-Richtung
			var zoom = 5;
			
			var fromProjection = new OpenLayers.Projection('EPSG:4326'); // transform from WGS 1984
			var toProjection = new OpenLayers.Projection('EPSG:900913'); // to Spherical Mercator Projection
			var position = new OpenLayers.LonLat(lon,lat).transform(fromProjection,toProjection);
			
			var map = new OpenLayers.Map({
				div: 'basicMap',
				numZoomLevels: 2,
				allOverlays: true
			});
			map.addControls([
				new OpenLayers.Control.LayerSwitcher(),
				new OpenLayers.Control.ScaleLine()
			]);
			
			// ICONS
			
			var iconEvent = new OpenLayers.Icon('images/icons/star-small.png');
			var iconLove = new OpenLayers.Icon('images/icons/heart.png');
			
			// LAYER VARIABLES
			
			var mapnikLayer = new OpenLayers.Layer.OSM();
			
			var satLayer = new OpenLayers.Layer.OSM(
				'Satellite Map',
				["http://otile1.mqcdn.com/tiles/1.0.0/sat/${z}/${x}/${y}.jpg",
				"http://otile2.mqcdn.com/tiles/1.0.0/sat/${z}/${x}/${y}.jpg",
				"http://otile3.mqcdn.com/tiles/1.0.0/sat/${z}/${x}/${y}.jpg",
				"http://otile4.mqcdn.com/tiles/1.0.0/sat/${z}/${x}/${y}.jpg"],
				{
					tileOptions: { 'crossOriginKeyword': null }
				}
			);
			
			var watercolorLayer = new OpenLayers.Layer.OSM(
				'Watercolor Map',
				'http://c.tile.stamen.com/watercolor/${z}/${x}/${y}.jpg',
				{
					tileOptions: { 'crossOriginKeyword': null }
				}
			);
			
			var histLayer1 = new OpenLayers.Layer.OSM(
				'Religions 1881',
				'http://mapwarper.net/mosaics/tile/493/${z}/${x}/${y}.png',
				{
					layers: 'basic',
					transparent: true,
					opacity: 0.8,
					transitionEffect: 'resize',
					tileOptions: { 'crossOriginKeyword': null }
				}
			);
			
			var histLayer2 = new OpenLayers.Layer.OSM(
				'Europe 1875',
				'http://mapwarper.net/mosaics/tile/133/${z}/${x}/${y}.png',
				{
					layers: 'basic',
					transparent: true,
					opacity: 0.8,
					transitionEffect: 'resize',
					tileOptions: { 'crossOriginKeyword': null }
				}
			);

			// Vector Layer
			
			var vectorLayer = new OpenLayers.Layer.Vector('Events',{
				styleMap: new OpenLayers.StyleMap({
					'default':{
						strokeColor: '#333333',
						strokeOpacity: 1,
						strokeWidth: 2,
						fillColor: '${pointColor}',
						fillOpacity: 0.8,
						pointRadius: '${pointRadius}',
						//pointerEvents: 'visiblePainted',
						label: '${pointLabel}',
						fontColor: 'white',
						fontSize: '12px',
						fontFamily: '"Lucida Console", Monaco, monospace',
						fontWeight: 'normal',
						labelAlign: 'ct',
						labelXOffset: 0,
						labelYOffset: -5,
						labelOutlineColor: 'black',
						labelOutlineWidth: 2
					}
				}),
				eventListeners:{
					'featureselected':function(evt){
						var feature = evt.feature;
						var popup = new OpenLayers.Popup.FramedCloud("popup",
							OpenLayers.LonLat.fromString(feature.geometry.toShortString()),
							null,
							'<div class="popup"><a href="'+feature.attributes.pointLink+'.php?nym='+feature.attributes.pointNym+'">'+feature.attributes.pointName+'</a></div>',
							null,
							false
						);
						feature.popup = popup;
						map.addPopup(popup);
					},
					'featureunselected':function(evt){
						var feature = evt.feature;
						map.removePopup(feature.popup);
						feature.popup.destroy();
						feature.popup = null;
					}
				}
			});
			
			// create the select feature control
			var selector = new OpenLayers.Control.SelectFeature(vectorLayer,{
				autoActivate:true
			});
			
			<?php $this->cast('events') ?>
			
			// Marker Layer
			
			var markerStyle = new OpenLayers.StyleMap({
				'default': {
					label: "${id}",
					fontSize: "12px",
					fontFamily: "Courier New, monospace",
					fontWeight: "bold"
				}
			});
			
			var markerLayer = new OpenLayers.Layer.Markers("Markers", {styleMap: markerStyle} );
			
			<?php $this->cast('markers') ?>
			
			// AVAILABLE LAYERS
			
			//map.addLayer(satLayer);
			map.addLayer(mapnikLayer);
			//map.addLayer(watercolorLayer);
			map.addLayer(histLayer1);
			map.addLayer(histLayer2);
			map.addLayer(markerLayer);
			map.addLayer(vectorLayer);
			
			map.addControl(selector);
			map.setCenter(position, zoom);
		}
		
		</script>
	</head>
	<body onload="initMap()">
		<?php require_once 'template.body.php' ?>
	</body>
</html>
