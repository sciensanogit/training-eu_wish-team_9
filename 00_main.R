############################################################################### #
# Aim ----
#| generating wastewater reports
# Requires: 
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#|
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))


# Mission 1.1 ----
## Source member 1 script ----
source("mission1-member1_LC.R")
source("Sayed.R")
source("20251030-Noor.R")
source("mission1-member1_IGM2.R")


## Source member 2 script ----
source("mission1-member2.R")


#Mission3
install.packages("dplyr", "ggplot2", "flextable", "quarto")
library("dplyr", "ggplot2", "flextable", "quarto")

source("01_data_prep_RR.R")
source("02_visuals.R")
source("03_tbl.R")
source("04_quarto.R")
