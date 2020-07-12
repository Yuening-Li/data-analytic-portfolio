# This is the R script to do chi-square test for independence between the average incidence/mortality counts in HSDAs from 2012-2016 and 10 Cancer types.

# get path
# please change the path to the folder
mainDir <- "~/Desktop/capstone_BC Cancer-Kelowna (Demographics)"
subDir <- "products/hsda_chi-square test"
setwd(mainDir)

# create folder
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)

# install library
library(pryr)
library(dplyr)
library(tidyr)
library(ggplot2)

# memory used
start_mem_used <- mem_used()
start_mem_used

# import dataset and function
source("Rcodes/capstone_dataset.R")

# Chi-square test
# Null Hypothesis (H0): there is no difference in the distribution of cancer types among HSDAs
# Alternative Hypothesis (H1): there are differences in the distribution of cancer types among HSDAs
# 
# If the chi-square test statistic is small (i.e. p-value ??? 0.05), there is evidence to reject the null hypothesis, 
# which means there are differences in the distribution of cancer types among HSDAs.

# merge years
### merge years
hsda_cancer_by_year <- data1mp %>%
  group_by(geo_hsda,incid_simple_grp2,year) %>%
  arrange(geo_hsda,incid_simple_grp2,year) %>%
  summarise_each(funs(sum(.,na.rm=TRUE)),Incidence.count2,mortality.count2)
hsda_cancer_merge_year <- hsda_cancer_by_year %>%
  group_by(geo_hsda,incid_simple_grp2) %>%
  arrange(geo_hsda,incid_simple_grp2) %>%
  summarise_each(funs(mean(.,na.rm=TRUE)),Incidence.count2,mortality.count2)
hsda_cancer_merge_year$Incidence.count2 <- round(hsda_cancer_merge_year$Incidence.count2,0)
hsda_cancer_merge_year$mortality.count2 <- round(hsda_cancer_merge_year$mortality.count2,0)

# Generate 4*24 HSDA by Cancer Type, incidents and mortality counts tabbles, which chi-square test will be conducted on
hsda_cancer_incident <- as.data.frame(hsda_cancer_merge_year[1:3]%>%spread(incid_simple_grp2,Incidence.count2))[,2:11]
hsda_cancer_mort <- as.data.frame(hsda_cancer_merge_year[c(1,2,4)]%>%spread(incid_simple_grp2,mortality.count2))[,2:11]

# name rows and columns
rn<-unique(hsda_cancer_merge_year$geo_hsda)
cn<-unique(hsda_cancer_merge_year$incid_simple_grp2)
colnames(hsda_cancer_incident) <- cn
colnames(hsda_cancer_mort) <- cn
rownames(hsda_cancer_incident) <- rn
rownames(hsda_cancer_mort) <- rn

# create dataframe to store chi-squared test statistic and p.value
chisq_data<- data.frame(matrix(ncol = 4, nrow = 0))

# R built-in chi-squre test
chisq1 <- chisq.test(hsda_cancer_incident)
chisq2 <- chisq.test(hsda_cancer_mort)
r <- c(chisq1$statistic,chisq1$p.value,chisq2$statistic,chisq2$p.value) 
chisq_data <- rbind(chisq_data,r)
chisq_data <- setNames(chisq_data, c( "incidents.statistic", "incidents.p.value","mortality.statistic","mortality.p.value"))

# output the p-values result
write.csv(chisq_data,"products/hsda_chi-square test/chi-square-test_hsda.csv", row.names = FALSE)

# output the tables tested that p-value on
# write.csv(hsda_cancer_incident,"products/hsda_chi-square test/hsda_cancer_incident.csv", row.names = F)
# write.csv(hsda_cancer_mort,"products/hsda_chi-square test/hsda_cancer_mort.csv", row.names = F)

# memory used
end_mem_used <- mem_used()
print(end_mem_used-start_mem_used)
rm(list = ls())


