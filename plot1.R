library(dplyr)

NEI <- readRDS("./data/summarySCC_PM25.rds")

NEI <- mutate(NEI, year = factor(year))
NEI <- group_by(NEI, year)
NEI <- summarize(NEI, pm25Total = sum(Emissions, na.rm = TRUE))

NEI$year <- as.Date(NEI$year, format = "%Y")

with(NEI, plot(year, pm25Total, xlab = "year", ylab = "PM2.5 Total", main = "US Total PM2.5 polutant emission by year", pch = 20))
model <- lm(pm25Total ~ year, NEI)
abline(model, lwd = 2, col = "red")

dev.copy(png, file = "plot1.png")
dev.off()

