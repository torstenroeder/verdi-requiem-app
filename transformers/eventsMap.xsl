<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output doctype-public="" method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:variable name="PLACE_LIST" select="document('../indices/placeList.xml')/placeList"/>
	
	<xsl:template match="eventList">
		<xsl:for-each select="eventListItem[@type='musical.production'][count(eventSeries/eventListItem) > 0]">
			<xsl:sort select="date/@when" order="descending"/>
			<xsl:variable name="EVENT_PLACE" select="place/@nym"/>
			<xsl:variable name="EVENT_COUNT" select="count(eventSeries/eventListItem)"/>
			<xsl:variable name="PLACE" select="$PLACE_LIST/placeListItem[@nym=$EVENT_PLACE]"/>
			<xsl:variable name="YEAR" select="substring(date/@when,3,2)"/>
			<xsl:text>
			vectorLayer.addFeatures(
				new OpenLayers.Feature.Vector(
					new OpenLayers.Geometry.Point(</xsl:text><xsl:value-of select="substring-after($PLACE/geo,' ')"/><xsl:text>,</xsl:text><xsl:value-of select="substring-before($PLACE/geo,' ')"/><xsl:text>).transform(fromProjection,toProjection),
					{
						pointLink: 'place',
						pointLabel: '<!--</xsl:text><xsl:value-of select="$YEAR"/><xsl:text>-->',
						pointNym: '</xsl:text><xsl:value-of select="$PLACE/@nym"/><xsl:text>',
						pointName: '</xsl:text><xsl:value-of select="$PLACE/name[@type='index']"/><xsl:text>',
						pointRadius: </xsl:text><xsl:value-of select="$EVENT_COUNT + 3"/><xsl:text>,
						pointColor: '</xsl:text>
						<xsl:choose>
							<xsl:when test="$YEAR = 74">
								<xsl:text>#ffffff</xsl:text>
							</xsl:when>
							<xsl:when test="$YEAR = 75">
								<xsl:text>#ffff33</xsl:text>
							</xsl:when>
							<xsl:when test="$YEAR = 76">
								<xsl:text>#ffcc00</xsl:text>
							</xsl:when>
							<xsl:when test="$YEAR = 77">
								<xsl:text>#cc9900</xsl:text>
							</xsl:when>
							<xsl:when test="$YEAR = 78">
								<xsl:text>#996600</xsl:text>
							</xsl:when>
						</xsl:choose>
						<xsl:text>'
					}
				)
			);
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
