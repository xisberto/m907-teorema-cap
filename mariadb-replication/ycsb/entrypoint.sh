#!/bin/sh

# Testa a conexão com o MaxScale
while ! mariadb -hendpoint -p3306 -uappuser -psecret -e 'use appname'
do
  sleep 10
done

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Iniciando YCSB em $HOSTNAME - $TIMESTAMP"

/app/ycsb-0.17.0/bin/ycsb.sh load jdbc -P workloads/workloada -s -P load.properties -P replica.properties > /results/$HOSTNAME-load-$TIMESTAMP.txt

/app/ycsb-0.17.0/bin/ycsb.sh run  jdbc -P workloads/workloada -s -P run.properties > /results/$HOSTNAME-run-$TIMESTAMP.txt

exit
