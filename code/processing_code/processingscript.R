# processing scrip
#
# Process the raw data

library(readr) # for load a CSV file
library(dplyr) #for data processing
library(here) #to set paths

# The data using in this assignment is from the CDC https://data.cdc.gov/NCHS/Conditions-Contributing-to-COVID-19-Deaths-by-Stat/hk9y-quqm
# This dataset shows health conditions and contributing causes mentioned in conjunction with deaths involving coronavirus disease 2019 (COVID-19) 
# by age group and jurisdiction of occurrence.

# The here package creates paths relative to the top-level directory.
# The package displays the top-level of the current project on load or any time you call

data_spot<- here::here("data","raw_data","Conditions_Contributing_to_COVID-19_Deaths__by_State_and_Age__Provisional_2020-2021.csv")
#Loading data
raw_data <- read.csv(data_spot)
# Checking the data 
dplyr::glimpse(raw_data)
# The data is particularly organized by groups: "By Total" or "By Year",. 
# "By Total" we can see the cumulative data per condition by age. 
# "By year" we can see the data from 2020 and 2021 by condition by age.
# "By Month" we can see the date by evey single month in both years by condition  by age.
#For this particular analysis we will use "By year" data, in order to see
# the behavior of some particular conditions by age in year 2020 and year 2021.
# The Flag variable counts less than 10 supressed. It takes in consideration values between 1 and 9. The we will removed those values from the data.

raw_data[-c("Flag"=="One or more"),]
processeddata <- filter(raw_data, Group=="By Year") %>%
  select(-"Month",-"ICD10_codes", -"Flag")

#looking for missing data
is.na(processeddata)

# Observations with NA values will be deleted

processeddata <- processeddata %>% na.omit(processeddata)

# Now the processeddata could be considerated as clean and we can start the analysis with:
# - What is the predominant condition contributing with COVID-19 deaths according with the age,
# we can do this by state or in general in United states.
# - We also, can make comparisons between year 2020 ans 2021 and see if the conditions are the same for both years.
# - What state(s) have the highest death rate according with the predominant condition in USA

# Now is time to save the data as RDS
save_data_spot<- here::here("data","processed_data","processeddata.rds")

saveRDS(processeddata, file = save_data_spot)


