# This is the R script to generate the descriptive tables based on LHAs.

# get path
# please change the path to the folder
mainDir <- "~/Desktop/capstone_BC Cancer-Kelowna (Demographics)"
subDir <- "products/hsda"
setwd(mainDir)

# create folder
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)

# install library
library(dplyr)
library(pryr)

# memory used
start_mem_used <- mem_used()
start_mem_used

# import dataset and function
source("Rcodes/capstone_dataset.R")
source("Rcodes/function_description.R")

# descriptve statistics tables for incidence count and mortality count in HSDAs in each year
count_incidence_year <- description(data1mp_hsda,"Incidence.count2","year")
count_incidence_year
count_mortality_year <- description(data1mp_hsda,"mortality.count2","year")
count_mortality_year

# descriptve statistics tables for incidence count and mortality count for each HSDA with all cancer types in each year
count_incidence_year_hsda <- description(data1mp_hsda,"Incidence.count2","year","geo_hsda")
count_incidence_year_hsda
count_mortality_year_hsda <- description(data1mp_hsda,"mortality.count2","year","geo_hsda")
count_mortality_year_hsda

# descriptve statistics tables for incidence count and mortality count in HSDAs for each cancer type in each year
count_incidence_year_ctype <- description(data1mp_hsda,"Incidence.count2","year","incid_simple_grp2")
count_incidence_year_ctype 
count_mortality_year_ctype <- description(data1mp_hsda,"mortality.count2","year","incid_simple_grp2")
count_mortality_year_ctype

# descriptve statistics tables for incidence rate and mortality rate in HSDAs in each year
rate_incidence_year <- description(data1mp_hsda,"Incidence.rate2","year")
rate_incidence_year
rate_mortality_year <- description(data1mp_hsda,"mortality.rate2","year")
rate_mortality_year

# descriptve statistics tables for incidence rate and mortality rate for each HSDA with all cancer types in each year
rate_incidence_year_hsda <- description(data1mp_hsda,"Incidence.rate2","year","geo_hsda")
rate_incidence_year_hsda
rate_mortality_year_hsda <- description(data1mp_hsda,"mortality.rate2","year","geo_hsda")
rate_mortality_year_hsda

# descriptve statistics tables for incidence rate and mortality rate in HSDAs for each cancer type in each year
rate_incidence_year_ctype <- description(data1mp_hsda,"Incidence.rate2","year","incid_simple_grp2")
rate_incidence_year_ctype 
rate_mortality_year_ctype <- description(data1mp_hsda,"mortality.rate2","year","incid_simple_grp2")
rate_mortality_year_ctype

# merge data frames count and rate 
incidence_year <- merge_cr(count_incidence_year,rate_incidence_year)
mortality_year <- merge_cr(count_mortality_year,rate_mortality_year)
incidence_year_hsda <- merge_cr(count_incidence_year_hsda,rate_incidence_year_hsda)
mortality_year_hsda <- merge_cr(count_mortality_year_hsda,rate_mortality_year_hsda)
incidence_year_ctype <- merge_cr(count_incidence_year_ctype,rate_incidence_year_ctype)
mortality_year_ctype <- merge_cr(count_mortality_year_ctype,rate_mortality_year_ctype)

# output csv
write.csv(incidence_year,"products/hsda/incidence_year.csv", row.names = FALSE)
write.csv(mortality_year,"products/hsda/mortality_year.csv", row.names = FALSE)
write.csv(incidence_year_hsda,"products/hsda/incidence_year_hsda.csv", row.names = FALSE)
write.csv(mortality_year_hsda,"products/hsda/mortality_year_hsda.csv", row.names = FALSE)
write.csv(incidence_year_ctype,"products/hsda/incidence_year_ctype.csv", row.names = FALSE)
write.csv(mortality_year_ctype,"products/hsda/mortality_year_ctype.csv", row.names = FALSE)

