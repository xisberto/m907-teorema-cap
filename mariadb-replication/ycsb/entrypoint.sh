#!/bin/sh

# Testa a conexão com o MaxScale
while ! mariadb -hendpoint -p3306 -uappuser -psecret -e 'use appname'
do
  sleep 10
done

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Iniciando YCSB em $TIMESTAMP"

/app/ycsb-0.17.0/bin/ycsb.sh load jdbc -P workloads/workloada -s -P db.properties -P replica.properties

/app/ycsb-0.17.0/bin/ycsb.sh run  jdbc -P workloads/workloada -s -P db.properties -P replica.properties > /results/$HOSTNAME-$TIMESTAMP.dat

exit
