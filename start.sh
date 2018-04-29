#!/bin/bash
echo "start cassandra..."

/opt/elassandra/bin/cassandra

sleep 60

echo "create schemas..."

# create schema
IP=`hostname --ip-address`
PORT=9042
/opt/elassandra/bin/cqlsh "$IP" "$PORT" -f /opt/elassandra/schema.cql

echo "done create schema..."

sleep 5

# create elastic index

echo "stop cassandra..."

# kill cassandra
pkill -f cassandra

sleep 5

echo "start etcd watcher..."
echo "start elassandra..."

mkdir -p /var/log/cassandra
chown -R cassandra:cassandra /var/log/cassandra
chmod -R 775 /var/log/cassandra

etcd-watch.sh > /dev/null 2>&1 &

exec /opt/elassandra/bin/cassandra -e -f
