# Open Adlib API's in The Netherlands and Belgium

## Our testdatabase provided by Axiell
    endpoint = "https://lodp-web.adlibhosting.com/webapi50/wwwopac.ashx"
    database = "Collect"
    baseUri = "https://lodp.bladiebla.nl/" + priref

## Amsterdam Museum
    endpoint = "http://amdata.adlibsoft.com/wwwopac.ashx"
    database = "AMcollect"
    baseUri = "http://hdl.handle.net/11259/collection." + priref

## Groninger Museum
    endpoint = "http://collectie.groningermuseum.nl/webapi/wwwopac.ashx"
    database = "collect"
    baseUri = "http://collectie.groningermuseum.nl/Details/collect/" + priref

## Limburgs Museum
    endpoint = "https://lmus-web.adlibhosting.com/webapi/wwwopac.ashx"
    database = "collect"
    baseUri = "http://lm.bladiebla.nl/" + priref

## Centraal Museum
    endpoint = "http://cmu.adlibhosting.com/wwwopacximages/wwwopac.ashx"
    database = "collect"
    baseUri = "http://cmu.bladiebla.nl/" + priref

## Zuiderzeemuseum
    endpoint = "http://adlib.zuiderzeemuseum.nl/api2/wwwopac.ashx"

## Legermuseum
    endpoint = "http://fabrique.adlib.legermuseum.nl/api/wwwopac.ashx"
     
## Maritiem Digitaal
    endpoint = "http://mmr.adlibhosting.com/madigopacx/wwwopac.ashx"

# Documentation
http://api.adlibsoft.com/documentation/the-adlibweb-xml-file

## Quick start
    command=getversion
    command=listdatabases
    database=[]&command=getmetadata
    database=[]&search=all&limit=[]&startfrom=[]
    database=[]&search=priref=[]
    
