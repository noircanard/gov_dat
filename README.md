# gov_dat
Data tools for government open data


### data sources:
1. The LIST http://listdata.thelist.tas.gov.au/opendata/
2. The ABS https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
3. MyHospitals https://www.myhospitals.gov.au/about-the-data/download-data
4. data.gov.au https://data.gov.au/



### ABS geography
The ABS publishing a number of shape files and related csv files options

being someone who doesnt like to have to download files and then write code to dig in Ive put together three scripts one to webscrape out all the links the names of the files and the file size, and two others designed to allow either csv files or shape files to be downloaded via R and then explored at will


### Australian Hospital data
MyHospitals publishes information provided by Australian hospitals. the most detail come from public hospitals

### The LIST
The LIST (Land Information System Tasmania) is a Tasmanian whole-of-government online infrastructure that helps you find and use information about land and property in Tasmania. All LIST files appear to be in easting and northing I have an example here in download_zipExtract_save.R where I have read in the data, converted to lat long and saved the results

I just found this link http://services.thelist.tas.gov.au/arcgis/rest/services/Public which i will have to write soemthing to read from as the LIST is not easy to webscrape via http://listdata.thelist.tas.gov.au/opendata/
