#!/bin/bash
echo "start cassandra..."

mkdir -p /var/log/cassandra
chown -R cassandra:cassandra /var/log/cassandra
chmod -R 775 /var/log/cassandra
chown -R cassandra:cassandra /opt/elassandra

/usr/local/bin/etcd-watch.sh > /dev/null 2>&1 &

exec sudo -u cassandra /opt/elassandra/bin/cassandra -e -f
