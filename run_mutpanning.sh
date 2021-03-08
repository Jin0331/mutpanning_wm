#!/bin/bash

root_path="/root/MutPanningV2/"
read -p "study_name insert : " study_name

# make folder
mkdir /root/MutPanning_result/${study_name}

# run mutpanning
java -Xmx32G -classpath /root/MutPanningV2/commons-math3-3.6.1.jar:/root/MutPanningV2/jdistlib-0.4.5-bin.jar:/root/MutPanningV2/ MutPanning \
"/root/MutPanning_result/${study_name}/" \
"/root/mutpanning_data/${study_name}/${study_name}_mutation.maf" \
"/root/mutpanning_data/${study_name}/${study_name}_sample_annotation.txt" \
 "/root/Hg19/"