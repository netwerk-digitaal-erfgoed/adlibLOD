<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:edmfp="http://www.europeanafashion.eu/edmfp/"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
    xmlns:mrel="http://id.loc.gov/vocabulary/relators/"
    xmlns="http://www.openarchives.org/OAI/2.0/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="imageUrl"/>

<!-- RDF wrap and OAI record -->
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
            <setSpec>
                <xsl:text>subject:Europeana_EDM</xsl:text>
            </setSpec>
        </header>
        <metadata>
            <rdf:RDF>
                <edm:ProvidedCHO>
                    <xsl:attribute name="rdf:about">
                        <!-- Create handle identifier for object -->
                        <xsl:text>http://</xsl:text>
                        <xsl:value-of select="PersistentIdentifier"/>
                    </xsl:attribute>
                    <!-- DC identifier -->
                    <xsl:apply-templates select="object.number"/>
                    <!-- DC title -->
                    <!-- When available add title based on label text -->
                    <xsl:choose>
                        <xsl:when test="label[1]/label.title">
                            <xsl:apply-templates select="label[1]/label.title"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="title/title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- DC creator and contributor -->
                    <xsl:apply-templates select="maker/PersistentIdentifier"/>
                    <!-- DC subject iconclass -->
                    <xsl:apply-templates select="content.classification.code/value[@lang='neutral']"/>
                    <!-- DC subject keyword -->
                    <xsl:apply-templates select="content.keyword/PersistentIdentifier"/>
                    <!-- DC subject period -->
                    <xsl:apply-templates select="content.period"/>
                    <!-- DC subject event -->
                    <xsl:apply-templates select="content.event/PersistentIdentifier"/>
                    <!-- DC subject location -->
                    <xsl:apply-templates select="content.location/PersistentIdentifier"/>
                    <!-- DC subject person -->
                    <xsl:apply-templates select="content.person/PersistentIdentifier"/>
                    <!-- DC description -->
                    <!-- When available add description based on label text -->
                    <xsl:choose>
                        <xsl:when test="string(label[1]/label.text)">
                            <xsl:apply-templates select="label[1]/label.text"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="description[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- DC type -->
                    <xsl:apply-templates select="object.name/PersistentIdentifier"/>
                    <!-- DC format -->
                    <xsl:apply-templates select="material/PersistentIdentifier"/>
                    <!-- Provider metadata -->
                    <dc:language>
                        <xsl:text>nl</xsl:text>
                    </dc:language>
                    <dc:publisher>
                        <xsl:text>Rijksmuseum</xsl:text>
                    </dc:publisher>
                    <!-- DC Terms created -->
                    <xsl:apply-templates select="dating/date.early"/>
                    <!-- DC Terms temporal -->
                    <xsl:apply-templates select="date.period"/>
                    <!-- DC Terms extent -->
                    <xsl:apply-templates select="dimension"/>
                    <!-- DC relation -->
                    <xsl:apply-templates select="related_object/PersistentIdentifier"/>
                    <!-- DC Terms is part of collection -->
                    <xsl:apply-templates select="collection"/>
                    <!-- DC Terms has part -->
                    <xsl:apply-templates select="parts/PersistentIdentifier"/>
                    <!-- DC Terms is part of -->
                    <xsl:apply-templates select="part.of/PersistentIdentifier"/>
                    <!-- DC Terms is referenced by -->
                    <xsl:apply-templates select="catrefrpk"/>
                    <!--DC Terms spatial -->
                    <xsl:apply-templates select="maker/production.place/PersistentIdentifier"/>
                    <!-- DC Terms provenance -->
                    <xsl:apply-templates select="provenance"/>
                    <!-- EDMFP technique -->
                    <xsl:apply-templates select="technique/PersistentIdentifier"/>
                    <!-- Mrel credit line -->
                    <xsl:apply-templates select="acquisition.creditline"/>
                    <edm:type>
                        <xsl:text>IMAGE</xsl:text>
                    </edm:type>
                </edm:ProvidedCHO>
                <!-- ORE aggregation and EDM web resource-->
                <xsl:apply-templates select="priref"/>
                <!-- SKOS concept iconclass -->
                <xsl:apply-templates select="content.classification.code"/>
                <!-- SKOS concept keyword -->
                <xsl:apply-templates select="content.keyword"/>
                <!-- SKOS concept type -->
                <xsl:apply-templates select="object.name"/>
                <!-- SKOS concept material -->
                <xsl:apply-templates select="material"/>
                <!-- SKOS concept technique -->
                <xsl:apply-templates select="technique"/>
                <!-- EDM time span -->
                <xsl:apply-templates select="content.event"/>
                <!-- EDM place production -->
                <!-- only add place when the same place did not precede -->
                <xsl:for-each select="maker">
                    <xsl:if test="not(production.place/PersistentIdentifier = preceding-sibling::maker/production.place/PersistentIdentifier)">
                        <xsl:apply-templates select="production.place"/>
                    </xsl:if>
                </xsl:for-each>
                <!-- only add place when not already added -->
                <xsl:for-each select="content.location">
                    <xsl:if test="not(PersistentIdentifier = ../maker/production.place/PersistentIdentifier)">
                        <!-- EDM place content -->
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
                <!-- EDM agent -->
                <!-- only add maker when the same maker did not precede -->
                <xsl:for-each select="maker">
                    <xsl:if test="not(PersistentIdentifier = preceding-sibling::maker/PersistentIdentifier)">
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
                <!-- only add person when not already added -->
                <xsl:for-each select="content.person">
                    <xsl:if test="not(PersistentIdentifier = ../maker/PersistentIdentifier)">
                        <!-- EDM agent -->
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
            </rdf:RDF>
        </metadata>
    </record>
