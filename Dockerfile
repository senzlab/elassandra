FROM ubuntu:16.04

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# explicitly set user/group
RUN groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra

# install required packages
# install wget/curl
# python cassandra driver
RUN apt-get update -y
RUN apt-get install -y python python-pip python-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN pip install cassandra-driver

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install elassandra
ENV ELASSANDRA_VERSION 5.5.0.14
RUN wget https://github.com/strapdata/elassandra/releases/download/v$ELASSANDRA_VERSION/elassandra-$ELASSANDRA_VERSION.tar.gz
RUN tar -xzf elassandra-$ELASSANDRA_VERSION.tar.gz -C /opt
RUN mv /opt/elassandra-$ELASSANDRA_VERSION /opt/elassandra
RUN rm elassandra-$ELASSANDRA_VERSION.tar.gz

# configure cassandra
ADD scripts /usr/local/bin/
RUN /usr/local/bin/configure.sh

# 7000: ipc; 7001: tls ipc; 7199: jmx; 9042: cql; 9160: thrift; 9200|9300: elasticsearch
EXPOSE 7000 7001 7199 9042 9160 9200 9300
ENTRYPOINT ["/usr/local/bin/start.sh"]
