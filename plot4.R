library(dplyr)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

NEI <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")

filterList <- c("Fuel Comb - Comm/Institutional - Coal", "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal")

NEI <- NEI[NEI$EI.Sector %in% filterList, 1:6]

NEI <- mutate(NEI, year = factor(year))
NEI <- group_by(NEI, year)
NEI <- summarize(NEI, pm25Total = sum(Emissions, na.rm = TRUE))

NEI$year <- as.Date(NEI$year, format = "%Y")

png("plot4.png", width=640, height=480)

with(NEI, plot(year, pm25Total, xlab = "year", ylab = "PM2.5 Total", main = "US Total PM2.5 polutant emission by coal combustion-related sources", type = "l"))

dev.off()
