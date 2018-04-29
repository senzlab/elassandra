FROM dockerregistry.pagero.local/ubuntu-java8:1.23.1-GO

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# explicitly set user/group
RUN groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra

# install required packages
# install wget/curl
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y wget

# install elassandra
ENV ELASSANDRA_VERSION 5.5.0.13
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
