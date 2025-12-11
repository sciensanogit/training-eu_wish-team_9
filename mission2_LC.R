############################################################################### #
# Aim ----
#| load data and produce first graph
# NOTES:
#| list of things to do
#|
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data ----
# Belgian data are available here https://www.geo.be/catalog/details/9eec5acf-a2df-11ed-9952-186571a04de2?l=en
#| Metadata
#| siteName is the name of the treatment plant
#| collDTStart is the date of sampling
#| labName is the name of the lab analysing the sample
#| labProtocolID is the protocol used to analyse the dample
#| flowRate is the flow rate measured at the inlet of the treatment plant during sampling
#| popServ is the population covered by the treatment plant
#| measure is the target measured
#| value is the result

# sars-cov-2 data
df_sc <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantscovid&outputFormat=csv")

# pmmv data
df_pmmv <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantspmmv&outputFormat=csv")

# join both
df <- df_sc %>%
  rbind(df_pmmv)

# clean data
df <- df %>%
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value)

# format date
df$date <- as.POSIXct(df$collDTStart, format = "%Y-%m-%dT%H:%M:%S")
df$date <- format(df$date, "%Y-%m-%d")

# compute viral ratio
# unique(df$measure) ...

#Define the date column as date instead of strings
df$date <- as.Date(df$date)

# graph with the ratio calculated lower on the script
plot <- df %>%
  filter(labProtocolID == "SC_COV_4.1") %>%
  filter(measure %in% c("SARS-CoV-2 E gene")) %>%
  filter(date > "2024-06-24" & date < "2026-08-26") %>%
  filter(siteName %in% c("Aalst", "Oostende")) %>%
  ggplot(aes(x = date, y = value, group = siteName, color = siteName)) +
  geom_point(size = 2, na.rm = T, alpha = 0.2) +
  geom_line(size = 1, na.rm = T, alpha = 0.2) +
  geom_smooth() +
  scale_color_manual(values = c("green4", "orange")) +
  geom_hline(yintercept = Mean_Aalst, linetype = "dashed", size = 1, color = "green4") +
  geom_hline(yintercept = Mean_Oostende, linetype = "dashed", size = 1, color = "orange")
  

plot

#mean values

Mean_Aalst <- mean(df$value[df$measure == "SARS-CoV-2 E gene" & 
                df$siteName %in% c("Aalst") &
                df$labProtocolID == "SC_COV_4.1"], 
     na.rm = T)

Mean_Oostende <- mean(df$value[df$measure == "SARS-CoV-2 E gene" & 
                df$siteName %in% c("Oostende") &
                df$labProtocolID == "SC_COV_4.1"], 
     na.rm = T)



#E gene, N1 and N2 into SARS

df <- df %>% 
  mutate(
    measure_standardized = case_when(
      measure %in% c("SARS-CoV-2 E gene", 
                     "SARS-CoV-2 nucleocapsid gene, allele 2", 
                     "SARS-CoV-2 nucleocapsid gene, allele 1"
                     ) ~ "SARS-CoV-2", 
      TRUE ~ measure
      )
    )

#Ratio SARS/PMMoV

library(dplyr)
library(tidyr)

df_ratio <- df %>%
  select(siteName, date, measure_standardized, value) %>% 
  pivot_wider(
    names_from = measure_standardized,
    values_from = value,
    values_fn = mean
  ) %>%
  mutate(
    ratio_SARS_vs_PMMoV =
      ifelse(
        is.na(`Pepper mild mottle virus capsid protein gene region`) |
          `Pepper mild mottle virus capsid protein gene region` == 0,
        NA,
        `SARS-CoV-2` / `Pepper mild mottle virus capsid protein gene region`
  )
)

#

# save
ggsave(file="./plot/graph_oostende_aalst.png",
       plot, width = 21, height = 12, dpi = 200)
