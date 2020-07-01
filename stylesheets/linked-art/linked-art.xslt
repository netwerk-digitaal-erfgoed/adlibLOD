<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<!--xsl:strip-space elements="*"/-->

<xsl:param name="baseUri">http://example.com/data/</xsl:param>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<xsl:template match="record">
    <crm:E22_Human-Made_Object>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$baseUri"/>
            <xsl:text>object/</xsl:text>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>

        <!-- type -->
        <xsl:apply-templates select="Object_name"/>

        <!-- identifier -->
        <xsl:apply-templates select="object_number">
            <xsl:with-param name="priref" select="@priref"/>
        </xsl:apply-templates>

        <!-- title -->
        <xsl:apply-templates select="Title/title">
            <xsl:with-param name="priref" select="@priref"/>
        </xsl:apply-templates>

        <!-- current owner -->
        <xsl:apply-templates select="institution.name"/>

        <!-- Production -->
        <crm:P108i_was_produced_by>
            <crm:E12_Production>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>production/</xsl:text>
                    <xsl:value-of select="@priref"/>
                </xsl:attribute>
                <crm:P4_has_time-span>
                    <crm:E52_Time-Span>
                        <xsl:apply-templates select="Production_date/production.date.start"/>
                        <xsl:apply-templates select="Production_date/production.date.end"/>
                    </crm:E52_Time-Span>
                </crm:P4_has_time-span>
                <xsl:apply-templates select="Production"/>
            </crm:E12_Production>
        </crm:P108i_was_produced_by>

        <!-- Dimension -->
        <xsl:apply-templates select="Dimension"/>

        <!-- Material -->
        <xsl:apply-templates select="Material"/>

    </crm:E22_Human-Made_Object>

    
</xsl:template>

<!-- type -->
<xsl:template match="Object_name">
    <xsl:if test="string(object_name.lref) or string(object_name)">
        <crm:P2_has_type>
            <crm:E55_Type>
                 <xsl:if test="string(object_name.lref)">
                     <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>concept/</xsl:text>
                        <xsl:value-of select="object_name.lref"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string(object_name)">
                    <rdfs:label>
                        <xsl:value-of select="object_name"/>
                    </rdfs:label>
                </xsl:if>
            </crm:E55_Type>
        </crm:P2_has_type>
    </xsl:if>
</xsl:template>

<xsl:template match="object_name">    
    <xsl:apply-templates/>
</xsl:template>

<!-- identifier -->
<xsl:template match="object_number">
    <xsl:param name="priref"/>
    <xsl:if test="string(.)">
        <crm:P1_is_identified_by>
             <crm:E42_Identifier>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>identifier/</xsl:text>
                    <xsl:value-of select="$priref"/>
                </xsl:attribute>
                <crm:P2_has_type>
                  <crm:E55_Type rdf:about="http://vocab.getty.edu/aat/300312355">
                    <rdfs:label>accession numbers</rdfs:label>
                  </crm:E55_Type>
                </crm:P2_has_type>
                <crm:P190_has_symbolic_content>
                    <xsl:value-of select="."/>
                </crm:P190_has_symbolic_content>
            </crm:E42_Identifier>
        </crm:P1_is_identified_by>
    </xsl:if>
</xsl:template>

<!-- title -->
<xsl:template match="Title/title">
    <xsl:param name="priref"/>
    <xsl:if test="string(.)">
        <crm:P1_is_identified_by>
            <crm:E33_E41_Linguistic_Appellation>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>title/</xsl:text>
                    <xsl:value-of select="$priref"/>
                </xsl:attribute>
                <crm:P2_has_type>
                  <crm:E55_Type rdf:about="http://vocab.getty.edu/aat/300404670">
                    <rdfs:label>primary name</rdfs:label>
                  </crm:E55_Type>
                </crm:P2_has_type>
            </crm:E33_E41_Linguistic_Appellation>
        </crm:P1_is_identified_by>
    </xsl:if>
</xsl:template>

<xsl:template match="title/value">
    <crm:P190_has_symbolic_content>
        <xsl:value-of select="."/>
    </crm:P190_has_symbolic_content>
    <xsl:choose>
        <xsl:when test="@lang='0' or @lang='en-GB'">
            <crm:P72_has_language>
                <crm:E56_Language rdf:about="http://vocab.getty.edu/aat/300388277">
                    <rdfs:label>English (language)</rdfs:label>
                </crm:E56_Language>
            </crm:P72_has_language>
        </xsl:when>
        <xsl:when test="@lang='1' or @lang='nl-NL'">
            <crm:P72_has_language>
                <crm:E56_Language rdf:about="http://vocab.getty.edu/aat/300388256">
                    <rdfs:label>Dutch (language)</rdfs:label>
                </crm:E56_Language>
            </crm:P72_has_language>
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
</xsl:template>

<!-- current owner -->
<xsl:template match="institution.name">
    <crm:P52_has_current_owner>
        <crm:E39_Actor>
            <xsl:if test="string(../institution.name.lref)">
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>actor/</xsl:text>
                    <xsl:value-of select="../institution.name.lref"/>
                </xsl:attribute>
            </xsl:if>
            <rdfs:label>
                <xsl:value-of select="."/>
            </rdfs:label>
        </crm:E39_Actor>
    </crm:P52_has_current_owner>
