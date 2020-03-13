# adlibLOD
In this repository we develop XSLT stylesheets for converting basic AdlibXML into Linked Open Data. For your own use it might be necessary to adjust the stylesheet to your own specific usages of Adlib fields and XML-elements.

## Testdata
We used testdata.adlib.xml, downloaded from a clean Axiell Collections installation. Furthermore we used [adlibHarvester](https://github.com/ivozandhuis/adlibHarvester) to download examples from other endpoints, to get an impression of the working of the stylesheets.

## XSLT conversion
We want to test our stylesheets with various XSLT-conversion tools.

### Xmllint
Usage examples:
```
xsltproc stylesheets/dc/dc.xslt test/input/testdata.adlib.xml > test/output/dc/testdata.rdf.xml
```

If you want to put the baseUri in the Command Line:
```
xsltproc --stringparam baseUri https://lodp-web.adlibhosting.com/priref/ stylesheets/dc/dc.xslt test/input/testdata.adlib.xml > test/output/dc/testdata.rdf.xml
```

### Saxon
Usage example:
```
saxon -s:test/input/testdata.adlib.xml -xsl:stylesheets/dc/dc.xslt -o:test/output/dc/testdata.rdf.xml
```

Conversion of the test set to [EDM](http://www.europeana.eu/schemas/edm/):
```
saxon -s:test/input/testdata.adlib.xml -xsl:stylesheets/edm/edm-dc.xslt -o:test/output/edm/testdata.rdf.xml
```

### MSXML 4.0
Usage example:
```
msxsl.exe input\testdata.adlib.xml ..\stylesheets\schema\schema.xslt -o testdata.rdf.xml
```

## Various schemas
We developed the stylesheets top-to-bottom implementing all basicfields of a description into the schema at hand, and bottom-up by searching for all available data in the fields from the schema.

### Dublin Core Metadata Initiative (DC)
Conversion (selection of objects) to [Dublin Core](http://dublincore.org/) can be done with the stylesheet *stylesheets/dc/dc.xslt*.

### Schema.org
Conversion (selection of objects) to [Schema.org](http://schema.org/) can be done with the stylesheet *stylesheets/schema/schema.xslt*.

### EDM
Conversion (selection of objects) to [Europeana Data Model](http://www.europeana.eu/schemas/edm/) can be done with the stylesheet *stylesheets/edm/edm-dc.xslt*.

### Linked Art
Conversion (selection of objects) to [Linked Art](https://linked.art/) can be done with the stylesheet *stylesheets/linked-art/linked-art.xslt*.

## Test RDF-syntax
We test the resulting XML/RDF by parsing it with [raptor](http://librdf.org/raptor/).

Usage example
```
rapper -o turtle test/output/dc/testdata.rdf.xml > test/output/dc/testdata.ttl
```
