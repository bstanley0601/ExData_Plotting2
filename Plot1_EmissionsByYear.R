###Exporatory Data Analysis Project2 - Question 1
###Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
###Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
###for each of the years 1999, 2002, 2005, and 2008.

library(plyr)
library(dplyr)
source(paste(wd, "get_data.R", sep="/"))

wd="./"

if(!exists("NEI")){
    if(!file.exists(paste(wd, "summarySCC_PM25.rds", sep="/"))) {
        get_data()
    }
    print("Reading summarySCC....")
    NEI <- readRDS(paste(wd,"summarySCC_PM25.rds", sep="/"))
}
if(!exists("SCC")){
    if(!file.exists(paste(wd, "SummarySCC_PM25.rds", sep="/"))) {
        get_data()
    }
    print("Reading Source Classification Code")
    SCC <- readRDS(paste(wd, "Source_Classification_Code.rds", sep="/"))
}

### Sum Emissions by year
print("Summing Emissions...")
yearlyEmissionsTotals<-summarize(group_by(NEI, year), totalEmissions = sum(Emissions))

print("Plotting Emissions by Year...")
### Open the png plot device
png("Plot1_EmissionsByYear.png")

### Plot using the base plotting system
with(yearlyEmissionsTotals, 
     barplot(names.arg=year, height=totalEmissions,
          xlab="Year", ylab="PM2.5 Emissions",
          main="Total Emissions in the United States, 1999-2008"))

### Close the plot device
dev.off()

print("Plot1_EmissionsByYear.png created")
