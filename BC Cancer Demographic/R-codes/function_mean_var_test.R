# This is the R script to set functions for test equal means/variances.

# call library
library(ggplot2)
library(dplyr)

# set round_pvalue function for round p-value
## return a value
round_pvalue<-function(pvalue){
  if(is.nan(pvalue) != TRUE){
    if(pvalue<0.001){
      return ("<0.001")
    } else if(pvalue<0.005){
      return ("<0.005")
    } else if(pvalue<0.01){
      return ("<0.01")
    } else if(pvalue<0.05){
      return ("<0.05")
    } else{
      return (signif(pvalue,2))
    }
  } else {
    return ("Nan")
  }
}

# set bartlett_test function
## return a value
## H0: all the variances of samples are equal
## H1: at least one variance of samples are not equal
bartlett_test<-function(column,column1){
    tryCatch({
      bartest <- bartlett.test(column ~ column1)
      return(bartest$p.value)
      }, error = function(e) {print("NULL pvalue.")})
}

# set anova_test function
## return a value
## H0: all the means of samples are equal
## H1: at least one mean of samples are not equal
anova_test<-function(column,column1){
  aovtest <- summary(aov(column ~ column1))
  if (is.null(aovtest[[1]][["Pr(>F)"]][1])){
    stop("NULL pvalue.")
  } else {
    return(aovtest[[1]][["Pr(>F)"]][1])
  }
}

# set mean_var_equal.test function
## return dataframe
mean_var_equal.test<-function(df,column,column1,groupby1,groupby2=NULL,groupby3=NULL,groupby4=NULL,groupby5=NULL){
  df_groupby<-df %>% group_by_(groupby1)
  if (is.null(groupby2)==FALSE){
    df_groupby<-df_groupby %>% group_by_(groupby2,add=TRUE)
  }
  if (is.null(groupby3)==FALSE){
    df_groupby<-df_groupby %>% group_by_(groupby3,add=TRUE)
  }
  if (is.null(groupby4)==FALSE){
    df_groupby<-df_groupby %>% group_by_(groupby4,add=TRUE)
  }
  if (is.null(groupby5)==FALSE){
    df_groupby<-df_groupby %>% group_by_(groupby5,add=TRUE)
  }
  if (grepl("count", column, fixed=TRUE)){
    column<-as.symbol(column)
    column1<-as.symbol(column1)
    description_df<-df_groupby %>% summarise("mean_equal"=anova_test(!!column,!!column1),
                                             "var_equal"=bartlett_test(!!column,!!column1))
  } else if (grepl("rate", column, fixed=TRUE)){
    column<-as.symbol(column)
    column1<-as.symbol(column1)
    description_df<-df_groupby %>% summarise("mean_equal"=anova_test(!!column,!!column1),
                                             "var_equal"=bartlett_test(!!column,!!column1))
  }
  return(description_df)
}

# set merge_cr function for merge rate and count dataset 
## return dataframe
merge_cr_mv <- function(df1,df2){
  df<-df1
  col_names <- c("mean_equal","var_equal")
  
  for (i in 1:length(col_names)){
    for (j in 1:nrow(df1)){
      df[j,col_names[i]] <- paste0(round_pvalue(df1[[col_names[i]]][j]),"(",round_pvalue(df2[[col_names[i]]][j]),")")
    }
  }
  return(df)
}

# set paste_fun function for pasting values together if more than one value
## return a value
paste_fun <- function(values){
  if (length(values)>1){
    return(paste(values,collapse=" + "))
  }
  else{
    return(values)
  }
}

