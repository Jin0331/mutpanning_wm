# **mutpanning_wm**


### **Docker run**

``docker run -dit -v /home/wmbio/data/mutpanning/data:/root/mutpanning_data -v /home/wmbio/data/mutpanning_result:/root/mutpanning_result -v /home/wmbio/data/mutagene_result:/root/mutagene_result -p 1222:22 -p 18888:8888  --name mutpanning sempre813/mutpanning:1.3``


### **run mutpanning target**

``./run_mutpanning_type.sh``

### **run mutpanning all loop**

``./run_mutpanning_all_loop.sh``

### **run mutagene - Calculating mutational profile with MutaGene and applying it to mutation ranking**
``mutagene -v rank -g hg19 -i /root/mutagene_preprocessing/[study].maf -o /root/mutagene_result/[study].profile -c [cacner type]``