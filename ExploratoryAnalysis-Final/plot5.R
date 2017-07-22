library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

motorVehicles <- SCC[grep("Motor", SCC$Short.Name),]$SCC
plotData <- NEI %>% filter(SCC %in% motorVehicles & fips=='24510') %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
p <- ggplot(plotData, aes(x=year, y=total.pm25)) + geom_point() + geom_line()
ggsave("plot5.png", plot=p, device="png", width=10, height=10, dpi=48)