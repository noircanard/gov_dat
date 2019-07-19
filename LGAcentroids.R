#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# packages for mapping
library(rgdal)
# set dsn  to shape file saved (ABS)
dsn <- "C:/Users/Romanee/Desktop/DataLibrary/2016_LGA_shape"
# set working directory
setwd(dsn)
# read in shape file
shape <- readOGR(dsn = '.', layer = "LGA_2016_AUST")
# get the centroids and then convert them to a SpatialPointsDataFrame
points <- SpatialPointsDataFrame(gCentroid(shape, byid=TRUE), 
                                      shape@data, match.ID=FALSE)
# 
df <- points@data
df$Longitude <- points@coords[,1]
df$Latitude <- points@coords[,2]
write.csv(df, "LGA_2016_AUST_centroids.csv", row.names =  F)
#############################################################################
# END

#https://gis.stackexchange.com/questions/43543/how-to-calculate-polygon-centroids-in-r-for-non-contiguous-shapes/43558
# for a point that sits in the true centre see above link and below code
# trueCentroids = gCentroid(sids,byid=TRUE)
# plot(sids)
# points(coordinates(sids),pch=1)
# points(trueCentroids,pch=2)
