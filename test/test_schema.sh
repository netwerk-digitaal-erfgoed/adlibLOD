#!/bin/bash

# Schema.org
# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/schema/schema.xslt input/testdata.adlib.xml > output/schema/testdata.rdf.xml

for xml_file in input/am/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/schema/am/${rdf_file%%.*}.rdf.xml ../stylesheets/schema/schema.xslt $xml_file
done

for xml_file in input/cmu/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/schema/cmu/${rdf_file%%.*}.rdf.xml ../stylesheets/schema/schema.xslt $xml_file
done

for xml_file in input/gm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/schema/gm/${rdf_file%%.*}.rdf.xml ../stylesheets/schema/schema.xslt $xml_file
done

for xml_file in input/lm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/schema/lm/${rdf_file%%.*}.rdf.xml ../stylesheets/schema/schema.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/schema/testdata.rdf.xml > output/schema/testdata.ttl

for rdf_file in output/schema/am/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/schema/am/${ttl_file%%.*}.ttl
done

for rdf_file in output/schema/cmu/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/schema/cmu/${ttl_file%%.*}.ttl
done

for rdf_file in output/schema/gm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/schema/gm/${ttl_file%%.*}.ttl
done

for rdf_file in output/schema/lm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/schema/lm/${ttl_file%%.*}.ttl
done