</xsl:template>

<!-- do not map diagnostics -->
<xsl:template match="diagnostic"/>

<!-- DC identifier -->
<xsl:template match="object.number">
    <dc:identifier>
        <xsl:value-of select="."/>
    </dc:identifier>
</xsl:template>

<!-- DC title -->
<xsl:template match="label[1]/label.title">
    <xsl:apply-templates select="value[@lang='0']"/>
    <xsl:apply-templates select="value[@lang='1']"/>
</xsl:template>

<!-- DC title -->
<xsl:template match="title/title">
    <!-- filter former titles -->
    <xsl:if test="not(../title.type/value[@lang=0] = 'former title')">
        <xsl:apply-templates select="value[@lang='0']"/>
        <xsl:apply-templates select="value[@lang='1']"/>
    </xsl:if>
</xsl:template>

<!-- DC title language nl -->
<xsl:template match="title/value[@lang='1'] | label.title/value[@lang='1']">
    <dc:title xml:lang="nl">
        <xsl:value-of select="."/>
    </dc:title>
</xsl:template>

<!-- DC title language en -->
<xsl:template match="title/value[@lang='0'] | label.title/value[@lang='0']">
    <xsl:if test="string(.)">
        <dc:title xml:lang="en">
            <xsl:value-of select="."/>
        </dc:title>
    </xsl:if>
</xsl:template>

<!-- DC creator and contributor -->
<xsl:template match="maker/PersistentIdentifier">
    <xsl:choose>
        <xsl:when test="../maker.type = 'Principal'">
            <dc:creator>
                <xsl:attribute name="rdf:resource">
                    <xsl:if test="contains(., 'RM0001')">
                        <xsl:text>http://hdl.handle.net/10934/</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="../PersistentIdentifier"/>
                </xsl:attribute>
            </dc:creator>
        </xsl:when>
        <xsl:otherwise>
            <dc:contributor>
                <xsl:attribute name="rdf:resource">
                    <xsl:if test="contains(., 'RM0001')">
                        <xsl:text>http://hdl.handle.net/10934/</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </dc:contributor>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- DC subject iconclass -->
<xsl:template match="content.classification.code/value[@lang='neutral']">
    <dc:subject>
        <xsl:attribute name="rdf:resource">
            <xsl:text>http://iconclass.org/</xsl:text>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:subject>
</xsl:template>

<!-- DC subject keyword -->
<xsl:template match="content.keyword/PersistentIdentifier">
    <dc:subject>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <!-- Create handle identifier for thesaurus term -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:subject>
</xsl:template>

<!-- DC subject period -->
<xsl:template match="content.period">
    <dc:subject>
        <xsl:if test="string(content.date.early)">
            <xsl:value-of select="content.date.early"/>
        </xsl:if>
        <xsl:if test="string(content.date.late) and not(content.date.early = content.date.late)">
            <xsl:text>&#160;-&#160;</xsl:text>
            <xsl:value-of select="content.date.late"/>
        </xsl:if>
    </dc:subject>
