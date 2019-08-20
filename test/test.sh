#!/bin/bash

# transform Adlib XML into RDF/XML
for xml_file in input/lm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/lm/${rdf_file%%.*}.rdf.xml dc.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
for rdf_file in output/lm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -q -o turtle $rdf_file > output/lm/${ttl_file%%.*}.ttl
done