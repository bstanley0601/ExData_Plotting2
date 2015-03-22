###Exporatory Data Analysis Project2 - Question 5
###In Baltimore City, MD
###How have emissions from motor vehicle sources changed from 1999–2008?

library(plyr)
library(dplyr)
library(ggplot2)
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

###subset SCC where Short.Name contains "motor"
mvSCC <- subset(SCC, grepl("motor", Short.Name, ignore.case=TRUE), select = c("SCC","Short.Name","EI.Sector"))

###subset NEI for Baltimore and motor vehicle emissions by joining to the mvSCC subset
mvNEI <- NEI %>% filter(fips==24510) %>% merge(mvSCC, by="SCC")
names(mvNEI) <- c("SCC","FIPS","Pollutant", "Emissions", "Pollutant_Type", "Year", "Short.Name", "EI.Sector")

### Sum Emissions by year
print("Summing Emissions...")
yearlyEmissionsTotals<-summarize(group_by(mvNEI, Year), totalEmissions = sum(Emissions))


print("Plotting Baltimore MV Emissions by Year and Type...")
### Open the png plot device
png("Plot5_BaltimoreMVEmissions.png")

with(yearlyEmissionsTotals, 
     plot(Year, totalEmissions, type="b", pch=16,
          xlab="Year", ylab="PM2.5 Emissions",
          main="Motor Vehicle Emissions in Baltimore City, MD, 1999-2008"))

### Close the plot device
dev.off()

print("Plot5_BalitmoreMVEmissions.png created")

