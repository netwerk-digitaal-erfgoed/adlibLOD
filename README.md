# adlibLOD
In this repository we develop XSLT stylesheets for converting basic AdlibXML into Linked Open Data. For your own use it might necessary to adjust the stylesheet to your own specific usages of Adlib fields and XML-elements.

## Home-brewed harvesting-tool in Python3
To get testdata - see directory "adlibHarvester".

## XSLT conversion
We will test our product with three XSLT-conversion tools.

### Saxon
Install saxon
[See this website](todo)

Usage example:
```
saxon -s:testdata/testset.xml -xsl:stylesheets/dc.xslt -o:out/test_dc.rdf.xml
```

### Xmllint
Install xmllint
[See this website](todo)

Usage examples:
```
xsltproc stylesheets/dc.xslt testdata/testset.xml > out/test_dc.rdf.xml
```

If you want to put the baseUri in the Command Line:
```
xsltproc --stringparam baseUri https://lodp-web.adlibhosting.com/priref/ stylesheets/dc.xslt testdata/testset.xml > out/test_dc.rdf.xml
```

### Microsoft thing
Is part of the Adlib intrastructure

## Various schemas
We developed the stylesheets top-to-bottom implementing all basicfields of a description into the schema at hand, and bottom-up by searching for all available data in the fields from the schema.

### Dublin Core Metadata Initiative (DC)
Conversion (selection of objects) to [Dublin Core](http://dublincore.org/) can be done with the stylesheet *stylesheets/dc.xslt*.

## Test RDF-syntax
We test the resulting XML/RDF by parsing it with raptor.
[See this website](todo)

Usage example
```
rapper -o turtle out/test_dc.rdf.xml > out/test_dc.ttl
```
