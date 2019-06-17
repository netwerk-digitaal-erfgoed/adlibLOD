<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 

	xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 

	exclude-result-prefixes="">

	<xsl:output method="xml" indent="yes" />

	<!-- Variables -->
	<xsl:variable name="uri-base" select="'http://example.orgdata.vangoghmuseum.nl/'" />

	<xsl:template match="/">
		
		<rdf:RDF>
			
			<xsl:apply-templates select="adlibXML/recordList/record" />
		
		</rdf:RDF>
		
	</xsl:template>
	
	<xsl:template match="record">
	
		<crm:E22_Man-Made_Object rdf:about="{concat($uri-base, 'object/', priref)}">

			<crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300133025" /> <!-- AAT concept: Artwork -->
			
			<crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300033618" /> <!-- AAT concept: Painting -->

			<!-- crm:P1_is_identified_by -->
			<xsl:apply-templates select="Title/title[@lang='en-US']" />

			<!-- crm:P1_is_identified_by -->
			<xsl:apply-templates select="object_number" />

			<!-- crm:P43_has_dimension -->
			<xsl:apply-templates select="Dimension[1]">

				<xsl:with-param name="type" select="'http://vocab.getty.edu/aat/300055644'" /> <!-- AAT concept: height -->

			</xsl:apply-templates>

			<!-- crm:P43_has_dimension -->
			<xsl:apply-templates select="Dimension[2]">

				<xsl:with-param name="type" select="'http://vocab.getty.edu/aat/300055647'" /> <!-- AAT concept: width -->

			</xsl:apply-templates>

			<!-- crm:P108i_was_produced_by -->
			<xsl:apply-templates select="Production[1]" />

			<!-- crm:P24i_changed_ownership_through -->
			<xsl:apply-templates select="Owner_history" />

		</crm:E22_Man-Made_Object>
		
	</xsl:template>

	<xsl:template match="object_number">

		<crm:P1_is_identified_by>

			<crm:E42_Identifier>

				<rdfs:label xml:lang='en'>Repository number</rdfs:label>

			    <crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300404621" /> <!-- AAT concept: Repository number -->

				<crm:P190_has_symbolic_content><xsl:value-of select="." /></crm:P190_has_symbolic_content>

			</crm:E42_Identifier>

		</crm:P1_is_identified_by>

	</xsl:template>

	<xsl:template match="title[@lang='en-US']">

		<rdfs:label xml:lang='en'><xsl:value-of select="." /></rdfs:label>

		<crm:P1_is_identified_by>

			<crm:E41_Appellation>

    			<crm:P2_has_type rdf:resource="http://vocab.getty.edu/aat/300404670" /> <!-- AAT concept: Preferred term -->

			    <crm:P190_has_symbolic_content xml:lang='en'><xsl:value-of select="." /></crm:P190_has_symbolic_content>

			</crm:E41_Appellation>

		</crm:P1_is_identified_by>

	</xsl:template>

	<xsl:template match="Dimension">

		<xsl:param name="type" />

		<crm:P43_has_dimension>

			<crm:E54_Dimension>

				<crm:P2_has_type rdf:resource="{$type}" />

				<crm:P90_has_value><xsl:value-of select="dimension.value" /></crm:P90_has_value>
				
    			<crm:P91_has_unit rdf:resource="http://vocab.getty.edu/aat/300379098" /> <!-- AAT concept: centimeters -->
    		
			</crm:E54_Dimension>

		</crm:P43_has_dimension>

	</xsl:template>

	<xsl:template match="Production">

		<crm:P108i_was_produced_by>

			<crm:E12_Production>
				
				<crm:P14_carried_out_by rdf:resource="{concat($uri-base, 'agent/', creator/@linkref)}" />
    			
				<crm:P7_took_place_at rdf:resource="{concat($uri-base, 'place/', production.place/@linkref)}" />

				<crm:P4_has_time-span>
				
					<crm:E52_Time-Span>

					    <crm:P82a_begin_of_the_begin><xsl:value-of select="../Production_date/production.date.start" /></crm:P82a_begin_of_the_begin>
    			
						<crm:P82b_end_of_the_end><xsl:value-of select="../Production_date/production.date.end" /></crm:P82b_end_of_the_end>

					</crm:E52_Time-Span>
				
				</crm:P4_has_time-span>

			</crm:E12_Production>

		</crm:P108i_was_produced_by>

	</xsl:template>

	<xsl:template match="Owner_history">

    	<crm:P24i_changed_ownership_through>

			<crm:E8_Acquisition>

				<crm:P22_transferred_title_to rdf:resource="{concat($uri-base, 'agent/', owner_hist.owner[1]/@linkref)}" />

				<crm:P23_transferred_title_from rdf:resource="{concat($uri-base, 'agent/', owner_hist.acquired_from[1]/@linkref)}" />
				
				<crm:P7_took_place_at rdf:resource="{concat($uri-base, 'place/', owner_hist.place[1]/@linkref)}" />

				<crm:P4_has_time-span>
				
					<crm:E52_Time-Span>

					    <crm:P82a_begin_of_the_begin><xsl:value-of select="owner_hist.date.start" /></crm:P82a_begin_of_the_begin>
    			
						<crm:P82b_end_of_the_end><xsl:value-of select="owner_hist.date.end" /></crm:P82b_end_of_the_end>

					</crm:E52_Time-Span>
				
				</crm:P4_has_time-span>			

			</crm:E8_Acquisition>

		</crm:P24i_changed_ownership_through>
	
	</xsl:template>

</xsl:stylesheet>