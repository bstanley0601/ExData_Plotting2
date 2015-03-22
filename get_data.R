### Exporatory Data Analysis Project 2
### get_data.R
### this script down loads and unzips the NEI data file

get_data <- function (wd="./") {
    print("Downloading the dataset...")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                  destfile=paste(wd, "NEI_data.zip", sep="/"), 
                  method="curl",
                  quiet=TRUE)
    unzip(paste(wd, "NEI_data.zip", sep="/"), overwrite=TRUE)    
    
    rdsFiles<-dir(wd, pattern="*.rds")
    
    if (length(rdsFiles)==0) {
        
        print(paste("ERROR: rds files not present in", wd, sep=" "))
    }
    rdsFiles
    
}