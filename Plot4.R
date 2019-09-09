#load the required library
library("data.table")
library("dplyr")

#set the working directory of the downloaded data
setwd("./data")

#Reads in data from file then subsets data for specified dates
allData <- read.csv("household_power_consumption.txt", sep = ";", dec=".", na.strings="?")

#Set the effective date as per requirement - 2 days 1st Feb 2007 and 2nd Feb 2007
# Convert to it Date time class
#Filter the data - should have 2880 lines 
effectiveDT <- data.frame(DateTime = paste(allData$Date, allData$Time))

effectiveDT <- data.frame(DateTime = strptime(effectiveDT$DateTime, "%d/%m/%Y %H:%M:%OS"))

allData <- data.frame(allData, effectiveDT)

allData <- filter(allData, allData$DateTime >= "2007/02/01 00:00:00" &  allData$DateTime <= "2007/02/02 23:59:59")

#Plot the graph
par(mfrow = c(2, 2))

with(allData, 
{
plot(allData$DateTime, allData$Global_active_power,type = "l",ylab = "Global Active Power",xlab="")
plot(allData$DateTime, allData$Voltage,type = "l",ylab = "Voltage",xlab="datetime")

with(allData, plot(allData$DateTime, allData$Sub_metering_1, type = "l", ylab="Energy sub metering", xlab=NA))
with(allData, lines(allData$DateTime, allData$Sub_metering_2, col="red"))
with(allData, lines(allData$DateTime, allData$Sub_metering_3, col="blue"))
legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col = c("black", "red", "blue"))

plot(allData$DateTime, allData$Global_reactive_power,type = "l",ylab = "Global_reactive_power",xlab="datetime")
})


# Write it to a PNG file that is 480px by 480 px
dev.copy(png, file="../Plot4.png", height=480, width=480)
dev.off()
