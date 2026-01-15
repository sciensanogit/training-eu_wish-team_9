## Adapt 02_visuals.R code to
#- load data saved in .data/Belgium_export-nation.csv. This csv will be created by running 01_data_prep-solution.R. If you cannot run 01_data_prep-solution.R, you can load the ./Belgium_expert-nation.csv
chek
#- create ./plot folder if not existing
check
#- create a figure with the viral ratio (variable called value_pmmv) at the national level (inspiration from mission2.R is welcome)

  #convert "date" from character to date
BelgiumExportNation <- BelgiumExportNation %>% 
  mutate(date = as.Date(date))

PlotPMMoVRatio <- BelgiumExportNation %>% 
  select(date, value_pmmv) %>%
  filter(!is.na(value_pmmv)) %>% 
  ggplot(aes(x = date, y = value_pmmv, group = 1)) + 
  geom_point(color = "orange2") +
  geom_line(color = "orange2") +
  labs(
    x = "Date",
    y = "PMMoV viral ratio",
  ) +
  theme_minimal() +
  scale_x_date(
    date_breaks = "2 month",
    date_labels = "%b %Y"
  )

PlotPMMoVRatio
  
#- save graph as ./plot/graph-viral_ratio-nation.png

check

#- Display nice xaxis, yaxis

check previous step

#- Add a past two weeks moving average line from the variable  (variable called value_pmmv_avg14d_past)

PlotPMMoVRatio_withpmmvAvg14d <- BelgiumExportNation %>% 
  select(date, value_pmmv, value_pmmv_avg14d_past) %>%
  filter(!is.na(value_pmmv) & !is.na(value_pmmv_avg14d_past)) %>% 
  ggplot(aes(x = date,group = 1)) + 
  geom_point(aes(y = value_pmmv), color = "orange2") +
  geom_line(aes(y = value_pmmv), color = "orange2") +
  geom_line(aes(y = value_pmmv_avg14d_past), color = "lightblue") + 
  labs(
    x = "Date",
    y = "PMMoV viral ratio",
  ) +
  theme_minimal()

PlotPMMoVRatio_withpmmvAvg14d

## Adapt 00_main.R code to
#- start doing this 45 min before the end of session2, to ensure having enough time.
#- ask each team member to commit their change and push it to the online repository

#- source 01_data_prep.R, 02_visuals.R, 03_tbl.R, and 04_quarto.R in the 00_main.R script
check
#- make sure to load all packages needed in 00_main.R only
check
#- commit and push the modifications
