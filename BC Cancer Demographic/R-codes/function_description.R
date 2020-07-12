# This is the R script to set functions to generate descriptive statistical data frames.

# set function for mode
## return a value
mode_fun<-function(column){
  uniqv <- unique(column)
  mode_value <- uniqv[which.max(tabulate(match(column, uniqv)))]
  return(mode_value)
}

# set description function
## return a dataframe
description<-function(df,column,groupby1,groupby2=NULL,groupby3=NULL,groupby4=NULL,groupby5=NULL){
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
    description_df<-df_groupby %>% summarise("mean"=round(mean(!!column),0),
                                             "median"=median(!!column),
                                             "mode"=mode_fun(!!column),
                                             "var"=round(var(!!column),2),
                                             "sd"=round(sd(!!column),2))
  } else if (grepl("rate", column, fixed=TRUE)){
    column<-as.symbol(column)
    description_df<-df_groupby %>% summarise("mean"=signif(mean(!!column),2),
                                             "median"=signif(median(!!column),2),
                                             "mode"=signif(mode_fun(!!column),2),
                                             "var"=signif(var(!!column),2),
                                             "sd"=signif(sd(!!column),2))
  }
  return(description_df)
}


# set merge_cr function for merge rate and count dataset 
## return a dataframe
merge_cr <- function(df1,df2){
  df<-df1
  col_names <- c("mean","median","mode","var","sd")
  for (i in 1:length(col_names)){
    for (j in 1:nrow(df1)){
      df[j,col_names[i]] <- paste0(df1[j,col_names[i]],"(",df2[j,col_names[i]],")")
    }
  }
  return(df)
}


