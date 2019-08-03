
#############################################################################
# The following is designed to read in ABS geography files (shape and csv) (*)
# 1) - reading the html and extracting the download links
# 5) - saving list of links to csv for later use
#
#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# package required for str_extract 
library(stringr)
#############################################################################
# Define Directories
#############################################################################
DataLibrary <- "C:/Users/Romanee/Desktop/DataLibrary"
#ScriptLibrary <-"C:/Users/Romanee/Desktop/ScriptLibrary"
#############################################################################
#
setwd(DataLibrary)
#
# location of geography files
# NOTE: link has a date so may need updateing (see end of script for source)
abs_geography <- "https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument"
#
# read in html page as lines
page <- readLines(abs_geography)
#
# this pattern is used to id the lines with the download links
pat_links = 'AUSSTATS/subscriber.nsf.*zip'

# use the above pattern to clean up the lines so only a list of urls
url = paste0("https://www.ausstats.abs.gov.au/",
             str_extract(grep(pat_links,page, value=TRUE), "AUSSTATS.*&Latest"))

# this pattern is used to id the lines with the description of the downloads
pat_desc = '<td align="left" >.*</td>'

#
# use the above pattern to clean up the lines so only a list of urls descriptions
desc <- gsub("[>&]", "",str_extract(grep(pat_desc,page, value=TRUE),">.*&"))

pat_size <- 
size <- gsub("[^0-9]","",str_extract(grep(pat_links,page, value=TRUE),
                                     "title=\"[Download Zip File (].*[&]"))

#
# create a dataframe of links and their descriptions
download_list <- data.frame(desc, url, size)
#

download_list$file_type <- ifelse(grepl("ESRI Shapefile",download_list$desc), "ESRI Shapefile",
                                  ifelse(grepl("MapInfo",download_list$desc), "MapInfo",
                                         ifelse(grepl("Geopackage",download_list$desc), "Geopackage",
                                                ifelse(grepl("csv Format",download_list$desc), "csv Format", "Other"
                                                ))))
                                               


download_list$folder_name <- paste(download_list$desc,".zip",sep="")
dir.create("Online_Datasources")
write.csv(download_list, "Online_Datasources/ABSgeography_download_list.csv", row.names = FALSE)
#############################################################################
# (*) Source: 
#
# 1270.0.55.001 - Australian Statistical Geography Standard (ASGS):
# Volume 1 - Main Structure and Greater Capital City Statistical Areas, 
# July 2016  
#
#############################################################################
#! END ABS_geography_part1.R
#############################################################################
