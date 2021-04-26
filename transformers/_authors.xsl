<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html"/>

	<xsl:param name="GET_ORDER"/>
	
	<xsl:variable name="DOCUMENT_LIST" select="document('../indices/documentList.xml')/documentList"/>

	<xsl:include href="templates.xsl"/>

	<xsl:key match="personListItem/nameNym[. != '']" name="groupByNameKey" use="."/>

	<xsl:template match="documentList">
		<div id="status">
			<xsl:value-of select="count(documentListItem)"/> Dokumente </div>
		<div id="tools">
			<xsl:text>Ansicht:</xsl:text>
			<span class="icon">
				<a href="authors">Name</a>
			</span>
			<span class="icon">
				<a href="authors?order=age">Alter</a>
			</span>
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'age'">
				<xsl:for-each
					select="personListItem/title[count(. | key('groupByNameKey', substring-before(., ','))[1]) = 1]">
					<xsl:sort lang="de" select="substring-before(., ',')"/>
					<ul>
						<xsl:for-each select="key('groupByAgeKey', substring-before(., ','))">
							<xsl:sort lang="de" select="../pubDateIso"/>
							<li>
								<a href="document?fn={../@xml:id}">
									<xsl:value-of select="."/>
								</a>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<table>
					<xsl:for-each
						select="documentListItem/authorNym[. != ''][count(. | key('groupByNameKey', .)[1]) = 1]">
						<xsl:sort select=". = ''"/>
						<!-- unnamed authors come last -->
						<xsl:sort select="substring(., 1, 6) = 'anonym'"/>
						<!-- described persons come last -->
						<xsl:sort select="substring(., 1, 6) = 'symbol'"/>
						<!-- symbolized names come 3rd -->
						<xsl:sort select="substring(., 1, 7) = 'akronym'"/>
						<!-- abbreviated names come 2nd -->
						<xsl:sort lang="de" select="."/>
						<tr>
							<th>
								<a href="person?nym={.}">
									<xsl:value-of select="../author"/>
								</a>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByNameKey', .)">
										<xsl:sort lang="de" select="../pubDateIso"/>
										<li>
											<a href="document?fn={../@xml:id}">
												<xsl:value-of select="../title"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
