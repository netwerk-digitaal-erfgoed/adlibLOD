<?xml version="1.0" encoding="UTF-8"?>
<!-- adlibXML2rdf voor Amsterdam Museum collectiedata -->
<!-- CC0 Ivo Zandhuis (https://ivozandhuis.nl) -->
<!-- 2018426 -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sem="http://semanticweb.cs.vu.nl/2009/11/sem/"
  xmlns:schema="http://schema.org/"
  xmlns:void="http://rdfs.org/ns/void#"
  xmlns:lido="http://www.lido-schema.org/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  >

  <xsl:output method="xml" indent="yes"/>

  <!--xsl:strip-space elements="*"/-->

  <!-- basic structure -->
  <xsl:template match="/">
    <xsl:apply-templates select="adlibXML"/>
  </xsl:template>

  <xsl:template match="adlibXML">
    <xsl:apply-templates select="recordList"/>
  </xsl:template>

  <xsl:template match="recordList">
    <xsl:element name="rdf:RDF">
      <xsl:apply-templates select="record"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="record">
    <xsl:element name="edm:ProvidedCHO">
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="persistent_ID"/>
      </xsl:attribute>
      <!--void:inDataset rdf:resource="https://data.adamlink.nl/am/amcollect/"></void:inDataset-->
      <xsl:apply-templates select="object_number"/>
      <xsl:apply-templates select="title[1]" mode="label"/>
      <xsl:apply-templates select="title" mode="dc_title"/>
      <xsl:apply-templates select="maker"/>
      <xsl:apply-templates select="AHMteksten"/>
      <xsl:apply-templates select="production.date.start"/>
      <xsl:apply-templates select="production.date.end"/>
      <xsl:apply-templates select="object_name"/>
      <!--xsl:apply-templates select="material"/-->
      <xsl:apply-templates select="persistent_ID"/>
      <xsl:apply-templates select="reproduction"/>
      <xsl:apply-templates select="copyright"/>
      <xsl:apply-templates select="content_subject"/>
      <xsl:apply-templates select="association_subject"/>
 	    <xsl:apply-templates select="content.motif.general"/>
      <xsl:apply-templates select="content_person"/>
      <xsl:apply-templates select="association_person"/>
    </xsl:element>
  </xsl:template>

  <!-- matching elements -->

  <!-- persistent_ID => uri  -->
  <xsl:template match="persistent_ID">
    <xsl:element name="edm:isShownAt">
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- AHMteksten => dc:description -->
  <xsl:template match="AHMteksten">
    <xsl:element name="dc:description">
      <xsl:choose>
        <xsl:when test="AHM.texts.type/value='zaaltekst ENG'">
          <xsl:attribute name="xml:lang">
            <xsl:text>en</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="AHM.texts.type/value='zaaltekst NL'">
          <xsl:attribute name="xml:lang">
            <xsl:text>nl</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:value-of select="AHM.texts.tekst"/>
    </xsl:element>
  </xsl:template>

<!-- SUBJECT -->
  <!-- content.subject => dc:subject -->

  <xsl:template match="content_subject[node()]">
    <xsl:variable name="tipe">
      <xsl:value-of select="content.subject.type/value[@lang='neutral']"/>
    </xsl:variable>
    <xsl:apply-templates select="content.subject">
      <xsl:with-param name="tipe" select="$tipe"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="association_subject[node()]">
    <xsl:variable name="tipe">
      <xsl:value-of select="association.subject.type/value[@lang='neutral']"/>
    </xsl:variable>
    <xsl:apply-templates select="association.subject">
      <xsl:with-param name="tipe" select="$tipe"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="content.motif.general[node()] | association.subject[node()] | content.subject[node()]">
    <xsl:param name="tipe" />
    <xsl:choose>
      <xsl:when test="bronnen/link_url[node()]">
        <xsl:apply-templates select="bronnen/link_url[node()]">
          <xsl:with-param name="tipe" select="$tipe"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="subject-zonder-uri">
            <xsl:with-param name="tipe" select="$tipe" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="broader_term[node()]">
      <xsl:with-param name="tipe" select="$tipe"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="broader_term[node()]">
    <xsl:param name="tipe" />
    <xsl:choose>
      <xsl:when test="bronnen/link_url[node()]">
        <xsl:apply-templates select="bronnen/link_url[node()]">
          <xsl:with-param name="tipe" select="$tipe"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="subject-zonder-uri-broader_term">
            <xsl:with-param name="tipe" select="$tipe" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- -->
  <xsl:template match="content.subject/bronnen/link_url[node()] |
                        content.motif.general/bronnen/link_url[node()] |
                        association.subject/bronnen/link_url[node()] |
                        broader_term/bronnen/link_url[node()]">
    <xsl:param name="tipe" />
    <xsl:choose>
      <xsl:when test="$tipe = 'GEOKEYW'">
        <xsl:element name="dcterms:spatial">
          <xsl:element name="rdf:Description">
            <xsl:attribute name="rdf:about">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <xsl:element name="skos:altLabel">
              <xsl:value-of select="ancestor::*[2]/term"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <!-- $tipe = PERSON komt niet voor: deze zit in content.person -->
      <xsl:when test="$tipe = 'EVENT'">
          <xsl:element name="dc:subject">
            <xsl:element name="rdf:Description">
              <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource">http://semanticweb.cs.vu.nl/2009/11/sem/Event</xsl:attribute>
              </xsl:element>
              <xsl:element name="skos:altLabel">
                <xsl:value-of select="ancestor::*[2]/term"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
       </xsl:when>
        <xsl:otherwise>
          <xsl:element name="dc:subject">
            <xsl:element name="rdf:Description">
              <xsl:attribute name="rdf:about">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:attribute>
              <xsl:element name="skos:altLabel">
                <xsl:value-of select="ancestor::*[2]/term"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- -->
  <xsl:template name="subject-zonder-uri">
    <xsl:param name="tipe" />
    <xsl:choose>
      <xsl:when test="$tipe = 'GEOKEYW'">
        <xsl:element name="dcterms:spatial">
          <xsl:value-of select="term"/>
        </xsl:element>
       </xsl:when>
       <!-- $tipe = PERSON komt niet voor: deze zit in content.person -->
      <xsl:when test="$tipe = 'EVENT'">
          <xsl:element name="dc:subject">
            <xsl:element name="rdf:Description">
              <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource">http://semanticweb.cs.vu.nl/2009/11/sem/Event</xsl:attribute>
              </xsl:element>
              <xsl:element name="skos:altLabel">
                <xsl:value-of select="term"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:subject">
          <xsl:value-of select="term"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="subject-zonder-uri-broader_term">
    <xsl:param name="tipe" />
    <xsl:choose>
      <xsl:when test="$tipe = 'GEOKEYW'">
        <xsl:element name="dcterms:spatial">
          <xsl:value-of select="."/>
        </xsl:element>
       </xsl:when>
       <!-- $tipe = PERSON komt niet voor: deze zit in content.person -->
        <xsl:when test="$tipe = 'EVENT'">
          <xsl:element name="dc:subject">
            <xsl:element name="rdf:Description">
              <xsl:element name="rdf:type">
                <xsl:attribute name="rdf:resource">http://semanticweb.cs.vu.nl/2009/11/sem/Event</xsl:attribute>
              </xsl:element>
              <xsl:element name="skos:altLabel">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:subject">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- content.person.name => dc:subject -->
<xsl:template match="content_person[node()]">
  <xsl:element name="dc:subject">
    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="content.person.name.uri"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="association_person[node()]">
  <xsl:element name="dc:subject">
    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="association.person.uri"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

  <!-- copyright => dc:rights -->
  <xsl:template match="copyright">
    <xsl:choose>
      <xsl:when test="text() = 'Public Domain'">
        <xsl:element name="dc:rights">
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:when test="text() = 'CC0'">
        <xsl:element name="dc:rights">
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:rights">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- description => dc:description -->
  <xsl:template match="description">
    <xsl:element name="dc:description">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- maker => dc:creator -->
  <!-- NB hoe modelleer ik creator_qualifier "naar"? -->
  <xsl:template match="maker[node()]">
    <xsl:choose>
      <xsl:when test="creator.qualifier[node()] | creator.role[node()]">
        <xsl:element name="dc:creator">
          <xsl:element name="rdf:Description">
            <xsl:apply-templates select="creator.uri | creator.qualifier | creator.role"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:creator">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="creator.uri"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="creator.uri[node()]">
    <xsl:element name="dc:creator">
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="creator.role[node()]">
    <xsl:element name="schema:roleName">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="creator.qualifier[node()]">
    <xsl:element name="lido:attributionQualifierActor">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>


  <!-- object_name => dc:type -->
  <xsl:template match="object_name">
    <xsl:choose>
      <xsl:when test="bronnen/link_url[node()]">
        <xsl:apply-templates select="bronnen/link_url[node()]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:type">
          <xsl:value-of select="term"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="object_name/bronnen/link_url[node()]">
    <xsl:element name="dc:type">
      <xsl:element name="rdf:Description">
        <xsl:attribute name="rdf:about">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
        <xsl:element name="skos:altLabel">
          <xsl:value-of select="ancestor::*[2]/term"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- object_number => dc:identifier -->
  <xsl:template match="object_number">
    <xsl:element name="dc:identifier">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- production.date.* => sem:hasBeginTimeStamp/sem:hasEndTimeStamp -->
  <xsl:template match="production.date.start">
    <xsl:element name="sem:hasBeginTimeStamp">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="production.date.end">
    <xsl:element name="sem:hasEndTimeStamp">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- reproduction.identifier_URL => foaf:depiction -->
  <xsl:template match="reproduction">
    <xsl:apply-templates select="reproduction.identifier_URL"/>
  </xsl:template>

  <xsl:template match="reproduction.identifier_URL">

    <xsl:variable name="imageValue">
      <xsl:choose>
        <xsl:when test="contains(., '\images\')">
          <xsl:value-of select="substring-after(., '\images\')"/>
        </xsl:when>
        <xsl:when test="contains(., '\IMAGES\')">
          <xsl:value-of select="substring-after(., '\IMAGES\')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="imageValue1">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$imageValue" />
        <xsl:with-param name="replace" select="'\'" />
        <xsl:with-param name="by" select="'%5C'" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="imageValue2">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$imageValue1" />
        <xsl:with-param name="replace" select="' '" />
        <xsl:with-param name="by" select="'%20'" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="foaf:depiction">
      <xsl:attribute name="rdf:resource">
        <xsl:text>http://amasp.adlibhosting.com/wwwopacx_images/wwwopac.ashx?command=getcontent&amp;server=images&amp;value=</xsl:text>
        <xsl:value-of select="$imageValue2"/>
      </xsl:attribute>
    </xsl:element>

  </xsl:template>

  <!-- title => dc:title -->
  <xsl:template match="title" mode="dc_title">
    <xsl:element name="dc:title">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title" mode="label">
    <xsl:element name="rdfs:label">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- functions -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
        <xsl:when test="$text = '' or $replace = '' or not($replace)" >
            <!-- Prevent this routine from hanging -->
            <xsl:value-of select="$text" />
        </xsl:when>
        <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text" />
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
