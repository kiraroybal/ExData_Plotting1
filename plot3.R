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

## Plot 3
png("plot3.png", width = 480, height = 480)
plot(ts(elec$Sub_metering_2), ylim = c(0,30), 
     xlab = "", ylab = "Energy sub metering", col = "red", axes = FALSE)
lines(ts(elec$Sub_metering_3), col = "blue")
lines(ts(elec$Sub_metering_1), col = "black")
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(0.1,10,20,29.6), labels = c(0,10,20,30))
box()
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", 
                              "Sub_metering_3"), 
       col = c("black", "red", "blue"),
       lty = c(1,1,1), 
       cex = 0.35)
dev.off()