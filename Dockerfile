FROM dockerregistry.pagero.local/ubuntu-java8:1.23.1-GO

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# explicitly set user/group IDs
RUN groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra

# install required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common

# install wget
RUN apt-get update && apt-get install -y wget

# install elassandra
ENV ELASSANDRA_VERSION 5.5.0.13
RUN wget https://github.com/strapdata/elassandra/releases/download/v$ELASSANDRA_VERSION/elassandra-$ELASSANDRA_VERSION.tar.gz
RUN tar -xzf elassandra-$ELASSANDRA_VERSION.tar.gz -C /opt
RUN mv /opt/elassandra-$ELASSANDRA_VERSION /opt/elassandra
RUN rm elassandra-$ELASSANDRA_VERSION.tar.gz

# post installation config
ADD configure.sh /opt/elassandra
ADD start.sh /opt/elassandra
ADD etcd-watch.sh /opt/elassandra
ADD schema.cql /opt/elassandra
RUN chmod +x /opt/elassandra/configure.sh
RUN chmod +x /opt/elassandra/start.sh
RUN chmod +x /opt/elassandra/etcd-watch.sh
RUN chmod +x /opt/elassandra/schema.cql
RUN /opt/elassandra/configure.sh

# start
RUN chown -R cassandra:cassandra /opt/elassandra
USER cassandra

# 7000: ipc; 7001: tls ipc; 7199: jmx; 9042: cql; 9160: thrift, 9200|9300: elasticsearch
EXPOSE 7000 7001 7199 9042 9160 9200 9300
ENTRYPOINT ["/opt/elassandra/start.sh"]
