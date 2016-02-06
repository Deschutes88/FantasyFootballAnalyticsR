library(ORCH)
ore.connect(type="HIVE") 
ore.attach()

#Sync Hives
ore.sync(table="ffstats") 
ore.sync(table="AAV") 

#Get Original R Working Directory
Original <- getwd()

#Set R Working Directory FantasyFootballAnalyticsR as Parent
setwd("/var/lib/hadoop-hdfs/jason/FantasyFootballAnalyticsR/")

#Update .csv Files
source(paste(getwd(),"/R Scripts/Projections/WalterFootball Projections.R", sep=""))
source(paste(getwd(),"/R Scripts/Projections/ESPN Projections.R", sep=""))
source(paste(getwd(),"/R Scripts/Projections/NFL Projections.R", sep=""))
source(paste(getwd(),"/R Scripts/Projections/FantasySharks Projections.R", sep=""))
source(paste(getwd(),"/R Scripts/Projections/FFtoday Projections.R", sep=""))

#Update Calculations
#These five are required to execute in this order. 
source(paste(getwd(),"/R Scripts/Calculations/Wisdom of the Crowd.R", sep=""))
source(paste(getwd(),"/R Scripts/Calculations/Calculate League Projections.R", sep=""))#Plot Data
source(paste(getwd(),"/R Scripts/Calculations/Risk.R", sep=""))
source(paste(getwd(),"/R Scripts/Calculations/Value Over Replacement.R", sep=""))
source(paste(getwd(),"/R Scripts/Calculations/Avg Cost.R", sep=""))
source(paste(getwd(),"/R Scripts/Calculations/Optimum Risk.R", sep=""))#Plot
#########################
source(paste(getwd(),"/R Scripts/Posts/Understanding Risk.R", sep=""))
source(paste(getwd(),"/R Scripts/Posts/AAV by Teams and Position/R Scripts/AAV by Teams and Position.R", sep=""))
############END

AAV <- read.csv(file = paste(getwd(),"/R Scripts/Posts/AAV by Teams and Position/Data/aavFitted.csv", sep=""))
AAV <- AAV[6]
AAV <- data.frame(lapply(AAV, as.character), stringsAsFactors=FALSE)
ore.push(AAV, table="AAV")

#Clean Data and Write to Tablesa
AC <- read.csv(file = paste(getwd(),"/Data/AvgCost.csv", sep=""))
AC <- AC[1:15]
AC <- data.frame(lapply(AC, as.character), stringsAsFactors=FALSE)
ore.push(AC, table="ffstats")
#data = ore.pull(ffstats)

#Change R's Working Directory Back to Original
setwd(Original)
      
