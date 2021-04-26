<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html"/>

	<xsl:param name="GET_ORDER"/>

	<xsl:include href="templates.xsl"/>

	<xsl:key match="documentListItem/title" name="groupByTitleKey" use="substring-before(., ',')"/>
	<xsl:key match="documentListItem/pubDateIso" name="groupByDateKey" use="substring(., 1, 7)"/>
	<xsl:key match="documentListItem/type" name="groupByTypeKey" use="."/>
	<xsl:key match="documentListItem/pubPlaceNym" name="groupByPubPlaceKey" use="."/>
	<xsl:key match="documentListItem/origPlaceNym" name="groupByOrigPlaceKey" use="."/>
	<xsl:key match="documentListItem/authorNym[. != '']" name="groupByAuthorKey" use="."/>
	<xsl:key match="documentListItem/lengthGroup" name="groupByLengthKey" use="."/>

	<xsl:template match="documentList">
		<div id="status">
			<xsl:value-of select="count(documentListItem)"/> Dokumente </div>
		<div id="tools">
			<xsl:text>Ansicht:</xsl:text>
			<span class="icon">
				<a href="documents">Datum</a>
			</span>
			<span class="icon">
				<a href="documents?order=title">Titel</a>
			</span>
			<span class="icon">
				<a href="documents?order=type">Typ</a>
			</span>
			<span class="icon">
				<a href="documentsMap?order=pubPlace">Publikationsort</a>
			</span>
			<span class="icon">
				<a href="documentsMap?order=origPlace">Bezugsort</a>
			</span>
			<span class="icon">
				<a href="documents?order=author">Autor</a>
			</span>
			<span class="icon">
				<a href="documents?order=length">Länge</a>
			</span>
			<span class="icon">
				<a href="documents?order=diagram">Diagramm</a>
			</span>
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'title'">
				<ul class="grouped">
					<xsl:for-each
						select="documentListItem/title[count(. | key('groupByTitleKey', substring-before(., ','))[1]) = 1]">
						<xsl:sort lang="de" select="substring-before(., ',')"/>
						<ul>
							<xsl:for-each select="key('groupByTitleKey', substring-before(., ','))">
								<xsl:sort lang="de" select="../pubDateIso"/>
								<li>
									<a href="document?fn={../@xml:id}">
										<xsl:value-of select="."/>
									</a>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'type'">
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var data = google.visualization.arrayToDataTable([
							['Typ', 'Anzahl'],
							<xsl:for-each select="documentListItem/type[count(. | key('groupByTypeKey', .)[1]) = 1]">
								<xsl:sort order="descending" select=". = 'Werkbesprechung'"/>
								<xsl:sort order="descending" select=". = 'Bericht'"/>
								<xsl:sort order="descending" select=". = 'Kurzbericht'"/>
								<xsl:sort order="descending" select=". = 'Notiz'"/>
								<xsl:sort order="descending" select=". = 'Ankündigung'"/>
								<xsl:sort order="descending" select=". = 'Anzeige'"/>
								<xsl:sort order="descending" select=". = 'Nachmeldung'"/>
								<xsl:sort order="descending" select=". = 'Biografik'"/>
								<xsl:sort order="descending" select=". = 'Privatschrift'"/>
								<xsl:sort order="descending" select=". = 'Satire'"/>
								<xsl:sort order="descending" select=". = 'Illustration'"/>
								<!--
								<xsl:sort order="descending" select=". = 'analysis'"/>
								<xsl:sort order="descending" select=". = 'commentary'"/>
								<xsl:sort order="descending" select=". = 'report'"/>
								<xsl:sort order="descending" select=". = 'note'"/>
								<xsl:sort order="descending" select=". = 'announcement'"/>
								<xsl:sort order="descending" select=". = 'advertisement'"/>
								<xsl:sort order="descending" select=". = 'minute'"/>
								<xsl:sort order="descending" select=". = 'biographic'"/>
								<xsl:sort order="descending" select=". = 'letters'"/>
								<xsl:sort order="descending" select=". = 'satire'"/>
								<xsl:sort order="descending" select=". = 'illustration'"/>
								-->
								<xsl:variable name="THIS_TYPE" select="."/>
								['<xsl:value-of select="."/>',<xsl:value-of select="count(../../documentListItem[type = $THIS_TYPE])"/>]<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							pieHole: 0.4,
							pieStartAngle: 0,
							colors: ['#3366CC', '#3355BB', '#3344AA',
							'#DC3942', '#DC3932', '#DC3922', '#DC3912',
							'#DD8822', '#FF9900', '#909809', '#109618']
						};
						var chart = new google.visualization.PieChart(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<xsl:call-template name="chartDiv"/>
				<table>
					<xsl:for-each
						select="documentListItem/type[count(. | key('groupByTypeKey', .)[1]) = 1]">
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Werkbesprechung'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Bericht'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Kurzbericht'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Notiz'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Ankündigung'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Anzeige'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Nachmeldung'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Biografik'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Privatschrift'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Satire'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'Illustration'"/>
						<!--
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'analysis'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'commentary'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'report'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'note'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'announcement'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'advertisement'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'minute'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'biographic'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'letter'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'satire'"/>
						<xsl:sort order="descending" select="key('groupByTypeKey', .) = 'illustration'"/>
						-->
						<xsl:sort lang="de" select="."/>
						<tr>
							<th>
								<xsl:variable name="THIS_TYPE" select="."/>
								<xsl:value-of select="."/>
								<!-- Anzahl aller Einträge in dieser Gruppe -->
								<xsl:text> (</xsl:text>
								<xsl:value-of
									select="count(../../documentListItem[type = $THIS_TYPE])"/>
								<xsl:text>)</xsl:text>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByTypeKey', .)">
										<xsl:sort lang="de" select="../pubDateIso"/>
										<li>
											<span class="mark">
												<xsl:if test="../pubPlaceNym != ../origPlaceNym">
												<xsl:text>*</xsl:text>
												</xsl:if>
											</span>
											<span class="mark">
												<xsl:if test="../author != ''">
												<xsl:text>$</xsl:text>
												</xsl:if>
											</span>
											<!--<xsl:value-of select="../length"/>
											<xsl:text> </xsl:text>-->
											<a href="document?fn={../@xml:id}">
												<!--<xsl:value-of select="substring-before(../@xml:id,'_')"/>-->
												<xsl:value-of select="../title"/>
												<!--<xsl:variable name="document" select="document(concat('../docs/', ../@xml:id))/document"/>
												<xsl:text> [</xsl:text>
												<xsl:value-of select="count($document/body//opus[starts-with(@nym,'verdi.requiem.')])"/>
												<xsl:text> +</xsl:text>
												<xsl:value-of select="count($document/body//opus[not(starts-with(@nym,'verdi.requiem'))])"/>
												<xsl:text>]</xsl:text>-->
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'pubPlace'">
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var data = google.visualization.arrayToDataTable([
							['Publikationsort', 'Anzahl'],
							<xsl:for-each select="documentListItem/pubPlaceNym[count(. | key('groupByPubPlaceKey', .)[1]) = 1]">
								<xsl:variable name="THIS_PLACE" select="."/>
								['<xsl:value-of select="../pubPlace"/>',<xsl:value-of select="count(../../documentListItem[pubPlaceNym = $THIS_PLACE])"/>]<xsl:if test="position() != last()">,</xsl:if>
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							pieHole: 0.4,
							pieStartAngle: 120
						};
						var chart = new google.visualization.PieChart(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<xsl:call-template name="chartDiv"/>
				<table>
					<xsl:for-each
						select="documentListItem/pubPlaceNym[count(. | key('groupByPubPlaceKey', .)[1]) = 1]">
						<xsl:sort select=". = ''"/>
						<xsl:sort lang="de" select="."/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". != ''">
										<a href="place?nym={.}">
											<xsl:value-of select="../pubPlace"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>o. O.</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByPubPlaceKey', .)">
										<xsl:sort lang="de" select="../pubPlace"/>
										<li>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'origPlace'">
				<table>
					<xsl:for-each
						select="documentListItem/origPlaceNym[count(. | key('groupByOrigPlaceKey', .)[1]) = 1]">
						<xsl:sort select=". = ''"/>
						<xsl:sort lang="de" select="."/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". != ''">
										<a href="place?nym={.}">
											<xsl:value-of select="../origPlace"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>o. O.</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByOrigPlaceKey', .)">
										<xsl:sort lang="de" select="../origPlace"/>
										<li>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'author'">
				<table>
					<xsl:for-each
						select="documentListItem/authorNym[. != ''][count(. | key('groupByAuthorKey', .)[1]) = 1]">
						<xsl:sort select=". = ''"/>
						<!-- unnamed authors come last -->
						<xsl:sort select="substring(., 1, 6) = 'anonym'"/>
						<!-- described persons come last -->
						<xsl:sort select="substring(., 1, 6) = 'symbol'"/>
						<!-- symbolized names come 3rd -->
						<xsl:sort select="substring(., 1, 7) = 'akronym'"/>
						<!-- abbreviated names come 2nd -->
						<xsl:sort lang="de" select="."/>
						<tr>
							<th>
								<a href="person?nym={.}">
									<xsl:value-of select="../author"/>
								</a>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByAuthorKey', .)">
										<xsl:sort lang="de" select="../pubDateIso"/>
										<li>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'length'">
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["treemap"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var data = google.visualization.arrayToDataTable([
							['Location', 'Parent', 'Market trade volume (size)', 'Market increase/decrease (color)'],
							['corpus',null,0,0],
							['Werkbesprechung','corpus',0,0],
							['Bericht','corpus',0,0],
							['Kurzbericht','corpus',0,0],
							['Notiz','corpus',0,0],
							['Ankündigung','corpus',0,0],
							['Anzeige','corpus',0,0],
							['Nachmeldung','corpus',0,0],
							['Biografik','corpus',0,0],
							['Privatschrift','corpus',0,0],
							['Satire','corpus',0,0],
							['Illustration','corpus',0,0],
							<xsl:for-each select="documentListItem">
								['<xsl:value-of select="@xml:id"/>','<xsl:value-of select="type"/>',<xsl:value-of select="length"/>,<xsl:value-of select="length"/>],
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							maxDepth: 1,
					        maxPostDepth: 2
						};
						var chart = new google.visualization.TreeMap(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<xsl:call-template name="chartDiv"/>				
				<table>
					<xsl:for-each
						select="documentListItem/lengthGroup[count(. | key('groupByLengthKey', .)[1]) = 1]">
						<xsl:sort data-type="number" select="."/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". = 0">
										<xsl:text>&lt;100</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
										<xsl:text>+</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByLengthKey', .)">
										<xsl:sort lang="de" select="../length"/>
										<li>
											<xsl:value-of select="../type"/>
											<xsl:text>: </xsl:text>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'diagram'">
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawSeriesChart);
					function drawSeriesChart() {
						var data = google.visualization.arrayToDataTable([
							['ID', 'Date', 'Latitude', 'Type', 'Length'],
							<xsl:for-each select="documentListItem[substring(pubDateIso, 1, 3) = '187' and 56 > origPlaceLat and origPlaceLat > 0]">
							['<xsl:value-of select="origPlace"/>', new Date('<xsl:value-of select="pubDateIso"/>'), <xsl:value-of select="origPlaceLat"/>, '<xsl:value-of select="type"/>', <xsl:value-of select="length"/>],
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							bubble: {textStyle: {fontSize: 11}},
							legend: {position: 'none'},
							explorer: { keepInBounds: true, maxZoomIn: 0.05 }
						};
						var chart = new google.visualization.BubbleChart(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<div id="chartDiv"/>
				<!--<div id="chartDiv" style="width:1280px; height:960px;"/>-->
			</xsl:when>
			<xsl:otherwise>
				<!-- DEFAULT: order by pubDateIso -->
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var data = google.visualization.arrayToDataTable([
							['Date', 'DR', 'ÖU', 'CH'],
							<xsl:for-each select="(//node())[5 >= position()]">
								<xsl:variable name="THIS_YEAR" select="position() + 1873"/>
								<xsl:for-each select="(//node())[12 >= position()]">
									<xsl:variable name="THIS_MONTH" select="concat($THIS_YEAR, '-', format-number(position(), '00'))"/>
									<xsl:variable name="TOTAL_DE" select="count(//documentListItem[substring(pubDateIso, 1, 7) = $THIS_MONTH and contains(pubCountryNym,'deutschland')])"/>
									<xsl:variable name="TOTAL_AT" select="count(//documentListItem[substring(pubDateIso, 1, 7) = $THIS_MONTH and contains(pubCountryNym,'oesterreich')])"/>
									<xsl:variable name="TOTAL_CH" select="count(//documentListItem[substring(pubDateIso, 1, 7) = $THIS_MONTH and contains(pubCountryNym,'schweiz')])"/>
									['<xsl:value-of select="$THIS_MONTH"/>',<xsl:value-of select="$TOTAL_DE"/>,<xsl:value-of select="$TOTAL_AT"/>,<xsl:value-of select="$TOTAL_CH"/>],
								</xsl:for-each>
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							isStacked: false
						};
						var chart = new google.visualization.SteppedAreaChart(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<xsl:call-template name="chartDiv"/>
				<table>
					<xsl:for-each
						select="documentListItem/pubDateIso[count(. | key('groupByDateKey', substring(., 1, 7))[1]) = 1]">
						<xsl:sort select=". = ''"/>
						<xsl:sort lang="de" select="substring(., 1, 7)"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test="../pubDateIso = ''">
										<xsl:text>o. D.</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring(../pubDateIso, 1, 4)"/>
										<xsl:if test="substring(../pubDateIso, 6, 2) != '00'">
											<xsl:text>/</xsl:text>
											<xsl:value-of select="substring(../pubDateIso, 6, 2)"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByDateKey', substring(., 1, 7))">
										<xsl:sort lang="de" select="."/>
										<li>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
