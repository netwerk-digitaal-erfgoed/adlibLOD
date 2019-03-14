<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<xsl:template match="record">
    <rdf:Description>
        <!-- DC identifier persistent -->
        <xsl:apply-templates select="todo"/>
        <!-- DC identifier object -->
        <xsl:apply-templates select="todo"/>
        <!-- DC title -->
        <xsl:apply-templates select="Title/title"/>
        <!-- DC creator or contributor -->
        <xsl:apply-templates select="todo"/>
        <!-- DC subject -->
        <xsl:apply-templates select="todo"/>
        <!-- DC description -->
        <xsl:apply-templates select="todo"/>
        <!-- DC date -->
        <xsl:apply-templates select="todo"/>
        <!-- DC type -->
        <xsl:apply-templates select="todo"/>
        <!-- DC format -->
        <xsl:apply-templates select="Material/material"/>
        <!-- DC rights -->
        <xsl:apply-templates select="todo"/>
        <!-- DC coverage/temporal -->
        <xsl:apply-templates select="todo"/>
        <!-- DC coverage/spatial -->
        <xsl:apply-templates select="todo"/>
    </rdf:Description>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- DC identifier persistent -->
<xsl:template match="todo">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC identifier object -->
<xsl:template match="todo">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC title -->
<xsl:template match="Title/title">
    <dc:title>
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

<!-- DC creator or contributor -->
<xsl:template match="todo">
    <xsl:choose>
        <xsl:when test="todo">
            <!-- Dublin Core creator -->
            <dc:creator>
                <xsl:value-of select="."/>
            </dc:creator>
        </xsl:when>
        <xsl:otherwise>
            <!-- Dublin Core contributor -->
            <dc:contributor>
                <xsl:value-of select="."/>
            </dc:contributor>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- DC subject -->
<xsl:template match="todo">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<!-- DC description -->
<xsl:template match="todo">
    <dc:description>
        <xsl:value-of select="."/>
    </dc:description>
</xsl:template>

<!-- DC date -->
<xsl:template match="todo">
    <dc:date>
        <xsl:value-of select="."/>
    </dc:date>
</xsl:template>

<!-- DC type -->
<xsl:template match="todo">
    <dc:type>
        <xsl:value-of select="."/>
    </dc:type>
</xsl:template>

<!-- DC format -->
<xsl:template match="Material/material">
    <dc:format>
        <xsl:value-of select="."/>
    </dc:format>
</xsl:template>

<!-- DC coverage/temporal -->
<xsl:template match="todo">
    <dct:temporal>
        <xsl:value-of select="."/>
    </dct:temporal>
</xsl:template>

<!-- DC coverage/spatial -->
<xsl:template match="todo">
    <dct:spatial>
        <xsl:value-of select="."/>
    </dct:spatial>
</xsl:template>

<!-- DC rights -->
<xsl:template match="todo">
    <dc:rights>
        <xsl:value-of select="."/>
    </dc:rights>
</xsl:template>

</xsl:stylesheet>
