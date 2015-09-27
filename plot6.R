library(dplyr)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

NEI <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")

filterList <- c("Mobile - On-Road Diesel Heavy Duty Vehicles", "Mobile - On-Road Diesel Light Duty Vehicles", "Mobile - On-Road Gasoline Heavy Duty Vehicles", "Mobile - On-Road Gasoline Light Duty Vehicles") 

NEI <- NEI[NEI$EI.Sector %in% filterList & (NEI$fips == "24510" | NEI$fips == "06037"), ]

NEI2 <- NEI

NEI <- mutate(NEI, fips_year = factor(paste(fips, year)))
NEI <- group_by(NEI, fips_year)
NEI <- summarize(NEI, pm25Total = sum(Emissions, na.rm = TRUE))

NEI$fips_year <- as.character(NEI$fips_year)
NEI$fips <- vector("character", length = nrow(NEI))
NEI$year <- vector("character", length = nrow(NEI))

for (i in 1:nrow(NEI)) {
  tmp <- strsplit(as.character(NEI[i, 1]), " ")
  
  NEI[i, 3] <- tmp[[1]][1]
  NEI[i, 4] <- tmp[[1]][2]
}

png("plot6.png", width=640, height=480)

NEI$fips <- factor(NEI$fips, labels = c("Los Angeles County", "Baltimore City"))

g <- qplot(as.Date(year, format = "%Y"), pm25Total, data = NEI, geom = c("point", "smooth"), method = "lm", xlab = "year", facets = . ~ fips)
g <- g + labs(title = "Comparative between Baltimore and Los Angeles PM2.5 Pollutant evolution over the years")
print(g)

dev.off()