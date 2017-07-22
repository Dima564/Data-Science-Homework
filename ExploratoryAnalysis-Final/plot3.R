library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

plotData <- NEI %>% filter(fips=='24510') %>% group_by(year, type) %>% summarize(total.pm25=sum(Emissions))
p <- ggplot(plotData, aes(x=year, y=total.pm25, color=type)) +  geom_point() + geom_line()
ggsave("plot3.png", plot=p, device="png", width=10, height=10, dpi=48)