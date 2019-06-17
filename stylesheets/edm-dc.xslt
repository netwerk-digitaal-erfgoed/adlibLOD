<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="baseUri">http://example.com/</xsl:param>

<!-- RDF wrap -->
<xsl:template match="record">
    <rdf:RDF>
        <edm:ProvidedCHO>
            <xsl:attribute name="rdf:about">
                <!-- Create identifier for object -->
                <xsl:value-of select="$baseUri"/>
                <xsl:text>object/</xsl:text>
                <xsl:value-of select="@priref"/>
            </xsl:attribute>
            <!-- DC identifier -->
            <xsl:apply-templates select="object_number"/>
            <!-- DC title -->
            <xsl:apply-templates select="Title"/>
            <!-- DC creator -->
            <xsl:apply-templates select="Production/creator.lref"/>
        </edm:ProvidedCHO>
        <!-- EDM agent -->
        <!-- only add maker when the same maker did not precede -->
        <xsl:for-each select="Production">
            <xsl:if test="not(creator.lref = preceding-sibling::Production/creator.lref)">
                <xsl:apply-templates select="."/>
            </xsl:if>
        </xsl:for-each>
    </rdf:RDF>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- DC identifier -->
<xsl:template match="object_number">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC title -->
<xsl:template match="Title">
    <xsl:if test="not(title.type = 'former title')">
        <dc:title>
            <xsl:value-of select="title"/>
        </dc:title>
    </xsl:if>
</xsl:template>

<!-- DC creator -->
<xsl:template match="Production/creator.lref">
    <dc:creator>
        <xsl:attribute name="rdf:resource">
            <!-- Create identifier for agent -->
            <xsl:value-of select="$baseUri"/>
            <xsl:text>agent/</xsl:text>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:creator>
</xsl:template>

<!-- EDM agent -->
<xsl:template match="Production">
    <edm:Agent>
        <xsl:attribute name="rdf:about">
            <!-- Create identifier for agent -->
            <xsl:value-of select="$baseUri"/>
            <xsl:text>agent/</xsl:text>
            <xsl:value-of select="creator.lref"/>
        </xsl:attribute>
    </edm:Agent>
</xsl:template>

</xsl:stylesheet>
