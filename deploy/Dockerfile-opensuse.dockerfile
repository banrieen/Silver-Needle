# DockerName: Devil runner
# Usecase: With many runtime dependentance tools and testsuites
# Update: 2021-03-14
# Arch: x86-64
# Version: v0.5.0
# Editor：banrieen
# Build In China

FROM opensuse/leap:15.2
# ENV JAVA_HOME=/spark/java/jre1.8.0_181  JRE_HOME=/spark/java/jre1.8.0_181  CLASSPATH=$JAVA_HOME/lib/:$JRE_HOME/lib/
# ENV PATH $PATH:$JAVA_HOME/bin:/usr/local/python37/bin
ENV PYTHON_HOME  /usr/bin/python3

WORKDIR /home/

# 同步测试库和工具
COPY MachineDevil docker-build/jdk-8u281-linux-x64.rpm  /home/MachineDevil/

RUN mkdir /etc/zypp/repos.d/repo_bak && mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/repo_bak/  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/non-oss/     NON-OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/distribution/leap/15.2/repo/oss/         OSS  \
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/non-oss/                UPDATE-NON-OSS    \              
    && zypper ar -fcg https://mirrors.bfsu.edu.cn/opensuse/update/leap/15.2/oss/                    UPDATE-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/non-oss       openSUSE-Aliyun-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/oss           openSUSE-Aliyun-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/non-oss                  openSUSE-Aliyun-UPDATE-NON-OSS  \
    && zypper ar -fcg https://mirrors.aliyun.com/opensuse/update/leap/15.2/oss                      openSUSE-Aliyun-UPDATE-OSS  \
    && zypper -q ref   \  
    && zypper update -y && zypper install -y gcc cmake git sudo python3 bash go rust vim htop iputils curl busybox wget tar gzip unzip curl python3-devel    \
    && go env -w GOPROXY=https://goproxy.cn,direct  \
    && rpm -ivh /home/MachineDevil/jdk-8u281-linux-x64.rpm   \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
    && python3 get-pip.py   \
    && ln -s /usr/bin/python3 /usr/bin/python  \
    && pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple   \
    && pip config set install.trusted-host https://repo.huaweicloud.com  \
    && pip install python-dev-tools  \
    && pip install -U -r /home/MachineDevil/requirements.ini \ 
    && bzt /home/MachineDevil/example/jmeter/trace_user_footprint.jmx  \
    && export SHELL=/bin/bash \
    && rm -rf /tmp/* 

# port
EXPOSE 1099 8088 8089

# ENTRYPOINT 
# ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--port 8088 ", "--allow-root", "--NotebookApp.notebook_dir=MachineDevil"]
# ENTRYPOINT ["jupyter", "lab", "--NotebookApp.token=''",  "--port 8088 ", "--no-browser",  "--ip=0.0.0.0",  "--allow-root",  "--NotebookApp.iopub_msg_rate_limit=1000000.0",  "--NotebookApp.iopub_data_rate_limit=100000000.0",  "--NotebookApp.notebook_dir=MachineDevil"]

# Build  example
# docker build -f MachineDevil/Dockerfile-opebsuse.dockerfile .  -t  MachineDevil-opebsuse:latest
# docker push MachineDevil-opebsuse:latest
# Run example
# docker run -d --name MachineDevil-jupyter -p 8099:8088  MachineDevil-opebsuse:latest
