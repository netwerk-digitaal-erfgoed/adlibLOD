<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<!--xsl:strip-space elements="*"/-->

<xsl:param name="baseUri">http://example.com/</xsl:param>
<xsl:param name="imageUrl">http://example.image.com/</xsl:param>

<!-- NB: use EDM if you need a visual representation -->

<!-- RDF wrap -->
<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>
    </rdf:RDF>
</xsl:template>

<!-- RDF:Description ==> dct:PhysicalResource -->
<xsl:template match="record">
    <dct:PhysicalResource>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>object/</xsl:text>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>

        <!-- DC identifier -->
        <xsl:apply-templates select="object_number"/>

        <!-- DC title -->
        <xsl:apply-templates select="Title"/>

        <!-- DC creator & DCT spatial & DC Publisher -->
        <xsl:apply-templates select="Production"/>

        <!-- DC subject -->
        <xsl:apply-templates select="Associated_subject"/>

        <!-- DC description -->
        <xsl:apply-templates select="Description"/>
        <xsl:apply-templates select="physical_description"/>

        <!-- DC type -->
        <xsl:apply-templates select="Object_name"/>

        <!-- DCT medium -->
        <xsl:apply-templates select="Material"/>

        <!-- DC language -->
        <!-- Language of the resource not available in source -->

        <!-- DC Terms created -->
        <xsl:apply-templates select="Production_date"/>

        <!-- DC Terms temporal -->
        <xsl:apply-templates select="production.period"/>

        <!-- DC Terms extent -->
        <xsl:apply-templates select="Dimension"/>

        <!-- DC relation -->
        <xsl:apply-templates select="Related_object"/>

        <!-- DC Terms has part -->
        <xsl:apply-templates select="Parts"/>

        <!-- DC Terms is part of -->
        <xsl:apply-templates select="Part_of"/>

    </dct:PhysicalResource>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- general -->
<!-- TODO: handle multilanguage sourcesystem -->
<!-- if different languages are stored in the database, the different languages are separated with "value" -->
<xsl:template match="value">
    <xsl:value-of select="."/>
</xsl:template>

<!-- DC identifier -->
<xsl:template match="object_number">
    <xsl:if test="string(object_number)">
        <dc:identifier>
            <xsl:value-of select="."/>
        </dc:identifier>
    </xsl:if>
</xsl:template>

<!-- DC title -->
<xsl:template match="Title">
    <xsl:if test="not(title.type = 'former title') and string(title)">
        <dc:title>
            <xsl:apply-templates select="title"/>
        </dc:title>
    </xsl:if>
</xsl:template>

<xsl:template match="title">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC creator -->
<xsl:template match="Production">
    <xsl:choose>
        <xsl:when test="creator.role = 'publisher'">
            <xsl:if test="string(creator.lref)">
                <dc:publisher>
                    <dct:Agent>
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$baseUri"/>
                            <xsl:text>agent/</xsl:text>
                            <xsl:value-of select="creator.lref"/>
                        </xsl:attribute>
                        <rdfs:label>
                            <xsl:apply-templates select="creator"/>
                        </rdfs:label>
                    </dct:Agent>
                </dc:publisher>
            </xsl:if>
            <xsl:if test="not(string(creator.lref)) and string(creator)">
                <dc:publisher>
                    <xsl:apply-templates select="creator"/>
                </dc:publisher>
            </xsl:if>
        </xsl:when>

        <xsl:otherwise>
            <xsl:if test="string(creator.lref)">
                <dc:creator>
                    <dct:Agent>
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$baseUri"/>
                            <xsl:text>agent/</xsl:text>
                            <xsl:value-of select="creator.lref"/>
                        </xsl:attribute>
                        <rdfs:label>
                            <xsl:apply-templates select="creator"/>
                        </rdfs:label>
                    </dct:Agent>
                </dc:creator>
            </xsl:if>
            <xsl:if test="not(string(creator.lref)) and string(creator)">
                <dc:creator>
                    <xsl:apply-templates select="creator"/>
                </dc:creator>
            </xsl:if>
        </xsl:otherwise>

    </xsl:choose>

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

<xsl:template match="creator">    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="production.place">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC subject = Associated subject-->
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
                <xsl:text>concept/</xsl:text>
            </xsl:when>
            <xsl:when test="association.subject.type/value[@lang='neutral'] = 'GEOKEYW'">
                <xsl:text>place/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>concept/</xsl:text>
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
                    <xsl:apply-templates select="association.subject"/>
                </rdfs:label>
            </rdf:Description>
        </dc:subject>
    </xsl:if>
    <xsl:if test="not(string(association.subject.lref)) and string(association.subject)">
        <dc:subject>
            <xsl:apply-templates select="association.subject"/>
        </dc:subject>
    </xsl:if>

</xsl:template>

