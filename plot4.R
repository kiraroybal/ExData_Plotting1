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

## Plot 4
par(mfcol = c(2,2))

png("plot4.png", width = 480, height = 480)
plot(ts(elec$Global_active_power),
     xlab = "", ylab = "Global Active Power (kilowatts)", axes = FALSE)
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(0.1,2,4,5.6), labels = c(0,2,4,6))
box()

plot(ts(elec$Sub_metering_2), ylim = c(0,30), 
     xlab = "", ylab = "Energy sub metering", col = "red", axes = FALSE)
lines(ts(elec$Sub_metering_3), col = "blue")
lines(ts(elec$Sub_metering_1), col = "black")
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(0.1,10,20,29.6), labels = c(0,10,20,30))
box()
legend(1600, 30, legend = c("Sub_metering_1", "Sub_metering_2", 
                            "Sub_metering_3"), 
       col = c("black", "red", "blue"),
       lty = c(1,1,1), 
       cex = 0.40, bty = "n", y.intersp = 0.5)

plot(ts(elec$Voltage), xlab = "datetime", ylab = "Voltage", 
     ylim = c(230, 250), axes = FALSE)
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(232,234.5,237,239.5,242,245.5,248), 
     labels = c(234,236,238,240,242,244,246), cex.axis=0.75)
box()

plot(ts(elec$Global_reactive_power), xlab = "datetime", 
     ylab = "Global_reactive_power", 
     ylim = c(0.0, 0.9), axes = FALSE)
axis(1, at=c(0, 1400, 2800), labels = c("Thu", "Fri", "Sat"))
axis(2, at=c(0,0.17,0.34,0.51,0.68,0.85), labels = c("0.0",0.1,0.2,0.3,0.4,0.5), 
     cex.axis=0.55)
box()
dev.off()

par(mfcol = c(1,1))