
################################# Adapt 03_tbl.R code to############################################### 
#- load data saved in .data/Belgium_export-nation.csv. This csv will be created by running 01_data_prep-solution.R. If you cannot run 01_data_prep-solution.R, you can load the ./Belgium_expert-nation.csv
#- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R
#- display only sampling days which are Mondays
#- display understandable headers, nice units, nice digits
#- test different themes
#- this table will be used by the 04_quarto.R script

############################################################################### #
# Aim ----
#| produce tables
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))


# Save table ----
tbl_nation <- df_nation %>%
  select(siteName, date, value_pmmv) %>%
  arrange(desc(date)) %>% 
  mutate(date = as.Date(date)) %>%
  filter(date <= date_reporting,
         !is.na(value_pmmv),
         lubridate::wday(date, week_start = 1) == 1) %>%
  arrange(desc(date)) %>%
  slice_head(n = 10) %>%
  flextable() %>%
  fontsize(part = "body",size = 9) %>%
  fontsize(part = "header",size = 9) %>%
  autofit() %>% theme_zebra()

tbl_nation

# display msg
cat("- Success : tables saved \n")