<xsl:template match="association.subject">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC subject = Content subject-->
<xsl:template match="Content_subject">
    <xsl:param name="type">
        <xsl:choose>
            <xsl:when test="content.subject.type/value[@lang='neutral'] = 'EVENT'">
                <xsl:text>event/</xsl:text>
            </xsl:when>
            <xsl:when test="content.subject.type/value[@lang='neutral'] = 'OBJECT'">
                <xsl:text>object/</xsl:text>
            </xsl:when>
            <xsl:when test="content.subject.type/value[@lang='neutral'] = 'SUBJECT'">
                <xsl:text>concept/</xsl:text>
            </xsl:when>
            <xsl:when test="content.subject.type/value[@lang='neutral'] = 'GEOKEYW'">
                <xsl:text>place/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>concept/</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:if test="string(content.subject.lref)">
        <dc:subject>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:value-of select="$type"/>
                    <xsl:value-of select="content.subject.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="content.subject"/>
                </rdfs:label>
            </rdf:Description>
        </dc:subject>
    </xsl:if>
    <xsl:if test="not(string(content.subject.lref)) and string(content.subject)">
        <dc:subject>
            <xsl:apply-templates select="content.subject"/>
        </dc:subject>
    </xsl:if>
</xsl:template>

<xsl:template match="content.subject">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC subject = Associated person-->
<xsl:template match="Associated_person">
    <xsl:if test="string(association.person.lref)">
        <dc:subject>
            <dct:Agent>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>agent/</xsl:text>
                    <xsl:value-of select="association.person.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="association.person"/>
                </rdfs:label>
            </dct:Agent>
        </dc:subject>
    </xsl:if>
    <xsl:if test="not(string(association.person.lref)) and string(association.person)">
        <dc:subject>
            <xsl:apply-templates select="association.person"/>
        </dc:subject>
    </xsl:if>
</xsl:template>

<xsl:template match="association.person">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC subject = Content person-->
<xsl:template match="Content_person">
    <xsl:if test="string(content.person.lref)">
        <dc:subject>
            <dct:Agent>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>agent/</xsl:text>
                    <xsl:value-of select="content.person.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="content.person"/>
                </rdfs:label>
            </dct:Agent>
        </dc:subject>
    </xsl:if>
    <xsl:if test="not(string(content.person.lref)) and string(content.person)">
        <dc:subject>
            <xsl:apply-templates select="content.person"/>
        </dc:subject>
    </xsl:if>
</xsl:template>

<xsl:template match="content.person">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC description -->
<xsl:template match="Description">
    <xsl:if test="string(description)">
        <dc:description>
            <xsl:apply-templates select="description"/>
        </dc:description>
    </xsl:if>
</xsl:template>

<xsl:template match="description">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC description -->
<xsl:template match="physical_description">
    <xsl:if test="string(physical_description)">
        <dc:description>
            <xsl:apply-templates/>
        </dc:description>
    </xsl:if>
</xsl:template>

<!-- DC type -->
<xsl:template match="Object_name">

    <xsl:if test="string(object_name.lref)">
        <dc:type>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>concept/</xsl:text>
                    <xsl:value-of select="object_name.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="object_name"/>
                </rdfs:label>
            </rdf:Description>
        </dc:type>
    </xsl:if>
    <xsl:if test="not(string(object_name.lref)) and string(object_name)">
        <dc:type>
            <xsl:apply-templates select="object_name"/>
        </dc:type>
    </xsl:if>
</xsl:template>

<xsl:template match="object_name">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DCT medium -->
<xsl:template match="Material">

    <xsl:if test="string(material.lref)">
        <dct:medium>
            <dct:PhysicalMedium>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>concept/</xsl:text>
                    <xsl:value-of select="material.lref"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:apply-templates select="material"/>
                </rdfs:label>
            </dct:PhysicalMedium>
        </dct:medium>
    </xsl:if>
    <xsl:if test="not(string(material.lref)) and string(material)">
        <dct:medium>
            <xsl:apply-templates select="material"/>
        </dct:medium>
    </xsl:if>
</xsl:template>

<xsl:template match="material">    
    <xsl:apply-templates/>
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
    <!-- TODO: create resource of type dc:PeriodOfTime -->
    <dct:temporal>
        <xsl:apply-templates select="."/>
    </dct:temporal>
</xsl:template>

<xsl:template match="production.period">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC Terms extent -->
<xsl:template match="Dimension">
    <dct:extent>
        <xsl:if test="string(dimension.part)">
            <xsl:value-of select="dimension.part"/>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="dimension.type"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:apply-templates select="dimension.value"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:apply-templates select="dimension.unit"/>
    </dct:extent>
</xsl:template>

<xsl:template match="dimension.type">    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dimension.value">    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dimension.unit">    
    <xsl:apply-templates/>
</xsl:template>

<!-- DC relation -->
<xsl:template match="Related_object">
    <xsl:if test="string(related_object.association.lref)">
        <dc:relation>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="$baseUri"/>
                <xsl:text>object/</xsl:text>
                <xsl:value-of select="related_object.association.lref"/>
            </xsl:attribute>
        </dc:relation>
    </xsl:if>
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
