#!/bin/bash

# EDM
# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/edm/edm-dc.xslt input/testdata.adlib.xml > output/edm/testdata.rdf.xml

for xml_file in input/am/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/edm/am/${rdf_file%%.*}.rdf.xml ../stylesheets/edm/edm-dc.xslt $xml_file
done

for xml_file in input/cmu/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/edm/cmu/${rdf_file%%.*}.rdf.xml ../stylesheets/edm/edm-dc.xslt $xml_file
done

for xml_file in input/gm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/edm/gm/${rdf_file%%.*}.rdf.xml ../stylesheets/edm/edm-dc.xslt $xml_file
done

for xml_file in input/lm/*.adlib.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o output/edm/lm/${rdf_file%%.*}.rdf.xml ../stylesheets/edm/edm-dc.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/edm/testdata.rdf.xml > output/edm/testdata.ttl

for rdf_file in output/edm/am/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/edm/am/${ttl_file%%.*}.ttl
done

for rdf_file in output/edm/cmu/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/edm/cmu/${ttl_file%%.*}.ttl
done

for rdf_file in output/edm/gm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/edm/gm/${ttl_file%%.*}.ttl
done

for rdf_file in output/edm/lm/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -o turtle $rdf_file > output/edm/lm/${ttl_file%%.*}.ttl
done

