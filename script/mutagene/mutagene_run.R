library(tidyverse)
library(data.table)
library(glue)

mut_cohort <- fread("/root/mutagene_preprocessing/mutagene_cohort.txt", header = T)
input_path <- "/root/mutagene_preprocessing/"
result_path <- "/root/mutagene_result/"

# file list
file_path <- list.files("~/mutagene_preprocessing/", pattern = "*.maf", full.names = T)

# for or lapply
for(path in file_path){
    
    study_name <- path %>%
        str_extract(pattern = "(?<=preprocessing//)[A-Z]+")
    cohort_name <- mut_cohort %>% filter(type == study_name) %>% pull(1)
    
    # pancancer
    system(glue("mutagene -v rank -g hg19 -i {input}{name}_mutagene_input.maf -o {result}{name}_pancancer_result.profile -c pancancer", 
                input = input_path, result = result_path, name = study_name, cohort = cohort_name))
    print(paste0(study_name, "-pancancer", " is done!!"))
    
    # handling
    if(length(cohort_name) == 0){ next } 
    
    # mutagene run each cohort
    system(glue("mutagene -v rank -g hg19 -i {input}{name}_mutagene_input.maf -o {result}{name}_{cohort}_result.profile -c {cohort}", 
                input = input_path, result = result_path, name = study_name, cohort = cohort_name))    
    print(paste0(study_name, "-", cohort_name, " is done!!"))
}library(tidyverse)
library(data.table)
library(glue)

mut_cohort <- fread("/root/mutagene_preprocessing/mutagene_cohort.txt", header = T)
input_path <- "/root/mutagene_preprocessing/"
result_path <- "/root/mutagene_result/"

# file list
file_path <- list.files("~/mutagene_preprocessing/", pattern = "*.maf", full.names = T)

# for or lapply
for(path in file_path){
    
    study_name <- path %>%
        str_extract(pattern = "(?<=preprocessing//)[A-Z]+")
    cohort_name <- mut_cohort %>% filter(type == study_name) %>% pull(1)
    
    # pancancer
    system(glue("mutagene -v rank -g hg19 -i {input}{name}_mutagene_input.maf -o {result}{name}_pancancer_result.profile -c pancancer", 
                input = input_path, result = result_path, name = study_name, cohort = cohort_name))
    print(paste0(study_name, "-pancancer", " is done!!"))
    
    # handling
    if(length(cohort_name) == 0){ next } 
    
    # mutagene run each cohort
    system(glue("mutagene -v rank -g hg19 -i {input}{name}_mutagene_input.maf -o {result}{name}_{cohort}_result.profile -c {cohort}", 
                input = input_path, result = result_path, name = study_name, cohort = cohort_name))    
    print(paste0(study_name, "-", cohort_name, " is done!!"))
}