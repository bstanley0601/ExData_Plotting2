###Exporatory Data Analysis Project2 - Question 2
###Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
###from 1999 to 2008? 
###Use the base plotting system to make a plot answering this question.

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

### Subset to only Baltimore City, MD by fips==24510
baltimoreNEI <- filter(NEI, fips==24510)
### Sum Emissions by year
print("Summing Emissions...")
yearlyEmissionsTotals<-summarize(group_by(baltimoreNEI, year), totalEmissions = sum(Emissions))

print("Plotting Emissions by Year...")
### Open the png plot device
png("Plot2_BaltimoreEmissionsByYear.png")

### Plot using the base plotting system
with(yearlyEmissionsTotals, 
     plot(year, totalEmissions, type="b", pch=16,
          xlab="Year", ylab="PM2.5 Emissions",
          main="Total Emissions in Baltimore City, MD, 1999-2008"))

polygon(yearlyEmissionsTotals, col="lightblue", border="darkblue")


### Close the plot device
dev.off()

print("Plot2_BaltimoreEmissionsByYear.png created")
