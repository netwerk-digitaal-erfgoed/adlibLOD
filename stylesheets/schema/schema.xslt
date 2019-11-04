<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
<!ENTITY schema "http://schema.org/" >
<!ENTITY dct "http://purl.org/dc/dcmitype/" >
]>



<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:schema="http://schema.org/"  >
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="baseUri">http://test.nl/</xsl:param>

<xsl:template match="recordList">
    <rdf:RDF>
        <xsl:apply-templates select="record"/>        
    </rdf:RDF>
</xsl:template>

<xsl:template match="record">

    <!-- schema:CreativeWork -->
    <rdf:Description>

        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'object/',@priref)"/>
        </xsl:call-template>
        
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;CreativeWork'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        
        <!-- rdf:type detail --> 
        <xsl:if test="string(Object_name/object_name.lref)">
          <xsl:call-template name="type">
            <xsl:with-param name="value" select="concat($baseUri,'ontology/',Object_name/object_name.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>

        <!-- schema:identifier -->
        <xsl:call-template name="id">
            <xsl:with-param name="value" select="object_number"/>
        </xsl:call-template>

        <!-- schema:name -->
        <xsl:if test="not(Title/title.type = 'former title') and string(Title/title)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Title/title"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- schema:creator -->
        <xsl:if test="string(Production/creator.lref)">
          <xsl:call-template name="creator">
            <xsl:with-param name="value" select="concat($baseUri,'person/',Production/creator.lref[node()])"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>

        <!-- schema:about (association) -->
        <xsl:if test="string(Associated_subject/association.subject.type/value[@lang='1'])">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="Associated_subject/association.subject.type/value[@lang='1']"/>
            <xsl:with-param name="resource" select="false()"/>
          </xsl:call-template>
        </xsl:if>

        <!-- schema:about (content) -->
        <xsl:if test="string(Content_subject/content.subject.lref)">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="concat($baseUri,'ontology/',Content_subject/content.subject.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>

        <!-- schema:about Person (association) -->
        <xsl:if test="string(Associated_person/association.person.lref)">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="concat($baseUri,'person/',Associated_person/association.person.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(string(Associated_person/association.person.lref)) and string(Associated_person/association.person)">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="Associated_person/association.person"/>
            <xsl:with-param name="resource" select="false()"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- schema:about Person (content) -->
        <xsl:if test="string(Content_person/content_person.lref)">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="concat($baseUri,'person/',Content_person/content_person.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(string(Content_person/content_person.lref)) and string(Content_person/content_person)">
          <xsl:call-template name="about">
            <xsl:with-param name="value" select="Content_person/content_person"/>
            <xsl:with-param name="resource" select="false()"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- schema:description-->
        <xsl:if test="string(Description/description)">
          <xsl:call-template name="description">
              <xsl:with-param name="value" select="Description/description"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- schema:material -->
        <xsl:if test="string(Material/material.lref)">
          <xsl:call-template name="material">
            <xsl:with-param name="value" select="concat($baseUri,'ontology/',Material/material.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(string(Material/material.lref)) and string(Material/material)">
          <xsl:call-template name="material">
            <xsl:with-param name="value" select="Material/material"/>
            <xsl:with-param name="resource" select="false()"/>
          </xsl:call-template>
        </xsl:if>

        <!-- schema:dateCreated   NOTE: Modelled as a single value , should be an Event -->
        <xsl:if test="string(Production_date/production.date.end)">
          <xsl:call-template name="dateCreated">
              <xsl:with-param name="value" select="Production_date/production.date.end"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- schema:related  -->
        <xsl:if test="string(Related_object/related_object.association.lref)">
          <xsl:call-template name="related">
            <xsl:with-param name="value" select="concat($baseUri,'object/',Related_object/related_object.association.lref)"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
        </xsl:if>

        
      </rdf:Description>

      
