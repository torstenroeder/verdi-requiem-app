<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output doctype-public="" method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="placeList">
		<xsl:for-each select="placeListItem[@type='settlement'][geo]">
			<xsl:text>
			vectorLayer.addFeatures(
				new OpenLayers.Feature.Vector(
					new OpenLayers.Geometry.Point(</xsl:text><xsl:value-of select="substring-after(geo,' ')"/><xsl:text>,</xsl:text><xsl:value-of select="substring-before(geo,' ')"/><xsl:text>).transform(fromProjection,toProjection),
					{
						pointLink: 'place',
						pointLabel: '',
						pointNym: '</xsl:text><xsl:value-of select="@nym"/><xsl:text>',
						pointName: '</xsl:text><xsl:value-of select="name[@type='index']"/><xsl:text>',
						pointRadius: 4.5,
						pointColor: '#fff899'
					}
				)
			);
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
