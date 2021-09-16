###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(tidyverse) 

#path to data
#note the use of the here() package and not absolute paths
"~/Documents/School/Fall 2021/MADA/ALEXANDRAGIL_MADA_analysis2.1/ <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)

summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)

#now lets take another look
print(summary_df)

#For the analysis, lets look at the predominant condition contributing with COVID-19 deaths according to age group

#From the summary I can see that COVID.19.Deaths are categorical. Let change to numeric

mydata$COVID.19.Deaths <- as.numeric(mydata$COVID.19.Deaths)

#Double check
class(mydata$COVID.19.Deaths)

#Since age is categorical, this will have to be presented in a bar graph or table
#Lets transform this data from long format to wide format with age group into rows
#When transforming from long to wide, you will inevbitably get NA. 
#Since we are adding the sums in the table, I changed all NA to 0 to avoid an error

mydata[is.na(mydata)] = 0

#Now we can use pivot wider
agetbl <- pivot_wider(mydata, names_from = c(Age.Group), values_from = COVID.19.Deaths, Condition,  values_fn = sum)

print(agetbl)

#save data table 
table1_file = here("results", "table1.rds")
saveRDS(agetbl, file = table1_file)

#make a barchart
plot1data <- mydata[c("COVID.19.Deaths","Age.Group")]
plot1 <- ggplot(plot1data, aes(Age.Group, COVID.19.Deaths)) + geom_bar(stat = "identity")

plot(plot1)

#save figure
figure_file1 = here("results", "resultfigure1.png")
ggsave(filename = figure_file1, plot=plot1) 


#Now lets look at death in children from COVID-19
childdata <- mydata[ which(mydata$Age.Group=="0-24"), ]

#Looking at condition in those ages 0-24
plot2data <- childdata[c("COVID.19.Deaths","Condition")]
plot2 <- ggplot(plot2data, aes(Condition, COVID.19.Deaths)) + geom_bar(stat = "identity")
plot2.1 <- plot2 + coord_flip()

plot(plot2.1)


#save figure
figure_file2 = here("results", "resultfigure2.1.png")
ggsave(filename = figure_file2, plot=plot2.1) 

