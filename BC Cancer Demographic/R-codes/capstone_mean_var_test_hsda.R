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

# Incidence ~ geo_hsda under year
# Test if there exist significant differences of means and variances for incidence of all cancer types between different HSDAs under each year.
result_inc_hsda_year <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="geo_hsda",groupby1="year")
result_inc_hsda_year$description_table
result_inc_hsda_year$`p-value_table`
# names(result_inc_hsda_year) ## show all content inside the list
###############################################################################################################
#[1] "count_table"         "rate_table"         "description_table"  "p-value_table"      "2012 initial_table"#
#[6] "2012 table"          "2012 boxplot"       "2013 initial_table" "2013 table"         "2013 boxplot"      #
#[11] "2014 initial_table" "2014 table"         "2014 boxplot"       "2015 initial_table" "2015 table"        #
#[16] "2015 boxplot"       "2016 initial_table" "2016 table"         "2016 boxplot"       "final_table"       #
###############################################################################################################
### Analysis:
### According to the results, there exist significant differences in means and variances for incidence counts of all cancer types for 4 HSDAs in each year. 
### And there is no significant difference in the means and variances of incidence rates of all cancer types for 4 HSDAs in each year.

# mortality ~ geo_hsda under year
# Test if there exist significant differences of means and variances for mortality of all cancer types between different HSDAs under each year.
result_mor_year_hsda <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="geo_hsda",groupby1="year")
result_mor_year_hsda$description_table
result_mor_year_hsda$`p-value_table`
### Analysis:
### According to the results, there exist significant differences in means and variances for mortality counts of all cancer types for 4 HSDAs in each year. 
### And there is no significant difference in the means and variances of mortality rates of all cancer types for 4 HSDAs in each year.

# Incidence ~ incid_simple_grp2 under year
# Test if there exist significant differences of means and variances for incidence of all HSDAs between different cancer types under each year.
result_inc_ctype_year <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="incid_simple_grp2",groupby1="year")
result_inc_ctype_year$description_table
result_inc_ctype_year$`p-value_table`
result_inc_ctype_year$final_table
filter(result_inc_ctype_year$`2013 initial_table`,incid_simple_grp2=="Genito-Urology")
### Example Analysis:
### According to the results, there exists a significant difference in the means of incidence rates of all HSDAs between different cancer types for these 5 years. 
### Except for 2012 and 2013, "Gastrointestinal" had the highest average incidence rate in the rest of 3 years, and "Brain" had the lowest average incidence rate in all 5 years. 
### In 2013, "Genito-Urology" had the highest variance, and we further explore found that "Kootenay Boundary" has a higher incidence rate in "Genito-Urology" comparing with other HSDAs in 2013.

# mortality ~ incid_simple_grp2 under year
# Test if there exist significant differences of means and variances for mortality of all HSDAs between different cancer types under each year.
result_mor_ctype_year <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="incid_simple_grp2",groupby1="year")
result_mor_ctype_year$description_table
result_mor_ctype_year$`p-value_table`
result_mor_ctype_year$final_table
filter(result_mor_ctype_year$`2013 initial_table`,incid_simple_grp2=="Gastrointestinal")
### Example Analysis:
### According to the results, there exists a significant difference in the means of mortality rates of all HSDAs between different cancer types for these 5 years. 
### The "Gastrointestinal" had the highest average mortality rate in 5 years, and "Skin" had the lowest average mortality rate in these years except 2014.
### In 2013, "Gastrointestinal" had the highest variance, and further explore found "Kootenay Boundary" has a higher mortality rate in "Gastrointestinal" comparing with other HSDAs in 2013.

# Incidence ~ year under geo_hsda
# Test if there exist significant differences of means and variances for incidence of all cancer types between 5 years under each HSDA.
result_inc_year_hsda <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="year",groupby1="geo_hsda")
result_inc_year_hsda$description_table
result_inc_year_hsda$`p-value_table`
result_inc_year_hsda$final_table
### Analysis:
### According to the results, there are no significant differences in the means and variances of incidence counts/rates between 5 years in each HSDA.

# mortality ~ year under geo_hsda
# Test if there exist significant differences of means and variances for mortality of all cancer types between 5 years under each HSDA.
result_mor_year_hsda <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="year",groupby1="geo_hsda")
result_mor_year_hsda$description_table
result_mor_year_hsda$`p-value_table`
result_mor_year_hsda$final_table
### Analysis:
### According to the results, there are no significant differences in the means and variances of mortality counts/rates between 5 years in each HSDA.

