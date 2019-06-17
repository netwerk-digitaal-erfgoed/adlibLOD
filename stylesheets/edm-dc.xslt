<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/">
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
            <!-- DC subject -->
            <xsl:apply-templates select="Associated_subject/association.subject.lref"/>
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

<!-- DC subject -->
<xsl:template match="Associated_subject/association.subject.lref">
    <xsl:if test="string(.)">
        <dc:subject>
            <xsl:choose>
                <xsl:when test="../association.subject.type/value[@lang='neutral'] = 'EVENT'">
                    <xsl:attribute name="rdf:resource">
                        <!-- Create identifier for event -->
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>event/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="../association.subject.type/value[@lang='neutral'] = 'OBJECT'">
                    <xsl:attribute name="rdf:resource">
                        <!-- Create identifier for object -->
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>object/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="../association.subject.type/value[@lang='neutral'] = 'SUBJECT'">
                    <xsl:attribute name="rdf:resource">
                        <!-- Create identifier for concept -->
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>concept/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="../association.subject.type/value[@lang='neutral'] = 'GEOKEYW'">
                    <xsl:attribute name="rdf:resource">
                        <!-- Create identifier for place -->
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>place/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rdf:resource">
                        <!-- Create identifier for concept -->
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>concept/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </dc:subject>
    </xsl:if>
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
        <!-- SKOS preferred label -->
        <xsl:apply-templates select="creator"/>
        <!-- rdaGr2 date of birth -->
        <xsl:apply-templates select="creator.date_of_birth"/>
        <!-- rdaGr2 date of death -->
        <xsl:apply-templates select="creator.date_of_death"/>
    </edm:Agent>
</xsl:template>

<!-- rdaGr2 date of birth -->
<xsl:template match="creator.date_of_birth">
    <xsl:if test="string(.)">
        <rdaGr2:dateOfBirth>
            <xsl:value-of select="."/>
        </rdaGr2:dateOfBirth>
    </xsl:if>
</xsl:template>

<!-- rdaGr2 date of death -->
<xsl:template match="creator.date_of_death">
    <xsl:if test="string(.)">
        <rdaGr2:dateOfDeath>
            <xsl:value-of select="."/>
        </rdaGr2:dateOfDeath>
    </xsl:if>
</xsl:template>

<!-- SKOS preferred label -->
<xsl:template match="creator">
    <xsl:if test="string(.)">
        <skos:prefLabel>
            <xsl:value-of select="."/>
        </skos:prefLabel>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
