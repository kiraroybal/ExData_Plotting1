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

## Plot 2
png("plot2.png", width = 480, height = 480)
plot(ts(elec$Global_active_power),
     xlab = "", ylab = "Global Active Power (kilowatts)", axes = FALSE)
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(0.1,2,4,5.6), labels = c(0,2,4,6))
box()
dev.off()