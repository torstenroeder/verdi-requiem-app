<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_NYM"/>
	
	<xsl:template match="conceptList">
		<xsl:apply-templates select="conceptListItem[@nym=$GET_NYM]"/>
	</xsl:template>
	
	<xsl:template match="conceptList/conceptListItem">
		<div id="internal">
			<p>
				<b><xsl:value-of select="name"/></b>
			</p>
		</div> <!-- #internal -->
	</xsl:template>
	
</xsl:stylesheet>