# Incidence ~ geo_hsda under incid_simple_grp2
# Test if there exist significant differences of means and variances for incidence of 5 years between different HSDAs under each cancer type.
result_inc_hsda_ctype<- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="geo_hsda",groupby1="incid_simple_grp2")
result_inc_hsda_ctype$description_table
result_inc_hsda_ctype$`p-value_table`
result_inc_hsda_ctype$final_table
### Example Analysis:
### According to the results, there exists a significant difference in the means of incidence rates in 5 years between different HSDAs under the cancer type "all other cancers". 
### And the mean of "all other cancers" in "Kootenay Boundary" has the highest mean, the mean of "all other cancers" in "Okanagan" has the lowest mean. 
### That means the people who lived in "Kootenay Boundary" had the highest average incidence rate of "all other cancers" from 2012 to 2016, the people who lived in "Okanagan" had the lowest average incidence rate of "all other cancers" from 2012 to 2016. 

# mortality ~ geo_hsda under incid_simple_grp2
# Test if there exist significant differences of means and variances for mortality of 5 years between different HSDAs under each cancer type.
result_mor_hsda_ctype <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="geo_hsda",groupby1="incid_simple_grp2")
result_mor_hsda_ctype$description_table
result_mor_hsda_ctype$`p-value_table`
result_mor_hsda_ctype$final_table
### Example Analysis:
### According to the results, there exists a significant difference in the means of mortality rates in 5 years between different HSDAs under the cancer type "all other cancers". 
### And the mean of "all other cancers" in "Kootenay Boundary" has the highest mean, the mean of "all other cancers" in "Okanagan" has the lowest mean. 
### That means the people who lived in "Kootenay Boundary" had the highest average mortality rate of "all other cancers" from 2012 to 2016, the people who lived in "Okanagan" had the lowest average mortality rate of "all other cancers" from 2012 to 2016. 

# Incidence ~ incid_simple_grp2 under geo_hsda 
# Test if there exist significant differences of means and variances for incidence of 5 years between all cancer types under each HSDA.
result_inc_ctype_hsda <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",groupby1="geo_hsda",x="incid_simple_grp2")
result_inc_ctype_hsda$description_table
result_inc_ctype_hsda$`p-value_table`
result_inc_ctype_hsda$final_table
filter(result_inc_ctype_hsda$`East Kootenay initial_table`,incid_simple_grp2=="Genito-Urology")
### Example Analysis:
### According to the results, there exists a significant difference in the means and variances of incidence rates of 5 years between all cancer types under "East Kootenay".
### The cancer type "Gastrointestinal" had the highest mean in "East Kootenay", the cancer type "Brain" had the lowest mean. 
### That means cancer type "Gastrointestinal" had the highest average incidence rate in "East Kootenay" during 5 years, and cancer type "Brain" had the highest average incidence rate. 
### The cancer type "Genito-Urology" had the highest variance in "East Kootenay", the cancer type "Gynaecology" had the lowest variance. 
### With further exploration, we found cancer type "Genito-Urology" had a higher incidence rate in East Kootenay in 2012 compared with other years, and the lowest happened in 2016.

# mortality ~ incid_simple_grp2 under geo_hsda 
# Test if there exist significant differences of means and variances for mortality of 5 years between all cancer types under each HSDA.
result_mor_ctype_hsda <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",groupby1="geo_hsda",x="incid_simple_grp2")
result_mor_ctype_hsda$description_table
result_mor_ctype_hsda$`p-value_table`
result_mor_ctype_hsda$final_table
filter(result_mor_ctype_hsda$`East Kootenay initial_table`,incid_simple_grp2=="Hematology/Lymphoma")
### Example Analysis:
### According to the results, there exists a significant difference in the means and variances of mortality rates of 5 years between all cancer types under "East Kootenay". 
### The cancer type "Gastrointestinal" had the highest mean in "East Kootenay", the cancer type "Head & Neck" had the lowest mean. 
### That means cancer type "Gastrointestinal" had the highest average mortality rate in "East Kootenay" during 5 years, and cancer type "Head & Neck" had the highest average mortality rate.
### The cancer type "Hematology/Lymphoma" had the highest variance in "East Kootenay", the cancer type "Gynaecology" had the lowest variance. 
### With further exploration, we found cancer type "Hematology/Lymphoma" had a higher mortality rate in East Kootenay in 2013 compared with other years, and the lowest happened in 2015.

