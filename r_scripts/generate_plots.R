
#
# This is code to produce the plots for the case study and save them in the 
# figs folder

library(dplyr)
library(tidyverse)
library(ggplot2) 
library(GGally)
library(reshape2)
library(grid)
library(gridExtra)
library(lubridate)


# read the datasets
daily_data_merged = read.csv2(paste('./CaseStudy_data/', "daily_data_merged.csv",sep = ''))[-1]
hourly_data_merged = read.csv2(paste('./CaseStudy_data/', "hourly_data_merged.csv",sep = ''))[-1]
minute_data_merged = read.csv2(paste('./CaseStudy_data/', "minute_data_merged.csv",sep = ''))[-1]


# barplot ------------------------------------------------------------------------------------------------------ 

barplot1 <- daily_data_merged %>%
  group_by(Day) %>%
  summarise(AvgCalories = mean(Calories)) %>%
  arrange(desc(AvgCalories)) %>%
  ggplot(aes(x=reorder(Day,AvgCalories), y= AvgCalories, fill = AvgCalories)) +
  geom_bar(stat = "identity", width = 0.2) +
  geom_col(width = 0.4) +
  coord_flip() + 
  # theme(aspect.ratio=1/2) +
  # theme(plot.margin = margin(7,.8,7,.8, "cm")) +
  labs(title =  "Figure 1. Average Calories of FitBeat Users",
       subtitle = "Plot of calories per day of week",
       x = element_blank(),
       y = "Average Calories") 

barplot2 <- minute_data_merged %>%
  group_by(Id) %>%
  summarise(AvgCalories = mean(Calories)) %>%
  arrange(desc(AvgCalories)) %>%
  ggplot(aes(x=reorder(Day,AvgCalories), y= AvgCalories, fill = AvgCalories)) +
  geom_bar(stat = "identity", width = 0.2) +
  geom_col(width = 0.4) +
  coord_flip() + 
  # theme(aspect.ratio=1/2) +
  # theme(plot.margin = margin(7,.8,7,.8, "cm")) +
  labs(title =  "Figure 1. Average Calories of FitBeat Users",
       subtitle = "Plot of calories per day of week",
       x = element_blank(),
       y = "Average Calories")

histogram1 <- minute_data_merged %>%
  ggplot(aes(x=MinuteUsage), color = "Blue") + 
  geom_histogram(color="darkblue", fill="lightblue") +
  geom_vline(xintercept=40000, linetype="dashed", color = "red") +
  labs(title =  "Figure. Distribution of minutes spent engageing with the app") 
  


# lineplots ------------------------------------------------------------------------------------------------------ 

# get days of week
days_of_week <- c("Monday", "Tuesday", "Wednesday", "Thursday",  "Friday", "Saturday", "Sunday")


# construc multiple lineplot figure all day long (argument: day)
day_lineplot1 <- function(d){
  
  # compute the minute averages
  minute_avg <- minute_data_merged %>%
    mutate(Time = as.POSIXct(hms::parse_hms(Time))) %>%
    filter(Day == d) %>%
    group_by(Time) %>%
    summarise(
      AvgCalories = mean(Calories),
      AvgSteps = mean(Steps),
      AvgHeartrate = mean(AvgHeartrate,na.rm = TRUE)) 
  
  # standardize the values and turn into wide format
  minute_avg <- minute_avg %>% mutate_at(scale, .vars = vars(-Time))
  minute_avg <- melt(minute_avg, id = "Time")
  
  # multiple lines plot 
  lineplot <- ggplot(minute_avg, aes(Time, value, group =variable )) +
    geom_line(aes(color=variable)) +
    ggtitle(d) +
    theme(axis.title.y=element_blank(),
          # axis.text.y=element_blank(),
          axis.ticks.y=element_blank()
          # aspect.ratio=1/5
          ) +
    scale_x_datetime(date_labels = "%H:%M") +
    geom_hline(yintercept=0, linetype="dashed", color = "indianred2") 
  
  return(lineplot)
}

