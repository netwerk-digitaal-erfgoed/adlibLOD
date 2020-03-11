#!/bin/bash

# DC
# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/dc/dc.xslt input/testdata.adlib.xml > output/dc/testdata.rdf.xml

for xml_file in input/am/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/dc/am/${rdf_file%%.*}.rdf.xml ../stylesheets/dc/dc.xslt $xml_file
done

for xml_file in input/cmu/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/dc/cmu/${rdf_file%%.*}.rdf.xml ../stylesheets/dc/dc.xslt $xml_file
done

for xml_file in input/gm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/dc/gm/${rdf_file%%.*}.rdf.xml ../stylesheets/dc/dc.xslt $xml_file
done

for xml_file in input/lm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/dc/lm/${rdf_file%%.*}.rdf.xml ../stylesheets/dc/dc.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/dc/testdata.rdf.xml > output/dc/testdata.ttl

for rdf_file in output/dc/am/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/dc/am/${ttl_file%%.*}.ttl
done

for rdf_file in output/dc/cmu/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/dc/cmu/${ttl_file%%.*}.ttl
done

for rdf_file in output/dc/gm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/dc/gm/${ttl_file%%.*}.ttl
done

for rdf_file in output/dc/lm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/dc/lm/${ttl_file%%.*}.ttl
done

