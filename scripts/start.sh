#!/bin/bash

# create dirs
mkdir -p /var/log/cassandra
chown -R cassandra:cassandra /var/log/cassandra
chmod -R 775 /var/log/cassandra
chown -R cassandra:cassandra /opt/elassandra

# start cassandra
# -e for start elassandra
# -f for start foreground
exec sudo -u cassandra /opt/elassandra/bin/cassandra -e -f
