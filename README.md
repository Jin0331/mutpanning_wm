# **mutpanning_wm**


### **Docker run**

``docker run -dit -v /home/wmbio/data/mutpanning/data:/root/mutpanning_data -v /home/wmbio/data/mutpanning/result:/root/MutPanning_result -p 1222:22 -p 18888:8888  --name mutpanning sempre813/mutpanning:1.2``


### **run mutpanning target**

``./run_mutpanning_type.sh``

### **run mutpanning all loop**

``./run_mutpanning_all_loop.sh``