</xsl:template>

<!-- DC subject event -->
<xsl:template match="content.event/PersistentIdentifier">
    <dc:subject>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <!-- Create handle identifier for thesaurus term -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:subject>
</xsl:template>

<!-- DC subject location -->
<xsl:template match="content.location/PersistentIdentifier">
    <dc:subject>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:subject>
</xsl:template>

<!-- DC subject person -->
<xsl:template match="content.person/PersistentIdentifier">
    <dc:subject>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:subject>
</xsl:template>

<!-- DC description -->
<xsl:template match="label[1]/label.text">
    <xsl:apply-templates select="value[@lang='0']"/>
    <xsl:apply-templates select="value[@lang='1']"/>
</xsl:template>

<!-- DC description language en -->
<xsl:template match="label[1]/label.text/value[@lang='0']">
    <dc:description xml:lang="en">
        <xsl:value-of select="."/>
    </dc:description>
</xsl:template>

<!-- DC description language nl -->
<xsl:template match="label[1]/label.text/value[@lang='1']">
    <dc:description xml:lang="nl">
        <xsl:value-of select="."/>
    </dc:description>
</xsl:template>

<!-- DC description -->
<xsl:template match="description">
    <dc:description xml:lang="nl">
        <xsl:value-of select="."/>
        <xsl:if test="string(../notes.public)">
            <xsl:text>&#160;</xsl:text>
            <xsl:value-of select="../notes.public"/>
        </xsl:if>
    </dc:description>
</xsl:template>

<!-- DC type -->
<xsl:template match="object.name/PersistentIdentifier">
    <dc:type>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:type>
</xsl:template>

<!-- DC format -->
<xsl:template match="material/PersistentIdentifier">
    <dc:format>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:format>
</xsl:template>

<!-- DC Terms created -->
<xsl:template match="dating/date.early">
    <xsl:choose>
        <xsl:when test=". = ../date.late">
            <dct:created xml:lang="nl">
                <xsl:if test="string(../date.early.precision/value[@lang='1'])">
                    <xsl:value-of select="../date.early.precision/value[@lang='1']"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
            </dct:created>
            <dct:created xml:lang="en">
                <xsl:if test="string(../date.early.precision/value[@lang='0'])">
                    <xsl:value-of select="../date.early.precision/value[@lang='0']"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
            </dct:created>
        </xsl:when>
        <xsl:otherwise>
            <dct:created xml:lang="nl">
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
            </dct:created>
            <dct:created xml:lang="en">
                <xsl:if test="string(../date.early.precision/value[@lang='0'])">
                    <xsl:value-of select="../date.early.precision/value[@lang='0']" />
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
                <xsl:text>&#160;-&#160;</xsl:text>
                <xsl:if test="string(../date.late.precision/value[@lang='0'])">
                    <xsl:value-of select="../date.late.precision/value[@lang='0']" />
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                <xsl:value-of select="../date.late"/>
            </dct:created>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- DC Terms temporal -->
<xsl:template match="date.period">
    <!-- DC Terms temporal nl -->
    <xsl:apply-templates select="value[@lang='1']"/>
    <!-- DC Terms temporal en -->
    <xsl:apply-templates select="value[@lang='0']"/>
</xsl:template>

<!-- DC Terms temporal nl -->
<xsl:template match="date.period/value[@lang='1']">
    <dct:temporal xml:lang="nl">
        <xsl:value-of select="."/>
    </dct:temporal>
</xsl:template>

<!-- DC Terms temporal en -->
<xsl:template match="date.period/value[@lang='0']">
    <dct:temporal xml:lang="en">
        <xsl:value-of select="."/>
    </dct:temporal>
</xsl:template>

<!-- DC Terms extent -->
<xsl:template match="dimension">
    <dct:extent xml:lang="en">
        <xsl:if test="string(dimension.part/value[@lang='0'])">
            <xsl:value-of select="dimension.part/value[@lang='0']"/>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:value-of select="dimension.type/value[@lang='0']"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.value/value[@lang='0']"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.unit/value[@lang='0']"/>
    </dct:extent>
    <dct:extent xml:lang="nl">
        <xsl:if test="string(dimension.part/value[@lang='1'])">
            <xsl:value-of select="dimension.part/value[@lang='1']"/>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:value-of select="dimension.type/value[@lang='1']"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.value/value[@lang='1']"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="dimension.unit/value[@lang='1']"/>
    </dct:extent>
