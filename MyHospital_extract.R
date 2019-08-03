#############################################################################
rm(list = ls())               # clear Global Environment
#############################################################################
# Call required packages
#############################################################################
# package requred for downloading file
library(downloader)
# package required for str_extract 
library(stringr)
# openxlsx is used to read in xlsx files
library(openxlsx)
#############################################################################
# Define Directories
#############################################################################
DataLibrary <- "C:/Users/Romanee/Desktop/DataLibrary"
#ScriptLibrary <-"C:/Users/Romanee/Desktop/ScriptLibrary"
##############################################################################
# PART 1 download ALL xlsx files and save to working dir.
##############################################################################
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
# set wd to data library
setwd(DataLibrary)
dir.create("Online_Datasources")
write.csv(hospital_datasets, "Online_Datasources/MyHospital_data_download_list.csv", 
          row.names = FALSE)
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

##############################################################################
# PART 2 process xlsx sheets into csv files + metadata
##############################################################################
# assign list of xlsx files to "xlsxfiles"
xlsxfiles <- list.files(pattern = "xlsx")


#Name of new folder (2) 
new_folder2 <- "processed_csv"
# create new folder where all the newly processed csv files will be stored
dir.create(new_folder2)

# create and empty dataframe to store the metadata in
df_md <- data.frame()

# double loop to read in xlsx files and convert to csv files
for(j in 1:length(xlsxfiles)){
  setwd(paste(DataLibrary,new_folder, sep = "/"))
  for ( i in 1:length(getSheetNames(xlsxfiles[j]))){
    setwd(paste(DataLibrary,new_folder, sep = "/"))
    #2. read xlsx file sheet i
    wb <- read.xlsx(xlsxfiles[j], i)
    #3. identify first non NA row in column 2
    nms <- min(which(!is.na(wb[, 2])))
    #4. name columns row identified in step 3
    colnames(wb) <- wb[nms,]
    #5. drop all rows before first data row
    wb.1 <- wb[-c(1:nms),]
    #6. drop all columns where header is NA
    wb.2 <- wb.1[!is.na(names(wb.1))]
    #7. assign sheet name to "TAB"
    TAB <- getSheetNames(xlsxfiles[j])[i]
    #8. assign workbook name to "wb_name"
    wb_name <- xlsxfiles[j]
    #9. assign count of TABs to "sheet_count"
    sheet_count <- length(getSheetNames(xlsxfiles[j]))
    #10. create dataframe for md entry
    df <- data.frame(
      file_name = wb_name,
      TAB_name = TAB,
      Sheet_count = sheet_count,
      Rows = dim(wb.2)[1],
      Columns = dim(wb.2)[2]
    )
    #11. append new md dataframe to base dataframe
    df_md <- rbind(df_md, df)
    #12 set working dir. for csv files
    setwd(new_folder2)
    #13. write dataframe to csv file
    write.csv(wb.2, paste0(gsub(" ", "_", TAB), ".csv"), row.names =   F)
    
  }
}
#
# write metadata to csv
write.csv(df_md,  "metadata.csv", row.names =   F)
#
#############################################################################
<<<<<<< HEAD
#! END MyHospital_extract.R
#############################################################################
=======
#! END MyHospital.R
#############################################################################
>>>>>>> 8a1cfce0cba4d477354183cb8a60bc5ab8583de8
