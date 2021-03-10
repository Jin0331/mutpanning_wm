setwd("/home/wmbio/data/mutpanning/data/")

study_list <- list.files(pattern = "[^mutpanning_result]")

# maf bind
maf_bind <- NULL
for(study_name in study_list){
  setwd(paste0("~/data/mutpanning/data/", study_name))
  file_list <- list.files(pattern = "*.maf", full.names = T)
  maf <- fread(file = file_list) %>% as_tibble()
  
  maf_bind <- bind_rows(maf_bind, maf)
  setwd("../")
}

# sample bind
sample_bind <- NULL
for(study_name in study_list){
  setwd(paste0("~/data/mutpanning/data/", study_name))
  file_list <- list.files(pattern = "*.txt", full.names = T)
  sample <- fread(file = file_list) %>% as_tibble()
  
  sample_bind <- bind_rows(sample_bind, sample)
  setwd("../")
}

maf_bind %>% write_delim(file = "ALL/ALL_mutation.maf", delim = "\t")
sample_bind %>% write_delim(file = "ALL/ALL_sample_annotation.txt", delim = "\t")
