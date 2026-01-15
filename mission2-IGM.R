

############################# Mission 2 - 02_visuals  ###################################### #

## Adapt 02_visuals.R code to
## load data saved in ./Belgium_export-nation.csv folder, at the end use the file exported by your team
## create ./plot folder if not existing
## create figure with the viral ratio at the national level (inspiration from Session1 is welcome)
## save graph as ./plot/graph-viral_ratio-nation.png
## Display nice xaxis, yaxis
## Add a past two weeks moving average line

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
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data
Belgium_data <- read.csv("Belgium_export-nation.csv", sep = ";")
Belgium_data

# create folder if not existing
Created 

# graph at national level
# compute viral ratio (SARS/PMMV)
library(readxl)
library(tidyverse)
library(viridis)
library(ggplot2)
library(scales)

# create the column viral ratio and delte NA rows - it was not needed. Viral ratio was already value_pmmv
Belgium_data <- Belgium_data |>
  mutate(
    viralratio = value / value_pmmv
  )
filtered_data <- na.omit(Belgium_data)%>% ungroup()


# create the scatter plot with the viral ratio 
ggplot(filtered_data) +
  geom_point(aes(x = date, y = value_pmmv)) +
  theme_bw() +
  labs(title = "Viral ratio") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7)) +
  geom_line(aes(x = date, y = value_pmmv_avg14d_past))


ggplot(filtered_data) +
  geom_point(aes(x = date, y = value_pmmv),
             alpha = 0.6, # Make points slightly transparent
             color = "blue") + # Color the points blue
  geom_line(aes(x = date, y = value_pmmv_avg14d_past),
            color = "red", # Set the line color to red
            linewidth = 1.5) + # Make the line thicker
  scale_y_log10() +
  theme_bw() +
  labs(title = "Viral Ratio: Point Data vs. 14-Day Average") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7))


# save graph
ggsave("graph-viral_ratio_Belgium.png", device = "png")

# display msg
cat("- Success : visuals saved \n")