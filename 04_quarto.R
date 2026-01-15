
################### Adapt 04_quarto.R code to #####################################
- make sure you have a .png named graph_oostend_aalst.png in the folder ./plot/ if not save a fake one (maybe using mission2.R).
- run 04_quarto.R and open the .html file produced in your internet browser
- modify the epi_assessment_text.csv at the reporting_date defined in 01_data_prep.R. run 04_quarto.R again and observe the modification of text
- add sentences in 04_quarto.qmd to introduce graphs and tables
- add tbl_nation when your team has saved it

############################################################################### #
# Aim ----
#| generating wastewater reports
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load epi assessment
main_text <- read.csv("epi_assessment_text.csv")

# Render weekly sub report ----
save.image(".RData")

# settings
output_name <- paste0("Report-", format(date_reporting, "%G-W%V"))
format_output <- c("html")
# format_output <- c("html","docx")

quarto_render(input = "04_quarto.qmd",
              output_file = output_name,
              output_format = format_output)

cat("- Success : quarto render \n")