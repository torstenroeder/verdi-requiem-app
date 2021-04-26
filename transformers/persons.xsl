<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:key name="groupByLetterKey" match="personListItem/name[@type='index']" use="substring(.,1,1)" />
	<xsl:key name="groupByLifespan" match="personListItem/name[@type='index']" use="1875-../birth/@when" />
	<xsl:key name="groupByOccupation" match="personListItem[//occupation]/name[@type='index']" use="../description/occupation[1]/@type" />
	
	<xsl:template match="personList">
		<div id="status">
			<xsl:value-of select="count(personListItem/name[@type='index'])"/><xsl:text> Namen zu </xsl:text>
			<xsl:value-of select="count(personListItem[name/@type='index'])"/><xsl:text> Personen</xsl:text>
		</div>
		<div id="tools">
			<xsl:text>Ansicht:</xsl:text>
			<span class="icon"><a href="persons">Name</a></span>
			<span class="icon"><a href="persons?order=occupation">Beruf</a></span>
			<!--<span class="icon"><a href="persons?order=lifespan">Lebensdaten</a></span>-->
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'occupation'">
				<table>
					<xsl:for-each select="personListItem[//occupation]/name[@type='index'][count(. | key('groupByOccupation', ../description/occupation[1]/@type)[1]) = 1]">
						<tr>
							<th>
								<xsl:variable name="OCCUPATION" select="../description/occupation[1]/@type"/>
								<xsl:value-of select="$OCCUPATION"/>
								<!-- Anzahl aller Einträge in dieser Gruppe -->
								<xsl:text> (</xsl:text>
								<xsl:value-of select="count(../../personListItem/description/occupation[1][@type = $OCCUPATION])"/>
								<xsl:text>)</xsl:text>
							</th>
							<td>
								<ul class="grouped">
									<xsl:for-each select="key('groupByOccupation', ../description/occupation[1]/@type)">
										<xsl:sort select="." lang="de"/>
										<xsl:call-template name="personByOccupation"/>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:when test="$GET_ORDER = 'lifespan'">
				<xsl:for-each select="personListItem/name[@type = 'index'][count(. | key('groupByLifespan', 1875-../birth/@when)[1]) = 1]">
					<xsl:sort select="1875-../birth/@when" data-type="number"/>
					<ul>
					<xsl:value-of select="1875-../birth/@when"/>
						<xsl:for-each select="key('groupByLifespan', 1875-../birth/@when)">
							<xsl:call-template name="personByName"/>
						</xsl:for-each>
					</ul>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise> <!-- DEFAULT: order by last name -->
				<ul class="grouped initial twoColumns">
					<xsl:for-each select="personListItem/name[@type = 'index'][count(. | key('groupByLetterKey', substring(.,1,1))[1]) = 1]">
						<xsl:sort select="../@nym='unidentified'"/> <!-- unnamed persons comes last -->
						<xsl:sort select="substring(../@nym,1,6)='anonym'"/> <!-- anonymous persons comes 2nd last -->
						<xsl:sort select="substring(../@nym,1,6)='symbol'"/> <!-- symbol acronyms come 3nd last -->
						<xsl:sort select="substring(../@nym,1,7)='akronym'"/> <!-- abbreviations come 4th last -->
						<xsl:sort select="substring(.,1,1)" lang="de"/>
						<ul>
							<xsl:for-each select="key('groupByLetterKey', substring(.,1,1))">
								<xsl:sort select="." lang="de"/>
								<xsl:call-template name="personByName"/>
							</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="personByName">
		<li>
			<a href="person?nym={../@nym}">
				<!-- last name, first name -->
				<xsl:choose>
					<xsl:when test="substring-before(.,',')">
						<b><xsl:value-of select="substring-before(.,',')"/></b>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="substring-after(.,',')"/>
					</xsl:when>
					<xsl:when test="substring-before(.,' von')">
						<b><xsl:value-of select="substring-before(.,' von')"/></b>
						<xsl:text> von </xsl:text>
						<xsl:value-of select="substring-after(.,' von')"/>
					</xsl:when>
					<xsl:when test="substring-before(.,' di')">
						<b><xsl:value-of select="substring-before(.,' di')"/></b>
						<xsl:text> di </xsl:text>
						<xsl:value-of select="substring-after(.,' di')"/>
					</xsl:when>
					<xsl:when test="substring-before(.,' de’')">
						<b><xsl:value-of select="substring-before(.,' de’')"/></b>
						<xsl:text> de’ </xsl:text>
						<xsl:value-of select="substring-after(.,' de’')"/>
					</xsl:when>
					<xsl:otherwise>
						<b><xsl:value-of select="."/></b>
					</xsl:otherwise>
				</xsl:choose>
				<!-- lifespan -->
				<!--
				<xsl:if test="../birth or ../death">
					<xsl:text> (</xsl:text>
					<xsl:for-each select="..">
						<xsl:call-template name="personLifespan"/>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</xsl:if>
				-->
				<!-- description -->
				<!--
				<xsl:text>, </xsl:text>
				<xsl:value-of select="description[position() = 1]">
					<xsl:apply-templates/>
				</xsl:value-of>
				-->
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="personByOccupation">
		<li>
			<a href="person?nym={../@nym}">
				<!-- last name, first name -->
				<xsl:choose>
					<xsl:when test="substring-before(.,',')">
						<b><xsl:value-of select="substring-before(.,',')"/></b>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="substring-after(.,',')"/>
					</xsl:when>
					<xsl:otherwise>
						<b><xsl:value-of select="."/></b>
					</xsl:otherwise>
				</xsl:choose>
				<!-- lifespan -->
				<xsl:if test="../birth">
				<!--<xsl:if test="../birth or ../death">-->
					<xsl:text> (</xsl:text>
					<xsl:for-each select="..">
						<xsl:text>*</xsl:text>
						<xsl:value-of select="birth/@when"/>
						<!--<xsl:call-template name="personLifespan"/>-->
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
