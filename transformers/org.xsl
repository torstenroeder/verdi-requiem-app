<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:param name="GET_NYM"/>

	<xsl:variable name="EVENT_LIST" select="document('../indices/eventList.xml')/eventList"/>
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>

	<xsl:include href="templates.xsl"/>
	
	<xsl:template match="orgList">
		<xsl:apply-templates select="orgListItem[@nym=$GET_NYM]"/>
	</xsl:template>
	
	<xsl:template match="orgList/orgListItem">
		<div id="tools">
			<span class="icon">
				<a href="orgs">zum Register</a>
			</span>
		</div>
		<div id="internal">
			<xsl:if test="language">
				<p><xsl:text>Sprache: </xsl:text><xsl:value-of select="language"/></p>
			</xsl:if>
			<p><xsl:text>Kategorie: </xsl:text><xsl:value-of select="category"/></p>
			<xsl:for-each select="description">
				<p><xsl:apply-templates/></p>
			</xsl:for-each>
		</div> <!-- #internal -->
		<xsl:call-template name="external"/>
	</xsl:template>

</xsl:stylesheet>
