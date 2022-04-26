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

# Delete Puerto Rico in row 52, columns 2:59 -----------------------------------
newtable = thetable[-52, -c(2:59,96:107)]

# Change tibble to data frame --------------------------------------------------
df <-  data.frame(newtable)

# Get column averages for every year -------------------------------------------
unemployment = cbind(df[1], sapply(split.default(df[-1], sub("\\D+", "", names(df)[-1])), rowMeans))

# Round numbers to one decimal -------------------------------------------------
unemployment_rate = unemployment %>% 
  mutate_if(is.numeric, round, digit = 1)

# pivots years and unemployment rates into columns
unemployment_rate <- unemployment_rate %>% 
  pivot_longer(c(`2017`,`2018`,`2019`,`2021`,`2022`), names_to = "Year", values_to = "Rate")
