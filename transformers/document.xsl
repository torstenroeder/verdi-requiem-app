<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="html" standalone="no"/>

	<xsl:param name="GET_HIGHLIGHT"/>
	<xsl:param name="GET_INDEX"/>
	<xsl:param name="GET_VARIANTS"/>
	<xsl:param name="GET_ID"/>
	<xsl:param name="GET_FILENAME"/>

	<xsl:variable name="DOCUMENT_LIST" select="document('../indices/documentList.xml')/documentList"/>
	<xsl:variable name="TERM">
		<xsl:call-template name="toLowerCase">
			<xsl:with-param name="string" select="translate($GET_HIGHLIGHT, '+-*', '')"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:template match="document">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="header">
		<div id="status">
			<xsl:choose>
				<xsl:when test="history/publication/facsimile[@source]">
					<xsl:text>Digitalisat (extern): </xsl:text>
					<xsl:for-each select="history/publication/facsimile[@source]">
						<a href="{@source}" target="_blank">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>]</xsl:text>
						</a>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>kein Digitalisat vorhanden</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div id="tools">
			<xsl:if test="$GET_HIGHLIGHT != ''">
				<a href="document?fn={$GET_FILENAME}">× Markierung</a>
			</xsl:if>
			<xsl:if test="$GET_INDEX">
				<a href="session?indexOff">– Registerbegriffe</a>
			</xsl:if>
			<xsl:if test="not($GET_INDEX)">
				<a href="session?indexOn">+ Registerbegriffe</a>
			</xsl:if>
			<xsl:if test="$GET_VARIANTS">
				<a href="session?variantsOff">– Varianten</a>
			</xsl:if>
			<xsl:if test="not($GET_VARIANTS)">
				<a href="session?variantsOn">+ Varianten</a>
			</xsl:if>
			<a href="tei/{$GET_FILENAME}" target="_blank">◱ XML-Quelle</a>
		</div>
	</xsl:template>

	<xsl:template match="body">
		<div class="{@rend} {@font}" id="document">
			<xsl:apply-templates/>
		</div>
		<div id="biblio">
			<xsl:text>Quelle: </xsl:text>
			<xsl:value-of select="$DOCUMENT_LIST/documentListItem[@xml:id = $GET_FILENAME]/biblio"/>
		</div>
	</xsl:template>

	<xsl:template match="body//head">
		<h2 class="{@rend} {@font} {@align}">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<xsl:template match="body//p">
		<p class="{@rend} {@font} {@align}">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="body//image">
		<img class="{@align}" src="images/{@src}" title="Abbildung: {@title}"/>
	</xsl:template>

	<xsl:template match="body//date">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>date</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Datum</xsl:text>
			</xsl:attribute>
			<!--
			<xsl:attribute name="href">
				<xsl:value-of select="concat('date?nym=',@nym)"/>
			</xsl:attribute>
			-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//event">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
			</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">
					<xsl:if test="$GET_INDEX">
						<xsl:text>event</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="concat('event?nym=', @nym)"/>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:text>Ereignis</xsl:text>
				</xsl:attribute>
				<xsl:text>｢</xsl:text>
				<!-- HALFWIDTH LEFT CORNER BRACKET (U+FF62) -->
			</xsl:element>
			<xsl:apply-templates/>
			<xsl:element name="a">
				<xsl:attribute name="class">
					<xsl:if test="$GET_INDEX">
						<xsl:text>event</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="concat('event?nym=', @nym)"/>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:text>Ereignis</xsl:text>
				</xsl:attribute>
				<xsl:text>｣</xsl:text>
				<!-- HALFWIDTH RIGHT CORNER BRACKET (U+FF63) -->
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//person">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>person</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('person?nym=', @nym)"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Person</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//place">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>place</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('place?nym=', @nym)"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Ort</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//opus">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>opus</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('opus?nym=', @nym)"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Werk</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//org">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>org</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('org?nym=', @nym)"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Körperschaft</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//text">
		<xsl:element name="a">
			<xsl:attribute name="class">
				<xsl:if test="$GET_INDEX">
					<xsl:text>text</xsl:text>
				</xsl:if>
				<xsl:if test="@nym = $GET_HIGHLIGHT"> highlight</xsl:if>
				<xsl:if test="@rend">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
				<xsl:if test="@font">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@font"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat('document?fn=', @href)"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:text>Textbezug</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="body//g">
		<span title="Sonderzeichen: {@desc}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<xsl:template match="body//hi">
		<!-- typographische Behandlung von Sperrungen -->
		<xsl:choose>
			<xsl:when test="contains(@rend, 'widespace')">
				<xsl:variable name="charBefore"
					select="substring(preceding-sibling::text()[1], string-length(preceding-sibling::text()[1]))"/>
				<xsl:variable name="charAfter" select="substring(following-sibling::text(), 1, 1)"/>
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@font"/>
						<xsl:text> </xsl:text>
						<!-- widespaceBefore bei vorausgehendem Spatium -->
						<xsl:if test="contains(' ', $charBefore)">
							<xsl:text> widespaceBefore</xsl:text>
						</xsl:if>
						<!-- noWidespaceAfter bei anschließenden (kleinen) Satzzeichen -->
						<xsl:if test="contains(',.“', $charAfter)">
							<xsl:text> noWidespaceAfter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<span class="{@rend} {@font}">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="body//choice">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="body//choice/sic">
		<span title="sic">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="body//choice/corr">
		<xsl:if test="$GET_VARIANTS">
			<span class="corr" title="recte">
				<xsl:text>[</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>]</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="body//gap">
		<xsl:if test="1 = 1">
			<span class="gap" title="Auslassung">
				<xsl:text>[...]</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="body//del">
		<xsl:if test="$GET_VARIANTS">
			<span class="del" title="überflüssiger Text">
				<!--<xsl:text>[</xsl:text>-->
				<xsl:apply-templates/>
				<!--<xsl:text>]</xsl:text>-->
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="body//add">
		<span class="add" title="fehlender Text">
			<xsl:if test="$GET_VARIANTS">
				<xsl:text>[</xsl:text>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="$GET_VARIANTS">
				<xsl:text>]</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="body//pb">
		<xsl:if test="1 = 1">
			<span class="pb" title="Seitenumbruch">
				<xsl:text>/</xsl:text>
				<xsl:apply-templates select="@n"/>
				<xsl:text>/</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="body//cb">
		<xsl:if test="1 = 1">
			<span class="cb" title="Spaltenumbruch">
				<xsl:text>|</xsl:text>
				<xsl:apply-templates select="@n"/>
				<xsl:text>|</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="body//lb">
		<br/>
	</xsl:template>

	<xsl:template match="body//note">
		<span class="note">
			<sup class="noteAnchor">
				<xsl:number level="any"/>
			</sup>
			<span class="noteContent">
				<span class="noteContentAnchor"><xsl:number level="any"/>)</span>
				<span class="noteContentText">
					<xsl:apply-templates/>
				</span>
			</span>
		</span>
	</xsl:template>

	<xsl:template match="body//text()">
		<xsl:choose>
			<xsl:when test="$TERM != ''">
				<xsl:variable name="TEXT">
					<xsl:call-template name="toLowerCase">
						<xsl:with-param name="string" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains($TEXT, $TERM)">
						<xsl:variable name="START"
							select="string-length(substring-before($TEXT, $TERM))"/>
						<xsl:value-of select="substring(., 1, $START)"/>
						<span class="highlight">
							<xsl:value-of select="substring(., $START + 1, string-length($TERM))"/>
						</span>
						<xsl:value-of select="substring(., $START + string-length($TERM) + 1)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template name="toLowerCase">
		<xsl:param name="string"/>
		<xsl:value-of select="translate($string, $uppercase, $lowercase)"/>
	</xsl:template>

</xsl:stylesheet>
