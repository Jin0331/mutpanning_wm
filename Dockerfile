FROM openjdk:8

USER root
WORKDIR /root/

# essential package install
RUN apt-get update && apt-get -y upgrade && \
  apt-get install -y apt-utils build-essential apt-transport-https software-properties-common && \
  apt-get install -y tree nano ncftp vim net-tools wget ssh htop iputils-ping sudo git make curl man unzip openssh-server openssh-client rsync wget  && \
  rm -rf /var/lib/apt/lists/*

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \ 
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

##replace sshd_config : root allow
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# install Python 3.7
RUN apt-add-repository -r ppa:armagetronad-dev/ppa \
    && apt-get update -q && apt-get install -y build-essential libpq-dev libssl-dev openssl libffi-dev zlib1g-dev python3-pip python3.7-dev python3.7 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

# pip upgrade
RUN pip3 install --upgrade pip

# jupyter notebook or lab install
RUN pip3 install jupyter && jupyter notebook --generate-config  && \
    echo "c.NotebookApp.ip='*'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py

# python jupyter lab && python3 venv
RUN apt-get update && apt-get install python3-venv -y && \
    pip3 install jupyterlab virtualenv

# git clone MutPanningV2
RUN git clone https://github.com/vanallenlab/MutPanningV2.git
ADD Hg19.zip /root/Hg19.zip

# Reference annotation hg19
RUN unzip /root/Hg19.zip \
&& rm -rf Hg19.zip

RUN cd MutPanningV2 && \
    javac -classpath commons-math3-3.6.1.jar:jdistlib-0.4.5-bin.jar *.java

# Mutagene
RUN pip3 install mutagene

# timezone 
# https://blog.hangyeong.com/1013

# result dir create
RUN mkdir /root/mutpanning_result /root/mutagene_result
RUN mkdir -p /root/mutagene_preprocessing/

# script copy
ADD script/mutpanning/run_mutpanning_all_loop.sh /root/mutpanning_script/run_mutpanning_all_loop.sh
ADD script/mutpanning/run_mutpanning_type.sh /root/mutpanning_script/run_mutpanning_type.sh
ADD script/mutpanning/pre_mutpanning.sh /root/mutpanning_script/pre_mutpanning.sh

ADD script/mutagene/mutagene_input_preprocessing.py /root/mutagene_script/mutagene_input_preprocessing.py

RUN chmod -R 777 /root/mutpanning_script
RUN chmod -R 777 /root/mutagene_script

# Mutagene
RUN /bin/bash -c "python3 -m venv env_mutagene && \
    source env_mutagene/bin/activate && \
    pip3 install pandas && \
    pip3 install mutagene"

# Entory Point
ADD script/entry-point.sh /usr/local/bin/entry-point.sh
RUN chmod 777 /usr/local/bin/entry-point.sh

EXPOSE 8888 22
ENTRYPOINT ["/usr/local/bin/entry-point.sh"]

