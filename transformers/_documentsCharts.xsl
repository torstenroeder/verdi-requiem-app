<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:key name="groupByTitleKey" match="documentListItem/title" use="substring-before(.,',')" />
	<xsl:key name="groupByDateKey" match="documentListItem/pubDateIso" use="substring(.,1,7)" />
	<xsl:key name="groupByTypeKey" match="documentListItem/type" use="." />
	<xsl:key name="groupByPubPlaceKey" match="documentListItem/pubPlaceNym" use="." />
	<xsl:key name="groupByOrigPlaceKey" match="documentListItem/origPlaceNym" use="." />
	<xsl:key name="groupByAuthorKey" match="documentListItem/authorNym" use="." />
	<xsl:key name="groupByLengthKey" match="documentListItem/lengthGroup" use="." />
	
	<xsl:template match="documentList">
		<div id="status">
			<xsl:value-of select="count(documentListItem)"/> Dokumente
		</div>
		<div id="tools">
			<xsl:text>Gliederung:</xsl:text>
			<span class="icon"><a href="documents">Datum</a></span>
			<span class="icon"><a href="documents?order=title">Titel</a></span>
			<span class="icon"><a href="documents?order=type">Typ</a></span>
			<span class="icon"><a href="documents?order=pubPlace">Publikationsort</a></span>
			<span class="icon"><a href="documents?order=origPlace">Bezugsort</a></span>
			<span class="icon"><a href="documents?order=author">Autor</a></span>
			<span class="icon"><a href="documents?order=length">Länge</a></span>
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'title'">
				<ul class="grouped">
					<xsl:for-each select="documentListItem/title[count(. | key('groupByTitleKey', substring-before(.,','))[1]) = 1]">
						<xsl:sort select="substring-before(.,',')" lang="de"/>
						<ul>
							<xsl:for-each select="key('groupByTitleKey', substring-before(.,','))">
								<xsl:sort select="../pubDateIso" lang="de"/>
								<li>
									<a href="document?fn={../@xml:id}"><xsl:value-of select="."/></a>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'type'">
				<table>
					<xsl:for-each select="documentListItem/type[count(. | key('groupByTypeKey', .)[1]) = 1]">
						<xsl:sort select="." lang="de"/>
						<tr>
							<th>
								<xsl:variable name="THIS_TYPE" select="."/>
								<xsl:value-of select="."/>
								<!-- Anzahl aller Einträge in dieser Gruppe -->
								<xsl:text> (</xsl:text>
								<xsl:value-of select="count(../../documentListItem[type = $THIS_TYPE])"/>
								<xsl:text>)</xsl:text>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByTypeKey', .)">
										<xsl:sort select="../pubDateIso" lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'pubPlace'">
				<table>
					<xsl:for-each select="documentListItem/pubPlaceNym[count(. | key('groupByPubPlaceKey', .)[1]) = 1]">
						<xsl:sort select=".=''"/>
						<xsl:sort select="." lang="de"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". != ''">
										<a href="place?nym={.}"><xsl:value-of select="../pubPlace"/></a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>o. O.</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByPubPlaceKey', .)">
										<xsl:sort select="../pubPlace" lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'origPlace'">
				<table>
					<xsl:for-each select="documentListItem/origPlaceNym[count(. | key('groupByOrigPlaceKey', .)[1]) = 1]">
						<xsl:sort select=".=''"/>
						<xsl:sort select="." lang="de"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". != ''">
										<a href="place?nym={.}"><xsl:value-of select="../origPlace"/></a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>o. O.</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByOrigPlaceKey', .)">
										<xsl:sort select="../origPlace" lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'author'">
				<table>
					<xsl:for-each select="documentListItem/authorNym[count(. | key('groupByAuthorKey', .)[1]) = 1]">
						<xsl:sort select=". = ''"/> <!-- unnamed authors come last -->
						<xsl:sort select="substring(.,1,6) = 'anonym'"/> <!-- described persons come last -->
						<xsl:sort select="substring(.,1,6) = 'symbol'"/> <!-- symbolized names come 3rd -->
						<xsl:sort select="substring(.,1,7) = 'akronym'"/> <!-- abbreviated names come 2nd -->
						<xsl:sort select="." lang="de"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". != ''">
										<a href="person?nym={.}"><xsl:value-of select="../author"/></a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>unbekannter Autor</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByAuthorKey', .)">
										<xsl:sort select="../pubDateIso" lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'length'">
				<table>
					<xsl:for-each select="documentListItem/lengthGroup[count(. | key('groupByLengthKey', .)[1]) = 1]">
						<xsl:sort select="." data-type="number"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test=". = 0">
										<xsl:text>&lt;100</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
										<xsl:text>+</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByLengthKey', .)">
										<xsl:sort select="../length" lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
											<xsl:text> (</xsl:text><xsl:value-of select="../length"/><xsl:text>)</xsl:text>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<!-- DEFAULT: order by pubDateIso -->
				<table>
					<xsl:for-each select="documentListItem/pubDateIso[count(. | key('groupByDateKey', substring(.,1,7))[1]) = 1]">
						<xsl:sort select=".=''"/>
						<xsl:sort select="substring(.,1,7)" lang="de"/>
						<tr>
							<th>
								<xsl:choose>
									<xsl:when test="../pubDateIso = ''">
										<xsl:text>o. D.</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring(../pubDateIso,1,4)"/>
										<xsl:if test="substring(../pubDateIso,6,2) != '00'">
											<xsl:text>/</xsl:text>
											<xsl:value-of select="substring(../pubDateIso,6,2)"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByDateKey', substring(.,1,7))">
										<xsl:sort select="." lang="de"/>
										<li>
											<a href="document?fn={../@xml:id}"><xsl:value-of select="../title"/></a>
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
