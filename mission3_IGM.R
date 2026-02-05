
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

# load data
df_nation <- read.table(file = "./data_example/Belgium_export-nation.csv", sep = ";", dec = ".", header = T)

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



################### Adapt 04_quarto.R code to #####################################
- make sure you have a .png named graph_oostend_aalst.png in the folder ./plot/ if not save a fake one (maybe using mission2.R).
- run 04_quarto.R and open the .html file produced in your internet browser
- modify the epi_assessment_text.csv at the reporting_date defined in 01_data_prep.R. run 04_quarto.R again and observe the modification of text
- add sentences in 04_quarto.qmd to introduce graphs and tables
- add tbl_nation when your team has saved it



