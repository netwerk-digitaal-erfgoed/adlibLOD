#!/bin/bash

# transform Adlib XML into RDF/XML
xsltproc ../stylesheets/dc/dc.xslt input/testset.xml > output/test_dc.rdf.xml
xsltproc ../stylesheets/dc/dc_cmu.xslt input/cmu/collectpriref1.adlib.xml > output/cmu/cmutest_dc.rdf.xml
xsltproc ../stylesheets/dc/dc.xslt input/lm/moviespriref150000081.adlib.xml > output/lm/lmtest_dc.rdf.xml

# serialize RDF/XML into turtle for the ultimate test
rapper -o turtle output/test_dc.rdf.xml > output/test_dc.ttl
rapper -o turtle output/cmu/cmutest_dc.rdf.xml > output/cmu/cmutest_dc.ttl
rapper -o turtle output/lm/lmtest_dc.rdf.xml > output/lm/lmtest_dc.ttl