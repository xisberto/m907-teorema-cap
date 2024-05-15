#!/bin/bash

# Função para aguardar o MongoDB estar pronto para aceitar conexões
function wait_for_mongodb {
    echo "Waiting for MongoDB to start..."
    # Lista de nós MongoDB
    mongodb_nodes=("mongodb_node1" "mongodb_node2" "mongodb_node3")
    
    # Esperar até que todos os nós respondam positivamente
    until check_all_nodes_available "${mongodb_nodes[@]}"; do
        echo "$(date) - MongoDB is unavailable - sleeping"
        sleep 20
    done
    
    echo "MongoDB is up - executing command"
}

# Função para verificar a disponibilidade de todos os nós
function check_all_nodes_available {
    local nodes=("$@")
    local all_available=true
    
    # Iterar sobre todos os nós
    for node in "${nodes[@]}"; do
        # Verificar se o nó está disponível
        if ! mongo --host "$node" --eval "quit()" &> /dev/null; then
            all_available=false
            break
        fi
    done
    
    # Retorna verdadeiro se todos os nós estiverem disponíveis, falso caso contrário
    $all_available
}

# Esperar que o MongoDB esteja pronto em todos os nós
wait_for_mongodb

# Comandos de carga e execução do YCSB
LOAD_COMMAND="/app/ycsb-0.18.0/bin/ycsb.sh load mongodb -s -P workloads/workloada -P db.properties"
RUN_COMMAND="/app/ycsb-0.18.0/bin/ycsb.sh run mongodb -s -P workloads/workloada -P db.properties"

# Timestamp para nomear arquivos de saída
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Executar comando de carga do YCSB
echo "Iniciando carga YCSB em $TIMESTAMP"
$LOAD_COMMAND > /results/load_$HOSTNAME-$TIMESTAMP.dat

# Executar comando de execução do YCSB
echo "Iniciando execução YCSB em $TIMESTAMP"
$RUN_COMMAND > /results/run_$HOSTNAME-$TIMESTAMP.dat

exit
