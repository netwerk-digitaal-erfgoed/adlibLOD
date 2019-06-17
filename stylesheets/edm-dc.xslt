<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="baseUri">http://example.com/</xsl:param>

<!-- RDF wrap -->
<xsl:template match="record">
    <rdf:RDF>
        <edm:ProvidedCHO>
            <xsl:attribute name="rdf:about">
                <!-- Create handle identifier for object -->
                <xsl:value-of select="$baseUri"/>
                <xsl:value-of select="@priref"/>
            </xsl:attribute>
        </edm:ProvidedCHO>
    </rdf:RDF>
</xsl:template>

</xsl:stylesheet>
