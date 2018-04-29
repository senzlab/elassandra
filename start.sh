#!/bin/bash
echo "Start cassandra..."

/opt/elassandra/bin/cassandra

sleep 60

echo "Create schemas..."

# create schema
IP=`hostname --ip-address`
PORT=9042
/opt/elassandra/bin/cqlsh "$IP" "$PORT" -f /opt/elassandra/schema.cql

echo "Done create schemas, stop cassandra..."

sleep 5

# create elastic index

# kill cassandra
pkill -f cassandra

sleep 5

echo "Start elassandra..."

/opt/elassandra/bin/cassandra -e -f
