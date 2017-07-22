library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


motorVehicles <- SCC[grep("Motor", SCC$Short.Name),]$SCC
codes <- data.frame(fips= c('24510', '06037'), area=c("Baltimore City", "Los Angeles County"))
plotData <- NEI %>% filter(SCC %in% motorVehicles & fips %in% c('24510', '06037')) %>% inner_join(codes)  %>% group_by(year, area) %>% summarize(total.pm25=sum(Emissions))
p <- ggplot(plotData, aes(x=year, y=total.pm25, color=area)) + geom_point() + geom_line() + labs('LA', "Baltimore")
ggsave("plot6.png", plot=p, device="png", width=10, height=10, dpi=48)

