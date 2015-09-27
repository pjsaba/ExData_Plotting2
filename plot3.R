library(dplyr)
library(ggplot2)

NEI <- readRDS("./data/summarySCC_PM25.rds")

NEI <- NEI[NEI$fips == "24510", ]

NEI <- mutate(NEI, type_year = factor(paste(type, year)))
NEI <- group_by(NEI, type_year)
NEI <- summarize(NEI, pm25Total = sum(Emissions, na.rm = TRUE))

NEI$type_year <- as.character(NEI$type_year)
NEI$type <- vector("character", length = nrow(NEI))
NEI$year <- vector("character", length = nrow(NEI))

for (i in 1:nrow(NEI)) {
    tmp <- strsplit(as.character(NEI[i, 1]), " ")
    
    NEI[i, 3] <- tmp[[1]][1]
    NEI[i, 4] <- tmp[[1]][2]
}

png("plot3.png", width=960, height=540)

NEI$type <- factor(NEI$type)

g <- qplot(as.Date(year, format = "%Y"), pm25Total, data = NEI, geom = c("point", "smooth"), method = "lm", xlab = "year", facets = . ~ type)
print(g)

dev.off()