# Incidence ~ year under incid_simple_grp2
# Test if there exist significant differences of means and variances for incidence of all HSDAs between 5 years under each cancer type.
result_inc_year_ctype <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",groupby1="incid_simple_grp2",x="year")
result_inc_year_ctype$description_table
result_inc_year_ctype$`p-value_table`
result_inc_year_ctype$final_table
filter(result_inc_year_ctype$`Brain initial_table`,year==2014)
### Example Analysis:
### According to the results, there is no significant difference in the means for incidence rates of all HSDAs between 5 years under cancer type "Brain".
### However, there exists a significant difference in the variances for incidence rates of all HSDAs between 5 years under cancer type "Brain", and the highest variance happened in 2014. 
### With further exploration, we found "Kootenay Boundary" has a higher incidence rate in 2014 under cancer type "Brain" compared with other HSDAs, and "Okanagan" has the lowest incidence rate.

# mortality ~ year under incid_simple_grp2
# Test if there exist significant differences of means and variances for mortality of all HSDAs between 5 years under each cancer type.
result_mor_year_ctype <- display_mean_var(df=data1mp_hsda,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",groupby1="incid_simple_grp2",x="year")
result_mor_year_ctype$description_table
result_mor_year_ctype$`p-value_table`
result_mor_year_ctype$final_table
### Analysis:
### According to the results, there is no significant difference in the means and variances for mortality of all HSDAs between 5 years under each cancer type.

############################################################

# Incidence ~ age_group2 under year & geo_hsda
# Test if there exist significant differences of means and variances for incidence of all cancer types between different age groups under each year and each HSDA.
result_inc_age_year_hsda <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="age_group2",groupby1="year",groupby2="geo_hsda")
result_inc_age_year_hsda$description_table
result_inc_age_year_hsda$`p-value_table`
result_inc_age_year_hsda$final_table
filter(result_inc_age_year_hsda$`2012_East Kootenay initial_table`,age_group2=="70-84")
### Example Analysis:
### According to the results, there exists significant differences in the means and variance for incidence rates of all cancer types between different age groups under HSDA "East Kootenay" in 2012.
### The highest mean for incidence rates of all cancer types under HSDA "East Kootenay" in 2012 happened on the age group 50-69, and lowest mean happened on the age group 15-29.
### And the highest variance for incidence rates of all cancer types under HSDA "East Kootenay" in 2012 happened on the age group 70-84, and lowest variance happened on the age group 15-29.
### With further exploration, we found cancer type "Genito-Urology" has a higher incidence rate comparing with other cancer types under "East Kootenay" in 2012.

# mortality ~ age_group2 under year & geo_hsda
# Test if there exist significant differences of means and variances for mortality of all cancer types between different age groups under each year and each HSDA.
result_mor_age_year_hsda <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="age_group2",groupby1="year",groupby2="geo_hsda")
result_mor_age_year_hsda$description_table
result_mor_age_year_hsda$`p-value_table`
result_mor_age_year_hsda$final_table
filter(result_mor_age_year_hsda$`2012_East Kootenay initial_table`,age_group2=="70-84")
### Example Analysis:
### According to the results, there exists significant differences in the means and variance for mortality rates of all cancer types between different age groups under HSDA "East Kootenay" in 2012.
### The highest mean for mortality rates of all cancer types under HSDA "East Kootenay" in 2012 happened on the age group 70-84, and lowest mean happened on the age group 15-29.
### And the highest variance for mortality rates of all cancer types under HSDA "East Kootenay" in 2012 happened on the age group 70-84, and lowest variance happened on the age group 15-29.
### With further exploration, we found cancer type "Thoracic" has a higher mortality rate comparing with other cancer types under "East Kootenay" in 2012.

