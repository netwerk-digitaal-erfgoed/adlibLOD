# adlibHarvester

Python3 script harvesting data from Adlib API endpoint
Stores xml-file for every priref from DATABASE on ENDPOINT in directory PATH, modified after DATE.

./adlibHarvester.py
* -v:  VERSION
* -t:  TEST download first 200 records
* -ep: ENDPOINT
* -db: DATABASE (default: collect)
* -p:  PATH (default: out\)
* -d:  DATE of last harvest (harvester only harvests records modified after date) default: 1900-01-01

example
```
./adlibHarvester.py -t -ep "http://collectie.groningermuseum.nl/webapi/wwwopac.ashx"
```
Stores AdlibXML-file for every priref from default database "collect" in default directory "out\"
