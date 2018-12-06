install.packages("sqldf")
library(sqldf)
query <- "select * from file where Date == '2/1/2007'" 
electric <- read.csv.sql(file = "household_power_consumption.txt", 
                         sql = query,
                         sep = ";")
query2 <- "select * from file where Date == '2/2/2007'" 
electric2 <- read.csv.sql(file = "household_power_consumption.txt", 
                         sql = query2,
                         sep = ";")
sqldf() # Close connection

elec <- rbind(electric, electric2)
elec$Date <- as.Date(elec$Date, format = "%m/%d/%Y")
elec$Time <- strptime(elec$Time, format = "%H:%M:%S")
elec$Time <- sub(".*\\s+", "",  elec$Time) # Subset only the time

## Plot 1
png("plot1.png", width = 480, height = 480)
hist(elec$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
     col = "red")
dev.off()