# construc multiple lineplot figure 4:30 - 6:30 (argument: day)
day_lineplot2 <- function(d){
  
  # compute the minute averages
  minute_avg <- minute_data_merged %>%
    mutate(Time = as.POSIXct(hms::parse_hms(Time))) %>%
    filter(Day == d) %>%
    group_by(Time) %>%
    summarise(
      AvgCalories = mean(Calories),
      AvgSteps = mean(Steps),
      AvgHeartrate = mean(AvgHeartrate,na.rm = TRUE),
      AvgIntencity = mean(Intensity)) %>%
    mutate(hm = format(Time, "%H:%M")) %>% 
    filter(between(row_number(), which(hm == '04:30'), which(hm == '07:30'))) %>%
    select(-hm)
  
  # standardize the values and turn into wide format
  minute_avg <- minute_avg %>% mutate_at(scale, .vars = vars(-Time))
  minute_avg <- melt(minute_avg, id = "Time")
  
  # multiple lines plot 
  lineplot <- ggplot(minute_avg, aes(Time, value, group =variable )) +
    geom_line(aes(color=variable)) +
    ggtitle(d) +
    theme(axis.title.y=element_blank(),
          # axis.text.y=element_blank(),
          axis.ticks.y=element_blank()
          ) 
    scale_x_datetime(date_labels = "%H:%M")
  
  return(lineplot)
}


# apply function to all days
lineplot1 <- lapply(days_of_week, day_lineplot1)
lineplot2 <- lapply(days_of_week, day_lineplot2)

# function to extract legend of a ggplot
get_legend <- function(ggplt) { 
  ggtab <- ggplot_gtable(ggplot_build(ggplt))
  gggob <- which(sapply(ggtab$grobs, function(x) x$name) == "guide-box")
  shared_legend <- ggtab$grobs[[gggob]]
  return(shared_legend)
}

