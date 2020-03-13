<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

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
    <xsl:if test="string(object_name.lref)">
        <crm:P2_has_type>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="$baseUri"/>
                <xsl:text>concept/</xsl:text>
                <xsl:value-of select="object_name.lref"/>
            </xsl:attribute>
        </crm:P2_has_type>
    </xsl:if>
    <xsl:if test="not(string(object_name.lref)) and string(object_name)">
        <crm:P2_has_type>
             <crm:E33_E41_Linguistic_Appellation>
                <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300404670"/>
                <crm:P190_has_symbolic_content>
                    <xsl:apply-templates select="object_name"/>
                </crm:P190_has_symbolic_content>
             </crm:E33_E41_Linguistic_Appellation>
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
                <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300312355"/>
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
                <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300404670"/>
                <crm:P190_has_symbolic_content>
                    <xsl:value-of select="."/>
                </crm:P190_has_symbolic_content>
            </crm:E33_E41_Linguistic_Appellation>
        </crm:P1_is_identified_by>
    </xsl:if>
</xsl:template>

<!-- production -->
<!-- vervaardigingsdatums -->
<xsl:template match="Production_date/production.date.start">
    <xsl:if test="string(.)">
        <crm:P82a_begin_of_the_begin rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
            <xsl:call-template name="begindateconverter">
                <xsl:with-param name="date" select="."/>
            </xsl:call-template>
        </crm:P82a_begin_of_the_begin>
    </xsl:if>
</xsl:template>

<xsl:template match="Production_date/production.date.end">
    <xsl:if test="string(.)">
        <crm:P82b_end_of_the_end rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
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
</xsl:template>

<xsl:template match="creator">
    <xsl:apply-templates/>
</xsl:template>

<!-- Dimension -->
<xsl:template match="Dimension">
    <crm:P43_has_dimension>
        <crm:E54_Dimension>
            <xsl:choose>
                <xsl:when test="(dimension.type = 'hoogte') or (dimension.type = 'height')">
                    <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300055644"/>
                </xsl:when>
                <xsl:when test="(dimension.type = 'breedte') or (dimension.type = 'width')">
                    <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300055647"/>
                </xsl:when>
                <xsl:when test="(dimension.type = 'diepte') or (dimension.type = 'depth')">
                    <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300072633"/>
                </xsl:when>
                <xsl:otherwise>
                    <crm:P91_has_type>
                        <xsl:text>dimension type unknown</xsl:text>
                    </crm:P91_has_type>
                </xsl:otherwise>
            </xsl:choose>
            <crm:P90_has_value rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
                <xsl:call-template name="valueconverter">
                    <xsl:with-param name="value" select="dimension.value"/>
                </xsl:call-template>
            </crm:P90_has_value>
            <xsl:choose>
                <xsl:when test="dimension.unit = 'cm'">
                    <crm:P91_has_unit rdf:resource="http://vocab.getty.edu/aat/300379098"/>
                </xsl:when>
                <xsl:when test="dimension.unit = 'mm'">
                    <crm:P91_has_unit rdf:resource="http://vocab.getty.edu/aat/300379097"/>
                </xsl:when>
                <xsl:otherwise>
                    <crm:P91_has_unit>
                        <xsl:text>dimension unit unknown</xsl:text>
                    </crm:P91_has_unit>
                </xsl:otherwise>
            </xsl:choose>
        </crm:E54_Dimension>
    </crm:P43_has_dimension>
</xsl:template>

<!-- Material -->
<xsl:template match="Material">
    <crm:P45_consists_of>
        <skos:Concept>
            <xsl:if test="string(material.lref)">
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="$baseUri"/>
                    <xsl:text>material/</xsl:text>
                    <xsl:value-of select="material.lref"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string(material)">
                <skos:prefLabel>
                    <xsl:apply-templates select="material"/>
                </skos:prefLabel>
            </xsl:if>
        </skos:Concept>
    </crm:P45_consists_of>
</xsl:template>

<xsl:template match="material">
    <xsl:apply-templates/>
</xsl:template>

<!-- general -->
<xsl:template match="value">
    <xsl:value-of select="."/>
</xsl:template>

<!-- named templates -->
<xsl:template name="valueconverter">
    <xsl:param name="value"/>
    <xsl:choose>
        <xsl:when test="format-number(translate($value, ',.', '.'), '###0.##########') != 'NaN'">
            <xsl:value-of select="format-number(translate($value, ',.', '.'), '###0.##########')" />
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
            <xsl:text>-01-01</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and not(contains(substring-after($date,'-'),'-'))">
            <xsl:value-of select="$date"/>
            <xsl:text>-01</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and contains(substring-after($date,'-'),'-')">
            <xsl:value-of select="$date"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>1000-01-01</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="enddateconverter">
    <xsl:param name="date"/>
    <xsl:choose>
        <xsl:when test="(number($date) &gt; 0) and (number($date) &lt; 9999)">
            <xsl:value-of select="$date"/>
            <xsl:text>-12-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '01')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '02')">
            <xsl:value-of select="$date"/>
            <xsl:text>-28</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '03')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '04')">
            <xsl:value-of select="$date"/>
            <xsl:text>-30</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '05')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '06')">
            <xsl:value-of select="$date"/>
            <xsl:text>-30</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '07')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '08')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '09')">
            <xsl:value-of select="$date"/>
            <xsl:text>-30</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '10')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '11')">
            <xsl:value-of select="$date"/>
            <xsl:text>-30</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and (substring-after($date,'-') = '12')">
            <xsl:value-of select="$date"/>
            <xsl:text>-31</xsl:text>
        </xsl:when>
        <xsl:when test="(number(substring-before($date,'-')) &lt; 9999) and contains(substring-after($date,'-'),'-')">
            <xsl:value-of select="$date"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>3000-12-31</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
