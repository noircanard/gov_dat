#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# call package rgdal (reading in shape files)
library(rgdal)
#
#############################################################################
# directories
wd.1 <- "C:/Users/Romanee/Desktop/DataLibrary/TFS"
wd.2 <- "C:/Users/Romanee/Desktop/DataLibrary/1259030001_sla11aaust_shape"
#############################################################################
# set working directory
setwd(wd.2)
SLA <- readOGR(dsn = '.', layer = "SLA11aAust")
# subset so only include Tas
SLA.sub <- subset(SLA, STATE_CODE == 6)
# re set working directory to where lat long dataset is located
setwd(wd.1)
# read in lat long data set (TFS lat long of fires - not open data though there is some stuff on the LIST)
tfs <- read.csv("TFS_data_ll.csv")
# convert lat longs in dataset to geo points
coordinates(tfs) <- ~  Longitude  + Latitude 
# make the crs for the lat long dataset the same as the shape file
crs(tfs) <- crs(SLA.sub)
# merge files on where the location of all the points are wihtin the shape file
pts.poly <- point.in.poly(tfs, SLA.sub)
# write new dataset to csv
write.csv(pts.poly, "tfs_SLA11.csv", row.names = F)
###############################################################################]
# END
