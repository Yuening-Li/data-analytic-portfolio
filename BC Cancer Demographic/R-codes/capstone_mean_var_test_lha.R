# This is the R script to test equal means/variances and generate the lists based on HSDAs.

# get path
# please change the path to the folder
setwd("~/Desktop/capstone_BC Cancer-Kelowna (Demographics)/")

# install library
library(dplyr)
library(pryr)

# memory used
start_mem_used <- mem_used()
start_mem_used

# import dataset and function
source("Rcodes/capstone_dataset.R")
source("Rcodes/function_description.R")
source("Rcodes/function_mean_var_test.R")

# Incidence ~ year under geo_hsda & geo_desc
# Test if there exist significant differences of means and variances for incidence of all cancer types between different year under each HSDA and each LHA.  
result_inc_year_hsda_lha <- display_mean_var(df=data1mp,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="year",groupby1="geo_hsda",groupby2="geo_desc")
result_inc_year_hsda_lha$description_table
result_inc_year_hsda_lha$`p-value_table`
result_inc_year_hsda_lha$final_table
# names(result_inc_year_hsda_lha) ## show all content inside the list
### Analysis:
### According to the results, there only exists a significant difference in variance for incidence rates of all cancer types between different years in "Golden" under "East Kootenay" with the highest variance happening in 2014 and lowest happening in 2016.

# mortality ~ year under geo_hsda & geo_desc
# Test if there exist significant differences of means and variances for mortality of all cancer types between different year under each HSDA and each LHA.  
result_mor_year_hsda_lha <- display_mean_var(df=data1mp,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="year",groupby1="geo_hsda",groupby2="geo_desc")
result_mor_year_hsda_lha$description_table
result_mor_year_hsda_lha$`p-value_table`
result_mor_year_hsda_lha$final_table
### Example Analysis:
### According to the results, there exists a significant difference in variance for mortality rates of all cancer types between different year under "Arrow Lakes" in "Kootenay Boundary" with the highest variance happened in 2015 and lowest happened in 2016.

# Incidence ~ geo_desc under year & geo_hsda
# Test if there exist significant differences of means and variances for incidence of all cancer types between different LHAs under each year and each HSDA.
result_inc_lha_year_hsda <- display_mean_var(df=data1mp,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="geo_desc",groupby1="year",groupby2="geo_hsda")
result_inc_lha_year_hsda$description_table
result_inc_lha_year_hsda$`p-value_table`
result_inc_lha_year_hsda$final_table
### Example Analysis:
### According to the results, there are no significant differences in the means and variances for incidence rates of all cancer types between different LHAs under HSDA "East Kootenay" in 2012.

# mortality ~ geo_desc under year & geo_hsda
# Test if there exist significant differences of means and variances for mortality of all cancer types between different LHAs under each year and each HSDA.
result_mor_lha_year_hsda <- display_mean_var(df=data1mp,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="geo_desc",groupby1="year",groupby2="geo_hsda")
result_mor_lha_year_hsda$description_table
result_mor_lha_year_hsda$`p-value_table`
result_mor_lha_year_hsda$final_table
### Example Analysis:
### According to the results, there are no significant differences in the means and variances for mortality rates of all cancer types between different LHAs under HSDA "East Kootenay" in 2012.

# Incidence ~ geo_hsda under year & incid_simple_grp2
# Test if there exist significant differences of means and variances for incidence of LHAs between different HSDAs under each year and each cancer type.
result_inc_hsda_year_ctype <- display_mean_var(df=data1mp,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="geo_hsda",groupby1="year",groupby2="incid_simple_grp2")
result_inc_hsda_year_ctype$description_table
result_inc_hsda_year_ctype$`p-value_table`
result_inc_hsda_year_ctype$final_table
filter(result_inc_hsda_year_ctype$`2012_All Other Cancers initial_table`,geo_hsda=="Kootenay Boundary")
### Example Analysis:
### According to the results, there is no significant difference in the means for incidence rates of LHAs between different HSDAs under cancer type "All Other Cancers" in 2012.
### However, there exists a significant difference in the variances for incidence rates of LHAs between different HSDAs under cancer type "All Other Cancers" in 2012, and the highest variance happened in "Kootenay Boundary",the lowest variance happened in "Thompson Cariboo Shuswap".
### With further exploration, we found LHA "Kootenay Lake" had the higher incidence rate camparing with other 5 LHAs under cancer type "All Other Cancers" and HSDA "Kootenay Boundary" in 2012.

