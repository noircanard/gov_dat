#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# packages for mapping
library(rgeos)
library(raster)
library(rgdal)
library(spatialEco)
library(sp)
library(maptools)
library(leaflet)
# package for plot
library(ggplot2)
# package for widgets
library(htmlwidgets) 
# package requred for unzipping file
library("utils") 
# package requred for downloading file
library("downloader")
# package required for wd prompt
library('svDialogs')
############################################################################################
# set working directory
#
setwd("C:/Users/Romanee/Desktop/DataLibrary/TEST")
#
# or prompt for wd
#setwd(dlg_dir(default = getwd())$res)
# location of zip file
#
url <- "http://listdata.thelist.tas.gov.au/opendata/data/LIST_LIQUOR_LICENCES_STATEWIDE.zip"
# download zip file
#
download(url, dest="LIST_LIQUOR_LICENCES_STATEWIDE.zip", mode="wb") 
# unzip newly downloaded file into temp
unzip("LIST_LIQUOR_LICENCES_STATEWIDE.zip")
# read in shape file
shape <-  readOGR(dsn = '.', layer = "list_liquor_licences_statewide")
# read in txt file
readme <- read.delim("readme.txt", header = FALSE, sep = "\t", dec = ".")
# save data table from shape file to df
df <- shape@data
# new field in df for extracted date (found in txt file) to extracted_date
df$LAST_UPDATED <- gsub("Extraction Date: ","",readme[1,1])
# new field in df for Easting
df$EASTING <- shape@coords[,1]
# new field in df for Northing
df$NORTHING <- shape@coords[,2]
df$id <- df$LICENCE_NO
# take subset of shape data to convert Easting Norting to Lat long
sub <- subset(df, select = c("id", "EASTING", "NORTHING"))
#
# Create a unique ID for each sub
sub$sub_ID <- 1:nrow(sub)
#
# Create coordinates variable
coords <- cbind(Easting = as.numeric(as.character(sub$EASTING)),
                Northing = as.numeric(as.character(sub$NORTHING)))
# Create id dataframe
dat <- data.frame(sub$id, sub$sub_ID)
#
# Create the SpatialPointsDataFrame
sub.sp <- SpatialPointsDataFrame(coords,
                                     data = dat,
                                     proj4string = CRS("+proj=utm +zone=55 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs "))
#
#Convert amg (EN) to lat long
EN.ll <- spTransform(sub.sp, CRS("+proj=longlat +datum=WGS84"))
#
# we also need to rename the columns
colnames(EN.ll@coords)[colnames(EN.ll@coords) == "EASTING"] <- "LONGITUDE"
colnames(EN.ll@coords)[colnames(EN.ll@coords) == "NORTHING"] <- "LATITUDE"
# create dataframe from data and coords
EN.ll.df <- data.frame(EN.ll@data, EN.ll@coords)
# merge df from the start and EN.ll.df by id --- dataset with both amg and lat long
n_data_ll <- merge(x= df, y = EN.ll.df, by.x= "LICENCE_NO"  , by.y= "sub.id"  )
# drop disclaimer, weblink, and id's
dat <- n_data_ll[,!names(n_data_ll) %in% c('WEB_LINK', 'DISCLAIMER', 'sub.sub_ID', 'id')]
# fix truncated names
names(dat) <- c( "LICENCE_NO", "PREMISE_NAME", "PREMISE_ADDRESS" ,  "CATEGORY", "SUB_CATEGORY",  
                 "CURRENCY","LAST_UPDATED", "EASTING", "NORTHING" , "LONGITUDE", "LATITUDE" )   
#
# write data to csv file - one dated the other generic for easy SSIS upload
write.csv(dat, paste("liquor_licence ",extract_date,".csv", sep = ""), row.names = F)
write.csv(dat, "liquor_licence.csv", row.names = F)
############################################################################################
#!END
