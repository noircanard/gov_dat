#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# call package rgdal (reading in shape files)
require(rgdal)
library(geosphere)
require(rgeos)
require(raster)
require(rgdal)
require(spatialEco)
require(sp)
require(maptools)
#
############################################################################
# define directories
wd.3 <- "C:/Users/Romanee/Desktop/DataLibrary/TFS"
wd.4 <- "C:/Users/Romanee/Desktop/DataLibrary/1259030001_sla11aaust_shape"
############################################################################
# set working directory
setwd(wd.4)
# read in shape file
SLA <- readOGR(dsn = '.', layer = "SLA11aAust")
# subset sape file
SLA.sub <- subset(SLA, STATE_CODE == 6)
# reset working directorie
setwd(wd.3)
#read in lat longs of points want to know distance from poly
p <- read.csv("p.csv")
# just the lat long
ps <- p[,c(3,4)]
# this next bit is very slow
start_time <- Sys.time()
# calc the distance between a point and its nearest polygon
poly2point <- dist2Line(ps, line = SLA.sub)
#
end_time <- Sys.time()
end_time - start_time
# write to csv
write.csv(cbind(p,data.frame(poly2point)), "DistPolytoPoint.csv", row.names = F)
############################################################################
# END
