<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:include href="templates.xsl"/>
	
	<xsl:key name="groupByCategoryKey" match="orgListItem/name[@type = 'index']" use="../category" />
	<xsl:key name="groupByLetterKey" match="orgListItem/name[@type = 'index']" use="substring(.,1,1)" />
	
	<xsl:template match="orgList">
		<div id="status">
			<xsl:value-of select="count(orgListItem/name[@type='index'])"/> Namen zu
			<xsl:value-of select="count(orgListItem[name/@type='index'])"/> Körperschaften
		</div>
		<div id="tools">
			<xsl:text>Ansicht:</xsl:text>
			<span class="icon"><a href="orgs">Name</a></span>
			<span class="icon"><a href="orgs?order=category">Kategorie</a></span>
		</div>
		<!-- display only names with index name -->
		<xsl:choose>
			<xsl:when test="$GET_ORDER = 'category'">
				<table>
					<xsl:for-each select="orgListItem/name[@type = 'index'][count(. | key('groupByCategoryKey', ../category)[1]) = 1]">
						<xsl:sort select="../@nym='unidentified'"/> <!-- unnamed org comes last -->
						<xsl:sort select="../category" lang="de"/>
						<tr>
							<th><xsl:value-of select="../category"/></th>
							<td>
								<ul>
								<xsl:for-each select="key('groupByCategoryKey', ../category)">
									<xsl:sort select="." lang="de"/>
									<xsl:call-template name="orgByCategory"/>
								</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:otherwise> <!-- DEFAULT: order by name -->
				<ul class="grouped initial twoColumns">
					<xsl:for-each select="orgListItem/name[@type = 'index'][count(. | key('groupByLetterKey', substring(.,1,1))[1]) = 1]">
						<xsl:sort select="../@nym='unidentified'"/> <!-- unnamed org comes last -->
						<xsl:sort select="substring(.,1,1)" lang="de"/>
						<ul>
						<xsl:for-each select="key('groupByLetterKey', substring(.,1,1))">
							<xsl:sort select="."/>
							<xsl:call-template name="orgByName"/>
						</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="orgByName">
		<li>
			<a href="org?nym={../@nym}">
				<xsl:choose>
					<xsl:when test="substring-before(.,'[')">
						<b><xsl:value-of select="substring-before(.,'[')"/></b>
						<xsl:text>[</xsl:text>
						<xsl:value-of select="substring-after(.,'[')"/>
					</xsl:when>
					<xsl:otherwise>
						<b><xsl:value-of select="."/></b>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="orgByCategory">
		<li>
			<a href="org?nym={../@nym}">
				<xsl:value-of select="."/>
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