# Incidence ~ age_group2 under geo_hsda & incid_simple_grp2
# Test if there exist significant differences of means and variances for incidence of all years between different age group under each HSDA and each cancer type.
result_inc_age_hsda_ctype<- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="age_group2",groupby1="geo_hsda",groupby2="incid_simple_grp2")
result_inc_age_hsda_ctype$description_table
result_inc_age_hsda_ctype$`p-value_table`
result_inc_age_hsda_ctype$final_table
### Example Analysis:
### According to the results, there exists a significant difference in the means for incidence rates of all years between different age group under HSDA "East Kootenay" and cancer type "All Other Cancers".
### The highest mean for incidence rates of all years happened on the age group 50-69, the lowest mean happened on the age group 15-29 under HSDA "East Kootenay" and cancer type "All Other Cancers".
### And there is no significant difference in variance for incidence rates of all years between different age group under HSDA "East Kootenay" and cancer type "All Other Cancers".

# mortality ~ age_group2 under geo_hsda & incid_simple_grp2
# Test if there exist significant differences of means and variances for mortality of allyears between different age group under each HSDA and each cancer type.
result_mor_age_hsda_ctype<- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="age_group2",groupby1="geo_hsda",groupby2="incid_simple_grp2")
result_mor_age_hsda_ctype$description_table
result_mor_age_hsda_ctype$`p-value_table`
result_mor_age_hsda_ctype$final_table
### Example Analysis:
### According to the results, there exists a significant difference in the means for mortality rates of all years between different age group under HSDA "East Kootenay" and cancer type "All Other Cancers".
### The highest mean for mortality rates of all years happened on the age group 50-69, the lowest mean happened on the age group 15-29 under HSDA "East Kootenay" and cancer type "All Other Cancers".
### And there is no significant difference in variance for mortality rates of all years between different age group under HSDA "East Kootenay" and cancer type "All Other Cancers".

# Incidence ~ age_group2 under year & incid_simple_grp2
# Test if there exist significant differences of mean and variance for incidence of all HSDAs between different age groups under each year and each cancer type.
result_inc_age_year_ctype <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="age_group2",groupby1="year",groupby2="incid_simple_grp2")
result_inc_age_year_ctype$description_table
result_inc_age_year_ctype$`p-value_table`
result_inc_age_year_ctype$final_table
filter(result_inc_age_year_ctype$`2012_All Other Cancers initial_table`,age_group2=="70-84")
### Example Analysis:
### According to the results, there exists significant differences in the means and variances for incidence rates of all HSDAs between different age groups under cancer type "All Other Cancers" in 2012.
### The highest mean for incidence rates of all HSDAs happened on the age group 70-84, the lowest mean happened on the age group 15-29 under cancer type "All Other Cancers" in 2012.
### The highest variance for incidence rates of all HSDAs happened on the age group 70-84, the lowest variance happened on the age group 15-29 under cancer type "All Other Cancers" in 2012.
### With further exploration, we found HSDA "Kootenay Boundary" has a higher incidence rate comparing with other HSDAs under cancer type "All Other Cancers" in 2012.

# mortality ~ age_group2 under year & incid_simple_grp2
# Test if there exist significant differences of mean and variance for mortality of all HSDAs between different age groups under each year and each cancer type.
result_mor_age_year_ctype <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="age_group2",groupby1="year",groupby2="incid_simple_grp2")
result_mor_age_year_ctype$description_table
result_mor_age_year_ctype$`p-value_table`
result_mor_age_year_ctype$final_table
filter(result_mor_age_year_ctype$`2012_All Other Cancers initial_table`,age_group2=="85+")
### Example Analysis:
### According to the results, there exists significant differences in the means and variances for mortality rates of all HSDAs between different age groups under cancer type "All Other Cancers" in 2012.
### The highest mean for mortality rates of all HSDAs happened on the age group 70-84, the lowest mean happened on the age group 15-29 under cancer type "All Other Cancers" in 2012.
### The highest variance for mortality rates of all HSDAs happened on age group 85+, the lowest variance happened on the age group 15-29 under cancer type "All Other Cancers" in 2012.
### With further exploration, we found HSDA "Kootenay Boundary" has a higher mortality rate comparing with other HSDAs under cancer type "All Other Cancers" in 2012.

