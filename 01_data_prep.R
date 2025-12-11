############################################################################### #
# Aim ----
#| load, clean and save data
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
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value, quality)

# format date
df$date <- as.Date(df$date)

# set and subset dates
date_reporting <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2024-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2025-12-01", format = "%Y-%m-%d")

# subset sars and pmmv data based on labProtocolID used betwen date_start and date_end

filtered_labprotocol <- c("SC_COV_4.1", "UA_COV_4.0", "SC_PMMV_2.1", "UA_PMMV_2.0")

df_filt_protocol_dates <- df %>%
  mutate(collDTStart = as.Date(collDTStart)) %>%
  filter(
    collDTStart >= date_graph_start,
    collDTStart <= date_graph_end,
    labProtocolID %in% filtered_labprotocol
  )

write.csv(df_filt_protocol_dates, "df_filt_protocol_dates.csv", row.names = FALSE)




# display existing labProtocolID
# unique(df$labProtocolID)

# rename measures
df_measure_renamed <- df_filt_protocol_dates %>%
  mutate(
    measure = case_when(
      measure %in% c("SARS-CoV-2 E gene", "SARS-CoV-2 nucleocapsid gene, allele 2") ~ "SARS",
      measure %in% c("Pepper mild mottle virus capsid protein gene region") ~ "PMMV",
      TRUE ~ measure
    )
  )

write.csv(df_measure_renamed, "df_measure_renamed.csv", row.names = FALSE)


# diplay existing measure
# unique(df$measure)

# translate siteName to english

df_sitename_translate <- df_measure_renamed %>%
  mutate(
    siteName = case_when(
      siteName %in% c("Bruxelles-Sud") ~ "Brussels-South",
      siteName %in% c("Bruxelles-Nord") ~ "Brussels-North",
      TRUE ~ siteName
    )
  )

write.csv(df_sitename_translate, "df_sitename_translate.csv", row.names = FALSE)

# apply LOQ provided by the lab
pmmv_loq <- 250
sars_loq <- 8

df_loq <- df_sitename_translate %>%
  mutate(
    value = case_when(
      measure == "SARS" & value < sars_loq ~ NA_real_,
      measure == "PMMV" & value < pmmv_loq ~ NA_real_,
      TRUE ~ value
    )
  )

write.csv(df_loq, "df_loq.csv", row.names = FALSE)

# remove outliers
filtered_quality <- c("No quality concern")

df_filt_outlier <- df_loq %>%
  filter(
    quality == filtered_quality,
    quality %in% filtered_quality
  )


write.csv(df_filt_outlier, "df_filt_outlier.csv", row.names = FALSE)

# compute mean of replicated analysis of each measure
df_mean <- df_filt_outlier %>%
  mutate(collDTStart = as.Date(collDTStart)) %>%
  group_by(siteName, measure, collDTStart) %>%
  summarise(
    mean_values = mean(value, na.rm = TRUE) %>% na_if(NaN),
    .groups = "drop"
  ) %>%
  arrange(siteName, measure, collDTStart)

write.csv(df_mean, "df_mean.csv", row.names = FALSE)

# compute viral ratio


df_viral_ratio <- df_mean %>%
  pivot_wider(
    names_from = measure,
    values_from = mean_values
  ) %>%
  mutate(viral_ratio = SARS / PMMV)

  pivot_longer(
    cols = c(SARS, PMMV, viral_ratio),
    names_to = "measure",
    values_to = "value"
  ) %>%
  
  arrange(siteName, collDTStart, measure)


write.csv(df_viral_ratio, "df_viral_ratio.csv", row.names = FALSE)  
    
# unique(df$measure) ...

# compute moving average on past 14 days

# natinoal aggregation: compute weighted mean with factor being the population served by each site

# export data ----
# create folder if not existing

# export as csv

# export as xls

# export as rds


# display msg
cat("- Success : data prep \n")