</xsl:template>

<!-- DC relation -->
<xsl:template match="related_object/PersistentIdentifier">
    <dc:relation>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dc:relation>
</xsl:template>

<!-- DC Terms is part of collection -->
<xsl:template match="collection">
    <!-- DC Terms is part of collection en -->
    <xsl:apply-templates select="value[@lang='0']"/>
    <!-- DC Terms is part of collection nl -->
    <xsl:apply-templates select="value[@lang='1']"/>
</xsl:template>

<!-- DC Terms temporal en -->
<xsl:template match="collection/value[@lang='0']">
    <dct:isPartOf xml:lang="en">
        <xsl:text>Collection:&#160;</xsl:text>
        <xsl:value-of select="."/>
    </dct:isPartOf>
</xsl:template>

<!-- DC Terms is part of collection nl -->
<xsl:template match="collection/value[@lang='1']">
    <dct:isPartOf xml:lang="nl">
        <xsl:text>Collectie:&#160;</xsl:text>
        <xsl:value-of select="."/>
    </dct:isPartOf>
</xsl:template>

<!-- DC Terms has part -->
<xsl:template match="parts/PersistentIdentifier">
    <dct:hasPart>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dct:hasPart>
</xsl:template>

<!-- DC Terms is part of -->
<xsl:template match="part.of/PersistentIdentifier">
    <dct:isPartOf>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dct:isPartOf>
</xsl:template>

<!-- DC Terms is referenced by -->
<xsl:template match="catrefrpk">
    <dct:isReferencedBy>
        <xsl:value-of select="catalogue.ref.RPK"/>
        <xsl:choose>
            <!-- only add number and page when they are added -->
            <xsl:when test="string(catalogue.ref.RPK.part_page)">
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="catalogue.ref.RPK.part_page"/>
                <xsl:if test="string(catalogue.ref.RPK.number)">
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="catalogue.ref.RPK.number"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="string(catalogue.ref.RPK.number)">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="catalogue.ref.RPK.number"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Check if addition has been added -->
        <xsl:if test="string(catalogue.ref.RPK.addition)">
            <xsl:text>&#160;</xsl:text>
            <xsl:value-of select="catalogue.ref.RPK.addition"/>
        </xsl:if>
        <!-- Check if remark has been added -->
        <xsl:if test="string(catalogue.ref.RPK.remark)">
            <xsl:text>,&#160;</xsl:text>
            <xsl:value-of select="catalogue.ref.RPK.remark"/>
        </xsl:if>
    </dct:isReferencedBy>
</xsl:template>

<!--DC Terms spatial -->
<xsl:template match="maker/production.place/PersistentIdentifier">
    <dct:spatial>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </dct:spatial>
</xsl:template>

<!-- DC Terms provenance -->
<xsl:template match="provenance">
    <dct:provenance xml:lang="nl">
        <xsl:value-of select="."/>
    </dct:provenance>
</xsl:template>

<!-- EDMFP technique -->
<xsl:template match="technique/PersistentIdentifier">
    <edmfp:technique>
        <xsl:attribute name="rdf:resource">
            <xsl:if test="contains(., 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:attribute>
    </edmfp:technique>
</xsl:template>

<!-- Mrel credit line -->
<xsl:template match="acquisition.creditline">
    <!-- Mrel credit line en -->
    <xsl:apply-templates select="value[@lang='0']"/>
    <!-- Mrel credit line nl -->
    <xsl:apply-templates select="value[@lang='1']"/>
</xsl:template>

<!-- Mrel credit line en -->
<xsl:template match="acquisition.creditline/value[@lang='0']">
    <mrel:spn xml:lang="en">
        <xsl:value-of select="."/>
    </mrel:spn>
</xsl:template>

<!-- Mrel credit line nl -->
<xsl:template match="acquisition.creditline/value[@lang='1']">
    <mrel:spn xml:lang="nl">
        <xsl:value-of select="."/>
    </mrel:spn>
</xsl:template>

