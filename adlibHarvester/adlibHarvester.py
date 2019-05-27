#! /usr/bin/env python3

import lxml.etree as etree
import urllib.request

# variables

## Adlib API-endpoint and variables
#endpoint = "http://amdata.adlibsoft.com/wwwopac.ashx?database=AMcollect&search=all&limit=100" # endpoint of Amsterdam Museum
#endpoint = "https://lodp-web.adlibhosting.com/webapi/wwwopac.ashx?database=Collect&search=all&limit=100"
endpoint = "http://collectie.groningermuseum.nl/webapi/wwwopac.ashx"

#database = "AMcollect" # database by Amsterdam Museum
#database = "Collect" # database in test environment
database = "collect" # database by Groninger Museum

search = "all"
limit = 100

# initialization
## initiate XSLT
xslt = etree.parse(stylesheet)
transform = etree.XSLT(xslt)

## initialize variables for loop
page = 0
numberFound = 1000000

# iterate through resultpages
while (numberFound > (page * limit)):
    startfrom = page * limit

    # read page of records
    requestUrl = endpoint + \
                    "?database=" + database + \
                    "&search=" + search + \
                    "&limit=" + str(limit) + \
                    "&startfrom=" + str(startfrom)

    print(requestUrl)
    result = urllib.request.urlopen(requestUrl)
    adlibXML = result.read()

    # parse adlibXML
    dom = etree.fromstring(adlibXML)

    for record in dom.findall('.//record'):
        priref = record.get('priref')
        requestUrl = endpoint + \
           "?database=" + database + \
           "&search=priref=" + priref

        print(requestUrl)
        result = urllib.request.urlopen(requestUrl)
        adlibXML = result.read()

        # parse adlibXML
        dom2 = etree.fromstring(adlibXML)
        adlibXML = etree.tostring(dom2, pretty_print=True)

        # write adlibXML-file
        filename = "out/" + database + "priref" + str(priref) + ".adlib.xml"
        f = open(filename,"wb")
        f.write(adlibXML)
        f.close()

    # make loop end
    ## read numberFound
    hits = dom.find(".//hits")
    numberFound = int(hits.text)
    numberFound = 200 # maximum for testing, comment this line for production

    page = page + 1