# mortality ~ geo_desc under year & incid_simple_grp2
# Test if there exist significant differences of means and variances for mortality of LHAs between different HSDAs under each year and each cancer type.
result_mor_hsda_year_ctype <- display_mean_var(df=data1mp,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="geo_hsda",groupby1="year",groupby2="incid_simple_grp2")
result_mor_hsda_year_ctype$description_table
result_mor_hsda_year_ctype$`p-value_table`
result_mor_hsda_year_ctype$final_table
### Example Analysis:
### According to the results, there are no significant differences in the means for mortality rates of LHAs between different HSDAs under cancer type "All Other Cancers" in 2012.
### However, there exists a significant difference in the variances for mortality rates of LHAs between different HSDAs under cancer type "All Other Cancers" in 2012, and the highest variance happened in "Kootenay Boundary",the lowest variance happened in "East Kootenay".

# Incidence ~ incid_simple_grp2 under geo_hsda & geo_desc
# Test if there exist significant differences of means and variances for incidence of all years between different cancer types under each HSDA and each LHA.  
result_inc_ctype_hsda_lha <- display_mean_var(df=data1mp,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="geo_desc")
result_inc_ctype_hsda_lha$description_table
result_inc_ctype_hsda_lha$`p-value_table`
result_inc_ctype_hsda_lha$final_table
filter(result_inc_ctype_hsda_lha$`East Kootenay_Cranbrook initial_table`,incid_simple_grp2=="Gastrointestinal")
### Example Analysis:
### According to the results, there exists significant differences in means and variances for incidence rates between different cancer types under LHA "Cranbrook", HSDA "East Kootenay".
### The highest mean happened on cancer type "Gastrointestinal", the lowest mean happened on cancer type "Brain" under LHA"Cranbrook", HSDA "East Kootenay".
### The highest variance happened on cancer type "Gastrointestinal", the lowest variance happened on cancer type "Brain" under LHA"Cranbrook", HSDA "East Kootenay".
### With further exploration, the cancer type "Gastrointestinal" had higher incidence rate in 2014 compared with other years under LHA"Cranbrook", HSDA "East Kootenay".

# mortality ~ incid_simple_grp2 under geo_hsda & geo_desc
# Test if there exist significant differences of mean and variance for mortality of all years between different cancer types under each HSDA and each LHA.
result_mor_ctype_hsda_lha <- display_mean_var(df=data1mp,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="geo_desc")
result_mor_ctype_hsda_lha$description_table
result_mor_ctype_hsda_lha$`p-value_table`
result_mor_ctype_hsda_lha$final_table
filter(result_mor_ctype_hsda_lha$`East Kootenay_Cranbrook initial_table`,incid_simple_grp2=="Gastrointestinal")
### Example Analysis:
### According to the results, there exists significant differences in means and variances for mortality rates of all years between different cancer types under LHA "Cranbrook", HSDA "East Kootenay".
### The highest mean happened on cancer type "Gastrointestinal", the lowest mean happened on cancer type "Brain" under LHA"Cranbrook", HSDA "East Kootenay".
### The highest variance happened on cancer type "Gastrointestinal", the lowest variance happened on cancer type "Head & Neck" under LHA"Cranbrook", HSDA "East Kootenay".
### With further exploration, the cancer type "Gastrointestinal" had lower incidence rate in 2016 compared with other years under LHA"Cranbrook", HSDA "East Kootenay".