</xsl:template>

<!-- production -->
<!-- vervaardigingsdatums -->
<xsl:template match="Production_date/production.date.start">
    <xsl:if test="string(.)">
        <crm:P82a_begin_of_the_begin rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
            <xsl:call-template name="begindateconverter">
                <xsl:with-param name="date" select="."/>
            </xsl:call-template>
        </crm:P82a_begin_of_the_begin>
    </xsl:if>
</xsl:template>

<xsl:template match="Production_date/production.date.end">
    <xsl:if test="string(.)">
        <crm:P82b_end_of_the_end rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
            <xsl:call-template name="enddateconverter">
                <xsl:with-param name="date" select="."/>
            </xsl:call-template>
        </crm:P82b_end_of_the_end>
    </xsl:if>
</xsl:template>

<!-- creator -->
<xsl:template match="Production">
    <xsl:if test="(not(creator.qualifier)) or (creator.qualifier = '')">
        <crm:P14_carried_out_by>
            <crm:E39_Actor>
                <xsl:if test="string(creator.lref)">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>creator/</xsl:text>
                        <xsl:value-of select="creator.lref"/>
                    </xsl:attribute>
                </xsl:if>
                <rdfs:label>
                    <xsl:value-of select="creator"/>
                </rdfs:label>
                <crm:P1_is_identified_by>
                    <crm:E33_E41_Linguistic_Appellation>
                        <xsl:if test="string(creator.lref)">
                            <xsl:attribute name="rdf:about">
                                <xsl:value-of select="$baseUri"/>
                                <xsl:text>creatorname/</xsl:text>
                                <xsl:value-of select="creator.lref"/>
                            </xsl:attribute>
                        </xsl:if>
                        <crm:P190_has_symbolic_content>
                            <xsl:apply-templates select="creator"/>
                        </crm:P190_has_symbolic_content>
                    </crm:E33_E41_Linguistic_Appellation>
                </crm:P1_is_identified_by>
            </crm:E39_Actor>
        </crm:P14_carried_out_by>
    </xsl:if>
    <xsl:if test="string(production.place) or string(production.place.lref)">
        <crm:P7_took_place_at>
            <crm:E53_Place>
                <xsl:if test="string(production.place.lref)">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>place/</xsl:text>
                        <xsl:value-of select="production.place.lref"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string(production.place)">
                    <rdfs:label>
                        <xsl:value-of select="production.place"/>
                    </rdfs:label>
                </xsl:if>
            </crm:E53_Place>
        </crm:P7_took_place_at>
    </xsl:if>
    <xsl:apply-templates select="../Technique"/>
</xsl:template>

<xsl:template match="creator">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="Technique">
    <xsl:if test="string(technique.lref) or string(technique)">
        <crm:P32_used_general_technique>
            <crm:E55_Type>
                <xsl:if test="string(technique.lref)">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>concept/</xsl:text>
                        <xsl:value-of select="technique.lref"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string(technique)">
                    <rdfs:label>
                        <xsl:value-of select="technique"/>
                    </rdfs:label>
                </xsl:if>
            </crm:E55_Type>
        </crm:P32_used_general_technique>
    </xsl:if>
</xsl:template>


