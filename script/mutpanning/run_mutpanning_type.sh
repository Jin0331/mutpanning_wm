#!/bin/bash

read -p "study_name insert : " study_name
read -p "process count insert : " p_count

study_count="${study_name}_${p_count}_result"

# make folder
mkdir /root/mutpanning_result/${study_count}

# run mutpanning
java -Xmx32G -classpath /root/MutPanningV2/commons-math3-3.6.1.jar:/root/MutPanningV2/jdistlib-0.4.5-bin.jar:/root/MutPanningV2/ MutPanning \
    "/root/mutpanning_result/run/${study_count}/" \
    "/root/mutpanning_data/${study_name}/${study_name}_mutation.maf" \
    "/root/mutpanning_data/${study_name}/${study_name}_sample_annotation.txt" \
    "/root/Hg19/"

chmod -R 777 /root/mutpanning_result/run/${study_count}