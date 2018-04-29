#!/bin/bash
CASSANDRA_HOME=/opt/elassandra
echo "Starting elassandra..."

/opt/elassandra/bin/cassandra -e -f

sleep 60

echo "Create schemas..."

sleep 10

echo "Done create schemas..."
