###Exporatory Data Analysis Project2 - Question 6
###Compare emissions from motor vehicle sources in Baltimore City 
###with emissions from motor vehicle sources in Los Angeles County, CA
###Which city has seen greater changes over time in motor vehicle emissions? 

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

### Subset to only Baltimore City, MD by fips==24510; add area name for use in plot instead of fips
balNEI <- NEI %>% filter(fips==24510) %>% merge(mvSCC, by="SCC")
balNEI$Area <- sub("24510", "Baltimore City, MD", balNEI$fips)
### Subset to only Los Angeles County, CA by fips==06037
laNEI <- NEI %>% filter(fips=="06037") %>% merge(mvSCC, by="SCC")
laNEI$Area <- sub("06037", "Los Angeles County, CA", laNEI$fips)

###combine Baltimore and Los Angeles; add area name for use in plot instead of fips
laAndBalNEI <- bind_rows(balNEI, laNEI)

### Sum Emissions by year
print("Summing Emissions...")
laAndBalSum<-ddply(laAndBalNEI, .(Area,year), summarize, totalEmissions=sum(Emissions))
names(laAndBalSum) <- c("Area", "Year", "Total_Emissions")

print("Plotting Emissions by Year and Type...")
### Open the png plot device
png("Plot6_BaltimoreAndLA_MVEmissions.png")

### Plot using the ggplot2 plotting system

p<-qplot(Year, Total_Emissions, data=laAndBalSum, 
      group=Area, color=Area, geom=c("point","line"),
      xlab="Year", ylab="PM2.5 Emissions", 
      main="Comparison of Motor Vehicle Emissions, 1999-2008")

print(p)

### Close the plot device
dev.off()

print("Plot6_BaltimoreAndLA_MVEmissions.png created")

#}