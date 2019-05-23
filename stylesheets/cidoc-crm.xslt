<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<xsl:template match="record">
    <crm:E22_Man-Made_Object>
        <xsl:attribute name="rdf:about">
            <xsl:text>http://lodp-web.adlibhosting.com/priref/</xsl:text>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>
        <!-- DC identifier -->
        <xsl:apply-templates select="object_number"/>
        <!-- DC title -->
        <xsl:apply-templates select="Title/title"/>
    </crm:E22_Man-Made_Object>
</xsl:template>

<!-- DC identifier -->
<xsl:template match="object_number">
    <crm:P1_is_identified_by>
        <xsl:value-of select="."/>
    </crm:P1_is_identified_by>
</xsl:template>

<!-- DC title -->
<xsl:template match="Title/title">
    <crm:P102_has_title>
        <xsl:value-of select="."/>
    </crm:P102_has_title>
</xsl:template>

</xsl:stylesheet>
