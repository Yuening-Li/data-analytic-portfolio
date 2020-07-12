# This is the R script to read original datasets and generate new datasets.

# install library
library(readxl)

#read  dataset dataset1 and population
data1 <- read_excel("data/dataset1.xlsx")
write.csv(data1,"data/dataset1.csv", row.names = FALSE)
data1 <- read.csv("data/dataset1.csv",stringsAsFactors=TRUE,header=TRUE)
population<-read.csv("data/population_interior.csv",stringsAsFactors=FALSE,header=TRUE) 

# check na in dataset1
apply(data1, 2, function(x) any(is.na(x)))
################################################################################################
#  geo_type         geo_id         geo_desc           geo_ha         geo_hsda           year   #
#  FALSE            FALSE            FALSE            FALSE            FALSE            FALSE  #
#  incid_simple_grp  sex          age_group       Incidence.count   mortality.count            #
#  FALSE            FALSE            FALSE            FALSE            FALSE                   #
################################################################################################

# change 24 types of cancer types into 10
data1$incid_simple_grp2 <- as.character(data1$incid_simple_grp)
gastrointestinal <- c("Esophagus","Stomach","Colorectal","Liver","Pancreas")
thoracic <- c("Lung")
gynaecology <- c("Cervix","Body of Uterus","Ovary")
Urology <- c("Testis","Kidney","Bladder","Prostate")
lymphoma <- c("Hodgkin Lymphoma","Non-Hodgkin Lymphoma","Multiple Myeloma","Leukemia")
head_neck <- c("Thyroid","Oral","Larynx")
skin <- c("Melanoma (Skin)")
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% gastrointestinal] <- "Gastrointestinal"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% thoracic] <- "Thoracic"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% gynaecology] <- "Gynaecology"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% Urology] <- "Genito-Urology"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% lymphoma] <- "Hematology/Lymphoma"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% head_neck] <- "Head & Neck"
data1$incid_simple_grp2[data1$incid_simple_grp2 %in% skin] <- "Skin"
rm(gastrointestinal,thoracic,gynaecology,Urology,lymphoma,head_neck,skin)

# change "<5" by sampling from 1,2,3,4
set.seed(1644)
sample1_4_incidence <- sample(1:4, sum(data1$Incidence.count == "<5"),replace = TRUE)
sample1_4_mortality <- sample(1:4, sum(data1$mortality.count == "<5"),replace = TRUE)
data1$Incidence.count2 <- as.character(data1$Incidence.count)
data1$Incidence.count2[data1$Incidence.count2 == "<5"] <- sample1_4_incidence
data1$Incidence.count2 <- as.numeric(data1$Incidence.count2)
data1$mortality.count2 <- as.character(data1$mortality.count)
data1$mortality.count2[data1$mortality.count2 == "<5"] <- sample1_4_mortality
data1$mortality.count2 <- as.numeric(data1$mortality.count2)
rm(sample1_4_incidence,sample1_4_mortality)

# combine age groups in dataset1
data1m <- as.data.frame(data1 %>% group_by(geo_desc,geo_hsda,year,incid_simple_grp2) %>% summarise_each(funs(sum(.,na.rm=TRUE)),Incidence.count2,mortality.count2))

# merge dataset1 and population
data1mp <- merge(data1m,population,by=c("geo_hsda","geo_desc"))

# calculate the rate
data1mp$Incidence.rate2 <- 0
data1mp$mortality.rate2 <- 0
for (i in unique(data1$year)){
  temp <- data1mp[data1mp$year==i,]
  data1mp[data1mp$year==i,]$Incidence.rate2 <- temp$Incidence.count2/temp[,paste0("pop_",i)]*100
  data1mp[data1mp$year==i,]$mortality.rate2 <- data1mp[data1mp$year==i,]$mortality.count2/data1mp[data1mp$year==i,][,paste0("pop_",i)]*100
}
data1mp <- subset(data1mp, select = -c(typeid,pop_2012,pop_2013,pop_2014,pop_2015,pop_2016) )
col_names <- c("geo_hsda","geo_desc","year","incid_simple_grp2")
data1mp[,col_names] <- lapply(data1mp[,col_names] ,factor)
rm(data1m,temp,col_names)

# output csv
# write.csv(data1mp,"data/data1_noage_lha.csv", row.names = FALSE)

# change new age groups in dataset1 
data1$age_group2 <- as.character(data1$age_group)
agegroups <- unique(data1$age_group)
data1$age_group2[data1$age_group2 %in% agegroups[1:3]] <- "15-29"
data1$age_group2[data1$age_group2 %in% agegroups[4:7]] <- "30-49"
data1$age_group2[data1$age_group2 %in% agegroups[8:11]] <- "50-69"
data1$age_group2[data1$age_group2 %in% agegroups[12:14]] <- "70-84"
data1$age_group2[data1$age_group2 %in% agegroups[15:16]] <- "85+"
data1m_age <- as.data.frame(data1 %>% group_by(geo_desc,geo_hsda,year,incid_simple_grp2,age_group2) %>% summarise_each(funs(sum(.,na.rm=TRUE)),Incidence.count2,mortality.count2))
rm(agegroups)

# merge dataset1 and population
data1mp_age<-merge(data1m_age,population,by=c("geo_hsda","geo_desc"))

