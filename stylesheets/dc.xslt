<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="baseUri">http://example.com/priref/</xsl:param>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<xsl:template match="record">
    <rdf:Description>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$baseUri"/>
            <xsl:value-of select="@priref"/>
        </xsl:attribute>

<!--    Inventory number (Objectnummer) -->
        <xsl:apply-templates select="object_number"/>

<!--    Record type (Recordtype) -->
        <!--xsl:apply-templates select="record_type"/-->

<!--    Parts (Delen) -->
        <!--xsl:apply-templates select="todo"/-->

<!--    Object name (Objectnaam) -->
        <!--xsl:apply-templates select="object_category"/-->
        <xsl:apply-templates select="Object_name/object_name"/>
        <xsl:apply-templates select="Other_name/other_name"/>

<!--    Title (Titel) -->
        <xsl:apply-templates select="Title/title"/>

<!--    Creator (Vervaardiger) -->
        <xsl:apply-templates select="Production/creator"/>

<!--    Date (Datering) -->
        <xsl:apply-templates select="Production_date"/>

<!--        Date From (Van) -->
        <!--xsl:apply-templates select="Production_date/production.date.start"/-->

<!--        Date Till (Tot) -->
        <!--xsl:apply-templates select="Production_date/production.date.start"/-->

<!--    Material (Materiaal) -->
        <xsl:apply-templates select="Material/material"/>

<!--    Dimensions (Afmetingen) -->
        <xsl:apply-templates select="Dimension/dimension.value"/>

<!--        Dimension Value (waarde) -->
        <!--xsl:apply-templates select="Dimension/dimension.value"/-->

<!--        Dimension Unit (eenheid) -->
        <!--xsl:apply-templates select="Dimension/dimension.unit"/-->

<!--        Dimension Type (soort afmeting) -->
        <!--xsl:apply-templates select="Dimension/dimension.type"/-->

<!--    Location (Huidige standplaats) -->
        <!--xsl:apply-templates select="current_location.name"/-->

<!--    Keeper (Beheerder) -->
        <!--xsl:apply-templates select="institution.name"/-->

<!--    Acquisition (Verwerving) -->
        <!--xsl:apply-templates select="todo"/-->

<!--        Acquisition method (Verwervingsmethode) -->
        <!--xsl:apply-templates select="acquisition.method"/-->

<!--        Acquisition date (Verwervingsdatum) -->
        <!--xsl:apply-templates select="acquisition.date"/-->

<!--        Acquisition from (Verworven van) -->
        <!--xsl:apply-templates select="todo"/-->

<!--        Missing in the basicfields but available in DC :-) -->

<!--        Description -->
        <xsl:apply-templates select="Description/description"/>
        <xsl:apply-templates select="physical_description"/>
        <xsl:apply-templates select="notes"/>

<!--        Subject -->
        <xsl:apply-templates select="Content_person"/>
        <xsl:apply-templates select="Content_subject"/>
        <xsl:apply-templates select="Associated_subject"/>
        <xsl:apply-templates select="Associated_period"/>
        <xsl:apply-templates select="Associated_person"/>


    </rdf:Description>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!--
    This stylesheet maps the basicfields above on Dublin Core and Dublin Core Terms. 
    For human semantics see: dublincore.org/documents/dcmi-terms/
-->

<!-- DC      title -->
<xsl:template match="Title/title[node()]">
    <dc:title>
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

<!-- DC      creator -->
<xsl:template match="Production/creator[node()]">
    <dc:creator>
        <xsl:value-of select="."/>
    </dc:creator>
</xsl:template>

<!-- DC      subject -->
<xsl:template match="Content_person/content.person.name[node()]">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<xsl:template match="Content_subject/content.subject[node()]">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<xsl:template match="Associated_subject/association.subject[node()]">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<xsl:template match="Associated_period/association.period[node()]">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<xsl:template match="Associated_person/association.person[node()] | Associated_person/association.person.name[node()]">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>


<!-- DC      description -->
<xsl:template match="Description/description[node()] | physical_description[node()]">
    <dc:description>
        <xsl:value-of select="."/>
    </dc:description>
</xsl:template>


<!-- DC      publisher -->
<!-- DC      contributor -->
<!-- DC      date -->
<xsl:template match="Production_date">
    <dc:date>
        <xsl:apply-templates select="production.date.start.prec"/>
        <xsl:apply-templates select="production.date.start"/>
        <xsl:apply-templates select="production.date.end.prec"/>
        <xsl:apply-templates select="production.date.end"/>
    </dc:date>
</xsl:template>

<xsl:template match="production.date.start.prec[node()]">
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="production.date.start[node()]">
    <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="production.date.end.prec[node()]">
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="production.date.end[node()]">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="."/>
</xsl:template>


<!-- DC      type -->
<xsl:template match="Object_name/object_name[node()] | Other_name/other_name[node()]">
    <dc:type>
        <xsl:value-of select="."/>
    </dc:type>
</xsl:template>

<!-- DC      format -->
<xsl:template match="Dimension/dimension.value[node()]">
    <dc:format>
        <xsl:apply-templates select="../dimension.type"/>
        <xsl:value-of select="."/>
        <xsl:apply-templates select="../dimension.unit"/>
    </dc:format>
</xsl:template>

<xsl:template match="dimension.type[node()]">
    <xsl:value-of select="."/>
    <xsl:text>: </xsl:text>
</xsl:template>

<xsl:template match="dimension.unit[node()]">
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
</xsl:template>

<!-- DC      identifier -->
<xsl:template match="object_number[node()]">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC      source -->
<!-- DC      language -->
<!-- DC      relation -->
<!-- DC      coverage -->
<!-- DC      rights (rechten) -->


<!-- DCT     abstract -->
<!-- DCT     accessRights -->
<!-- DCT     accrualMethod -->
<!-- DCT     accrualPeriodicity -->
<!-- DCT     accrualPolicy -->
<!-- DCT     alternative -->
<!-- DCT     audience -->
<!-- DCT     available -->
<!-- DCT     bibliographicCitation -->
<!-- DCT     conformsTo -->
<!-- DCT     created -->
<!-- DCT     dateAccepted -->
<!-- DCT     dateCopyrighted -->
<!-- DCT     dateSubmitted -->
<!-- DCT     educationLevel -->
<!-- DCT     extent -->
<!-- DCT     hasFormat -->
<!-- DCT     hasPart -->
<!-- DCT     hasVersion -->
<!-- DCT     instructionalMethod -->
<!-- DCT     isFormatOf -->
<!-- DCT     isPartOf -->
<!-- DCT     isReferencedBy -->
<!-- DCT     isReplacedBy -->
<!-- DCT     isRequiredBy -->
<!-- DCT     issued -->
<!-- DCT     isVersionOf -->
<!-- DCT     license -->
<!-- DCT     mediator -->
<!-- DCT     medium -->
<xsl:template match="Material/material[node()]">
    <dct:medium>
        <xsl:value-of select="."/>
    </dct:medium>
</xsl:template>

<!-- DCT     modified -->
<!-- DCT     provenance -->
<!-- DCT     references -->
<!-- DCT     replaces -->
<!-- DCT     requires -->
<!-- DCT     rightsHolder -->
<!-- DCT     spatial -->
<!-- DCT     tableOfContents -->
<!-- DCT     temporal -->
<!-- DCT     valid -->

</xsl:stylesheet>
