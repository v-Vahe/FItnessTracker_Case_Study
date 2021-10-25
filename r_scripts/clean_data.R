#
# This is code to clean and merge the datasets into minute, hour and daily summaries and save them in the 
# CaseStudy_data folder


library(dplyr)
library(lubridate)
library(tidyverse)
library(hms)
library(chron)

# # list the filenames
files = list.files('./Fitbit_data',pattern="*.csv")

for (i in 1:length(files)) {
  assign(gsub("\\..*","",files)[i], read_csv(paste('./Fitbit_data/',files[i],sep = '')))
}

# organize datasets to prepare for merge ------------------------------------------

# organize the daily weight columns
daily_weight <- weightLogInfo_merged %>%
  separate(Date,c("ActivityDate", "Time"), sep = " ") %>%
  rename(IsWeightManual = IsManualReport) %>%
  select(Id,ActivityDate,WeightKg:LogId)

# prepare daily sleep
daily_sleep <- sleepDay_merged %>%
  separate(SleepDay,c("ActivityDate", "Time"), sep = " ") %>%
  select(-Time)

# organize heart rate and aggrigate into minutes
minute_heartrate <- heartrate_seconds_merged %>% # takes a while
  mutate(Time = mdy_hms(Time)) %>%
  separate(Time,c("Date", "Time"), sep = " ") %>%
  mutate(Time = as.character.Date(parse_hm(Time)),Date = ymd(Date)) %>%
  group_by(Id, Date, Time) %>%
  summarise(AvgHeartrate = mean(Value),.groups = "drop")

# prepare minute sleep
minute_sleep_merged <- minuteSleep_merged %>%
  mutate(Time = mdy_hms(date)) %>%
  separate(Time,c("Date", "Time"), sep = " ") %>%
  mutate(Time = as.character.Date(parse_hm(Time)),Date = ymd(Date)) %>%
  group_by(Id, Date, Time) %>%
  summarise(Asleep = mean(value),.groups = "drop")


# Merge Datasets --------------------------------------------------------------------

# merge and organize the minute datasets
minute_data_merged <- minuteCaloriesNarrow_merged %>%
  left_join(minuteIntensitiesNarrow_merged, by = c("Id", "ActivityMinute")) %>%
  # left_join(minuteMETsNarrow_merged, by = c("Id", "ActivityMinute")) %>%
  left_join(minuteStepsNarrow_merged, by = c("Id", "ActivityMinute")) %>%
  mutate(ActivityMinute = mdy_hms(ActivityMinute)) %>%
  separate(ActivityMinute,c("Date", "Time"), sep = " ") %>%
  mutate(Date = ymd(Date), Day = weekdays(Date)) %>%
  left_join(minute_heartrate,c("Id","Date", "Time")) %>% # AvgHeartrate already in format
  select(Id,Date,Day,Time:Steps,AvgHeartrate)

# merge and organize the hourly datasets
hourly_data_merged <- hourlyCalories_merged %>%
  left_join(hourlyIntensities_merged, by = c("Id", "ActivityHour")) %>%
  left_join(hourlySteps_merged, by = c("Id", "ActivityHour")) %>%
  mutate(ActivityHour = mdy_hms(ActivityHour)) %>%
  separate(ActivityHour, c("Date", "Time"), sep = " ") %>%
  mutate(Date = ymd(Date), Day = weekdays(Date)) %>%
  rename(TotalStep = StepTotal) %>%
  left_join(minute_heartrate,c("Id","Date", "Time")) %>% # AvgHeartrate already in format
  left_join(minute_sleep_merged,c("Id","Date", "Time")) %>% # sleep already in format
  select(Id, Date, Time, Day, Calories, TotalIntensity:TotalStep, AvgHeartrate, Asleep)

# merge and organize daily datasets
daily_data_merged <- dailyActivity_merged %>%
  left_join(daily_sleep, by = c("Id", "ActivityDate")) %>%
  left_join(daily_weight, by = c("Id", "ActivityDate")) %>%
  mutate(ActivityDate = mdy(ActivityDate),Day = weekdays(ActivityDate)) %>%
  rename(Date = ActivityDate ) %>%
  select(
    Id, Date, Day, Calories,
    TotalSteps:SedentaryMinutes,
    TotalSleepRecords:TotalTimeInBed,
    WeightPounds,
    BMI,
    -LoggedActivitiesDistance,
    -Fat
  )


# Usage Groups -----------------------------------------------------------------

# Usage categories 
minutes_usaged <- minute_data_merged %>% 
  group_by(Id) %>% 
  select(Id,Date) %>% 
  summarise(Usage = n()) %>% 
  mutate(Usage = if_else(Usage < 40000, "Low", "High"))


# add usage groups to the datasets
minute_data_merged <- minute_data_merged %>% left_join(minutes_usaged)
hourly_data_merged <- hourly_data_merged %>% left_join(minutes_usaged)
daily_data_merged <- daily_data_merged %>% left_join(minutes_usaged)



# Duplicates -------------------------------------------------------------------

# get the number of duplicates 
daily_duplicates <- daily_data_merged %>% filter(duplicated(daily_data_merged)) %>% summarize(n())
hourly_duplicates <- hourly_data_merged %>% filter(duplicated(hourly_data_merged)) %>% summarize(n())
minute_duplicates <- minute_data_merged %>% filter(duplicated(minute_data_merged)) %>% summarize(n())

# duplicates into dataframe
duplicates <- data.frame(
  Dataset = c("daily_data_merged", "hourly_data_merged", "minute_data_merged"),
  Duplicates = c( daily_duplicates[[1]], hourly_duplicates[[1]], minute_duplicates[[1]])
)

# remove the duplicates
minute_data_merged <- minute_data_merged[!duplicated(minute_data_merged), ]
hourly_data_merged <- hourly_data_merged[!duplicated(hourly_data_merged), ]
daily_data_merged <- daily_data_merged[!duplicated(daily_data_merged), ]

# Table | Sedentary Minutes ------------------------------------------------------
sedentary_prc <- daily_data_merged %>% 
  select(Usage, 
         VeryActiveMinutes, 
         FairlyActiveMinutes, 
         LightlyActiveMinutes, 
         SedentaryMinutes) %>%
  mutate(NonSedentary = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes) %>%
  group_by(Usage)  %>%
  summarize(Sedentary = sum(SedentaryMinutes),
            NonSedentary = sum(NonSedentary))  %>%
  mutate(total = Sedentary + NonSedentary,
         Sedentary = paste0(round(Sedentary / total, 2) * 100, '%'),
         NonSedentary = paste0(round(NonSedentary / total, 2) * 100, '%')) %>% 
  select(-total)


# Write the results ------------------------------------------------------------------

#split minute_data_merge to reduce size of each
minute_data_merged1 <- minute_data_merged[,c(1,2,4,5)] 
minute_data_merged2 <- minute_data_merged[,c(1,2,4,3,6,7,8)]

# write the tables for number of duplicates
write.table(duplicates, file = "./CaseStudy_data/duplicates.txt", sep = "\t",
            row.names = FALSE)

# save the tables for sedebtary minures by groups
write.table(sedentary_prc, file = "./CaseStudy_data/sedentary_table.txt", sep = "\t",
            row.names = FALSE)
# write final datasets
write.csv2(minute_data_merged1, "./CaseStudy_data/minute_data_merged1.csv")
write.csv2(minute_data_merged2, "./CaseStudy_data/minute_data_merged2.csv")
write.csv2(hourly_data_merged, "./CaseStudy_data/hourly_data_merged.csv")
write.csv2(daily_data_merged, "./CaseStudy_data/daily_data_merged.csv")


