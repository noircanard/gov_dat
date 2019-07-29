


# The following is designed to read in ABS geography files (shape and csv)
# 1) - reading the html and extracting the download links
# 2) - downloading zip to newly created folder
# 3) - extracting zip contents
# 4) - deleteing zip
# 5) - taking a squiz at the data
#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
############################################################################################
# packages for reading in shape file
library(rgdal)
# package requred for unzipping file
library(utils) 
# package requred for downloading file
library(downloader)
############################################################################################
# set working directory
#
base_dir <- "C:/Users/Romanee/Desktop/DataLibrary"
setwd(base_dir)
#
# location of geography files
abs_geography <- "https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument"
#
# read in html page as lines
page <- readLines(abs_geography)
#
# this pattern is used to id the lines with the download links
pat_links = '<a href="/AUSSTATS/subscriber.nsf.*"><img'
#
# use the above pattern to clean up the lines so only a list of urls
url = paste("https://www.ausstats.abs.gov.au",
              gsub('"><img src=.*',"",gsub( "<td  align=\"left\"><a href=\"","",grep(pat_links,page, value=TRUE))),sep = "")
#
# this pattern is used to id the lines with the description of the downloads
pat_desc = '<td align="left" >.*</td>'
#
# use the above pattern to clean up the lines so only a list of urls descriptions
desc = gsub("&nbsp;</td>", "" ,  gsub("<td align=\"left\" >", "",grep(pat_desc,page, value=TRUE)))
#
# create a dataframe of links and their descriptions
download_list <- data.frame(desc, url)
#

download_list$file_type <- ifelse(grepl("ESRI Shapefile",download_list$desc), "ESRI Shapefile",
                                  ifelse(grepl("MapInfo",download_list$desc), "MapInfo",
                                         ifelse(grepl("Geopackage",download_list$desc), "Geopackage",
                                                ifelse(grepl("csv Format",download_list$desc), "csv Format", "Other"
                                                ))))
                                               


download_list$folder_name <- paste(download_list$desc,".zip",sep="")



########################################################################################################################
# download csv format
# makea subset of download_list for just the csv format data
csv_sub <- subset(download_list, file_type == "csv Format")
# reset row index
row.names(csv_sub) <- NULL
#
# of teh 15 listed pick one of the files to download and assign it to 'i'
View(csv_sub)
i <- 13
#
# dest_i the description of the chosen zipfile i
dest_i <- csv_sub$folder_name[i]
#
# url_i the url to download the the chosen zipfile i
url_i <- paste(csv_sub$url[i])
#
setwd(base_dir)
# create a new directory named as the new zip file
dir.create(dest_i)
#
# set working directory to the new folder
setwd(dest_i)
#
# download the zip file and save as dest_i
download(url_i, dest=dest_i, mode="wb") 
#
# delete zip file

# unzip newly downloaded file
unzip(dest_i)
#
# delete  zipfile
unlink(dest_i)
#
# get a list of all files in new dir 
files <- list.files(pattern = "csv")
df <- read.csv(files[1])

########################################################################################################################
# download shape format
# makea subset of download_list for just the csv format data
shape_sub <- subset(download_list, file_type == "ESRI Shapefile")
# reset row index
row.names(shape_sub) <- NULL
#
# of the x listed pick one of the files to download and assign it to 's'
View(shape_sub)
s <- 13
#
# dest_s the description of the chosen zipfile s
dest_s <- shape_sub$folder_name[s]
#
# url_s the url to download the the chosen zipfile s
url_s <- paste(shape_sub$url[s])
#
# create a new directory named as the new zip file
dir.create(dest_s)
#
setwd(base_dir)
# set working directory to the new folder
setwd(dest_s)
#
# download the zip file and save as dest_s
download(url_s, dest=dest_s, mode="wb") 
#
# delete zip file
# unzip newly downloaded file
unzip(dest_s)
#
# delete  zipfile
unlink(dest_s)
#
# get a list of all files in new dir 
shape_file <- list.files(pattern = "shp")

shape <-  readOGR(dsn = '.', layer = gsub(".shp","",shape_file))
head(shape@data)
plot(shape)
