# dockrize elassandra

## build

```
docker build erangaeb/elassandra:1.0 .
```

## run

```
docker run \
 -e CASSANDRA_BROADCAST_ADDRESS=10.4.1.26 \
 -p 9042:9042 \
 -p 9200:9200\
 erangaeb/elassandra:1.0
```
