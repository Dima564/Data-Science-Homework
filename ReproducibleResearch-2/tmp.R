library(dplyr)
library(ggplot2)
library(data.table)
library(scales)
timescale <-  scale_x_datetime(labels = date_format("%H:%M", tz=Sys.timezone()))

# Read data
data <- fread("activity.csv")
data <- data %>%  mutate(date=as.Date(date)) %>% 
  mutate(interval=sprintf("%04d", interval)) %>% 
  mutate(interval = as.POSIXct(paste(substr(interval, 1,2), substr(interval, 3,4)), format="%H %M"))

plotData <- data %>% group_by(date) %>% summarize(total.steps=sum(steps))
ggplot(plotData, aes(total.steps)) + geom_histogram(na.rm=TRUE)

data %>% group_by(date) %>% 
  summarize(total.steps = sum(steps)) %>% 
  summarize(mean=mean(total.steps, na.rm=T), median=median(total.steps, na.rm=T))



plotData <- data %>% group_by(interval) %>% summarize(avg.steps=mean(steps, na.rm=T))
ggplot(plotData, aes(x=interval, y=avg.steps)) + geom_line() + timescale

# highest interval
plotData[which.max(plotData$avg.steps),]$interval

#Imputing data
data <- data %>% group_by(interval) %>%
  mutate(steps=ifelse(is.na(steps), round(mean(steps, na.rm=T)), steps))


plotData <- data %>% group_by(date) %>% summarize(total.steps=sum(steps))
ggplot(plotData, aes(total.steps)) + geom_histogram(na.rm=TRUE)


data$weekday <- weekdays(data$date)
plotData <- data %>% group_by(weekday, interval) %>% summarize(avg.steps=mean(steps, na.rm=T))
ggplot(plotData, aes(x=interval, y=avg.steps)) + geom_line() + timescale + facet_grid(weekday ~ .)


