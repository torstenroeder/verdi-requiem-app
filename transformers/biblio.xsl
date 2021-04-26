<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="documentList">
		<!-- just display all bibliographic entries -->
		<ul>
			<xsl:for-each select="documentListItem">
				<xsl:sort select="biblio"/>
				<li class="documentListItem">
					<a href="document?fn={@xml:id}"><xsl:value-of select="biblio"/></a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>
