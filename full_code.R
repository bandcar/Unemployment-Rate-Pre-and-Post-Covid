library(tidyverse)
library(rvest)
# Create url object of website -------------------------------------------------
url = ("https://www.bls.gov/charts/state-employment-and-unemployment/state-unemployment-rates-animated.htm")

# Change the url to an html object ---------------------------------------------
page = read_html(url)

# copy the table ---------------------------------------------------------------
thetable = page %>% 
  html_element(css= '#lau_rc_unmapanim') %>% 
  html_table()

# Delete DC and Puerto Rico in rows 9 and 52. Delete columns 2:11 --------------
newtable = thetable[c(-9,-52),-c(2:11)] 
# Change tibble to data frame --------------------------------------------------
df <-  data.frame(newtable)
# Change mar and apr 2020 columns to numeric
df$Mar.2020 <- as.numeric(df$Mar.2020)
df$Apr.2020 = as.numeric(df$Apr.2020)

# Add a row for the US average unemployment rate
df = df %>%
  ungroup %>%
  summarise(State = c(State, 'United States'), 
            across(where(is.numeric), ~ c(., mean(.))))

# Get row averages for every year -------------------------------------------
unemployment = cbind(df[1], sapply(split.default(df[-1], sub("\\D+", "", names(df)[-1])), rowMeans))

# Round numbers to one decimal -------------------------------------------------
unemployment = unemployment %>% 
  mutate_if(is.numeric, round, digit = 1)

# pivots years and unemployment rates into columns
unemployment_rate <- unemployment %>% 
  pivot_longer(c(`2013`,`2014`,`2015`,`2016`,`2017`,`2018`,`2019`,`2020`,`2021`,`2022`), names_to = "Year", values_to = "Rate")

# Create CSV for long data------------------------------------------------------
write.csv(unemployment_rate, "pathname.csv",row.names=FALSE)

q<-read.csv("pathname.csv", stringsAsFactors = F)

save(q, file="pathname.RData")

# Wider version of data
df2_new = unemployment_rate %>% 
  pivot_wider(names_from = "State", values_from = "Rate")

# Create CSV of wider data
write.csv(df2_new, "pathname.csv", row.names = FALSE)

q<-read.csv("pathname.csv", stringsAsFactors = F)

save(q, file="pathname.RData")


