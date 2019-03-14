#! /usr/bin/env python3

import lxml.etree as etree
import urllib.request
import rdflib

# variables
## path/file for stylesheet to convert adlibXML into RDF/XML
stylesheet = "../example-stylesheets/amsterdammuseum/adlibXML2rdf.xslt"

## Adlib API-endpoint
#endpoint = "http://amdata.adlibsoft.com/wwwopac.ashx" # endpoint of Amsterdam Museum
endpoint = "https://lodp-web.adlibhosting.com/webapi/wwwopac.ashx"

## Adlib API variables
#database = "AMcollect" # database by Amsterdam Museum
database = "Collect"
search = "all"

# initialization
## initiate XSLT
xslt = etree.parse(stylesheet)
transform = etree.XSLT(xslt)

## initialize variables for loop
page = 0
numberFound = 1000000
numberShow = 100

# iterate through resultpages
while (numberFound > (page * numberShow)):
    start = page * numberShow

    # read page of records
    requestUrl = endpoint + \
                    "?database=" + database + \
                    "&search=" + search + \
                    "&limit=" + str(numberShow) + \
                    "&startfrom=" + str(start)

    print(requestUrl)

    result = urllib.request.urlopen(requestUrl)
    adlibXML = result.read()

    # write adlibXML-file for debugging purposes
    filename = "output/" + database + str(page) + ".adlib.xml"
    f = open(filename,"wb")
    f.write(adlibXML)
    f.close()

    # parse adlibXML
    dom = etree.fromstring(adlibXML)

    # read numberFound
    hits = dom.find(".//hits")
#    numberFound = int(hits.text)
    numberFound = 500 # maximum for testing

    # transform adlibXML into RDF/XML
    newdom = transform(dom)
    rdfxml = etree.tostring(newdom, pretty_print=True)

    # write rdfxml-file for debugging purposes
    filename = "output/" + database + str(page) + ".rdf.xml"
    f = open(filename,"wb")
    f.write(rdfxml)
    f.close()

    # read into rdf-graph object and serialize as turtle
    g = rdflib.Graph()
    r = g.parse(data=rdfxml, format="xml")
    s = g.serialize(format='turtle')

    # write turtle-file
    filename = "output/" + database + str(page) + ".ttl"
    f = open(filename,"wb")
    f.write(s)
    f.close()

    page = page + 1