<!--       SEPARATE RESOURCES -->
      
    
    <!-- schema:Person --> 
    <xsl:if test="string(Production/creator.lref)">
      <rdf:Description>
          <!-- URI -->
          <xsl:call-template name="attr-about">
            <xsl:with-param name="value" select="concat($baseUri,'person/',Production/creator.lref)"/>
          </xsl:call-template>
          
          <!-- rdf:type --> 
          <xsl:call-template name="type">
            <xsl:with-param name="value" select="'&schema;Person'"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>

          <!-- rdf:type role --> 
          <xsl:if test="string(Production/creator.role.lref)">
            <xsl:call-template name="type">
              <xsl:with-param name="value" select="concat($baseUri,'ontology/',Production/creator.role.lref)"/>
              <xsl:with-param name="resource" select="true()"/>
            </xsl:call-template>
          </xsl:if>
          
          <!-- schema:name -->
          <xsl:if test="string(Production/creator)">
            <xsl:call-template name="name">
                <xsl:with-param name="value" select="Production/creator"/>
            </xsl:call-template>
          </xsl:if>
      </rdf:Description>
    </xsl:if>

        
    <!-- schema:Role -->    
    <xsl:if test="string(Production/creator.role.lref)">
      <rdf:Description>
          <!-- URI -->
          <xsl:call-template name="attr-about">
            <xsl:with-param name="value" select="concat($baseUri,'ontology/',Production/creator.role.lref)"/>
          </xsl:call-template>
          <!-- rdf:type --> 
          <xsl:call-template name="type">
            <xsl:with-param name="value" select="'&schema;Role'"/>
            <xsl:with-param name="resource" select="true()"/>
          </xsl:call-template>
          <!-- schema:name -->
          <xsl:if test="string(Production/creator.role)">
            <xsl:call-template name="name">
                <xsl:with-param name="value" select="Production/creator.role"/>
            </xsl:call-template>
          </xsl:if>
      </rdf:Description>
    </xsl:if>
        
        
    <!-- Organization schema:owner -->
    <xsl:if test="string(institution.name.lref)">
      <rdf:Description>
          <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'organization/', institution.name.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Organization'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(institution.name)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="institution.name"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="owns">
          <xsl:with-param name="value" select="concat($baseUri,'object/',@priref)"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
      </rdf:Description>  
    </xsl:if>

 
    <!-- Detail type -->
    <xsl:if test="string(Object_name/object_name.lref)">
      <rdf:Description>
        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'ontology/', Object_name/object_name.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Class'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(Object_name/object_name)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Object_name/object_name"/>
          </xsl:call-template>
        </xsl:if>
      </rdf:Description>
    </xsl:if>
 
    <!-- Subject schema:about -->
    <xsl:if test="string(Content_subject/content.subject.lref)">
      <rdf:Description>
        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'ontology/',Content_subject/content.subject.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Class'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- rdfs:
 --> 
        <xsl:call-template name="subClassOf">
          <xsl:with-param name="value" select="Content_subject/content.subject.type/value[@lang='1']"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(Content_subject/content.subject)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Content_subject/content.subject"/>
          </xsl:call-template>
        </xsl:if>
        <!-- schema:identifier -->
        <xsl:if test="string(Content_subject/content.subject.identifier)">
          <xsl:call-template name="id">
              <xsl:with-param name="value" select="Content_subject/content.subject.identifier"/>
          </xsl:call-template>
        </xsl:if>
      </rdf:Description>
    </xsl:if>
    
    <!-- Super class -->
    <xsl:if test="string(Content_subject/content.subject.type/value[@lang='1'])" >
      <rdf:Description>
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'ontology/',Content_subject/content.subject.type/value[@lang='1'])"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Class'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:call-template name="name">
            <xsl:with-param name="value" select="Content_subject/content.subject.type/value[@lang='1']"/>
        </xsl:call-template>
    
      </rdf:Description>
    </xsl:if>

    

    <!-- Person schema:about (association) -->
    <xsl:if test="string(Associated_person/association.person.lref)">
      <rdf:Description>
        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'person/',Associated_person/association.person.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Person'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(Associated_person/association.person)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Associated_person/association.person"/>
          </xsl:call-template>
        </xsl:if>
      </rdf:Description>
    </xsl:if>

    <!-- Person schema:about (content) -->
    <xsl:if test="string(Content_person/content_person.lref)">
      <rdf:Description>
        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'person/',Content_person/content_person.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Person'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(Content_person/content_person)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Content_person/content_person"/>
          </xsl:call-template>
        </xsl:if>
      </rdf:Description>
    </xsl:if>
    
    <!-- schema:material Class -->
    <xsl:if test="string(Material/material.lref)">
      <rdf:Description>
        <!-- URI -->
        <xsl:call-template name="attr-about">
          <xsl:with-param name="value" select="concat($baseUri,'ontology/',Material/material.lref)"/>
        </xsl:call-template>
        <!-- rdf:type --> 
        <xsl:call-template name="type">
          <xsl:with-param name="value" select="'&schema;Class'"/>
          <xsl:with-param name="resource" select="true()"/>
        </xsl:call-template>
        <!-- schema:name -->
        <xsl:if test="string(Material/material)">
          <xsl:call-template name="name">
              <xsl:with-param name="value" select="Material/material"/>
          </xsl:call-template>
        </xsl:if>
      </rdf:Description>
    </xsl:if>

