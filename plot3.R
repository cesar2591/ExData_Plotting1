library(readr)
library(dplyr)
library(lubridate)

if(!file.exists("./source/data.zip")){
  if(!dir.exists("./source")){
    dir.create("./source")
  }
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, "./source/data.zip")
  unzip("./source/data.zip")
}

if(!dir.exists("./figure")){
  dir.create("./figure")
}

data <- read_delim("household_power_consumption.txt",
                   delim = ";",
                   col_types = cols(
                     Date = col_date(format = "%d/%m/%Y"),
                     Time = col_time(format = ""),
                     Global_active_power = col_double(),
                     Global_reactive_power = col_double(),
                     Sub_metering_1 = col_double(),
                     Sub_metering_2 = col_double(),
                     Sub_metering_3 = col_double()),
                   na = "?") %>%
  filter(Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")) %>%
  mutate(datetime = ymd_hms(paste(Date, Time)))

png(file = "./figure/plot3.png", width = 480, height = 480)
plot(data$datetime, data$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(data$datetime, data$Sub_metering_1)
lines(data$datetime, data$Sub_metering_2, col = "red")
lines(data$datetime, data$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Submetering_1", "Submetering_2", "Submetering_3"),
       col = c("black", "red", "blue"),
       lty = 1)
dev.off()