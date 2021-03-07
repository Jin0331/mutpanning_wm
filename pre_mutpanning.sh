#!/bin/bash

read -p "study_name insert : " study_name
#cd /root/mutpanning/mutpanning_data/${study_name}
study_path=/root/mutpanning_data/${study_name}

# ._ file remove
find ${study_path} -type f -name '._*' -delete

# raw maf dir create
mkdir ${study_path}/raw
find ${study_path} -name "*.tar.gz" -exec mv {} ${study_path}/raw \;

# gdc maf unzip
mkdir ${study_path}/maf
find ${study_path}/raw/ -name "*.tar.gz" -exec tar -xzvf {} -C ${study_path}/raw \;
find ${study_path}/raw -name "*.maf" -exec cp {} ${study_path}/maf \;