# calculate the rate
data1mp_age$Incidence.rate2 <- 0
data1mp_age$mortality.rate2 <- 0
for (i in unique(data1$year)){
  temp <- data1mp_age[data1mp_age$year==i,]
  data1mp_age[data1mp_age$year==i,]$Incidence.rate2 <- temp$Incidence.count2/temp[,paste0("pop_",i)]*100
  data1mp_age[data1mp_age$year==i,]$mortality.rate2<-data1mp_age[data1mp_age$year==i,]$mortality.count2/data1mp_age[data1mp_age$year==i,][,paste0("pop_",i)]*100
}
data1mp_age <- subset(data1mp_age, select = -c(typeid,pop_2012,pop_2013,pop_2014,pop_2015,pop_2016) )
col_names <- c("geo_hsda","geo_desc","year","incid_simple_grp2","age_group2")
data1mp_age[,col_names] <- lapply(data1mp_age[,col_names] ,factor)
rm(data1m_age,temp,col_names)

# output csv
# write.csv(data1mp_age,"data/data1_age_lha.csv", row.names = FALSE)

# combine LHAs in population dataset
population_hsda <- as.data.frame(population %>% group_by(geo_hsda) %>% summarise_each(funs(sum(.,na.rm=TRUE)),pop_2012,pop_2013,pop_2014,pop_2015,pop_2016))

# combine age groups and LHAs in dataset1
data1m_hsda <- as.data.frame(data1 %>% group_by(geo_hsda,year,incid_simple_grp2) %>% summarise_each(funs(sum(.,na.rm=TRUE)),Incidence.count2,mortality.count2))

# merge dataset1 and dataset population_hsda
data1mp_hsda <- merge(data1m_hsda,population_hsda,by=c("geo_hsda"))

# calculate the rate
data1mp_hsda$Incidence.rate2 <- 0
data1mp_hsda$mortality.rate2 <- 0
for (i in unique(data1$year)){
  data1mp_hsda[data1mp_hsda$year==i,]$Incidence.rate2 <- data1mp_hsda[data1mp_hsda$year==i,]$Incidence.count2/ data1mp_hsda[data1mp_hsda$year==i,][,paste0("pop_",i)]*100
  data1mp_hsda[data1mp_hsda$year==i,]$mortality.rate2 <- data1mp_hsda[data1mp_hsda$year==i,]$mortality.count2/ data1mp_hsda[data1mp_hsda$year==i,][,paste0("pop_",i)]*100
}
data1mp_hsda <- subset(data1mp_hsda, select = -c(pop_2012,pop_2013,pop_2014,pop_2015,pop_2016) )
col_names <- c("geo_hsda","year","incid_simple_grp2")
data1mp_hsda[,col_names] <- lapply(data1mp_hsda[,col_names] ,factor)
rm(data1m_hsda,col_names)

# output csv
# write.csv(data1mp_hsda,"data/data1_noage_hsda.csv", row.names = FALSE)

# change new age groups in dataset1
data1$age_group2 <- as.character(data1$age_group)
agegroups <- unique(data1$age_group)
## 15-29，30-49，50-69，70-84，85+
data1$age_group2[data1$age_group2 %in% agegroups[1:3]] <- "15-29"
data1$age_group2[data1$age_group2 %in% agegroups[4:7]] <- "30-49"
data1$age_group2[data1$age_group2 %in% agegroups[8:11]] <- "50-69"
data1$age_group2[data1$age_group2 %in% agegroups[12:14]] <- "70-84"
data1$age_group2[data1$age_group2 %in% agegroups[15:16]] <- "85+"

# merge dataset1 and dataset population_hsda
data1m_hsda_age <- as.data.frame(data1 %>% group_by(geo_hsda,year,incid_simple_grp2,age_group2) %>% summarise_each(funs(sum(.,na.rm=TRUE)),Incidence.count2,mortality.count2))
data1mp_hsda_age<-merge(data1m_hsda_age,population_hsda,by=c("geo_hsda")) 
rm(agegroups,data1m_hsda_age)

# calculate the rate
data1mp_hsda_age$Incidence.rate2 <- 0
data1mp_hsda_age$mortality.rate2 <- 0
for (i in c(2012:2016)){
  data1mp_hsda_age[data1mp_hsda_age$year==i,]$Incidence.rate2 <- data1mp_hsda_age[data1mp_hsda_age$year==i,]$Incidence.count2/ data1mp_hsda_age[data1mp_hsda_age$year==i,][,paste0("pop_",i)]*100
  data1mp_hsda_age[data1mp_hsda_age$year==i,]$mortality.rate2 <- data1mp_hsda_age[data1mp_hsda_age$year==i,]$mortality.count2/ data1mp_hsda_age[data1mp_hsda_age$year==i,][,paste0("pop_",i)]*100
}
data1mp_hsda_age <- subset(data1mp_hsda_age, select = -c(pop_2012,pop_2013,pop_2014,pop_2015,pop_2016) )

col_names <- c("geo_hsda","year","incid_simple_grp2","age_group2")
data1mp_hsda_age[,col_names] <- lapply(data1mp_hsda_age[,col_names] ,factor)
rm(col_names)

# output csv
# write.csv(data1mp_hsda_age,"data/data1_age_hsda.csv", row.names = FALSE)