<!-- ORE aggregation and EDM web resource-->
<xsl:template match="priref">
    <ore:Aggregation>
        <xsl:attribute name="rdf:about">
            <!-- Create handle identifier for aggregation -->
            <xsl:text>http://</xsl:text>
            <xsl:value-of select="../PersistentIdentifier"/>
            <xsl:text>:aggregation</xsl:text>
        </xsl:attribute>
        <edm:aggregatedCHO>
            <xsl:attribute name="rdf:resource">
                <!-- Create handle identifier for object -->
                <xsl:text>http://</xsl:text>
                <xsl:value-of select="../PersistentIdentifier"/>
            </xsl:attribute>
        </edm:aggregatedCHO>
        <edm:dataProvider>
            <xsl:text>Rijksmuseum</xsl:text>
        </edm:dataProvider>
        <edm:isShownAt>
            <xsl:attribute name="rdf:resource">
                <!-- Create handle identifier for object -->
                <xsl:text>http://</xsl:text>
                <xsl:value-of select="../PersistentIdentifier"/>
            </xsl:attribute>
        </edm:isShownAt>
        <!-- Add URL image if available -->
        <xsl:if test="string($imageUrl) and ../publish.website/value[@lang='neutral']='1'">
            <edm:isShownBy>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$imageUrl"/>
                </xsl:attribute>
            </edm:isShownBy>
            <edm:object>
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="$imageUrl"/>
                </xsl:attribute>
            </edm:object>
        </xsl:if>
        <edm:provider>
            <xsl:text>Rijksmuseum</xsl:text>
        </edm:provider>
        <!-- Rights of metadata, check for public domain -->
        <xsl:choose>
            <xsl:when test="../rights.freeofrights/value[1] = 'YES'">
                <edm:rights>
                    <xsl:attribute name="rdf:resource">
                        <xsl:text>http://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
                    </xsl:attribute>
                </edm:rights>
            </xsl:when>
            <xsl:otherwise>
                <edm:rights>
                    <xsl:attribute name="rdf:resource">
                        <xsl:text>http://rightsstatements.org/vocab/InC/1.0/</xsl:text>
                    </xsl:attribute>
                </edm:rights>
            </xsl:otherwise>
        </xsl:choose>
    </ore:Aggregation>
    <xsl:if test="string($imageUrl) and ../publish.website/value[@lang='neutral']='1'">
        <edm:WebResource>
                <xsl:attribute name="rdf:about">
                <xsl:value-of select="$imageUrl"/>
            </xsl:attribute>
            <dc:format>
                <xsl:text>image/jpeg</xsl:text>
            </dc:format>
            <!-- Rights of web resource, check for public domain -->
            <xsl:choose>
                <xsl:when test="../rights.freeofrights/value[1] = 'YES'">
                    <dc:rights xml:lang="en">
                        <xsl:text>Public Domain</xsl:text>
                    </dc:rights>
                    <dc:rights xml:lang="nl">
                        <xsl:text>Publiek Domein</xsl:text>
                    </dc:rights>
                    <edm:rights>
                        <xsl:attribute name="rdf:resource">
                            <xsl:text>http://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
                        </xsl:attribute>
                    </edm:rights>
                </xsl:when>
                <xsl:otherwise>
                    <dc:rights xml:lang="en">
                        <xsl:text>Copyright&#160;</xsl:text>
                        <xsl:value-of select="../rights.copyrightnotice"/>
                    </dc:rights>
                    <dc:rights xml:lang="nl">
                        <xsl:text>Auteursrecht&#160;</xsl:text>
                        <xsl:value-of select="../rights.copyrightnotice"/>
                    </dc:rights>
                    <edm:rights>
                        <xsl:attribute name="rdf:resource">
                            <xsl:text>http://creativecommons.org/licenses/by-nc-nd/4.0/</xsl:text>
                        </xsl:attribute>
                    </edm:rights>
                </xsl:otherwise>
            </xsl:choose>
            <dct:created>
                <xsl:value-of select="../reproduction.web_last_update"/>
            </dct:created>
        </edm:WebResource>
    </xsl:if>
</xsl:template>

<!-- SKOS concept iconclass -->
<xsl:template match="content.classification.code">
    <skos:Concept>
        <!-- Create iconclass identifier -->
        <xsl:attribute name="rdf:about">
            <xsl:text>http://iconclass.org/</xsl:text>
            <xsl:value-of select="value[@lang='neutral']"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </skos:Concept>
</xsl:template>

<!-- SKOS concept keyword -->
<xsl:template match="content.keyword">
    <skos:Concept>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <!-- Create handle identifier for concept -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </skos:Concept>
