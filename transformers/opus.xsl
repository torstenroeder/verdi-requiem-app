<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_NYM"/>
	
	<xsl:variable name="EVENT_LIST" select="document('../indices/eventList.xml')/eventList"/>
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>
	<xsl:variable name="PERSON_LIST" select="document('../indices/personList.xml')/personList"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:template match="opusList">
		<xsl:apply-templates select="//opusListItem[@nym=$GET_NYM]"/>
	</xsl:template>
	
	<xsl:template match="opusList//opusListItem">
		<div id="tools">
			<span class="icon">
				<a href="opuses">zum Register</a>
			</span>
		</div>
		<div id="internal">
			<xsl:if test="person[@role='composer']">
				<xsl:variable name="COMPOSER" select="person[@role='composer']/@nym"/>
				<xsl:text>Komponist: </xsl:text>
				<a href="person?nym={$COMPOSER}"><xsl:value-of select="$PERSON_LIST/personListItem[@nym=$COMPOSER]/name"/></a>
			</xsl:if>
			<xsl:if test="../../../opusListItem[opusParts/opusListItem[@nym=$GET_NYM]]">
				<p>
					<xsl:text>Teil von: </xsl:text>
					<xsl:for-each select="../../../opusListItem[opusParts/opusListItem[@nym=$GET_NYM]]">
						<a class="opus" href="opus?nym={@nym}"><xsl:value-of select="name"/></a>
					</xsl:for-each>
				</p>
			</xsl:if>
			<xsl:if test="opusParts">
				<p>
					<xsl:text>Teile: </xsl:text>
					<xsl:for-each select="opusParts/opusListItem">
						<xsl:if test="not(position()=1)"><xsl:text>, </xsl:text></xsl:if>
						<a class="opus" href="opus?nym={@nym}"><xsl:value-of select="name"/></a>
					</xsl:for-each>
				</p>
			</xsl:if>
			<!-- EVENTS WITH THIS OPUS -->
			<xsl:variable name="eventCount" select="count($EVENT_LIST/eventListItem[opus[@nym=$GET_NYM]]/eventSeries/eventListItem | $EVENT_LIST/eventListItem/eventSeries/eventListItem[opus[@nym=$GET_NYM]])"/>
			<xsl:if test="$eventCount > 0">
				<h2>Aufgeführt in <xsl:value-of select="$eventCount"/> Veranstaltungen</h2>
				<ul>
					<xsl:for-each
						select="$EVENT_LIST/eventListItem[opus[@nym=$GET_NYM]]/eventSeries/eventListItem | $EVENT_LIST/eventListItem/eventSeries/eventListItem[opus[@nym=$GET_NYM]]">
						<xsl:sort select="date/@when"/>
						<xsl:variable name="RELATED_PLACE" select="../../place/@nym"/>
						<li>
							<a href="event?nym={@nym}">
								<xsl:value-of select="$PLACE_LIST/placeListItem[@nym=$RELATED_PLACE]/name"/>
								<xsl:text>, </xsl:text>
								<xsl:call-template name="formattedDate"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</div> <!-- #internal -->
		<xsl:call-template name="external"/>
	</xsl:template>
	
</xsl:stylesheet>
