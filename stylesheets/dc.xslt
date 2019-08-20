<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="baseUri">http://example.com/</xsl:param>
<xsl:param name="imageUrl">http://example.image.com/</xsl:param>
<!--xsl:param name="provider">museum</xsl:param>
<xsl:param name="language">en</xsl:param-->

<!-- DISCUSS: hard to determine which language is used -->
<!-- DISCUSS HOWTO handle empty elements? -->

<!-- RDF wrap -->
<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>
    </rdf:RDF>
</xsl:template>

<!-- RDF -->
<xsl:template match="record">
    <rdf:Description>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>object/</xsl:text>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>

        <!-- DC identifier -->
        <xsl:apply-templates select="object_number"/>

        <!-- DC title -->
        <xsl:apply-templates select="Title"/>

        <!-- DC creator -->
        <!-- DCT spatial -->
        <xsl:apply-templates select="Production"/>

        <!-- DC subject -->
        <xsl:apply-templates select="Associated_subject"/>
        <!-- DISCUSS: other subjects? -->
        <!--xsl:apply-templates select="Content_person"/-->
        <!--xsl:apply-templates select="Content_subject"/-->
        <!--xsl:apply-templates select="Associated_period"/-->
        <!--xsl:apply-templates select="Associated_person"/-->

        <!-- DC description -->
        <xsl:apply-templates select="Description"/>
        <!-- DISCUSS other descriptions? -->
        <!--xsl:apply-templates select="physical_description"/-->
        <!--xsl:apply-templates select="notes"/-->

        <!-- DC type -->
        <xsl:apply-templates select="Object_name"/>

        <!-- DC format -->
        <xsl:apply-templates select="Material"/>

        <!-- DC language -->
        <!-- DISCUSS: shouldn't this be the language of the object ? -->
        <!--dc:language>
            <xsl:value-of select="$language"/>
        </dc:language-->

        <!-- DC publisher -->
        <!-- DISCUSS: shouldn't this be the publisher of the object ? -->
        <!--dc:publisher>
            <xsl:value-of select="$provider"/>
        </dc:publisher -->

        <!-- DC Terms created -->
        <!-- DISCUSS: DC date? both or choose? -->
        <xsl:apply-templates select="Production_date"/>

        <!-- DC Terms temporal -->
        <xsl:apply-templates select="production.period"/>

        <!-- DC Terms extent -->
        <xsl:apply-templates select="Dimension"/>

        <!-- DC relation -->
        <xsl:apply-templates select="Related_object"/>

        <!-- DC Terms has part -->
        <!-- DISCUSS: no example in testset? -->
        <!-- <xsl:apply-templates select="Parts"/> -->

        <!-- DC Terms is part of -->
        <xsl:apply-templates select="Part_of"/>

    </rdf:Description>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- DC identifier -->
<xsl:template match="object_number[node()]">
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
<xsl:template match="Production">
    <xsl:if test="string(creator.lref)">
        <dc:creator>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>agent/</xsl:text>
                    <xsl:value-of select="creator.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="creator"/>
                </rdfs:label>
            </rdf:Description>
        </dc:creator>
    </xsl:if>
    <xsl:if test="string(production.place.lref)">
        <dct:spatial>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>place/</xsl:text>
                    <xsl:value-of select="production.place.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="production.place"/>
                </rdfs:label>
            </rdf:Description>                
        </dct:spatial>
    </xsl:if>
</xsl:template>

<!-- DC subject -->
<xsl:template match="Associated_subject">
    <xsl:param name="type">
        <xsl:choose>
            <xsl:when test="association.subject.type/value[@lang='neutral'] = 'EVENT'">
                <xsl:text>event/</xsl:text>
            </xsl:when>
            <xsl:when test="association.subject.type/value[@lang='neutral'] = 'OBJECT'">
                <xsl:text>object/</xsl:text>
            </xsl:when>
            <xsl:when test="association.subject.type/value[@lang='neutral'] = 'SUBJECT'">
                <xsl:text>concept1/</xsl:text>
            </xsl:when>
            <xsl:when test="association.subject.type/value[@lang='neutral'] = 'GEOKEYW'">
                <xsl:text>place/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>concept2/</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:if test="string(association.subject.lref)">
        <dc:subject>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="$type"/>
                    <xsl:value-of select="association.subject.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="association.subject"/>
                </rdfs:label>
            </rdf:Description>
        </dc:subject>
    </xsl:if>
</xsl:template>

<!-- DC description -->
<xsl:template match="Description">
    <xsl:if test="string(description)">
        <dc:description>
            <xsl:value-of select="description"/>
        </dc:description>
    </xsl:if>
</xsl:template>

<!-- DC type -->
<xsl:template match="Object_name">
    <dc:type>
        <xsl:attribute name="rdf:resource">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>concept3/</xsl:text>
            <xsl:value-of select="object_name.lref"/>
        </xsl:attribute>
    </dc:type>
</xsl:template>

<!-- DC format -->
<xsl:template match="Material">
    <dc:format>
        <xsl:attribute name="rdf:resource">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>concept4/</xsl:text>
            <xsl:value-of select="material.lref"/>
        </xsl:attribute>
    </dc:format>
</xsl:template>

<!-- DC Terms created -->
<xsl:template match="Production_date">
    <xsl:choose>
        <xsl:when test="production.date.start = production.date.end">
            <dct:created>
                <xsl:if test="string(production.date.start.prec)">
                    <xsl:value-of select="production.date.start.prec"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="production.date.start"/>
            </dct:created>
        </xsl:when>
        <xsl:otherwise>
            <dct:created>
                <xsl:if test="string(production.date.start.prec)">
                    <xsl:value-of select="production.date.start.prec" />
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="production.date.start"/>
                <xsl:if test="string(production.date.end)">
                    <xsl:text>&#160;-&#160;</xsl:text>
                    <xsl:if test="string(production.date.end.prec)">
                        <xsl:value-of select="production.date.end.prec" />
                        <xsl:text>&#160;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="production.date.end"/>
                </xsl:if>
            </dct:created>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- DC Terms temporal -->
<xsl:template match="production.period">
    <!-- DISCUSS: make resource? what type? -->
    <dct:temporal>
        <xsl:value-of select="."/>
    </dct:temporal>
</xsl:template>

<!-- DC Terms extent -->
<xsl:template match="Dimension">
    <dct:extent>
        <xsl:if test="string(dimension.part)">
            <xsl:value-of select="dimension.part"/>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:value-of select="dimension.type"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.value"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.unit"/>
    </dct:extent>
</xsl:template>

<!-- DC relation -->
<xsl:template match="Related_object">
    <dc:relation>
        <xsl:attribute name="rdf:resource">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>object/</xsl:text>
            <xsl:value-of select="related_object.association.lref"/>
        </xsl:attribute>
    </dc:relation>
</xsl:template>

<!-- DC Terms is part of -->
<xsl:template match="Part_of">
    <xsl:if test="string(part_of_reference.lref)">
        <dct:isPartOf>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="$baseUri"/>
                <xsl:text>object/</xsl:text>
                <xsl:value-of select="part_of_reference.lref"/>
            </xsl:attribute>
        </dct:isPartOf>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
