# adlibLOD

In this repository we develop XSLT stylesheets for converting AdlibXML into Linked Open Data.

Aanpak:
- testset maken
- iedereen toegang geven tot git en afspraken maken, hoe we codeveranderingen toevoegen
- uitgangspunt: we maken het voor de API
- uitgangspunt: dc.xslt van Chris
- aanpassen van de dc.xslt totdat het werkt
- testen aan serverside bij Axiell
- idem voor edm
- cidoc-crm

## Dublin Core Metadata Initiative (DC)
Conversion of the tist file (selection of objects) to [Dublin Core](http://dublincore.org/):

```
saxon -s:testdata/testset.xml -xsl:stylesheets/dc.xslt -o:out/test_dc.xml
```

```
xsltproc stylesheets/dc.xslt testdata/testset.xml > out/test_dc.xml
```