</xsl:template>





<!-- ################ TEMPLATES ################ -->

<!-- rdf:about -->
<xsl:template name="attr-about">
    <xsl:param name="value"/>
    <xsl:attribute name="rdf:about">
        <xsl:value-of select="$value"/>
    </xsl:attribute>
</xsl:template>


<!-- rdf:type --> 
<xsl:template name="type">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <rdf:type>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </rdf:type>
</xsl:template>


<!-- schema:identifier -->
<xsl:template name="id">
    <xsl:param name="value"/>
    <schema:identifier>
        <xsl:apply-templates select="$value"/>
    </schema:identifier>
</xsl:template>


<!-- schema:description -->
<xsl:template name="description">
    <xsl:param name="value"/>
    <schema:description>
        <xsl:apply-templates select="$value"/>
    </schema:description>
</xsl:template>

<!-- schema:dateCreated UNTYPED!! -->
<xsl:template name="dateCreated">
    <xsl:param name="value"/>
    <schema:dateCreated>
        <xsl:apply-templates select="$value"/>
    </schema:dateCreated>
</xsl:template>


<!-- schema:name / rdfs:label -->
<xsl:template name="name">
    <xsl:param name="value"/>
    <schema:name>
        <xsl:apply-templates select="$value"/>
    </schema:name>
    <rdfs:label>
        <xsl:value-of select="$value"/>
    </rdfs:label>
</xsl:template>


<!-- schema:creator-->
<xsl:template name="creator">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <schema:creator>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </schema:creator>
</xsl:template>


<!-- schema:owns-->
<xsl:template name="owns">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <schema:owns>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </schema:owns>
</xsl:template>

<!-- schema:about-->
<xsl:template name="about">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <schema:about>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </schema:about>
</xsl:template>

<!-- schema:related-->
<xsl:template name="related">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <schema:related>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </schema:related>
</xsl:template>

<!-- rdfs:subClasOf -->
<xsl:template name="subClassOf">
    <xsl:param name="value"/>
    <xsl:param name="uri" select="concat($baseUri,'ontology/',$value)" />
    <rdfs:subClassOf>
        <xsl:call-template name="resource">
            <xsl:with-param name="value" select="$uri"/>
        </xsl:call-template>
    </rdfs:subClassOf>
</xsl:template>

<!-- schema:material-->
<xsl:template name="material">
    <xsl:param name="value"/>
    <xsl:param name="resource" select="false()"/>
    <schema:material>
        <xsl:choose>
            <xsl:when test="$resource = true()">
                <xsl:call-template name="resource">
                    <xsl:with-param name="value" select="$value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </schema:material>
</xsl:template>



<!-- rdf:resource --> 
<xsl:template name="resource">
    <xsl:param name="value"/>
    <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$value"/>
    </xsl:attribute>
</xsl:template>




</xsl:stylesheet>
