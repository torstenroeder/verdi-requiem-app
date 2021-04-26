<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html"/>

	<xsl:param name="GET_NYM"/>

	<xsl:variable name="DOCUMENT_LIST" select="document('../indices/documentList.xml')/documentList"/>
	<xsl:variable name="EVENT_LIST" select="document('../indices/eventList.xml')/eventList"/>
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>

	<xsl:include href="templates.xsl"/>

	<xsl:template match="placeList">
		<xsl:apply-templates select="placeListItem[@nym = $GET_NYM]"/>
	</xsl:template>

	<xsl:template match="placeList/placeListItem">
		<div id="tools">
			<span class="icon">
				<a href="places">zum Register</a>
			</span>
		</div>
		<xsl:call-template name="external"/>
		<div id="internal">
			<!-- Hierarchische Einordnung -->
			<p>
				<b>
					<xsl:value-of select="name[@lang = 'de']"/>
				</b>
				<!-- ggf. aktuelle Namensform -->
				<xsl:if test="name[@lang = 'de']/@to">
					<xsl:for-each select="name[@from][1]">
						<xsl:sort select="@from"/>
						<xsl:text>, heute </xsl:text>
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:if>
				<!-- ggf. landestypische Namensform, falls nicht schon genannt -->
				<xsl:if test="not(name[@lang = 'de']/@to)">
					<xsl:for-each select="name[@lang != 'de' and @type = 'index']">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="@lang"/>
						<xsl:text>. </xsl:text>
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:if>
				<xsl:text> (</xsl:text>
				<xsl:if test="place[@role = 'parentContinent']">
					<xsl:for-each
						select="place[@role = 'parentCountry' and (@from &lt; '1870' or not(@from)) and (@to &gt; '1880' or not(@to))]">
						<xsl:sort select="@from"/>
						<xsl:variable name="RELATED_NYM" select="@nym"/>
						<xsl:if test="not(position() = 1)">
							<xsl:text>/</xsl:text>
						</xsl:if>
						<a class="place {@type}" href="place?nym={$RELATED_NYM}">
							<xsl:value-of
								select="/placeList/placeListItem[@nym = $RELATED_NYM]/name[@lang = 'de']"
							/>
						</a>
						<!--<xsl:if test="@from or @to">
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@from"/>
							<xsl:text>–</xsl:text>
							<xsl:value-of select="@to"/>
							<xsl:text>)</xsl:text>
						</xsl:if>-->
					</xsl:for-each>
					<xsl:text>, </xsl:text>
					<xsl:for-each select="place[@role = 'parentContinent']">
						<xsl:variable name="RELATED_NYM" select="@nym"/>
						<xsl:if test="not(position() = 1)">
							<xsl:text> und </xsl:text>
						</xsl:if>
						<a class="place {@type}" href="place?nym={$RELATED_NYM}">
							<xsl:value-of
								select="/placeList/placeListItem[@nym = $RELATED_NYM]/name[@lang = 'de']"
							/>
						</a>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="place[@role = 'parentSettlement']">
					<xsl:for-each select="place[@role = 'parentSettlement']">
						<xsl:variable name="RELATED_NYM" select="@nym"/>
						<xsl:if test="not(position() = 1)">
							<xsl:text> und </xsl:text>
						</xsl:if>
						<a class="place {@type}" href="place?nym={$RELATED_NYM}">
							<xsl:value-of
								select="/placeList/placeListItem[@nym = $RELATED_NYM]/name[@lang = 'de']"
							/>
						</a>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>)</xsl:text>
				<xsl:if test="/placeList/placeListItem/place[@nym = $GET_NYM]">
					<xsl:text> umfasst die Orte </xsl:text>
					<xsl:for-each select="/placeList/placeListItem/place[@nym = $GET_NYM]">
						<xsl:sort select="../@nym"/>
						<xsl:variable name="RELATED_NYM" select="../@nym"/>
						<xsl:if test="not(position() = 1)">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<a class="place {../@type}" href="place?nym={$RELATED_NYM}">
							<xsl:value-of
								select="/placeList/placeListItem[@nym = $RELATED_NYM]/name[@lang = 'de']"
							/>
						</a>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>.</xsl:text>
			</p>
			<!-- Beschreibung -->
			<xsl:if test="description">
				<p>
					<xsl:for-each select="description">
						<xsl:value-of select="."/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@source"/>
						<xsl:text>)</xsl:text>
						<br/>
					</xsl:for-each>
				</p>
			</xsl:if>
			<!-- VARIABLEN -->
			<xsl:variable name="EVENTS_HERE"
				select="$EVENT_LIST/eventListItem[place[@nym = $GET_NYM]]/eventSeries/eventListItem | $EVENT_LIST/eventListItem/eventSeries/eventListItem[place[@nym = $GET_NYM]]"/>
			<xsl:variable name="PUBLICATIONS_HERE"
				select="$DOCUMENT_LIST/documentListItem[pubPlaceNym = $GET_NYM]"/>
			<xsl:variable name="PUBLICATIONS_THERE"
				select="$DOCUMENT_LIST/documentListItem[origPlaceNym = $GET_NYM][pubPlaceNym != $GET_NYM]"/>
			<!-- EVENTS AT THIS PLACE -->
			<xsl:if test="count($EVENTS_HERE) > 0">
				<h2>Aufführungen an diesem Ort <span class="plain">(<xsl:value-of
							select="count($EVENTS_HERE)"/>)</span></h2>
				<ul>
					<xsl:for-each select="$EVENTS_HERE">
						<xsl:sort select="date/@when"/>
						<xsl:variable name="RELATED_NYM" select="place/@nym"/>
						<li>
							<a href="event?nym={@nym}">
								<xsl:call-template name="formattedDate"/>
								<xsl:text>, </xsl:text>
								<xsl:if test="$RELATED_NYM">
									<xsl:value-of
										select="$PLACE_LIST/placeListItem[@nym = $RELATED_NYM]/name"/>
									<xsl:text>, </xsl:text>
								</xsl:if>
								<xsl:value-of select="name"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<!-- PUBLICATIONS AT THIS PLACE -->
			<xsl:if test="count($PUBLICATIONS_HERE) > 0">
				<h2>Publikationen an diesem Ort <span class="plain">(<xsl:value-of
							select="count($PUBLICATIONS_HERE)"/>)</span></h2>
				<ul>
					<xsl:for-each select="$PUBLICATIONS_HERE">
						<xsl:sort select="pubDateIso"/>
						<li>
							<a href="document?fn={@xml:id}">
								<xsl:value-of select="pubDate"/>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="pubPlace"/>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="pubOrg"/>
							</a>
							<xsl:if test="origPlaceNym != pubPlaceNym">
								<xsl:variable name="ORIG_PLACE_HERE" select="origPlaceNym"/>
								<xsl:text> (→</xsl:text>
								<a class="place {../@type}" href="place?nym={$ORIG_PLACE_HERE}">
									<xsl:value-of
										select="$PLACE_LIST/placeListItem[@nym = $ORIG_PLACE_HERE]/name[@lang = 'de']"
									/>
								</a>
								<xsl:text>)</xsl:text>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<!-- PUBLICATIONS ON THIS PLACE -->
			<xsl:if test="count($PUBLICATIONS_THERE) > 0">
				<h2>Publikationen über diesen Ort <span class="plain">(<xsl:value-of
							select="count($PUBLICATIONS_THERE)"/>)</span></h2>
				<ul>
					<xsl:for-each select="$PUBLICATIONS_THERE">
						<xsl:sort select="pubDateIso"/>
						<li>
							<a href="document?fn={@xml:id}">
								<xsl:value-of select="pubDate"/>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="pubPlace"/>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="pubOrg"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<!-- TIMELINE -->
			<xsl:if test="count($PUBLICATIONS_HERE) + count($PUBLICATIONS_THERE) > 4">
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawSeriesChart);
					function drawSeriesChart() {
					var data = google.visualization.arrayToDataTable([
					['Title', 'Date', 'Length', 'Type', 'Length'],
					<!--
< xsl: for - each select = "$EVENTS_HERE[substring(date, 1, 3) = '187']" >[ '<xsl:value-of select="substring(pubPlace,1,2)"/>', new Date('<xsl:value-of select="pubDateIso"/>'), < xsl: value - of select = "length" />, '<xsl:value-of select="type"/ > ', <xsl:value-of select="length"/>], < / xsl: for - each >//-->
					<xsl:for-each select="$PUBLICATIONS_HERE[substring(pubDateIso, 1, 3) = '187']">
						<xsl:variable name="SOURCE">
							<xsl:choose>
								<xsl:when test="origPlace = ''">
									<xsl:value-of select="author"/>
								</xsl:when>
								<xsl:when test="pubPlace != origPlace">
									<xsl:text>↑</xsl:text>
									<xsl:value-of select="substring(origPlace, 1, 2)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(pubPlace, 1, 2)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						['<xsl:value-of select="$SOURCE"/>', new Date('<xsl:value-of select="pubDateIso"/>'), <xsl:value-of select="length"/>, '<xsl:value-of select="type"/>', <xsl:value-of select="length"/>],
					</xsl:for-each>
					<xsl:for-each select="$PUBLICATIONS_THERE[substring(pubDateIso, 1, 3) = '187']">
						<xsl:variable name="SOURCE">
							<xsl:choose>
								<xsl:when test="pubPlace = ''">
									<xsl:value-of select="author"/>
								</xsl:when>
								<xsl:when test="pubPlace != origPlace">
									<xsl:text>↓</xsl:text>
									<xsl:value-of select="substring(pubPlace, 1, 2)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(origPlace, 1, 2)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						['<xsl:value-of select="$SOURCE"/>', new Date('<xsl:value-of select="pubDateIso"/>'), <xsl:value-of select="length"/>, '<xsl:value-of select="type"/>', <xsl:value-of select="length"/>],
					</xsl:for-each>
					]);
					var options = {
					<xsl:call-template name="globalChartOptions"/>
					vAxis: {textPosition:"none", minValue:10, maxValue:50000, ticks:[], logScale:true},
					sizeAxis: { minValue:10, maxValue:50000, logScale:true },
					series: {
					"Werkbesprechung": {color: "#3366CC"},
					"Bericht": {color: "#3355BB"},
					"Kurzbericht": {color: "#3344AA"},
					"Notiz": {color: "#DC3942"},
					"Ankündigung": {color: "#DC3932"},
					"Anzeige": {color: "#DC3922"},
					"Nachmeldung": {color: "#DC3912"},
					"Biografik": {color: "#DD8822"},
					"Privatschrift": {color: "#FF9900"},
					"Satire": {color: "#909809"},
					"Illustration": {color: "#109618"}
					},
					bubble: {textStyle: {fontSize: 11}},
					legend: {position: 'none'}
					};
					var chart = new google.visualization.BubbleChart(document.getElementById('chartDiv'));
					chart.draw(data, options);
					}
				</script>
				<div id="chartDiv"/>
			</xsl:if>
		</div>
		<!-- end #internal -->
	</xsl:template>

</xsl:stylesheet>
