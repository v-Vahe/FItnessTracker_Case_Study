#
# This is code to create metadata for the case study and save them in the 
# figs folder

library(dplyr)
library(lubridate)
library(reshape2)
library(tidyverse)

# save the filenames
files = list.files('./Fitbit_data',pattern="*.csv")

# load origial datasets
for (i in 1:length(files)) {
  assign(gsub("\\.*","",files)[i], read_csv(paste('./Fitbit_data/',files[i],sep = '')))
}


# Dataset Summaries  ------------------------------------------

# dataframes into a list (same order as files)
DataFrames <- list(
  dailyActivity_merged,     
  heartrate_seconds_merged,   
  hourlyCalories_merged,      
  hourlyIntensities_merged,  
  hourlySteps_merged,     
  minuteCaloriesNarrow_merged,
  minuteIntensitiesNarrow_merged,
  minuteMETsNarrow_merged,   
  minuteSleep_merged,     
  minuteStepsNarrow_merged,   
  sleepDay_merged,          
  weightLogInfo_merged
)

# compute dataset characteristics
num_unique = num_row = num_var = num_missing_rows <- c()
for(i in 1:length(DataFrames)){
  # num_unique[i] <- length(unique(DataFrames[i]$Id)))
  num_unique <- append(num_unique, length(unique(DataFrames[[i]]$Id)))
  num_var <- append(num_var, ncol(DataFrames[[i]]))
  num_row <- append(num_row, nrow(DataFrames[[i]]))
  num_missing_rows <- append(num_missing_rows, sum(is.na(DataFrames[[i]])))
}

# prepare variable names of each dataset 
get.col.names <- function(dataset) {
  var_names <- paste(colnames(dataset),collapse=", ")
}


# Design Table For Summaries -----------------------------------------
paste(gsub("\\..*", "", files), ".", "csv")
# Put sumamry values a dataframe
summaries <- data.frame(
  Datasets = paste(gsub("\\..*", "", files), ".", "csv"),
  Variables = unlist(lapply(DataFrames, get.col.names)),
  `Num of Unique Ids` = num_unique,
  `Num of Variables` = num_var,
  `Num of Rows` = num_row,
  `Missing Values` = unlist(num_missing_rows)
)



# if(file.exists('../CaseStudy_data/'))
# stop("This is an error message")
write.table(summaries, file = "CaseStudy_data/metadata_orig.txt", sep = "\t",
            row.names = FALSE)