</xsl:template>

<!-- SKOS concept type -->
<xsl:template match="object.name">
    <skos:Concept>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <!-- Create handle identifier for concept -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </skos:Concept>
</xsl:template>

<!-- SKOS concept material -->
<xsl:template match="material">
    <skos:Concept>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <!-- Create handle identifier for concept -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="material/value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="material/value[@lang='0']"/>
    </skos:Concept>
</xsl:template>

<!-- SKOS concept technique -->
<xsl:template match="technique">
    <skos:Concept>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <!-- Create handle identifier for concept -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="technique/value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="technique/value[@lang='0']"/>
    </skos:Concept>
</xsl:template>

<!-- EDM time span -->
<xsl:template match="content.event">
    <edm:TimeSpan>
        <!-- Create handle identifier for event -->
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </edm:TimeSpan>
</xsl:template>

<!-- EDM agent maker -->
<xsl:template match="maker">
    <!-- Anonymous creators do not get a sepperate EDM Agent occurence -->
    <xsl:if test="not(name/value[@lang='0'] = 'anonymous')">
        <edm:Agent>
            <xsl:attribute name="rdf:about">
                <!-- Create handle identifier for person -->
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
                <xsl:value-of select="PersistentIdentifier"/>
            </xsl:attribute>
            <!-- SKOS preferred label nl -->
            <xsl:apply-templates select="name/value[@lang='1']"/>
            <!-- SKOS preferred label en -->
            <xsl:apply-templates select="name/value[@lang='0']"/>
            <!-- rdaGr2 date of birth -->
            <xsl:apply-templates select="birth.date.end"/>
            <!-- rdaGr2 date of death -->
            <xsl:apply-templates select="death.date.end"/>
            <!-- rdaGr2 gender -->
            <xsl:apply-templates select="gender/value[@lang='0']"/>
            <!-- rdaGr2 place of birth -->
            <xsl:apply-templates select="born_at"/>
            <!-- rdaGr2 place of death -->
            <xsl:apply-templates select="died_at"/>
            <!-- rdaGr2 occupation nl -->
            <xsl:apply-templates select="occupation/value[@lang='1']"/>
            <!-- rdaGr2 occupation en -->
            <xsl:apply-templates select="occupation/value[@lang='0']"/>
            <!-- edmfp nationality -->
            <xsl:apply-templates select="nationality"/>
        </edm:Agent>
    </xsl:if>
</xsl:template>

<!-- EDM agent content person -->
<xsl:template match="content.person">
    <edm:Agent>
        <xsl:attribute name="rdf:about">
            <!-- Create handle identifier for person -->
            <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
        <!-- rdaGr2 date of birth -->
        <xsl:apply-templates select="born.on[@lang='1']"/>
        <!-- rdaGr2 date of death -->
        <xsl:apply-templates select="died.on[@lang='1']"/>
        <!-- rdaGr2 gender -->
        <xsl:apply-templates select="gender/value[@lang='0']"/>
        <!-- rdaGr2 place of birth -->
        <xsl:apply-templates select="born.at[@lang='1']"/>
        <!-- rdaGr2 place of death -->
        <xsl:apply-templates select="died.at[@lang='1']"/>
        <!-- rdaGr2 occupation nl -->
        <xsl:apply-templates select="occupation[@lang='1']"/>
        <!-- rdaGr2 occupation en -->
        <xsl:apply-templates select="occupation[@lang='0']"/>
        <!-- edmfp nationality -->
        <xsl:apply-templates select="nationality[@lang='1']"/>
    </edm:Agent>
</xsl:template>

<!-- rdaGr2 date of birth -->
<xsl:template match="content.person/born.on[@lang='1'] | maker/birth.date.end">
    <rdaGr2:dateOfBirth>
        <xsl:value-of select="."/>
    </rdaGr2:dateOfBirth>
</xsl:template>

<!-- rdaGr2 date of death -->
<xsl:template match="content.person/died.on[@lang='1'] | maker/death.date.end">
    <rdaGr2:dateOfDeath>
        <xsl:value-of select="."/>
    </rdaGr2:dateOfDeath>
</xsl:template>

<!-- rdaGr2 gender -->
<xsl:template match="content.person/gender/value[@lang='0'] | maker/gender/value[@lang='0']">
    <rdaGr2:gender>
        <xsl:value-of select="."/>
    </rdaGr2:gender>
