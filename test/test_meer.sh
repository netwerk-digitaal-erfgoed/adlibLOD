#!/bin/bash

# transform Adlib XML into RDF/XML
for xml_file in input/cmu/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/cmu/${rdf_file%%.*}.rdf.xml ../stylesheets/dc/dc_cmu.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
for rdf_file in output/cmu/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -q -o turtle $rdf_file > output/cmu/${ttl_file%%.*}.ttl
done