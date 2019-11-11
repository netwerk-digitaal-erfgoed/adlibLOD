# adlibHarvester

Python3 script harvesting data from Adlib API endpoint
Stores AdlibXML-file for every priref from DATABASE on ENDPOINT in directory PATH, modified after DATE.

./adlibHarvester.py
* -v:  VERSION
* -t:  TEST download first 200 records
* -ep: ENDPOINT
* -db: DATABASE (default: collect)
* -p:  PATH (default: output\)
* -d:  DATE of last harvest (harvester only harvests records modified after date) (default: 1900-01-01)
* -s:  SEARCH value, selecting records (default: all)

examples
```
./adlibHarvester.py -t -ep "http://collectie.groningermuseum.nl/webapi/wwwopac.ashx"
```

```
./adlibHarvester.py -ep "https://lmus-web.adlibhosting.com/webapi/wwwopac.ashx" -db "movies" -s "website_url=*"
```

```
./adlibHarvester.py -ep "http://cmu.adlibhosting.com/wwwopacximages/wwwopac.ashx" -db "collect" -s "creator=*Gogh*"
```