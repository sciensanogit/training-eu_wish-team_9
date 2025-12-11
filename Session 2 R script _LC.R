#Session 2

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

## Adapt 03_tbl.R code to

library(dplyr)
library(readr)
library(lubridate)
install.packages("janitor")
library(janitor)
library(knitr)

#- load data saved in ./Belgium_export-nation.csv folder, at the end use the file exported by your team

BelgiumExportNation <- read.csv("Belgium_export-nation.csv", sep = ";")
  
#- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R

LastTenDates <- BelgiumExportNation %>% 
  select(siteName, date, value_pmmv) %>% 
  arrange(desc(date)) %>% 
  slice_head(n = 10) %>% 
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  autofit() %>% theme_vanilla()

LastTenDates

#- display only sampling days which are Mondays

BelgiumExportNation <- BelgiumExportNation %>%
  mutate(weekday = weekdays(as.Date(date)))

BelgiumExportNation_mondays <- BelgiumExportNation %>% 
  select(siteName, date, value_pmmv, weekday) %>% 
  filter(weekday == "Monday") %>% 
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  autofit() %>% theme_vanilla()

BelgiumExportNation_mondays

#- display understandable headers, nice units, nice digits

BelgiumExportNation_Rounded <- BelgiumExportNation %>% 
  mutate(value = round(value, 2)) %>% 
  mutate(value_load = round(value_load, 2)) %>% 
  mutate(value_pmmv = round(value_pmmv, 4)) %>% 
  mutate(value_avg14d_past = round(value_avg14d_past, 2)) %>% 
  mutate(value_load_avg14d_past = round(value_load_avg14d_past, 2)) %>% 
  mutate(value_pmmv_avg14d_past = round(value_pmmv_avg14d_past, 4)) %>% 
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  autofit() %>% theme_vanilla()

BelgiumExportNation_Rounded

#- test different themes
  #I didn't test different themes


## Adapt 04_quarto code to
  #- make sure you have a .png named graph_oostend_aalst.png in the folder ./plot/ if not save a fake one (maybe using mission2.R).
      
      #I have it
  
  #- run 04_quarto and view the .html file produced

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))



  #- modify the epi_assessment_text.csv at the reporting_date defined in 01_data_prep.R. run 04_quarto.R again and observe the modification of text
  #- add sentences in 04_quarto.qmd to introduce graphs and tables
  #- try to subtract reporting_date by 7 days to save a new version .html version
  #- add tbl_nation when your team has saved it
