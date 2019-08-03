#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# package requred for downloading file
library(downloader)
# package required for str_extract 
library(stringr)
#############################################################################
# Define Directories
#############################################################################
DataLibrary <- "C:/Users/Romanee/Desktop/DataLibrary"
#ScriptLibrary <-"C:/Users/Romanee/Desktop/ScriptLibrary"
#############################################################################
#
# location of hospital files
myhospital <- "https://www.myhospitals.gov.au/about-the-data/download-data"
#
# read in html page as lines
page <- readLines(myhospital)
#
# pattern used to ID the lines with the download links
pat_links = 'data-download-track-event.*xlsx'
# NOTE: captures all but xls file - not bothered
#
# links
links <- paste0("https://www.myhospitals.gov.au/",
                str_extract(grep(pat_links,page, value=TRUE), 
                            "excel-datasheets.*xlsx"))
#
# names
names <- gsub("<.*>","",gsub('xlsx\">', '',
              str_extract(grep(pat_links,page, value=TRUE),
                          "xlsx.*data")))
#
# create a dataframe out of links and names
hospital_datasets <- data.frame(names, links)
#
# set wd to data library
setwd(DataLibrary)
#
#Name of new folder 
new_folder <- "MyHospital"
# create new folder where all files will be stored in
dir.create(new_folder)
# set wd to new folder
setwd(new_folder)
#
# loop for download, name and save all data files from MyHospital
for ( i in 1:dim(hospital_datasets)[1]){
  
  download.file(url = paste0(hospital_datasets$links[i]), 
                destfile = paste0(hospital_datasets$names[i], ".xlsx"), mode="wb")
}

#list.files()
#############################################################################
#! END
#############################################################################