# set display_less_alpha function for displaying only when p-value < 0.05
## return a list
display_less_alpha <- function(df,test_df,column,column_name1,groupby1,groupby2=NULL,groupby3=NULL,groupby4=NULL){
  return_df <- NULL
  return_list <-list()
  for (i in 1:nrow(test_df)){
    if(is.nan(test_df[i,]$mean_equal) == FALSE | is.nan(test_df[i,]$var_equal) == FALSE){
        column_2 <- as.symbol(column)
        column_name1_2 <- as.symbol(column_name1)
        column_value <- as.character(test_df[[column_name1]][i])
        temp <- filter(df,!!column_name1_2==column_value)
        old_table_name <- paste(column_value,"initial_table")
        return_list[[old_table_name]] <- temp
        if(is.null(groupby2)==FALSE){
          groupby2_2 <- as.symbol(groupby2)
          column_value2 <- as.character(test_df[[groupby2]][i])
          temp <- filter(temp,!!groupby2_2==column_value2)
        } 
        if (is.null(groupby3)==FALSE){
          groupby3_2 <- as.symbol(groupby3)
          column_value3 <- as.character(test_df[[groupby3]][i])
          temp <- filter(temp,!!groupby3_2==column_value3)
        } 
        if (is.null(groupby4)==FALSE){
          groupby4_2 <- as.symbol(groupby4)
          column_value4 <- as.character(test_df[[groupby4]][i])
          temp <- filter(temp,!!groupby4_2==column_value4)
        }
        temp_new <- temp %>% group_by_(groupby1)
        if (is.null(groupby2)==FALSE){
          temp_new <- temp_new %>% group_by_(groupby2,add=TRUE)
          column_value <- paste0(column_value,"_",as.character(test_df[[groupby2]][i]))
          old_table_name <- paste(column_value,"initial_table")
          return_list[[old_table_name]] <- temp
        }
        if (is.null(groupby3)==FALSE){
          temp_new <- temp_new %>% group_by_(groupby3,add=TRUE)
          column_value <- paste0(column_value,"_",as.character(test_df[[groupby3]][i]))
          old_table_name <- paste(column_value,"initial_table")
          return_list[[old_table_name]] <- temp
        }
        if (is.null(groupby4)==FALSE){
          temp_new <- temp_new %>% group_by_(groupby4,add=TRUE)
          column_value <- paste0(column_value,"_",as.character(test_df[[groupby4]][i]))
          old_table_name <- paste(column_value,"initial_table")
          return_list[[old_table_name]] <- temp
        }
        if (test_df[i,]$mean_equal<0.05 & test_df[i,]$var_equal<0.05){
          temp_new <- temp_new %>% summarise("mean"=mean(!!column_2),
                                             "var"=var(!!column_2)) 
          temp_new$mean_order <- dense_rank(temp_new$mean)
          temp_new$var_order <- dense_rank(temp_new$var)
          return_df1 <- data.frame("x" = column_value,
                                   "mean_highest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$mean_order==max(temp_new$mean_order)])),
                                   "mean_lowest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$mean_order==min(temp_new$mean_order)])),
                                   "var_highest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$var_order==max(temp_new$var_order)])),
                                   "var_lowest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$var_order==min(temp_new$var_order)])))
          if (i==1){
            return_df <- return_df1
          } else {
            return_df <- rbind(return_df,return_df1)
          }
        } else if(test_df[i,]$mean_equal<0.05 & test_df[i,]$var_equal>0.05){
          temp_new <- temp_new %>% summarise("mean"=mean(!!column_2))
          temp_new$mean_order <- dense_rank(temp_new$mean)
          return_df1 <- data.frame("x" = column_value,
                                   "mean_highest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$mean_order==max(temp_new$mean_order)])),
                                   "mean_lowest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$mean_order==min(temp_new$mean_order)])),
                                   "var_highest"="equal","var_lowest"="equal")
          if (i==1){
            return_df <- return_df1
          } else {
            return_df <- rbind(return_df,return_df1)
          }
        } else if(test_df[i,]$mean_equal>0.05 & test_df[i,]$var_equal<0.05){
          temp_new <- temp_new %>% summarise("var"=var(!!column_2))
          temp_new$var_order <- dense_rank(temp_new$var)
          return_df1 <- data.frame("x" = column_value,
                                   "mean_highest"="equal","mean_lowest"="equal",
                                   "var_highest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$var_order==max(temp_new$var_order)])),
                                   "var_lowest"=paste_fun(as.character(temp_new[[groupby1]][temp_new$var_order==min(temp_new$var_order)])))
          if (i==1){
            return_df <- return_df1
          } else {
            return_df <- rbind(return_df,return_df1)
          }
        } else if (test_df[i,]$mean_equal>0.05 & test_df[i,]$var_equal>0.05){
          return_df1 <- data.frame("x"=column_value,
                                   "mean_highest"="equal","mean_lowest"="equal",
                                   "var_highest"="equal","var_lowest"="equal")
          if (i==1){
            return_df <- return_df1
          } else {
            return_df <- rbind(return_df,return_df1)
          }
        }
        temp_new$x <- column_value
        box_plot <- ggplot(temp, aes(x=temp[,groupby1], y=temp[,column])) +
          geom_boxplot() +
          geom_jitter(shape=16, position=position_jitter(0.2))+      # plot option 1
          #geom_dotplot(binaxis='y', stackdir='center', dotsize=1) + # plot option 2 
          labs(title=paste("Boxplot of",column,"vs",groupby1,"in",column_value), x=groupby1, y=column)
        table_name <- paste(column_value,"table")
        boxplot_name <- paste(column_value,"boxplot")
        return_list[[table_name]] <- temp_new
        return_list[[boxplot_name]] <- box_plot
    }
  }
  return_list[["final_table"]] <- return_df
  return(return_list)
}

# set display_mean_var function for merge functions mean_var_equal.test & display_less_alpha
## return a list
display_mean_var <- function(df,c_or_r,columnc,columnr,x,groupby1,groupby2=NULL,groupby3=NULL,groupby4=NULL){
  df1 <- description(df,columnc,x,groupby1,groupby2,groupby3,groupby4)
  df2 <- description(df,columnr,x,groupby1,groupby2,groupby3,groupby4)
  return_list <- list(df1)
  names(return_list) <- c("count_table")
  return_list[["rate_table"]] <- df2
  df12 <- merge_cr(df1,df2)
  return_list[["description_table"]] <- df12
  
  df3 <- mean_var_equal.test(df,columnc,x,groupby1,groupby2,groupby3,groupby4)
  df4 <- mean_var_equal.test(df,columnr,x,groupby1,groupby2,groupby3,groupby4)
  df34 <- merge_cr_mv(df3,df4)
  return_list[["p-value_table"]] <- df34

  if(c_or_r == "rate"){
    test_df = df4
    column = columnr
  } else if (c_or_r == "count"){
    test_df = df3
    column = columnc
  }
  result <- display_less_alpha(df,test_df,column,groupby1,x,groupby2,groupby3,groupby4)
  return_list <- c(return_list,result)
  return(return_list)
}


