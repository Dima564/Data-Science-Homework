library(dplyr)

EI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

plotData <- NEI %>% filter(fips=='24510') %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
png(filename = "plot2.png")
with(plotData, plot(year, total.pm25, type='o'), main="Total Emissions in Baltimore City")
dev.off()