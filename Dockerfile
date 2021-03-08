FROM openjdk:8

USER root
WORKDIR /root/
# essential package
RUN apt-get update && apt-get install nano git -y 

# git clone MutPanningV2
RUN git clone https://github.com/vanallenlab/MutPanningV2.git
ADD Hg19.zip /root/Hg19.zip

# Reference annotation hg19
RUN unzip /root/Hg19.zip \
&& rm -rf Hg19.zip

RUN cd MutPanningV2 && \
    javac -classpath commons-math3-3.6.1.jar:jdistlib-0.4.5-bin.jar *.java


# MutPanning preprocessing/run sh
RUN mkdir /root/MutPanning_result
ADD run_mutpanning_all.sh /root/run_mutpanning_all.sh
ADD run_mutpanning_type.sh /root/run_mutpanning_type.sh
ADD pre_mutpanning.sh /root/pre_mutpanning.sh
RUN chmod 777 /root/run_mutpanning_all.sh
RUN chmod 777 /root/run_mutpanning_type.sh
RUN chmod 777 /root/pre_mutpanning.sh

# Entory Point
ADD entry-point.sh /usr/local/bin/entry-point.sh
RUN chmod 777 /usr/local/bin/entry-point.sh
ENTRYPOINT ["/usr/local/bin/entry-point.sh"]

