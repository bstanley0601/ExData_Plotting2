###Exporatory Data Analysis Project2 - Question 3
###Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
###which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
###Which have seen increases in emissions from 1999–2008? 
###Use the ggplot2 plotting system to make a plot answer this question.

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

### Subset to only Baltimore City, MD by fips==24510
baltimoreNEI <- filter(NEI, fips==24510)
### Sum Emissions by year
print("Summing Emissions...")
baltimoreSum<-ddply(baltimoreNEI, .(type,year), summarize, totalEmissions=sum(Emissions))
names(baltimoreSum) <- c("Pollutant_Type", "Year", "Total_Emissions")

print("Plotting Emissions by Year and Type...")
### Open the png plot device
png("Plot3_BaltimoreEmissionsByType.png")

### Plot using the ggplot2 plotting system

p<-qplot(Year, Total_Emissions, data=baltimoreSum, 
      group=Pollutant_Type, color=Pollutant_Type, geom=c("point","line"),
      xlab="Year", ylab="PM2.5 Emissions", 
      main="Emissions in Baltimore by Pollutant Type, 1999-2008")

print(p)

### Close the plot device
dev.off()

print("Plot3_BaltimoreEmissionsByType.png created")

#}