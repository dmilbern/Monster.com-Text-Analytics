library(data.table)
library(readr)
library(sqldf)
library(dplyr)
install.packages("dlpyr")
install.packages("sqldf")
getwd()
setwd("/Users/davidmilbern/Downloads")
file <- readr::read_csv("locationjobtitlesectorandjobtypeclean_latest.csv")
#here we are determing which "sector" has the highest paying salary on average
file2<- file %>% filter(file$salary!=""|file$salary!="NA")

#subset file where salary does not equal na or blank
file2$salary2 = gsub("\\$", "", file2$SALARY_NEW)
file2$salary2 = gsub("\\,", "", file2$salary2)
avgsalary<-sqldf("select avg(salary2) as average_salary, sector, stdev(salary2) from file2 group by sector order by average_salary DESC")

###here we are seeing which sector jobs are most common in each region of the country
file3 <- readr::read_csv("Monster_Data_V_03.csv")
zonecount<-sqldf("Select count(*) as num_postings , SECTOR from file3 group by SECTOR order by  num_postings DESC ")
#Group by Zone, Sector, Count(sector) 