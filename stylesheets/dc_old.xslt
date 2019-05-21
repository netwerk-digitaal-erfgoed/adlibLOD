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

<!--    Inventory number (Objectnummer) -->
        <xsl:apply-templates select="object_number"/>

<!--    Record type (Recordtype) -->
        <xsl:apply-templates select="record_type"/>

<!--    Parts (Delen) -->
        <xsl:apply-templates select="todo"/>

<!--    Object name (Objectnaam) -->
        <xsl:apply-templates select="object_category"/>

<!--    Title (Titel) -->
        <xsl:apply-templates select="Title/title"/>

<!--    Creator (Vervaardiger) -->
        <xsl:apply-templates select="Production"/>

<!--    Date (Datering) -->
        <xsl:apply-templates select="Production_date"/>

<!--        Date From (Van) -->
        <xsl:apply-templates select="todo"/>

<!--        Date Till (Tot) -->
        <xsl:apply-templates select="todo"/>

<!--    Material (Materiaal) -->
        <xsl:apply-templates select="Material/material"/>

<!--    Dimensions (Afmetingen) -->
        <xsl:apply-templates select="Dimension"/>

<!--        Dimension Value (waarde) -->
        <xsl:apply-templates select="todo"/>

<!--        Dimension Unit (eenheid) -->
        <xsl:apply-templates select="todo"/>

<!--        Dimension Type (soort afmeting) -->
        <xsl:apply-templates select="todo"/>

<!--    Location (Huidige standsplaats) -->
        <xsl:apply-templates select="current_location.name"/>

<!--    Keeper (Beheerder) -->
        <xsl:apply-templates select="institution.name"/>

<!--    Acquisition (Verwerving) -->
        <xsl:apply-templates select="todo"/>

<!--        Acquisition method (Verwervingsmethode) -->
        <xsl:apply-templates select="todo"/>

<!--        Acquisition date (Verwervingsdatum) -->
        <xsl:apply-templates select="acquisition.date"/>

<!--        Acquisition from (Verworven van) -->
        <xsl:apply-templates select="todo"/>

    </rdf:Description>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!--
    This stylesheet maps the basicfields above on Dublin Core and Dublin Core Terms. 
    For human semantics see: dublincore.org/documents/dcmi-terms/
-->

<!-- DC      title -->
<xsl:template match="Title/title">
    <dc:title>
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

<!-- DC      creator -->
<xsl:template match="Production">
    <dc:creator>
        <xsl:value-of select="creator"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="creator.role"/>
        <xsl:text>)</xsl:text>
    </dc:creator>
</xsl:template>

<!-- DC      subject -->
<!-- DC      description -->
<!-- DC      publisher -->
<!-- DC      contributor -->
<!-- DC      date -->

<!-- DC      type -->
<xsl:template match="object_category">
    <dc:type>
        <xsl:value-of select="."/>
    </dc:type>
</xsl:template>

<!-- DC      format -->
<xsl:template match="Dimenion">
    <dc:format>
        <xsl:value-of select="dimension.type"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="dimension.value"/>
        <xsl:value-of select="dimension.unit"/>       
    </dc:format>
</xsl:template>


<!-- DC      identifier -->
<xsl:template match="object_number">
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
<xsl:template match="Production_date">
    <dct:created>
        <xsl:value-of select="production.date.start.prec"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="production.date.start"/>
        <xsl:text>  --  </xsl:text>
        <xsl:value-of select="production.date.end.prec"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="production.date.end"/>
    </dct:created>
</xsl:template>

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
<xsl:template match="Material/material">
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
