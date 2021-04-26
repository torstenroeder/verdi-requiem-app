<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html"/>

	<xsl:param name="GET_ORDER"/>

	<xsl:key match="placeListItem[@type = 'settlement']/name[@type = 'index']"
		name="groupByLetterKey" use="substring(., 1, 1)"/>

	<xsl:template match="placeList">
		<div id="status">
			<xsl:value-of select="count(placeListItem[@type = 'settlement']/name[@type = 'index'])"/>
			<xsl:text> Namen zu </xsl:text>
			<xsl:value-of
				select="count(placeListItem[@type = 'settlement' and name/@type = 'index'])"/>
			<xsl:text> Ortschaften</xsl:text>
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'structure'">
				<ul class="twoColumns">
					<xsl:for-each select="placeListItem[@type = 'continent']">
						<xsl:variable name="thisContinent" select="@nym"/>
						<li class="placeListItem">
							<a href="place?nym={@nym}">
								<xsl:value-of select="name[@type = 'index']"/>
							</a>
							<xsl:if
								test="//placeListItem[@type = 'country' and place[@role = 'parentContinent' and @nym = $thisContinent]]">
								<ul>
									<xsl:for-each
										select="//placeListItem[@type = 'country' and place[@role = 'parentContinent' and @nym = $thisContinent]]">
										<xsl:variable name="thisCountry" select="@nym"/>
										<li class="placeListItem">
											<a href="place?nym={@nym}">
												<xsl:value-of select="name[@type = 'index']"/>
											</a>
										</li>
										<xsl:if
											test="//placeListItem[@type = 'settlement' and place[@role = 'parentCountry' and @nym = $thisCountry]]">
											<ul>
												<xsl:for-each
												select="//placeListItem[@type = 'settlement' and place[@role = 'parentCountry' and @nym = $thisCountry]]">
													<xsl:variable name="thisSettlement" select="@nym"/>
												<li class="placeListItem">
												<a href="place?nym={@nym}">
												<xsl:value-of select="name[@type = 'index']"/>
												</a>
												</li>
												<xsl:if
												test="//placeListItem[@type = 'location' and place[@role = 'parentSettlement' and @nym = $thisSettlement]]">
												<ul>
												<xsl:for-each
													select="//placeListItem[@type = 'location' and place[@role = 'parentSettlement' and @nym = $thisSettlement]]">
												<li class="placeListItem">
												<a href="place?nym={@nym}">
												<xsl:value-of select="name[@type = 'index']"/>
												</a>
												</li>
												</xsl:for-each>
												</ul>
												</xsl:if>
												</xsl:for-each>
											</ul>
										</xsl:if>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<!-- DEFAULT: order by last name -->
				<ul class="grouped initial fourColumns">
					<xsl:for-each
						select="placeListItem/name[@type = 'index'][count(. | key('groupByLetterKey', substring(., 1, 1))[1]) = 1]">
						<xsl:sort select="../@nym = 'unidentified'"/>
						<!-- unnamed place comes last -->
						<xsl:sort lang="de" select="substring(., 1, 1)"/>
						<ul>
							<xsl:for-each select="key('groupByLetterKey', substring(., 1, 1))">
								<xsl:sort lang="de" select="."/>
								<xsl:call-template name="placeListItem"/>
							</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="placeListItem">
		<li class="placeListItem">
			<a href="place?nym={../@nym}">
				<xsl:value-of select="."/>
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>