# put the plots together
lineplots1 <- grid.arrange(
  lineplot1[[1]] + theme(legend.position='hidden', axis.title.x=element_blank()),
  lineplot1[[2]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot1[[3]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot1[[4]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot1[[5]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot1[[6]] + theme(legend.position='hidden'), 
  lineplot1[[7]] + theme(legend.position='hidden'),
  get_legend(lineplot1[[1]]),
  top = textGrob("Figure 2. Averages per minute by days of week \n", gp=gpar(fontsize=18,font=3)),
  nrow = 4
)

# put the plots together
lineplots2 <- grid.arrange(
  lineplot2[[1]] + theme(legend.position='hidden', axis.title.x=element_blank()),
  lineplot2[[2]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot2[[3]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot2[[4]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot2[[5]] + theme(legend.position='hidden', axis.title.x=element_blank()), 
  lineplot2[[6]] + theme(legend.position='hidden'), 
  lineplot2[[7]] + theme(legend.position='hidden'),
  get_legend(lineplot2[[1]]),
  top = textGrob("Figure 3. Averages per minute by days of week \n", gp=gpar(fontsize=18,font=3)),
  bottom = textGrob("Hours from 4:30 to 6:30 \n", gp=gpar(fontsize=8,font=1)),
  nrow = 4
)


# Lineplot 3 / Hourly Usages --------------------------------------------------------------------------------  

# add Usages 
minute_avg_highcont <- minute_data_merged %>% 
  filter(Usage == "High") %>% 
  mutate(Time = as.POSIXct(hms::parse_hms(Time))) %>% 
  group_by(Time) %>% 
  summarise( 
    AvgCalories = mean(Calories), 
    AvgSteps = mean(Steps), 
    AvgIntensity = mean(Intensity), 
    AvgHeartrate = mean(AvgHeartrate,na.rm = TRUE), 
    NumUsers = n()) %>% 
  mutate(NumUsers = (NumUsers- min(NumUsers))/(max(NumUsers)- min(NumUsers))) 

# aggregare Usages 
minute_avg_modcont <- minute_data_merged %>% 
  filter(Usage != "High") %>% 
  mutate(Time = as.POSIXct(hms::parse_hms(Time))) %>% 
  group_by(Time) %>% 
  summarise( 
    AvgCalories = mean(Calories), 
    AvgSteps = mean(Steps), 
    AvgIntensity = mean(Intensity), 
    AvgHeartrate = mean(AvgHeartrate,na.rm = TRUE), 
    NumUsers = n())  %>% 
  mutate(NumUsers = (NumUsers- min(NumUsers))/(max(NumUsers)- min(NumUsers))) 


# aggregare Usages 
minute_avg_lowcont <- minute_data_merged %>% 
  filter(Usage == "Low") %>% 
  mutate(Time = as.POSIXct(hms::parse_hms(Time))) %>% 
  group_by(Time) %>% 
  summarise( 
    AvgCalories = mean(Calories), 
    AvgSteps = mean(Steps), 
    AvgIntensity = mean(Intensity), 
    AvgHeartrate = mean(AvgHeartrate,na.rm = TRUE), 
    NumUsers = n())  %>% 
  mutate(NumUsers = (NumUsers- min(NumUsers))/(max(NumUsers)- min(NumUsers))) 


# add a Usage column 
minute_avg_highcont$Usage = "High" 
minute_avg_lowcont$Usage = "Low" 

# merge high and low Usages 
minute_Usage <- minute_avg_highcont %>% 
  full_join(minute_avg_lowcont)  


lineplot3 <- minute_Usage %>%
  ggplot(aes(Time, AvgCalories, fill =Usage)) +
  geom_line(aes(color = Usage), size=0.8) +
  theme_bw(base_size = 12) +
  theme(legend.position="bottom") +
  labs(title = "Figure 6. Hourly calories burnt",
       subtitle = "lineplots by low and high ussage groups") +
  scale_x_datetime(date_labels = "%H:%M") +
  scale_fill_manual(values=c( "#56B4E9","#E69F00")) +
  scale_color_manual(values=c("#56B4E9","#E69F00"))
  


# correlograms -------------------------------------------------------------------------------------------------------- 

# change the color codes of groups / correlogram
change_palette <- function(correlogram){
  for(i in 1:correlogram$nrow) {
    for(j in 1:correlogram$ncol){
      correlogram[i,j] <- correlogram[i,j] + 
        scale_fill_manual(values=c( "#56B4E9","#E69F00")) +
        scale_color_manual(values=c("#56B4E9","#E69F00"))  
    }
  }
  return(correlogram)
}

change_palette_single <- function(data, mapping, method = "lm", ...) {
  correlogram <- ggplot(data = data, mapping = mapping) +
    geom_point(colour = "Darkgreen") +
    geom_smooth(method = method, color = "darkred", ...)
  return(correlogram)
}

# create correlogram for sleep and sedentary minutes
correlogram1 <- daily_data_merged %>% 
  select(TotalMinutesAsleep,TotalTimeInBed, SedentaryMinutes) %>% 
  ggpairs(lower = list(continuous = wrap(change_palette_single, method = "lm")),
          diag = list(continuous = wrap("barDiag", colour = "Darkgreen")),
          upper = list(continuous = wrap("cor", size = 4))) + 
  theme(panel.grid.major = element_blank()) +
  labs(title = "Figure 4. Correlogram Of Sedentary Minutes vs Sleep",
       caption = "Data source: ToothGrowth")

# create correlogram for weight
correlogram2 <- daily_data_merged %>% 
  select(WeightPounds, BMI, SedentaryMinutes) %>% 
  ggpairs(lower = list(continuous = wrap(change_palette_single, method = "lm")),
          diag = list(continuous = wrap("barDiag", colour = "Darkgreen")),
          upper = list(continuous = wrap("cor", size = 4))) + 
  theme(panel.grid.major = element_blank()) +
  labs(title = "Figure 5. Correlogram Of Weight vs Sedentary Minutes",
       subtitle = "Plots by low and high ussage groups",
       caption = "Data source: ToothGrowth")

# create correlogram for activities and calories
correlogram3 <- daily_data_merged %>% 
  select(Calories, VeryActiveMinutes, 
         LightlyActiveMinutes, SedentaryMinutes, Usage) %>% 
  ggpairs(mapping = ggplot2::aes(colour = Usage),
          lower = list(continuous = wrap("smooth", alpha = 0.5, size=0.9,alignPercent=0.8)),
          diag = list(discrete="barDiag", continuous = wrap("densityDiag", alpha=0.5 )),
          upper = list(combo = wrap("box_no_facet", alpha=0.5)),
          columns = 1:5) + 
  theme(panel.grid.major = element_blank()) +
  labs(title = "Figure 8. Correlogram Of Calories vs Minutes Active",
       subtitle = "Plots by low and high ussage groups",
       caption = "Data source: ToothGrowth") 
correlogram3 <- change_palette(correlogram3)



# create correlogram for sleep
correlogram4 <- daily_data_merged %>% 
  select(TotalMinutesAsleep,TotalTimeInBed, Usage) %>% 
  ggpairs(mapping = aes(colour = Usage),
          lower = list(continuous = wrap("smooth", alpha = 0.5, size=2,alignPercent=0.8)),
          diag = list(discrete="barDiag", continuous = wrap("densityDiag", alpha=0.5 )),
          columns = 1:2) + 
  theme(panel.grid.major = element_blank()) +
  labs(title = "Figure 9. Correlogram Of Minutes Asleep vs Minutes In Bed",
       subtitle = "Plots by low and high ussage groups",
       caption = "Data source: ToothGrowth") 
correlogram4 <- change_palette(correlogram4)


# Pie-Charts (ACTIVITIES) ---------------------------------------------------------------------------------------- 

# compute the percentages of activity level by groups
activiry_prc <- daily_data_merged %>% 
  select(Usage, 
         VeryActiveMinutes, 
         FairlyActiveMinutes, 
         LightlyActiveMinutes) %>%
  group_by(Usage)  %>%
  mutate(rsum = rowSums(across(where(is.numeric)))) %>%
  summarize(LightlyActive = sum(LightlyActiveMinutes), 
            FairlyActive = sum(FairlyActiveMinutes), 
            VeryActive = sum(VeryActiveMinutes), 
            rsum = sum(rsum)) %>%
  mutate(VeryActive = round(VeryActive/rsum, 2) * 100,
         FairlyActive = round(FairlyActive/rsum, 2) * 100,
         LightlyActive = round(LightlyActive/rsum, 2) * 100) %>%
  select(-rsum) %>%
  melt()

# construct pie-chart fow low usage groups
pie1 <- activiry_prc %>% 
  filter(Usage == "Low") %>%
  ggplot(aes(x = "", y = value, fill = variable)) +
  geom_col(color = "black") +
  geom_label(aes(label = value),
             color = "Black",
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette="YlOrBr") +
  labs(title = "Low Usage")


# construct pie-chart fow high usage groups
pie2 <- activiry_prc %>% 
  filter(Usage == "High") %>%
  ggplot(aes(x = "", y = value, fill = variable)) +
  geom_col(color = "black") +
  geom_label(aes(label = value),
             color = "Black",
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette="Blues") +
  labs(title = "High Usage")


# put pies together
pies <- grid.arrange(
  pie1 + theme(legend.position='hidden', axis.title.x= element_blank(), axis.title.y =element_blank(), axis.ticks.y=element_blank()),
  pie2 + theme(legend.position='hidden', axis.title.x= element_blank(), axis.title.y =element_blank(), axis.ticks.y=element_blank()),
  get_legend(pie1),
  get_legend(pie2),
  top = textGrob("Figure 7. Activities per usage groups", gp=gpar(fontsize=18,font=3)),
  heights = c(3,1),
  nrow = 2)


# save the resulted figures -------------------------------------------------------------------------------- 

ggsave('./figs/barplot1.png',plot = barplot1, width = 6, height = 3, dpi = 300)
ggsave('./figs/histogram1.png',plot = histogram1, width = 6, height = 3, dpi = 300)
ggsave('./figs/lineplots1.png', plot = lineplots1)
ggsave('./figs/lineplots2.png', plot = lineplots2)
ggsave('./figs/lineplot3.png', plot = lineplot3, width = 6, height = 3, dpi = 250)
ggsave('./figs/pies.png', plot = pies,  width = 6, height = 5, dpi = 300)
ggsave('./figs/correlogram1.png', plot = correlogram1)
ggsave('./figs/correlogram2.png', plot = correlogram2)
ggsave('./figs/correlogram3.png', plot = correlogram3)
ggsave('./figs/correlogram4.png', plot = correlogram4)




