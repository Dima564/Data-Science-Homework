library(data.table)
library(dplyr)
library(ggplot2)

data <- fread("data.csv")

nydata <- data %>% filter(Provider.State=="NY")
p <- ggplot(nydata, aes(x=Average.Covered.Charges, y=Average.Total.Payments)) + geom_point() + geom_smooth(method='lm')
ggsave("plot1.pdf", plot=p, device="pdf")

p <- ggplot(data, aes(x=Average.Covered.Charges, y=Average.Total.Payments)) + geom_point() + facet_grid(Provider.State ~ DRG.Definition) + geom_smooth(method='lm')
ggsave("plot2.pdf", plot=p, device="pdf")