# Incidence ~ geo_desc under geo_hsda & incid_simple_grp2
# Test if there exist significant differences of means and variances for incidence of all years between different LHAs under each HSDA and each cancer type.  
result_inc_lha_hsda_ctype <- display_mean_var(df=data1mp,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="geo_desc",groupby1="geo_hsda",groupby2="incid_simple_grp2")
result_inc_lha_hsda_ctype$description_table
result_inc_lha_hsda_ctype$`p-value_table`
result_inc_lha_hsda_ctype$final_table
filter(result_inc_lha_hsda_ctype$`East Kootenay_All Other Cancers initial_table`,geo_desc=="Kimberley")
### Example Analysis:
### According to the results, there is no significant differences in means for incidence rates of all years between different LHAs under HSDA "East Kootenay" and cancer type "All Other Cancers".
### However, there exists a significant difference in variances for incidence rates of all years between different LHAs under HSDA "East Kootenay" and cancer type "All Other Cancers".
### The highest variance happened in LHA "Kimberley", the lowest variance happened in LHA "Cranbrook" for for incidence rates of all years under HSDA "East Kootenay" and cancer type "All Other Cancers".
### With further exploration, the LHA "Kimberley" had higher incidence rate in 2013 compared with other years under HSDA "East Kootenay" and cancer type "All Other Cancers".

# mortality ~ geo_desc under geo_hsda & incid_simple_grp2
# Test if there exist significant differences of means and variances for mortality of all years between different LHAs under each HSDA and each cancer type.  
result_mor_lha_hsda_ctype <- display_mean_var(df=data1mp,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="geo_desc",groupby1="geo_hsda",groupby2="incid_simple_grp2")
result_mor_lha_hsda_ctype$description_table
result_mor_lha_hsda_ctype$`p-value_table`
result_mor_lha_hsda_ctype$final_table
### Example Analysis:
### According to the results, there are no significant differences in means and variances for mortality rates of all years between different LHAs under HSDA "East Kootenay" and cancer type "All Other Cancers".


############################################################

# Incidence ~ incid_simple_grp2 under geo_hsda & geo_desc & age_group2
# Test if there exist significant differences of means and variances for incidence of all years between different cancer types under each HSDA and each LHA and each age group.
result_inc_ctype_hsda_lha_age <- display_mean_var(df=data1mp_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="geo_desc",groupby3="age_group2") 
result_inc_ctype_hsda_lha_age$description_table
result_inc_ctype_hsda_lha_age$`p-value_table`
result_inc_ctype_hsda_lha_age$final_table
filter(result_inc_ctype_hsda_lha_age$`East Kootenay_Cranbrook_15-29 initial_table`,incid_simple_grp2=="Hematology/Lymphoma")
### Example Analysis:
### According to the results, there is no significant difference in means for incidence rates of all years between different cancer types under HSDA "East Kootenay" and LHA "Cranbrook" and age group 15-29.
### However, there exists significant difference in variances for incidence rates of all years under HSDA "East Kootenay" and LHA "Cranbrook" and age group 15-29, the highest variance happened on cancer type "Hematology/Lymphoma".
### With further exploration, under cancer type "Hematology/Lymphoma", HSDA "East Kootenay", LHA "Cranbrook" and age group 15-29, year 2013 has the highest incidence rate.

# mortality ~ incid_simple_grp2 under geo_hsda & geo_desc & age_group2
# Test if there exist significant differences of means and variances for mortality of all years between different cancer types under each HSDA and each LHA and each age group.
result_mor_ctype_hsda_lha_age <- display_mean_var(df=data1mp_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="geo_desc",groupby3="age_group2") 
result_mor_ctype_hsda_lha_age$description_table
result_mor_ctype_hsda_lha_age$`p-value_table`
result_mor_ctype_hsda_lha_age$final_table
filter(result_mor_ctype_hsda_lha_age$`East Kootenay_Cranbrook_30-49 initial_table`,incid_simple_grp2=="Gastrointestinal")
### Example Analysis:
### According to the results, there is no significant difference in means for mortality rates of all years between different cancer types under HSDA "East Kootenay" and LHA "Cranbrook" and age group 30-49.
### However, there exists significant difference in variances for mortality rates of all years under HSDA "East Kootenay" and LHA "Cranbrook" and age group 30-49, the highest variance happened on cancer type "Gastrointestinal".
### With further exploration, under cancer type "Gastrointestinal", HSDA "East Kootenay", LHA "Cranbrook" and age group 30-49, only year 2015 has the mortality rate.

# memory used
end_mem_used <- mem_used()
print(end_mem_used-start_mem_used)
rm(list = ls())


