#!/bin/bash

# Linked Art
# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/linked-art/linked-art.xslt input/testdata.adlib.xml > output/linked-art/testdata.rdf.xml

for xml_file in input/am/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/linked-art/am/${rdf_file%%.*}.rdf.xml ../stylesheets/linked-art/linked-art.xslt $xml_file
done

for xml_file in input/cmu/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/linked-art/cmu/${rdf_file%%.*}.rdf.xml ../stylesheets/linked-art/linked-art.xslt $xml_file
done

for xml_file in input/gm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/linked-art/gm/${rdf_file%%.*}.rdf.xml ../stylesheets/linked-art/linked-art.xslt $xml_file
done

for xml_file in input/lm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/linked-art/lm/${rdf_file%%.*}.rdf.xml ../stylesheets/linked-art/linked-art.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/linked-art/testdata.rdf.xml > output/linked-art/testdata.ttl

for rdf_file in output/linked-art/am/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/linked-art/am/${ttl_file%%.*}.ttl
done

for rdf_file in output/linked-art/cmu/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/linked-art/cmu/${ttl_file%%.*}.ttl
done

for rdf_file in output/linked-art/gm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/linked-art/gm/${ttl_file%%.*}.ttl
done

for rdf_file in output/linked-art/lm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/dc/lm/${ttl_file%%.*}.ttl
done

