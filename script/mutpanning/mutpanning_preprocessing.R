library(tidyverse)
library(data.table)

project_name <- readline('insert projtect name : ')

# ./pre_mutpanning.sh 이후 실행할 것. study별 maf 및 raw 폴더 생성 확인
setwd(paste0("/home/wmbio/data/mutpanning/data/", project_name, "/maf"))
maf_path <- list.files(pattern = "*.maf", full.names = T)

mutpanning_maf <- lapply(X = maf_path, FUN = function(path){
  fread(file = path) %>% as_tibble() %>% 
    select(Hugo_Symbol, Chromosome, Start_Position = Start_position, End_Position = End_position, Strand, 
           Variant_Classification, Variant_Type, Reference_Allele, Tumor_Seq_Allele1, 
           Tumor_Seq_Allele2, Tumor_Sample_Barcode) %>% 
    return()
}) %>% bind_rows() %>% distinct(Hugo_Symbol, Chromosome, Start_Position, Strand, End_Position, Variant_Classification, 
                                Tumor_Sample_Barcode, Variant_Type, Reference_Allele, Tumor_Seq_Allele1, Tumor_Seq_Allele2, .keep_all = T)

mutpanning_sample <- mutpanning_maf %>% select(Sample = Tumor_Sample_Barcode) %>% distinct() %>% 
  mutate(Cohort = project_name)

mutpanning_maf %>% write_delim(file = paste0("../", project_name, "_mutation.maf"), delim = "\t")
mutpanning_sample %>% write_delim(file = paste0("../", project_name, "_sample_annotation.txt"), delim = "\t")
setwd("../")
