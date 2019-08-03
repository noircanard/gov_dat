#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# packages for reading in shape file
library(rgdal)
# package requred for unzipping file
library(utils) 
# package requred for downloading file
library(downloader)
#############################################################################
# Define Directories
#############################################################################
DataLibrary <- "C:/Users/Romanee/Desktop/DataLibrary"
#ScriptLibrary <-"C:/Users/Romanee/Desktop/ScriptLibrary"
#############################################################################
#
setwd(DataLibrary)
setwd("Online_Datasources")
#
download_list <- read.csv("ABSgeography_download_list.csv")
#
# download shape format
# make a subset of download_list for just the csv format data
shape_sub <- subset(download_list, file_type == "ESRI Shapefile")
# reset row index
row.names(shape_sub) <- NULL
#
# of the x listed pick one of the files to download and assign it to 's'
View(shape_sub)
# let graba little one - state and territory (larger ones take much longer)
s <- 15
#
# dest_s the description of the chosen zipfile s
dest_s <- paste0(shape_sub$folder_name[s])
#
# url_s the url to download the the chosen zipfile s
url_s <- paste(shape_sub$url[s])
#
# set wd to data library
setwd(DataLibrary)
#
# create a new directory named as the new zip file
dir.create(dest_s)
#
# set working directory to the new folder
setwd(dest_s)
#
# download the zip file and save as dest_s
download(paste0(url_s,".zip"), dest=dest_s, mode="wb") 
#
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
#plot(shape)
#############################################################################
# (*) Source: 
#
# 1270.0.55.001 - Australian Statistical Geography Standard (ASGS):
# Volume 1 - Main Structure and Greater Capital City Statistical Areas, 
# July 2016  
#
#############################################################################
#! END ABS_geography_part2(shp).R
#############################################################################