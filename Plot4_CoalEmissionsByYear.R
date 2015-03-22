###Exporatory Data Analysis Project2 - Question 4
###Across the United States, 
###how have emissions from coal combustion-related sources changed from 1999–2008?

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

###subset SCC where Short.Name contains "coal"
coalSCC <- subset(SCC, grepl("coal", Short.Name, ignore.case=TRUE), select = c("SCC","Short.Name","EI.Sector"))
###subset NEI for coal emissions by joining to the coalSCC subset
coalNEI <- merge(NEI, coalSCC, by="SCC")

print("Plotting Coal Emissions by Year and Type...")
### Open the png plot device
png("Plot4_CoalEmissionsByYear.png")

### Plot using ggplot2
p <- ggplot(data=coalNEI, aes(x=year, y=Emissions, fill = type)) + 
     geom_bar(stat="identity", position=position_dodge()) + 
     ggtitle("Emissions from Coal in the US, 1999-2008") +
     xlab("Year") +
     ylab("PM2.5 Emissions")

print(p)

### Close the plot device
dev.off()

print("Plot4_CoalEmissionsByYear.png created")

