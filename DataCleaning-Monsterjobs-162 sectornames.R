
install.packages('dplyr')
library(dplyr)
getwd()
#file<-"sectortitles.csv"
#file<-read.csv(file)
monster<- "monster_com-job_sample.csv"
monster<-"Monster_myexcel.csv"
df<-read.csv(monster)
install.packages("sqldf")
library('sqldf')
filter<- sqldf(' Select DISTINCT *  FROM file')
#162 Unique Sector 
filtercount<-sqldf('select count(*) as count, sector from file group by sector order by count desc')
write.csv(filtercount, 'distinct162.csv',row.names=FALSE)
# we want to select only rows where 
#titles <-c("IT/Software Development","Experienced (Non-Manager)","Project/Program Management","Customer Support/Client Care","Entry Level","Building Construction/Skilled Trades","Civil & Structural EngineeringGeneral/Other: Engineering","Installation/Maintenance/Repair","Business/Strategic Management","Accounting/Finance/Insurance","General/Other: Engineering","Engineering","Editorial/Writing","Medical/Health","Marketing/Product","Manager (Manager/Supervisor of Staff)","Administrative/Clerical","Student (Undergraduate/Graduate)","Biotech/R&D/Science","Logistics/Transportation","General/Other: Customer Support/Client Care","Sales/Retail/Business Development","Education/Training","Other")
top20<-c("Experienced (Non-Manager)","Medical/Health","Entry Level","Sales/Retail/Business Development","Manager (Manager/Supervisor of Staff)","IT/Software Development","Project/Program Management","Accounting/Finance/Insurance","Food Services/Hospitality","Installation/Maintenance/Repair","Manufacturing/Production/Operations","Logistics/Transportation","Customer Support/Client Care","Quality Assurance/Safety","Marketing/Product","Security/Protective Services","Administrative/Clerical","Legal")
subset<-df[df$sector %in% top20,]
subsetdata<-data.frame(subset)
test<-sqldf('select count(*) as count, subset from subsetdata group by subset order by count desc')
removedfirst5<-subsetdata[,6:14]
sectorclean<-removedfirst5[,c(1:5,7:8)]
#few extra steps for deepas file
#sectorclean<-subsetdata
#write.csv(sectorclean, "sectorclean.csv",row.names=FALSE)
test2<-sqldf(" select count(*) as count, job_type from sectorclean group by job_type order by count desc")
##### Standardizing the Job_type column
#testdf<-replace(sectorclean$job_type, sectorclean[sectorclean$job_type=='Full Time Employee'], "XTEST")
 sectorclean$job_type[sectorclean$job_type == "Full Time, Employee"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time Temporary/Contract/Project"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time, Temporary/Contract/Project"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time / Employee"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time , Employee"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time , Temporary/Contract/Project"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time<e5><ca>"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Full Time/ Employee"] <- "Full Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Employee"] <- "Full Time Employee"
 #recode part time
 sectorclean$job_type[sectorclean$job_type == "Part Time"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Part Time, Employee"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Temporary/Contract/Project"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Per Diem, Employee"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Part Time Seasonal"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Per Diem"] <- "Part Time Employee"
 sectorclean$job_type[sectorclean$job_type == "Part Time/ Temporary/Contract/Project"] <- "Part Time Employee"
 jobtype3<-c(sectorclean$job_type == "Part Time Employee" | sectorclean$job_type == "Full Time Employee" |sectorclean$job_type == "")
sectorclean2<- sectorclean[jobtype3,]
 test3<-sqldf(" select count(*) as count, job_type from sectorclean2 group by job_type order by count desc")
write.csv(sectorclean2, "locationjobtitlesectorandjobtypeclean.csv", row.names=FALSE) 
