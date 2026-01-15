############################################################################### #
# Aim ----
#| produce visuals
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "tidyr", "zoo", "writexl", "ggplot2")
# install packages
#install.packages(setdiff(pkgs, rownames(installed.packages())))
#invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data

# create folder if not existing

# graph at national level

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

# save graph

# display msg
cat("- Success : visuals saved \n")

