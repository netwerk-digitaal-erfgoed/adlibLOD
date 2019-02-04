<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.openarchives.org/OAI/2.0/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="record">
    <record>
        <header>
            <identifier>
                <xsl:text>oai:rijksmuseum.nl:</xsl:text>
                <xsl:value-of select="object.number"/>
            </identifier>
            <datestamp>
                <xsl:value-of select="@modification"/>
                <xsl:text>Z</xsl:text>
            </datestamp>
        </header>
        <metadata>
            <oai_dc:dc>
                <!-- DC identifier persistent -->
                <xsl:apply-templates select="PersistentIdentifier"/>
                <!-- DC identifier object -->
                <xsl:apply-templates select="object.number"/>
                <!-- DC title -->
                <!-- When available add title based on label text -->
                <xsl:choose>
                    <xsl:when test="label[1]/label.title">
                        <xsl:apply-templates select="label[1]/label.title/value[@lang='1']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="title/title/value[@lang='1']"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- DC creator or contributor -->
                <xsl:apply-templates select="maker/name/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.classification.code/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.keyword/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.period/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.event/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.location/value[@lang='1']"/>
                <!-- DC subject -->
                <xsl:apply-templates select="content.person/value[@lang='1']"/>
                <!-- DC description -->
                <!-- When available add title based on label text -->
                <xsl:choose>
                    <xsl:when test="string(label[1]/label.text/value[@lang='1'])">
                        <xsl:apply-templates select="label[1]/label.text/value[@lang='1']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="description[1]/value[@lang='1']"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- DC date -->
                <xsl:apply-templates select="dating/date.early"/>
                <!-- DC type -->
                <xsl:apply-templates select="object.name/value[@lang='1']"/>
                <!-- DC format -->
                <xsl:apply-templates select="material/material/value[@lang='1']"/>
                <!-- Provider metadata -->
                <dc:language>
                    <xsl:text>nl</xsl:text>
                </dc:language>
                <dc:publisher>
                    <xsl:text>Rijksmuseum</xsl:text>
                </dc:publisher>
                <!-- Dublin Core rights -->
                <xsl:apply-templates select="rights.freeofrights/value[@lang='neutral']"/>
                <!-- Dublin Core coverage -->
                <xsl:apply-templates select="content.place/value[@lang='1']"/>
                <!-- Dublin Core coverage -->
                <xsl:apply-templates select="maker/production.place/value[@lang='1']"/>
            </oai_dc:dc>
        </metadata>
    </record>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- DC identifier persistent -->
<xsl:template match="PersistentIdentifier">
    <dc:identifier>
        <xsl:text>http://</xsl:text>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC identifier object -->
<xsl:template match="object.number">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC title -->
<xsl:template match="title/value[@lang='1'] | label.title/value[@lang='1']">
    <dc:title>
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

<!-- DC creator or contributor -->
<xsl:template match="maker/name/value[@lang='1']">
    <xsl:choose>
        <xsl:when test="../../maker.type = 'Principal'">
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
<xsl:template match="content.classification.code/value[@lang='1'] | content.keyword/value[@lang='1'] | content.period/value[@lang='1'] | content.event/value[@lang='1'] | content.location/value[@lang='1'] | content.person/value[@lang='1']">
    <dc:subject>
        <xsl:value-of select="."/>
    </dc:subject>
</xsl:template>

<!-- DC description -->
<xsl:template match="description/value[@lang='1'] | label[1]/label.text/value[@lang='1']">
    <dc:description>
        <xsl:value-of select="."/>
    </dc:description>
</xsl:template>

<!-- DC date -->
<xsl:template match="dating/date.early">
    <dc:date>
        <xsl:choose>
            <xsl:when test=". = ../date.late">
                <xsl:if test="string(../date.early.precision/value[@lang='1'])">
                    <xsl:value-of select="../date.early.precision/value[@lang='1']"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="string(../date.early.precision/value[@lang='1'])">
                    <xsl:value-of select="../date.early.precision/value[@lang='1']"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
                <xsl:text>&#160;-&#160;</xsl:text>
                <xsl:if test="string(../date.late.precision/value[@lang='1'])">
                    <xsl:value-of select="../date.late.precision/value[@lang='1']"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="../date.late"/>
            </xsl:otherwise>
        </xsl:choose>
    </dc:date>
</xsl:template>

<!-- DC type -->
<xsl:template match="object.name/value[@lang='1']">
    <dc:type>
        <xsl:value-of select="."/>
    </dc:type>
</xsl:template>

<!-- DC format -->
<xsl:template match="material/material/value[@lang='1']">
    <dc:format>
        <xsl:value-of select="."/>
    </dc:format>
</xsl:template>

<!-- Dublin Core coverage -->
<xsl:template match="content.place/value[@lang='1']">
    <dc:coverage>
        <xsl:value-of select="."/>
    </dc:coverage>
</xsl:template>

<!-- Dublin Core coverage -->
<xsl:template match="maker/production.place/value[@lang='1']">
    <!-- add only when not the same as content.place -->
    <xsl:if test="not(. = ../../content.place/value[@lang='1'])">
        <dc:coverage>
            <xsl:value-of select="."/>
        </dc:coverage>
    </xsl:if>
</xsl:template>

<!-- Dublin Core rights -->
<xsl:template match="rights.freeofrights/value[@lang='neutral']">
    <xsl:choose>
        <xsl:when test=". = 'YES'">
            <dc:rights>
                <xsl:text>http://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
            </dc:rights>
        </xsl:when>
        <xsl:otherwise>
            <dc:rights>
                <xsl:text>http://rightsstatements.org/vocab/InC/1.0/</xsl:text>
            </dc:rights>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