# descriptve statistics tables for incidence count and mortality count in HSDAs for each age group in each year
count_incidence_year_age <- description(data1mp_hsda_age,"Incidence.count2","year","age_group2")
count_incidence_year_age 
count_mortality_year_age <- description(data1mp_hsda_age,"mortality.count2","year","age_group2")
count_mortality_year_age 

# descriptve statistics tables for incidence count and mortality count for each age group, each HSDA with all cancer types in each year
count_incidence_year_age_hsda <- description(data1mp_hsda_age,"Incidence.count2","year","age_group2","geo_hsda")
count_incidence_year_age_hsda 
count_mortality_year_age_hsda <- description(data1mp_hsda_age,"mortality.count2","year","age_group2","geo_hsda")
count_mortality_year_age_hsda 

# descriptve statistics tables for incidence count and mortality count in HSDAs for each age group, each cancer type in each year
count_incidence_year_age_ctype <- description(data1mp_hsda_age,"Incidence.count2","year","age_group2","incid_simple_grp2")
count_incidence_year_age_ctype 
count_mortality_year_age_ctype <- description(data1mp_hsda_age,"mortality.count2","year","age_group2","incid_simple_grp2")
count_mortality_year_age_ctype

# descriptve statistics tables for incidence rate and mortality rate in HSDAs for each age group in each year
rate_incidence_year_age <- description(data1mp_hsda_age,"Incidence.rate2","year","age_group2")
rate_incidence_year_age 
rate_mortality_year_age <- description(data1mp_hsda_age,"mortality.rate2","year","age_group2")
rate_mortality_year_age 

# descriptve statistics tables for incidence rate and mortality rate for each age group, each HSDA with all cancer types in each year
rate_incidence_year_age_hsda <- description(data1mp_hsda_age,"Incidence.rate2","year","age_group2","geo_hsda")
rate_incidence_year_age_hsda 
rate_mortality_year_age_hsda <- description(data1mp_hsda_age,"mortality.rate2","year","age_group2","geo_hsda")
rate_mortality_year_age_hsda 

# descriptve statistics tables for incidence rate and mortality rate in HSDAs for each age group, each cancer type in each year
rate_incidence_year_age_ctype <- description(data1mp_hsda_age,"Incidence.rate2","year","age_group2","incid_simple_grp2")
rate_incidence_year_age_ctype 
rate_mortality_year_age_ctype <- description(data1mp_hsda_age,"mortality.rate2","year","age_group2","incid_simple_grp2")
rate_mortality_year_age_ctype

# merge data frames count and rate 
incidence_year_age <- merge_cr(count_incidence_year_age,rate_incidence_year_age)
mortality_year_age <- merge_cr(count_mortality_year_age,rate_mortality_year_age)
incidence_year_age_hsda <- merge_cr(count_incidence_year_age_hsda,rate_incidence_year_age_hsda)
mortality_year_age_hsda <- merge_cr(count_mortality_year_age_hsda,rate_mortality_year_age_hsda)
incidence_year_age_ctype <- merge_cr(count_incidence_year_age_ctype,rate_incidence_year_age_ctype)
mortality_year_age_ctype <- merge_cr(count_mortality_year_age_ctype,rate_mortality_year_age_ctype)

# output csv
write.csv(incidence_year_age,"products/hsda/incidence_year_age.csv", row.names = FALSE)
write.csv(mortality_year_age,"products/hsda/mortality_year_age.csv", row.names = FALSE)
write.csv(incidence_year_age_hsda,"products/hsda/incidence_year_age_hsda.csv", row.names = FALSE)
write.csv(mortality_year_age_hsda,"products/hsda/mortality_year_age_hsda.csv", row.names = FALSE)
write.csv(incidence_year_age_ctype,"products/hsda/incidence_year_age_ctype.csv", row.names = FALSE)
write.csv(mortality_year_age_ctype,"products/hsda/mortality_year_age_ctype.csv", row.names = FALSE)


# memory used
end_mem_used <- mem_used()
print(end_mem_used-start_mem_used)
rm(list = ls())


