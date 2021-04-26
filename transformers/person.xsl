<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_NYM"/>
	
	<xsl:variable name="EVENT_LIST" select="document('../indices/eventList.xml')/eventList"/>
	<xsl:variable name="OPUS_LIST" select="document('../indices/opusList.xml')/opusList"/>
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:template match="personList">
		<xsl:apply-templates select="personListItem[@nym=$GET_NYM]"/>
	</xsl:template>
	
	<xsl:template match="personList/personListItem">
		<div id="tools">
			<span class="icon">
				<a href="persons">zum Register</a>
			</span>
		</div>
		<div id="internal">
			<p>
				<!-- primary name -->
				<b>
					<xsl:value-of select="name[position() = 1]"/>
				</b>
				<!-- alternative names -->
				<xsl:if test="name[position() > 1 and @type != 'index']">
					<xsl:text> (</xsl:text>
					<xsl:for-each select="name[position() > 1 and @type != 'index']">
						<xsl:sort select="@type='other'"/>
						<xsl:sort select="@type='veronym'"/>
						<xsl:sort select="@type='acronym'"/>
						<xsl:sort select="@type='pseudonym'"/>
						<xsl:if test="@type='veronym'">eigentl. </xsl:if>
						<xsl:if test="@type='acronym'">akr. </xsl:if>
						<xsl:if test="@type='pseudonym'">pseud. </xsl:if>
						<xsl:if test="@type='other'">auch </xsl:if>
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<!-- gender -->
				<xsl:if test="sex">
					<xsl:choose>
						<xsl:when test="sex = 'm'">
							<xsl:text> ♂</xsl:text>
						</xsl:when>
						<xsl:when test="sex = 'f'">
							<xsl:text> ♀</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<!-- lifespan -->
				<xsl:if test="birth or death">
					<xsl:text> </xsl:text>
					<xsl:call-template name="personLifespan"/>
				</xsl:if>
				<xsl:if test="description">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="description[position() = 1]"/>
				</xsl:if>
				<xsl:for-each select="description[position() > 1]">
					<xsl:choose>
						<xsl:when test="position() = 2">
							<xsl:text>; </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>, </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</xsl:for-each>
				<xsl:text>.</xsl:text>
			</p>
			<xsl:variable name="opusCount" select="count($OPUS_LIST/opusListItem//person[@nym=$GET_NYM])"/>
			<xsl:if test="$opusCount > 0">
				<h2>Autor von <xsl:value-of select="$opusCount"/> Werken</h2>
				<ul>
					<xsl:for-each select="$OPUS_LIST/opusListItem[person[@nym=$GET_NYM]]">
						<xsl:sort select="name"/>
						<li>
							<a href="opus?nym={@nym}"><xsl:value-of select="name"/></a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<!-- EVENTS WITH THIS PERSON -->
			<xsl:variable name="eventCount" select="count($EVENT_LIST/eventListItem[person[@nym=$GET_NYM]]/eventSeries/eventListItem | $EVENT_LIST/eventListItem/eventSeries/eventListItem[person[@nym=$GET_NYM]])"/>
			<xsl:if test="$eventCount > 0">
				<h2><xsl:value-of select="$eventCount"/> Aufführungen</h2>
				<ul>
					<xsl:for-each
						select="$EVENT_LIST/eventListItem[person[@nym=$GET_NYM]]/eventSeries/eventListItem | $EVENT_LIST/eventListItem/eventSeries/eventListItem[person[@nym=$GET_NYM]]">
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
