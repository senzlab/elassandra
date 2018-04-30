#!/bin/bash

# configure cassandra
/usr/local/bin/configure.sh

# start cassandra
# -e for start elassandra
# -f for start foreground
exec /opt/elassandra/bin/cassandra -e -f
