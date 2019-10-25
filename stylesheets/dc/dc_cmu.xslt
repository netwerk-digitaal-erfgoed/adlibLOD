<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    >

<xsl:import href="dc.xslt"/>

<!-- overruling dc.xslt => DC creator -->
<xsl:template match="Production">
    <xsl:if test="string(creator/priref)">
        <dc:creator>
            <dct:Agent>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>agent/</xsl:text>
                    <xsl:value-of select="creator/priref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="creator/name"/>
                </rdfs:label>
                <xsl:apply-templates select="creator/url"/>
            </dct:Agent>
        </dc:creator>
    </xsl:if>
    <xsl:if test="not(string(creator/priref)) and string(creator/name)">
        <dc:creator>
            <xsl:apply-templates select="creator/name"/>
        </dc:creator>
    </xsl:if>

    <xsl:if test="string(production.place.lref)">
        <dct:spatial>
            <dct:Location>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>place/</xsl:text>
                    <xsl:value-of select="production.place.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="production.place"/>
                </rdfs:label>
            </dct:Location>                
        </dct:spatial>
    </xsl:if>
    <xsl:if test="not(string(production.place.lref)) and string(production.place)">
        <dct:spatial>
            <xsl:apply-templates select="production.place"/>
        </dct:spatial>
    </xsl:if>
</xsl:template>

<xsl:template match="url">
    <owl:sameAs>
        <xsl:attribute name="rdf:resource">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </owl:sameAs>
</xsl:template>

</xsl:stylesheet>
