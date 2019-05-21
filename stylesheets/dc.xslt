<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dcterms="http://purl.org/dc/terms/">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<xsl:template match="record">
    <rdf:Description>
        <xsl:attribute name="rdf:about">
            <xsl:text>http://lodp-web.adlibhosting.com/priref/</xsl:text>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>
        <!-- DC title -->
        <xsl:apply-templates match="Title/title"/>
    </rdf:Description>
</xsl:template>

<!-- DC title -->
<xsl:template match="Title/title">
    <dc:title>
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

</xsl:stylesheet>
