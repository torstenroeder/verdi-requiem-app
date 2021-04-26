<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:template match="conceptList">
		<div id="tools">
			<xsl:text>Sortierung:</xsl:text>
			<span class="icon"><a href="concepts">Begriff</a></span>
		</div>
		<div id="status"><xsl:value-of select="count(conceptListItem/name)"/> Begriffe</div>
		<!-- display only names with index name -->
		<ul id="twoColumns">
			<xsl:choose>
				<xsl:when test="$GET_ORDER = 'group'">
					<xsl:for-each select="conceptListItem/name[@type='index']">
						<xsl:sort select="birth/@when"/>
						<xsl:sort select="birth/@not-before"/>
						<xsl:sort select="birth/@not-after"/>
						<xsl:sort select="death/@when"/>
						<xsl:sort select="death/@not-before"/>
						<xsl:sort select="death/@not-after"/>
						<xsl:call-template name="conceptListItem"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="conceptListItem[name]">
						<xsl:sort select="@nym"/>
						<xsl:call-template name="conceptListItem"/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	
	<xsl:template name="conceptListItem">
		<li>
			<a href="concept?nym={@nym}">
				<b><xsl:value-of select="name"/></b>
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
