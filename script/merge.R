library(tidyverse)
library(data.table)
library(doMC)

# root path 
root_path <- "~/data/mutpanning/data/mutpanning_result/suc"
setwd(root_path)

result_list <-  list()
for(path1 in list.files(full.names = T)){
  print(paste0(path1, "_start"))
  
  # path change
  setwd(paste0(path1, "/", "SignificanceFiltered"))  
  
  # tryCatch(
  #   expr = {
  #     setwd(paste0(path1, "/", "SignificanceFiltered"))  
  #   },
  #   error = { 
  #     setwd(root_path);next;
  #     }
  # )
  
  # print(list.files(full.names = T))
  
  file_path <- list.files(full.names = T) %>% 
    .[str_detect(., pattern = "Uniform", negate = T)]
  list_name <- list.files(full.names = F, ) %>% 
    .[str_detect(., pattern = "Uniform", negate = T)] %>% 
    str_remove(".txt")
  
  # file load
  DF <- lapply(X = file_path, FUN = function(path){
    fread(file = path) %>% as_tibble() %>%
      distinct(Name, .keep_all = T) %>% return()
  })
  names(DF) <- list_name # list name 
  
  # 첫 실행인 경우, first value가 left
  if(length(result_list) == 0){
    result_list <- DF
  
  # 비교시작
  } else {
    
    for(study_type in names(result_list)){
      print(paste0(path1, "_start_result_list_", study_type))
      left <- result_list[[study_type]]
      right <- DF[[study_type]]
      # join, 중복 column x, y name 지정
      join_DF <- inner_join(x = left, y = right, by = "Name")
      
      # result_list 재정의 study 별로
      result_list[[study_type]] <- mclapply(X = 1:nrow(join_DF), FUN = function(row_index){ # study의 row 별로(gene)
          row_df <- join_DF[row_index, ]
          # FDR값 추출
          x_FDR <- row_df %>% pull(FDR.x)
          y_FDR <- row_df %>% pull(FDR.y)
          
          if(x_FDR <= y_FDR){
            return_df <- row_df %>% select(Name, TargetSize = TargetSize.x, TargetSizeSyn = TargetSizeSyn.x,
                                           Count = Count.x,  CountSyn =  CountSyn.x, Significance = Significance.x, FDR = FDR.x)
          } else {
            return_df <- row_df %>% select(Name, TargetSize = TargetSize.y, TargetSizeSyn = TargetSizeSyn.y,
                                           Count = Count.y,  CountSyn =  CountSyn.y, Significance = Significance.y, FDR = FDR.y)
          }
          return(return_df)}, mc.cores = 5) %>% bind_rows()
    }
  }
  setwd(root_path) ## root path로 복귀
}
