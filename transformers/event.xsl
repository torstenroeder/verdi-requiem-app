<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html"/>

	<xsl:param name="GET_NYM"/>

	<xsl:variable name="PERSON_LIST" select="document('../indices/personList.xml')/personList"/>
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>
	<xsl:variable name="OPUS_LIST" select="document('../indices/opusList.xml')/opusList"/>

	<xsl:include href="templates.xsl"/>

	<xsl:template match="eventList">
		<xsl:apply-templates select="eventListItem[@nym = $GET_NYM]"/>
	</xsl:template>

	<xsl:template match="eventList/eventListItem">
		<xsl:variable name="PRECEDING_NYM" select="preceding-sibling::eventListItem[1]/@nym"/>
		<xsl:variable name="FOLLOWING_NYM" select="following-sibling::eventListItem[1]/@nym"/>
		<div id="tools">
			<xsl:if test="$PRECEDING_NYM != ''">
				<span class="icon">
					<a href="event?nym={$PRECEDING_NYM}">vorheriges</a>
				</span>
			</xsl:if>
			<xsl:if test="$FOLLOWING_NYM != ''">
				<span class="icon">
					<a href="event?nym={$FOLLOWING_NYM}">nächstes</a>
				</span>
			</xsl:if>
			<span class="icon">
				<a href="events">zum Register</a>
			</span>
		</div>
		<xsl:variable name="SERIES_PLACE" select="place/@nym"/>
		<div id="internal">
			<h2>
				<xsl:if test="place">
					<xsl:value-of select="$PLACE_LIST/placeListItem[@nym = $SERIES_PLACE]/name"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:value-of select="date/@when"/>
			</h2>
			<ul>
				<xsl:for-each select="description">
					<li>
						<xsl:apply-templates/>
					</li>
				</xsl:for-each>
			</ul>
			<xsl:for-each select="eventSeries/eventListItem">
				<xsl:variable name="EVENT_PLACE" select="place/@nym"/>
				<h4>
					<xsl:if test="date">
						<xsl:call-template name="formattedDate"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="place">
						<xsl:value-of select="$PLACE_LIST/placeListItem[@nym = $EVENT_PLACE]/name"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="name"/>
				</h4>
				<xsl:if test="person | ../../person">
					<ul>
						<xsl:for-each select="person | ../../person">
							<xsl:sort order="descending" select="@role = 'conductor'"/>
							<xsl:sort order="descending" select="@role = 'concert-master'"/>
							<xsl:sort order="descending" select="@role = 'soloist.soprano'"/>
							<xsl:sort order="descending" select="@role = 'soloist.mezzo'"/>
							<xsl:sort order="descending" select="@role = 'soloist.tenor'"/>
							<xsl:sort order="descending" select="@role = 'soloist.basso'"/>
							<li>
								<xsl:variable name="CURRENT_PERSON" select="@nym"/>
								<a href="person?nym={@nym}">
									<xsl:value-of
										select="$PERSON_LIST/personListItem[@nym = $CURRENT_PERSON]/name[1]"
									/>
								</a>
								<xsl:choose>
									<xsl:when test="@role = 'conductor'"> (Dirigent)</xsl:when>
									<xsl:when test="@role = 'concert-master'">
										(Konzertmeister)</xsl:when>
									<xsl:when test="@role = 'soloist'"> (SolistIn)</xsl:when>
									<xsl:when test="@role = 'soloist.soprano'"> (S)</xsl:when>
									<xsl:when test="@role = 'soloist.mezzo'"> (M)</xsl:when>
									<xsl:when test="@role = 'soloist.alto'"> (A)</xsl:when>
									<xsl:when test="@role = 'soloist.tenor'"> (T)</xsl:when>
									<xsl:when test="@role = 'soloist.baritone'"> (Bt)</xsl:when>
									<xsl:when test="@role = 'soloist.basso'"> (B)</xsl:when>
									<xsl:when test="@role = 'spectator'"> (Zuschauer)</xsl:when>
									<xsl:when test="@role = 'stage-director'">
										(Bühnenmeister)</xsl:when>
								</xsl:choose>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="description">
					<p>
						<xsl:text>Besonderheiten: </xsl:text>
						<xsl:for-each select="description">
							<xsl:if test="position() != 1">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:value-of select="."/>
						</xsl:for-each>
					</p>
				</xsl:if>
				<xsl:if test="resource">
					<p>
						<xsl:text>Quellen: </xsl:text>
						<xsl:for-each select="resource">
							<xsl:if test="position() != 1">
								<xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:text>.</xsl:text>
					</p>
				</xsl:if>
				<xsl:if test="opus[@nym != 'verdi.requiem']">
					<p>
						<xsl:text>Programm: </xsl:text>
						<xsl:for-each select="opus">
							<xsl:if test="position() != 1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:variable name="CURRENT_OPUS" select="@nym"/>
							<a href="opus?nym={@nym}">
								<xsl:value-of
									select="$OPUS_LIST//opusListItem[@nym = $CURRENT_OPUS]/name[1]"
								/>
							</a>
						</xsl:for-each>
						<xsl:text>.</xsl:text>
					</p>
				</xsl:if>
			</xsl:for-each>
		</div>
		<!-- #internal -->
		<xsl:call-template name="external"/>
	</xsl:template>

</xsl:stylesheet>