</xsl:template>

<!-- rdaGr2 place of birth -->
<xsl:template match="content.person/born.at[@lang='1'] | maker/born_at">
    <rdaGr2:placeOfBirth>
        <xsl:value-of select="."/>
    </rdaGr2:placeOfBirth>
</xsl:template>

<!-- rdaGr2 place of death -->
<xsl:template match="content.person/died.at[@lang='1'] | maker/died_at">
    <rdaGr2:placeOfDeath>
        <xsl:value-of select="."/>
    </rdaGr2:placeOfDeath>
</xsl:template>

<!-- rdaGr2 profession or occupation nl  -->
<xsl:template match="content.person/occupation/value[@lang='1'] | maker/occupation/value[@lang='1']">
    <rdaGr2:professionOrOccupation xml:lang="nl">
        <xsl:value-of select="."/>
    </rdaGr2:professionOrOccupation>
</xsl:template>

<!-- rdaGr2 profession or occupation en -->
<xsl:template match="content.person/occupation/value[@lang='0'] | maker/occupation/value[@lang='0']">
    <rdaGr2:professionOrOccupation xml:lang="en">
        <xsl:value-of select="."/>
    </rdaGr2:professionOrOccupation>
</xsl:template>

<!-- edmfp nationality -->
<xsl:template match="content.person/nationality[@lang='1'] | maker/nationality">
    <edmfp:nationality xml:lang="nl">
        <xsl:value-of select="."/>
    </edmfp:nationality>
</xsl:template>

<!-- EDM place production -->
<xsl:template match="maker/production.place">
    <edm:Place>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- wgs latitude -->
        <xsl:apply-templates select="production.place.location/latitude"/>
        <!-- wgs longitude -->
        <xsl:apply-templates select="production.place.location/longitude"/>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </edm:Place>
</xsl:template>

<!-- EDM place content -->
<xsl:template match="content.location">
    <edm:Place>
        <xsl:attribute name="rdf:about">
            <xsl:if test="contains(PersistentIdentifier, 'RM0001')">
                <xsl:text>http://hdl.handle.net/10934/</xsl:text>
            </xsl:if>
            <xsl:value-of select="PersistentIdentifier"/>
        </xsl:attribute>
        <!-- wgs latitude -->
        <xsl:apply-templates select="content.place.location/latitude"/>
        <!-- wgs longitude -->
        <xsl:apply-templates select="content.place.location/longitude"/>
        <!-- SKOS preferred label nl -->
        <xsl:apply-templates select="value[@lang='1']"/>
        <!-- SKOS preferred label en -->
        <xsl:apply-templates select="value[@lang='0']"/>
    </edm:Place>
</xsl:template>

<!-- wgs latitude -->
<xsl:template match="production.place.location/latitude | content.place.location/latitude">
    <wgs84_pos:lat>
        <xsl:value-of select="."/>
    </wgs84_pos:lat>
</xsl:template>

<!-- wgs longitude -->
<xsl:template match="production.place.location/longitude | content.place.location/longitude">
    <wgs84_pos:long>
        <xsl:value-of select="."/>
    </wgs84_pos:long>
</xsl:template>

<!-- SKOS preferred label nl -->
<xsl:template match="content.classification.code/value[@lang='1'] | content.keyword/value[@lang='1'] | content.event/value[@lang='1'] | production.place/value[@lang='1'] | content.location/value[@lang='1'] | content.person/value[@lang='1'] | maker/name/value[@lang='1'] | object.name/value[@lang='1'] | material/value[@lang='1'] | technique/value[@lang='1']">
    <skos:prefLabel xml:lang="nl">
        <xsl:value-of select="."/>
    </skos:prefLabel>
</xsl:template>

<!-- SKOS preferred label en -->
<xsl:template match="content.person/value[@lang='0'] | maker/name/value[@lang='0'] | content.classification.code/value[@lang='0'] | content.keyword/value[@lang='0'] | content.event/value[@lang='0'] | production.place/value[@lang='0'] | content.location/value[@lang='0'] | object.name/value[@lang='0'] | material/value[@lang='0'] | technique/value[@lang='0']">
    <skos:prefLabel xml:lang="en">
        <xsl:value-of select="."/>
    </skos:prefLabel>
</xsl:template>

</xsl:stylesheet>