<!-- Dimension -->
<xsl:template match="Dimension">
    <xsl:variable name="dimtype">
        <xsl:choose>
            <xsl:when test="string(dimension.type/value)">
                <xsl:value-of select="dimension.type/value"/>
            </xsl:when>
            <xsl:when test="string(dimension.type)">
                <xsl:value-of select="dimension.type"/>
            </xsl:when>
            <xsl:when test="not(string(dimension.type/value))">
                <xsl:text>dimtype_empty</xsl:text>
            </xsl:when>
            <xsl:when test="not(string(dimension.type))">
                <xsl:text>dimtype_empty</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>dimtype_error</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:if test="not($dimtype = 'dimtype_empty')">
        <crm:P43_has_dimension>
            <crm:E54_Dimension>
                <xsl:choose>
                    <xsl:when test="($dimtype = 'hoogte') or ($dimtype = 'height')">
                        <crm:P2_has_type>
                            <crm:E55_Type rdf:about="http://vocab.getty.edu/aat/300055644">
                                <rdfs:label>
                                    <xsl:value-of select="$dimtype"/>
                                </rdfs:label>
                            </crm:E55_Type>
                        </crm:P2_has_type>                    
                    </xsl:when>
                    <xsl:when test="($dimtype = 'breedte') or ($dimtype = 'width')">
                        <crm:P2_has_type>
                            <crm:E55_Type rdf:about="http://vocab.getty.edu/aat/300055647">
                                <rdfs:label>
                                    <xsl:value-of select="$dimtype"/>
                                </rdfs:label>
                            </crm:E55_Type>
                        </crm:P2_has_type>                    
                    </xsl:when>
                    <xsl:when test="($dimtype = 'diepte') or ($dimtype = 'depth')">
                        <crm:P2_has_type>
                            <crm:E55_Type rdf:about="hhttp://vocab.getty.edu/aat/300072633">
                                <rdfs:label>
                                    <xsl:value-of select="$dimtype"/>
                                </rdfs:label>
                            </crm:E55_Type>
                        </crm:P2_has_type>                    
                    </xsl:when>
                    <xsl:otherwise>
                        <crm:P2_has_type>
                            <crm:E55_Type>
                                <rdfs:label>
                                    <xsl:value-of select="$dimtype"/>
                                </rdfs:label>
                            </crm:E55_Type>
                        </crm:P2_has_type>
                    </xsl:otherwise>
                </xsl:choose>
                <crm:P90_has_value rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
                    <xsl:call-template name="valueconverter">
                        <xsl:with-param name="value" select="dimension.value"/>
                    </xsl:call-template>
                </crm:P90_has_value>
                <xsl:choose>
                    <xsl:when test="dimension.unit = 'cm' or dimension.unit/value = 'cm'">
                        <crm:P91_has_unit>
                            <crm:E58_Measurement_Unit rdf:about="http://vocab.getty.edu/aat/300379098">
                                <rdfs:label>centimeters</rdfs:label>
                            </crm:E58_Measurement_Unit>
                        </crm:P91_has_unit>
                    </xsl:when>
                    <xsl:when test="dimension.unit = 'mm' or dimension.unit/value = 'mm'">
                        <crm:P91_has_unit>
                            <crm:E58_Measurement_Unit rdf:about="http://vocab.getty.edu/aat/300379097">
                                <rdfs:label>millimeters</rdfs:label>
                            </crm:E58_Measurement_Unit>
                        </crm:P91_has_unit>
                    </xsl:when>
                    <xsl:otherwise>
                        <crm:P91_has_unit>
                            <crm:E58_Measurement_Unit>
                                <rdfs:label>
                                    <xsl:value-of select="dimension.unit"/>
                                </rdfs:label>
                            </crm:E58_Measurement_Unit>
                        </crm:P91_has_unit>
                    </xsl:otherwise>
                </xsl:choose>
            </crm:E54_Dimension>
        </crm:P43_has_dimension>
    </xsl:if>
</xsl:template>

<!-- Material -->
<xsl:template match="Material">
    <xsl:if test="string(material.lref) or string(material)">
        <crm:P45_consists_of>
            <crm:E57_Material>
                <xsl:if test="string(material.lref)">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$baseUri"/>
                        <xsl:text>material/</xsl:text>
                        <xsl:value-of select="material.lref"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string(material)">
                    <rdfs:label>
                        <xsl:apply-templates select="material"/>
                    </rdfs:label>
                </xsl:if>
            </crm:E57_Material>
        </crm:P45_consists_of>
    </xsl:if>
</xsl:template>

<xsl:template match="material">
    <xsl:apply-templates/>
</xsl:template>

<!-- general -->
<xsl:template match="value">
    <xsl:value-of select="."/>
</xsl:template>

    <!-- ********** named templates ************** -->
    <xsl:template name="valueconverter">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="format-number(translate($value, ',.', '.'), '###0.##########') != 'NaN'">
                <xsl:value-of select="format-number(translate($value, ',.', '.'), '###0.##########')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>-1</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- datum conversie -->
    <xsl:template name="begindateconverter">
        <xsl:param name="date"/>
        <xsl:choose>
            <xsl:when test="(number($date) &gt; 0) and (number($date) &lt; 9999)">
                <xsl:value-of select="$date"/>
                <xsl:text>-01-01T00:00:00</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and not(contains(substring-after($date,'-'),'-'))">
                <xsl:value-of select="$date"/>
                <xsl:text>-01T00:00:00</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and contains(substring-after($date,'-'),'-')">
                <xsl:value-of select="$date"/>
                <xsl:text>T00:00:00</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>rkdimages_linked-art.xslt - begindateconverter: conversion error (wrong database value?)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="enddateconverter">
        <xsl:param name="date"/>
        <xsl:choose>
            <xsl:when test="(number($date) &gt; 0) and (number($date) &lt; 9999)">
                <xsl:value-of select="$date"/>
                <xsl:text>-12-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '01')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '02')">
                <xsl:value-of select="$date"/>
                <xsl:text>-28T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '03')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '04')">
                <xsl:value-of select="$date"/>
                <xsl:text>-30T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '05')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '06')">
                <xsl:value-of select="$date"/>
                <xsl:text>-30T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '07')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '08')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '09')">
                <xsl:value-of select="$date"/>
                <xsl:text>-30T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '10')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '11')">
                <xsl:value-of select="$date"/>
                <xsl:text>-30T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '12')">
                <xsl:value-of select="$date"/>
                <xsl:text>-31T23:59:59</xsl:text>
            </xsl:when>
            <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and contains(substring-after($date,'-'),'-')">
                <xsl:value-of select="$date"/>
                <xsl:text>T23:59:59</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>rkdimages_linked-art.xslt - enddateconverter: conversion error (wrong database value?)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
