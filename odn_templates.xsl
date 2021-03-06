<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:oai-pmh="http://www.openarchives.org/OAI/2.0/"
  xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/" xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xsi:schemaLocation="http://worldcat.org/xmlschemas/qdc-1.0/
  http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd
  http://purl.org/net/oclcterms
  http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd"
  exclude-result-prefixes="xs" version="2.0" xmlns="http://worldcat.org/xmlschemas/qdc-1.0/">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  
  <!-- This stylesheet processes standard qualified Dublin Core fields from standard oai_qdc OAI feeds. -->
  
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  
  <!-- use the URL dc:identifier to both populate edm:isShownAt and use known
    cDm thumbnail path to construct thumbnail URL for edm:preview -->
  <xsl:template match="dc:identifier" mode="odn">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://')">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:variable name="cdm_root" select="substring-before(., '/cdm/ref/')"/>
          <xsl:variable name="record_info" select="substring-after(., '/collection/')"/>
          <xsl:variable name="alias" select="substring-before($record_info, '/id/')"/>
          <xsl:variable name="pointer" select="substring-after($record_info, '/id/')"/>
          <xsl:value-of select="concat($cdm_root, '/utils/getthumbnail/collection/', $alias, '/id/', $pointer)"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <!-- cDM passes multiple subjects separated by semicolons; split them out and
    copy them to dcterms:subject -->
  <xsl:template match="dc:subject" mode="odn">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="dcterms:alternative" mode="odn">
    <xsl:copy-of select="normalize-space(.)"/>
  </xsl:template>
  
  <!-- use dc:relation for dcterms:isPartOf (collection) -->
  <xsl:template match="dc:relation" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:isPartOf"><xsl:value-of select="."/></xsl:element>
  </xsl:template>
  
  <!-- most of the follwing simply copy the dc: element to the corresponding
        dcterms: element as specified in ODN MAP -->
  
  <xsl:template match="dc:creator" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:creator">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:description" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:description">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dc:language" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dc:title" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:title">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dc:publisher" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:publisher">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dc:rights" mode="odn">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http')">
        <xsl:choose>
          <xsl:when test="contains(., '|')">
            <xsl:element name="edm:rights"><xsl:value-of select="normalize-space(substring-before(., ' |'))"/></xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="edm:rights"><xsl:value-of select="normalize-space(.)"/></xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'in copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'no copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'no known copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'copyright undetermined')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'copyright not evaluated')"/>
          <xsl:otherwise>
            <xsl:element namespace="http://purl.org/dc/elements/1.1/" name="dc:rights">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>