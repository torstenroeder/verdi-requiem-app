<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:key match="documentListItem[pubPlace != '']/pubPlaceNym" name="groupByPubPlaceKey" use="."/>
	<xsl:key match="documentListItem[origPlace != '']/origPlaceNym" name="groupByOrigPlaceKey" use="."/>
	<!--<xsl:key match="documentListItem[origPlace != ''][pubPlaceNym='berlin']/origPlaceNym" name="groupByOrigPlaceKey" use="."/>-->
	
	<xsl:template match="documentList">
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'pubPlace'">
				<xsl:for-each select="documentListItem[pubPlace != '']/pubPlaceNym[count(. | key('groupByPubPlaceKey', .)[1]) = 1]">
					<xsl:variable name="THIS_PLACE" select="."/>
					<xsl:variable name="COUNT" select="count(../../documentListItem[pubPlace != ''][pubPlaceNym = $THIS_PLACE])"/>
					<xsl:text>
					vectorLayer.addFeatures(
						new OpenLayers.Feature.Vector(
							new OpenLayers.Geometry.Point(</xsl:text><xsl:value-of select="../pubPlaceLon"/><xsl:text>,</xsl:text><xsl:value-of select="../pubPlaceLat"/><xsl:text>).transform(fromProjection,toProjection),
							{
								pointLink: 'place',
								pointLabel: '</xsl:text><!--<xsl:value-of select="$COUNT"/>--><xsl:text>',
								pointNym: '</xsl:text><xsl:value-of select="../pubPlaceNym"/><xsl:text>',
								pointName: '</xsl:text><xsl:value-of select="../pubPlace"/><xsl:text>',
								pointRadius: </xsl:text>
								<xsl:choose>
									<xsl:when test="$COUNT = 1">
										<xsl:text>4</xsl:text>
									</xsl:when>
									<xsl:when test="$COUNT &lt; 10">
										<xsl:text>5</xsl:text>
									</xsl:when>
									<xsl:when test="$COUNT &lt; 30">
										<xsl:text>7</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>10</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>,
								pointColor: '#fff899'
							}
						)
					);
					</xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'origPlace'">
				<xsl:for-each select="documentListItem[origPlace != '']/origPlaceNym[count(. | key('groupByOrigPlaceKey', .)[1]) = 1]">
				<!--<xsl:for-each select="documentListItem[origPlace != ''][pubPlaceNym='berlin']/origPlaceNym[count(. | key('groupByOrigPlaceKey', .)[1]) = 1]">-->
					<xsl:variable name="THIS_PLACE" select="."/>
					<xsl:variable name="COUNT" select="count(../../documentListItem[origPlace != ''][origPlaceNym = $THIS_PLACE])"/>
					<xsl:if test="not(contains(.,' '))">
						<xsl:text>
						vectorLayer.addFeatures(
							new OpenLayers.Feature.Vector(
								new OpenLayers.Geometry.Point(</xsl:text><xsl:value-of select="../origPlaceLon"/><xsl:text>,</xsl:text><xsl:value-of select="../origPlaceLat"/><xsl:text>).transform(fromProjection,toProjection),
								{
									pointLink: 'place',
									pointLabel: '</xsl:text><!--<xsl:value-of select="count(../../documentListItem[origPlace != ''][origPlaceNym = $THIS_PLACE])"/>--><xsl:text>',
									<!--pointLabel: '</xsl:text><xsl:value-of select="count(../../documentListItem[origPlace != ''][pubPlaceNym='berlin'][origPlaceNym = $THIS_PLACE])"/><xsl:text>',-->
									pointNym: '</xsl:text><xsl:value-of select="../origPlaceNym"/><xsl:text>',
									pointName: '</xsl:text><xsl:value-of select="../origPlace"/><xsl:text>',
									pointRadius: </xsl:text>
									<xsl:choose>
										<xsl:when test="$COUNT = 1">
											<xsl:text>4</xsl:text>
										</xsl:when>
										<xsl:when test="$COUNT &lt; 10">
											<xsl:text>5</xsl:text>
										</xsl:when>
										<xsl:when test="$COUNT &lt; 30">
											<xsl:text>7</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>10</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>,
									pointColor: '#fff899'
								}
							)
						);
						</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
