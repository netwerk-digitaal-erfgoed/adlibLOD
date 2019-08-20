#!/bin/bash

# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/dc.xslt input/testset.xml > output/test_dc.rdf.xml

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/test_dc.rdf.xml > output/test_dc.ttl