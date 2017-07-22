library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI <- NEI %>% mutate(type = as.factor(type))

plotData <- NEI %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
jpeg(filename = "plot4.jpg")
with(plotData, plot(year, total.pm25, type='o'), main="Total Emissions in the US")
dev.off()

plotData <- NEI %>% filter(fips=='24510') %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
with(plotData, plot(year, total.pm25, type='o'), main="Total Emissions in Baltimore City")


plotData <- NEI %>% filter(fips=='24510') %>% group_by(year, type) %>% summarize(total.pm25=sum(Emissions))
ggplot(plotData, aes(x=year, y=total.pm25, color=type)) +  geom_point() + geom_line()

#4
coalCombustion <- SCC[grep("(Comb.*Coal)", SCC$Short.Name),]$SCC
plotData <- NEI %>% filter(SCC %in% coalCombustion) %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
ggplot(plotData, aes(x=year, y=total.pm25)) + geom_point() + geom_line()

#5
motorVehicles <- SCC[grep("Motor", SCC$Short.Name),]$SCC
plotData <- NEI %>% filter(SCC %in% motorVehicles & fips=='24510') %>% group_by(year) %>% summarize(total.pm25=sum(Emissions))
ggplot(plotData, aes(x=year, y=total.pm25)) + geom_point() + geom_line()

#6
motorVehicles <- SCC[grep("Motor", SCC$Short.Name),]$SCC
codes <- data.frame(fips= c('24510', '06037'), area=c("Baltimore City", "Los Angeles County"))
plotData <- NEI %>% filter(SCC %in% motorVehicles & fips %in% c('24510', '06037')) %>% inner_join(codes)  %>% group_by(year, area) %>% summarize(total.pm25=sum(Emissions))
p <- ggplot(plotData, aes(x=year, y=total.pm25, color=area)) + geom_point() + geom_line() + labs('LA', "Baltimore")
ggsave("plot1.png", plot=p, device="png", width=10, height=10, dpi=48)
  
  
  