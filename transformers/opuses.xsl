<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GET_ORDER"/>
	
	<xsl:variable name="PERSON_LIST" select="document('../indices/personList.xml')/personList"/>
	
	<xsl:key name="groupByComposerKey" match="opusListItem[name/@type = 'index']" use="person[@role='composer']/@nym" />
	<xsl:key name="groupByGenreKey" match="opusListItem[name/@type = 'index']" use="category" />
	<xsl:key name="groupByLetterKey" match="opusListItem[name/@type = 'index']" use="substring(name[@type = 'index'],1,1)" />
	
	<xsl:template match="opusList">
		<div id="tools">
			<xsl:text>Ansicht:</xsl:text>
			<span class="icon"><a href="opuses">Titel</a></span>
			<span class="icon"><a href="opuses?order=composer">Komponist</a></span>
			<span class="icon"><a href="opuses?order=genre">Gattung</a></span>
		</div>
		<div id="status"><xsl:value-of select="count(opusListItem[name/@type='index'])"/> Einträge</div>
		<xsl:choose>
			<!-- order by composer -->
			<xsl:when test="$GET_ORDER = 'composer'">
				<table>
					<xsl:for-each select="opusListItem[name/@type = 'index'][count(. | key('groupByComposerKey', person[@role='composer']/@nym)[1]) = 1]">
						<xsl:sort select="not(person[@role='composer'])"/> <!-- anonymous works come last -->
						<xsl:sort select="person[@role='composer']/@nym" lang="de"/>
						<xsl:variable name="COMPOSER" select="person[@role='composer']/@nym"/>
						<tr>
							<th>
								<xsl:value-of select="$PERSON_LIST/personListItem[@nym=$COMPOSER]/name[@type='index']"/>
								<!-- anonymous composer -->
								<xsl:if test="not($COMPOSER)">
									<xsl:text>?</xsl:text>
								</xsl:if>
							</th>
							<td>
								<ul class="grouped">
								<xsl:for-each select="key('groupByComposerKey', person[@role='composer']/@nym)">
									<xsl:sort select="name[position() = 1]" lang="de"/>
									<xsl:call-template name="opusByComposer"/>
								</xsl:for-each>
								<!-- work by anonymous composer -->
								<xsl:if test="not($COMPOSER)">
									<xsl:for-each select=".">
										<xsl:call-template name="opusByComposer"/>
									</xsl:for-each>
								</xsl:if>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<!-- order by genre -->
			<xsl:when test="$GET_ORDER = 'genre'">
				<table>
					<xsl:for-each select="opusListItem[name/@type = 'index'][count(. | key('groupByGenreKey', category)[1]) = 1]">
						<xsl:sort select="category" lang="de"/>
						<tr>
							<th><xsl:value-of select="category"/></th>
							<td>
								<ul class="grouped">
								<xsl:for-each select="key('groupByGenreKey', category)">
									<xsl:sort select="person[@role='composer']/@nym" lang="de"/>
									<xsl:call-template name="opusByGenre"/>
								</xsl:for-each>
								</ul>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:when>
			<!-- DEFAULT: order by title -->
			<xsl:otherwise>
				<ul class="grouped initial">
					<xsl:for-each select="opusListItem[name/@type = 'index'][count(. | key('groupByLetterKey', substring(name[@type = 'index'],1,1))[1]) = 1]">
						<xsl:sort select="@nym = 'unidentified'"/> <!-- unidentified works come last -->
						<xsl:sort select="substring(name[@type = 'index'],1,1)"/>
						<ul>
						<xsl:for-each select="key('groupByLetterKey', substring(name[@type = 'index'],1,1))">
							<xsl:sort select="name[@type = 'index'][1]" lang="de"/>
							<xsl:sort select="person[@role='composer']/@nym"/>
							<xsl:call-template name="opusByTitle"/>
						</xsl:for-each>
						</ul>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="opusByTitle">
		<xsl:variable name="COMPOSER" select="person[@role='composer']/@nym"/>
		<li>
			<a href="opus?nym={@nym}">
				<b><xsl:value-of select="name[position() = 1]"/></b>
				<xsl:if test="$COMPOSER != ''">
					<xsl:text> (</xsl:text><xsl:value-of select="$PERSON_LIST/personListItem[@nym=$COMPOSER]/name"/><xsl:text>)</xsl:text>
				</xsl:if>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="opusByComposer">
		<li>
			<a href="opus?nym={@nym}">
				<xsl:value-of select="name[position() = 1]"/>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="opusByGenre">
		<xsl:variable name="COMPOSER" select="person[@role='composer']/@nym"/>
		<li>
			<a href="opus?nym={@nym}">
				<xsl:if test="$COMPOSER != ''">
					<xsl:text></xsl:text><xsl:value-of select="$PERSON_LIST/personListItem[@nym=$COMPOSER]/name"/><xsl:text>: </xsl:text>
				</xsl:if>
				<b><xsl:value-of select="name[position() = 1]"/></b>
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
