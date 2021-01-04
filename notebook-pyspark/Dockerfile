FROM ubuntu:18.04

ARG WORKDIR=/jupyter
ARG openjdk_version="11"
ARG spark_version="3.0.1"
ARG hadoop_version="2.7"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

USER root
WORKDIR /tmp
RUN apt update 
RUN apt-get install --no-install-recommends -y \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN apt update  && \
    apt install -y python3.7 && \
    apt install -y python3-distutils && \
    cp /usr/bin/python3.7 /usr/bin/python3

# Spark installation
WORKDIR /tmp
# Using the preferred mirror to download Spark
# hadolint ignore=SC2046
RUN apt install -y wget && \
    wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python3 -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark && \
    # Add a link in the before_notebook hook in order to source automatically PYTHONPATH
    mkdir -p /usr/local/bin/before-notebook.d && \
    ln -s "${SPARK_HOME}/sbin/spark-config.sh" /usr/local/bin/before-notebook.d/spark-config.sh

COPY ./requirements.txt /tmp/requirements.txt

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip install -r /tmp/requirements.txt

RUN mkdir ${WORKDIR} 
COPY ./big_data.ipynb ${WORKDIR}/big_data.ipynb

WORKDIR ${WORKDIR}

CMD jupyter notebook --no-browser --ip=127.0.0.1 --allow-root