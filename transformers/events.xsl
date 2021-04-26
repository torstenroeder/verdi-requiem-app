<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>
	<xsl:variable name="PERSON_LIST" select="document('../indices/personList.xml')/personList"/>
	
	<xsl:key name="groupByDateKey" match="eventListItem[@type='musical.production']" use="substring(date/@when,1,4)" />
	<xsl:key name="groupByPlaceKey" match="eventListItem[@type='musical.production']" use="substring(place/@nym,1,1)" />
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:template match="eventList">
		<div id="status"><xsl:value-of select="count(eventListItem[@type='musical.production']/eventSeries/eventListItem)"/> Aufführungen in <xsl:value-of select="count(eventListItem[@type='musical.production'])"/> Produktionen</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<!-- order by place -->
			<xsl:when test="$GET_ORDER = 'place'">
				<ul class="grouped initial threeColumns">
					<xsl:for-each select="eventListItem[@type='musical.production'][count(. | key('groupByPlaceKey', substring(place/@nym,1,1))[1]) = 1]">
						<xsl:sort select="place/@nym"/>
						<ul>
						<xsl:for-each select="key('groupByPlaceKey', substring(place/@nym,1,1))">
							<xsl:sort select="place/@nym"/>
							<xsl:call-template name="eventListItemByPlace"/>
						</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<!-- order by date (table) -->
			<xsl:when test="$GET_ORDER = 'table'">
				<table>
					<xsl:for-each select="/eventList/eventListItem[@type='musical.production']">
						<xsl:sort select="date/@when"/>
						<tr>
							<xsl:call-template name="eventListItemInTable"/>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<!-- DEFAULT: order by date -->
			<xsl:otherwise>
				<script src="https://www.google.com/jsapi" type="text/javascript"/>
				<script type="text/javascript">
					google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var data = google.visualization.arrayToDataTable([
							['Date', 'Σ', 'EA'],
							<xsl:for-each select="(//node())[5 >= position()]">
								<xsl:variable name="THIS_YEAR" select="position() + 1873"/>
								<xsl:for-each select="(//node())[12 >= position()]">
									<xsl:variable name="THIS_MONTH" select="concat($THIS_YEAR, '-', format-number(position(), '00'))"/>
									<xsl:variable name="TOTAL_PREMIERES" select="count(//eventListItem[@type='musical.production.performance.first'][substring(date/@when,1,7) = $THIS_MONTH])"/>
									<xsl:variable name="TOTAL_EVENTS" select="count(//eventListItem[starts-with(@type,'musical.production.performance')][substring(date/@when,1,7) = $THIS_MONTH])"/>
									['<xsl:value-of select="$THIS_MONTH"/>',<xsl:value-of select="$TOTAL_EVENTS"/>,<xsl:value-of select="$TOTAL_PREMIERES"/>],
								</xsl:for-each>
							</xsl:for-each>
						]);
						var options = {
							<xsl:call-template name="globalChartOptions"/>
							isStacked: false,
							vAxis: { ticks: [3,6,9,12,15] }
						};
						var chart = new google.visualization.SteppedAreaChart(document.getElementById('chartDiv'));
						chart.draw(data, options);
					}
				</script>
				<xsl:call-template name="chartDiv"/>
				<ul class="grouped threeColumns">
					<xsl:for-each select="eventListItem[@type='musical.production'][count(. | key('groupByDateKey', substring(date/@when,1,4))[1]) = 1]">
						<xsl:sort select="date/@when"/>
						<ul>
						<xsl:for-each select="key('groupByDateKey', substring(date/@when,1,4))">
							<xsl:sort select="date/@when"/>
							<xsl:call-template name="eventListItemByDate"/>
						</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="eventListItemInTable">
		<xsl:variable name="EVENT_PLACE" select="place/@nym"/>
		<td>
			<xsl:call-template name="formattedDate"/>
		</td>
		<td>
			<xsl:if test="place">
				<xsl:value-of select="$PLACE_LIST/placeListItem[@nym=$EVENT_PLACE]/name"/>
			</xsl:if>
		</td>
		<td>
			<xsl:if test="eventSeries/eventListItem[@type='musical.production.performance.first']">
				<i>EA</i>
			</xsl:if>
		</td>
		<td>
			<ul class="noBullets">
			<xsl:for-each select="eventSeries/eventListItem">
				<li>
					<a href="event?nym={@nym}"><xsl:call-template name="formattedDate"/></a>
					<xsl:for-each select="(person | ../../person)[@role != 'spectator']">
						<xsl:sort select="@role != 'conductor'"/>
						<xsl:variable name="EVENT_PERSON" select="@nym"/>
						<xsl:text>, </xsl:text>
						<a href="person?nym={$EVENT_PERSON}"><xsl:value-of select="substring-before($PERSON_LIST/personListItem[@nym=$EVENT_PERSON]/name[@type='index'],',')"/></a>
					</xsl:for-each>
					<xsl:text>.</xsl:text>
				</li>
			</xsl:for-each>
			</ul>
		</td>
	</xsl:template>
	
	<xsl:template name="eventListItemByDate">
		<xsl:variable name="EVENT_PLACE" select="place/@nym"/>
		<li>
			<a href="event?nym={@nym}">
				<b><xsl:call-template name="formattedDate"/></b>
				<!--EN SPACE-->
				<xsl:text>&#x2002;</xsl:text>
				<xsl:if test="eventSeries/eventListItem[@type='musical.production.performance.first']">
					<i>EA</i>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="place">
					<xsl:value-of select="$PLACE_LIST/placeListItem[@nym=$EVENT_PLACE]/name"/>
				</xsl:if>
				<xsl:if test="count(eventSeries/eventListItem[starts-with(@type,'musical.production.performance')]) &gt; 1">
					<!--EN SPACE-->
					<xsl:text>&#x2002;</xsl:text>
					<i>(<xsl:value-of select="count(eventSeries/eventListItem[starts-with(@type,'musical.production.performance')])"/>)</i>
					<xsl:text> </xsl:text>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="eventListItemByPlace">
		<xsl:variable name="EVENT_PLACE" select="place/@nym"/>
		<li>
			<a href="event?nym={@nym}">
				<xsl:if test="place">
					<b><xsl:value-of select="$PLACE_LIST/placeListItem[@nym=$EVENT_PLACE]/name"/></b>
				</xsl:if>
				<!--EN SPACE-->
				<xsl:text>&#x2002;</xsl:text>
				<xsl:if test="eventSeries/eventListItem[@type='musical.production.performance.first']">
					<i>EA</i>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:call-template name="formattedDate"/>
				<xsl:if test="count(eventSeries/eventListItem[starts-with(@type,'musical.production.performance')]) &gt; 1">
					<!--EN SPACE-->
					<xsl:text>&#x2002;</xsl:text>
					<i>(<xsl:value-of select="count(eventSeries/eventListItem[starts-with(@type,'musical.production.performance')])"/>)</i>
					<xsl:text> </xsl:text>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
