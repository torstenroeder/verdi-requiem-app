<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="chartDiv">
		<div id="chartDiv"/>
	</xsl:template>
	
	<xsl:template name="globalChartOptions"> fontName: 'Georgia, serif', backgroundColor:
		'white', chartArea: {width:'75%',height:'75%'}, </xsl:template>
	
	<xsl:template name="formattedDate">
		<!-- TODO dies noch vereinfachen mit Subtemplate -->
		<xsl:choose>
			<!-- WHEN -->
			<xsl:when test="date/@when">
				<xsl:if test="string-length(date/@when) = 10">
					<xsl:value-of select="substring(date/@when,9,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@when,6,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@when,1,4)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@when) = 7">
					<xsl:value-of select="substring(date/@when,1,4)"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(date/@when,6,2)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@when) = 4">
					<xsl:value-of select="substring(date/@when,1,4)"/>
				</xsl:if>
			</xsl:when>
			<!-- notBefore -->
			<xsl:when test="date/@notBefore and not(date/@notAfter)">
				<xsl:text>frühestens </xsl:text>
				<xsl:if test="string-length(date/@notBefore) = 10">
					<xsl:text>am </xsl:text>
					<xsl:value-of select="substring(date/@notBefore,9,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,6,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notBefore) = 7">
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,6,2)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notBefore) = 4">
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
				</xsl:if>
			</xsl:when>
			<!-- notAfter -->
			<xsl:when test="date/@notAfter and not(date/@notBefore)">
				<xsl:text>spätestens </xsl:text>
				<xsl:if test="string-length(date/@notAfter) = 10">
					<xsl:text>am </xsl:text>
					<xsl:value-of select="substring(date/@notAfter,9,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,6,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notAfter) = 7">
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,6,2)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notAfter) = 4">
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
				</xsl:if>
			</xsl:when>
			<!-- notBefore/notAfter -->
			<xsl:when test="date/@notAfter and date/@notBefore">
				<xsl:text>zwischen </xsl:text>
				<xsl:if test="string-length(date/@notBefore) = 10">
					<xsl:text>dem </xsl:text>
					<xsl:value-of select="substring(date/@notBefore,9,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,6,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notBefore) = 7">
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(date/@notBefore,6,2)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notBefore) = 4">
					<xsl:value-of select="substring(date/@notBefore,1,4)"/>
				</xsl:if>
				<xsl:text> und </xsl:text>
				<xsl:if test="string-length(date/@notAfter) = 10">
					<xsl:text>dem </xsl:text>
					<xsl:value-of select="substring(date/@notAfter,9,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,6,2)"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notAfter) = 7">
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="substring(date/@notAfter,6,2)"/>
				</xsl:if>
				<xsl:if test="string-length(date/@notAfter) = 4">
					<xsl:value-of select="substring(date/@notAfter,1,4)"/>
				</xsl:if>
			</xsl:when>
			<!-- keine Angaben -->
			<xsl:otherwise>
				<xsl:text>unbekanntes Datum</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Annotation -->
		<xsl:if test="date/. != ''">
			<xsl:text> (</xsl:text>
			<xsl:value-of select="date/."/>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="personLifespan">
		<xsl:if test="not(death)">
			<xsl:text>*</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="birth = ''">
				<xsl:value-of select="birth/@when"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="birth"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="birth and death">
			<xsl:text>–</xsl:text>
		</xsl:if>
		<xsl:if test="not(birth)">
			<xsl:text>†</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="death = ''">
				<xsl:value-of select="death/@when"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="death"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="external">
	<xsl:if test="resource or id">
		<div id="external">
			<h2>siehe auch ...</h2>
			<ul id="links">
				<xsl:call-template name="resources"/>
				<xsl:call-template name="ids"/>
			</ul>
			</div> <!-- #external -->
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="resources">
		<xsl:for-each select="resource">
			<xsl:choose>
				<xsl:when test="@type='de.wikipedia.org'">
					<li><a href="http://de.wikipedia.org/wiki/{.}" target="_blank">Wikipedia (DE)</a></li>
				</xsl:when>
				<xsl:when test="@type='en.wikipedia.org'">
					<li><a href="http://en.wikipedia.org/wiki/{.}" target="_blank">Wikipedia (EN)</a></li>
				</xsl:when>
				<xsl:when test="@type='it.wikipedia.org'">
					<li><a href="http://it.wikipedia.org/wiki/{.}" target="_blank">Wikipedia (IT)</a></li>
				</xsl:when>
				<xsl:when test="@type='fr.wikipedia.org'">
					<li><a href="http://fr.wikipedia.org/wiki/{.}" target="_blank">Wikipedia (FR)</a></li>
				</xsl:when>
				<xsl:when test="@type='sv.wikipedia.org'">
					<li><a href="http://sv.wikipedia.org/wiki/{.}" target="_blank">Wikipedia (SV)</a></li>
				</xsl:when>
				<xsl:when test="@type='anno.onb.ac.at'">
					<li><a href="http://anno.onb.ac.at/info/{.}_info.htm" target="_blank" title="AustriaN Newspapers Online">ANNO</a></li>
				</xsl:when>
				<xsl:when test="@type='bmlo.lmu.de'">
					<li><a href="http://www.bmlo.lmu.de/{.}" target="_blank" title="Bayerisches Musiker-Lexikon Online">BMLO</a></li>
				</xsl:when>
				<xsl:when test="@type='deutsche-biographie.de'">
					<li><a href="http://www.deutsche-biographie.de/{.}.html" target="_blank">Deutsche Biographie</a></li>
				</xsl:when>
				<!-- just plain weblinks -->
				<xsl:when test="@type='weblink'">
					<li>
						<a href="{.}" target="_blank">
							<xsl:choose>
								<xsl:when test="@title">
									<xsl:value-of select="@title"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</li>
				</xsl:when>
				<xsl:when test="@type='book'">
					<li><xsl:value-of select="."/></li>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ids">
		<xsl:for-each select="id">
			<xsl:choose>
				<xsl:when test="@authority='gnd'">
					<li><a href="http://d-nb.info/gnd/{.}" target="_blank" title="Gemeinsame Normdatei">GND</a></li>
				</xsl:when>
				<xsl:when test="@authority='lccn'">
					<li><a href="http://lccn.loc.gov/{.}" target="_blank" title="Library of Congress Control Number">LCCN</a></li>
				</xsl:when>
				<xsl:when test="@authority='viaf'">
					<li><a href="http://viaf.org/viaf/{.}" target="_blank" title="Virtual International Authority File">VIAF</a></li>
				</xsl:when>
				<xsl:when test="@authority='iccu'">
					<li><a href="http://id.sbn.it/af/IT\ICCU\{.}" target="_blank" title="Istituto Centrale per il Catalogo Unico">ICCU</a></li>
				</xsl:when>
				<xsl:when test="@authority='zdb'">
					<li><a href="http://dispatch.opac.d-nb.de/DB=1.1/SET=13/TTL=4/CMD?ACT=SRCHA&amp;IKT=8506&amp;TRM={.}" target="_blank" title="Zeitschriftendatenbank">ZDB</a></li>
				</xsl:when>
				<xsl:when test="@authority='geonames.org'">
					<li><a href="http://geonames.org/{.}" target="_blank">geonames.org</a></li>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>