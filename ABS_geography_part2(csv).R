
# Note: require ABS_geography_part1.R to run first in order to create a list
# of links from which to download from
#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
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
dest_i <- paste0(csv_sub$folder_name[i])
#
# url_i the url to download the the chosen zipfile i
url_i <- paste(csv_sub$url[i])
#
setwd(DataLibrary)
# create a new directory named as the new zip file
dir.create(dest_i)
#
# set working directory to the new folder
setwd(dest_i)
#
# download the zip file and save as dest_i
download(paste0(url_i,".zip"), dest=dest_i, mode="wb") 
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
#files
df <- read.csv(files[1])
head(df)
#############################################################################
# (*) Source: 
#
# 1270.0.55.001 - Australian Statistical Geography Standard (ASGS):
# Volume 1 - Main Structure and Greater Capital City Statistical Areas, 
# July 2016  
#
#############################################################################
#! END ABS_geography_part2(csv).R
#############################################################################
