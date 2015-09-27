library(dplyr)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

NEI <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")

filterList <- c("Mobile - On-Road Diesel Heavy Duty Vehicles", "Mobile - On-Road Diesel Light Duty Vehicles", "Mobile - On-Road Gasoline Heavy Duty Vehicles", "Mobile - On-Road Gasoline Light Duty Vehicles") 

NEI <- NEI[NEI$EI.Sector %in% filterList & NEI$fips == "24510", 1:6]

NEI <- mutate(NEI, year = factor(year))
NEI <- group_by(NEI, year)
NEI <- summarize(NEI, pm25Total = sum(Emissions, na.rm = TRUE))

NEI$year <- as.Date(NEI$year, format = "%Y")

png("plot5.png", width=640, height=480)

with(NEI, plot(year, pm25Total, xlab = "year", ylab = "PM2.5 Total", main = "Baltimore City PM2.5 polutant emission by motor vehicle-related sources", type = "l"))

dev.off()
