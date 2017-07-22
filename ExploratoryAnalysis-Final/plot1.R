library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

plotData <- NEI %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
png(filename = "plot1.png")
with(plotData, plot(year, total.pm25, type='o'), main="Total Emissions in the US")
dev.off()