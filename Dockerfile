FROM ubuntu:16.04

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# explicitly set user/group IDs
RUN groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra

# install required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk8-installer

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install curl
RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y wget

# install elassandra
RUN wget https://github.com/strapdata/elassandra/releases/download/v5.5.0.4/elassandra-5.5.0.4.tar.gz
RUN tar -xzf elassandra-5.5.0.4.tar.gz -C /opt
RUN mv /opt/elassandra-5.5.0.4 /opt/elassandra
RUN rm elassandra-5.5.0.4.tar.gz

WORKDIR /opt/elassandra

# post installation config
ADD configure.sh /opt/elassandra
ADD start.sh /opt/elassandra
RUN chmod +x /opt/elassandra/configure.sh
RUN chmod +x /opt/elassandra/start.sh
RUN /opt/elassandra/configure.sh

# start
RUN chown -R cassandra:cassandra /opt/elassandra
USER cassandra

# 7000: ipc; 7001: tls ipc; 7199: jmx; 9042: cql; 9160: thrift, 9200|9300: elasticsearch
EXPOSE 7000 7001 7199 9042 9160 9200 9300

#CMD ["/opt/elassandra/bin/cassandra", "-e", "-f"]
ENTRYPOINT ["/opt/elassandra/start.sh"]