# Incidence ~ incid_simple_grp2 under geo_hsda & age_group2
# Test if there exist significant differences of mean and variance for incidence of all years between different cancer type under each HSDA and each age group.
result_inc_ctype_hsda_age <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="age_group2")
result_inc_ctype_hsda_age$description_table
result_inc_ctype_hsda_age$`p-value_table`
result_inc_ctype_hsda_age$final_table
filter(result_inc_ctype_hsda_age$`East Kootenay_15-29 initial_table`,incid_simple_grp2=="Hematology/Lymphoma")
### Example Analysis:
### According to the results, there is no significant difference in the means for incidence rates of all years between different cancer type under HSDA "East Kootenay" and age group 15-29.
### And there exists a significant difference in variances for incidence rates of all years between different cancer type under HSDA "East Kootenay" and age group 15-29.
### The highest variance for incidence rates of all years happened on cancer type "Hematology/Lymphoma", and lowest happened on cancer type "Brain","Head & Neck" and "Thoracic" under HSDA "East Kootenay" and age group 15-29.
### With further exploration, we found cancer type "Hematology/Lymphoma" had a higher incidence rate in 2014 compared with other years under HSDA "East Kootenay" and age group 15-29.

# mortality ~ incid_simple_grp2 under geo_hsda & age_group2
# Test if there exist significant differences of mean and variance for mortality of all years between different cancer type under each HSDA and each age group.
result_inc_ctype_hsda_age <- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="incid_simple_grp2",groupby1="geo_hsda",groupby2="age_group2")
result_inc_ctype_hsda_age$description_table
result_inc_ctype_hsda_age$`p-value_table`
result_inc_ctype_hsda_age$final_table
filter(result_inc_ctype_hsda_age$`East Kootenay_15-29 initial_table`,incid_simple_grp2=="All Other Cancers")
### Example Analysis:
### According to the results, there is no significant difference in the means for mortality rates of all years between different cancer type under HSDA "East Kootenay" and age group 15-29.
### And there exists a significant difference in variances for mortality rates of all years between different cancer type under HSDA "East Kootenay" and age group 15-29.
### The highest variance for mortality rates of all years happened on cancer type "All Other Cancers" under HSDA "East Kootenay" and age group 15-29.
### With further exploration, we found cancer type "All Other Cancers" had a higher mortality rate in 2015 compared with other years under HSDA "East Kootenay" and age group 15-29.

# Incidence ~ incid_simple_grp2 under year & age_group2
# Test if there exist significant differences of mean and variance for incidence of all HSDAs between different cancer type under each year and each age group.
result_inc_ctype_year_age<- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="Incidence.count2",columnr="Incidence.rate2",x="incid_simple_grp2",groupby1="year",groupby2="age_group2")
result_inc_ctype_year_age$description_table
result_inc_ctype_year_age$`p-value_table`
result_inc_ctype_year_age$final_table
filter(result_inc_ctype_year_age$`2012_15-29 initial_table`,incid_simple_grp2=="Skin")
### Example Analysis:
### According to the results, there is no significant difference in the means for incidence rates of all HSDAs between different cancer type under age group 15-29 in 2012.
### And there exists a significant difference in variances for incidence rates of all HSDAs between different cancer type under age group 15-29 in 2012.
### The highest variance for incidence rates of all HSDAs happened on cancer type "Skin", and lowest happened on cancer type "Gynaecology" under age group 15-29 in 2012.
### With further exploration, we found cancer type "Skin" had a higher incidence rate in HSDA "East Kootenay" under age group 15-29 in 2012.

# mortality ~ incid_simple_grp2 under year & age_group2
# Test if there exist significant differences of mean and variance for mortality of all HSDAs between different cancer type under each year and each age group.
result_mor_ctype_year_age<- display_mean_var(df=data1mp_hsda_age,c_or_r="rate",columnc="mortality.count2",columnr="mortality.rate2",x="incid_simple_grp2",groupby1="year",groupby2="age_group2")
result_mor_ctype_year_age$description_table
result_mor_ctype_year_age$`p-value_table`
result_mor_ctype_year_age$final_table
filter(result_mor_ctype_year_age$`2012_15-29 initial_table`,incid_simple_grp2=="Hematology/Lymphoma")
### Example Analysis:
### According to the results, there is no significant difference in the means for mortality rates of all HSDAs between different cancer type under age group 15-29 in 2012.
### And there exists a significant difference in variances for mortality rates of all HSDAs between different cancer type under age group 15-29 in 2012.
### The highest variance for mortality rates of all HSDAs happened on cancer type "Hematology/Lymphoma" under age group 15-29 in 2012.
### With further exploration, we found cancer type "Hematology/Lymphoma" had a higher mortality rate in HSDA "Thompson Cariboo Shuswap" under age group 15-29 in 2012.

# memory used
end_mem_used <- mem_used()
print(end_mem_used-start_mem_used)
rm(list = ls())


