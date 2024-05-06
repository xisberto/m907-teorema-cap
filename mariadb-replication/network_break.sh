#!/bin/bash

echo "Iniciando quebra de rede do docker"

basename=$(basename $PWD)
network="${basename}_mariadb-network"


disconnect_target() {
  hostnum=$1
  target="${basename}-host0$hostnum-1"

  # delay aleatório entre 1 e 5
  delay=$((RANDOM % 5 + 1))
  echo "Em $delay minutos $target será desconectado da rede $network"

  sleep $((delay * 60))

  echo "Desconectando $target"
  docker network disconnect "$network" $target

}


connect_target() {
  hostnum=$1
  target="${basename}-host0$hostnum-1"

  # delay aleatório entre 5 e 10
  delay=$((RANDOM % 5 + 5))
  echo "Em $delay minutos $target será reconectado"

  sleep $((delay * 60))

  echo "Conectando $target"
  docker network connect --alias host0$hostnum $newtork $target 

}


disconnect_target 1
connect_target 1

hostnum=$((RANDOM % 3 + 1))
disconnect_target $hostnum
connect_target $hostnum
