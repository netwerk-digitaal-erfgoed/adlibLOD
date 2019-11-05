#!/bin/bash

# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/schema/schema.xslt input/testset.xml > output/test_schema.rdf.xml

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/test_schema.rdf.xml > output/test_schema.ttl
