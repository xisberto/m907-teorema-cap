#!/bin/bash

function wait_for_cassandra {
    echo "Waiting for Cassandra to start..."
    # Lista de nós Cassandra
    cassandra_nodes=("cassandra_node01" "cassandra_node02" "cassandra_node03")
    
    # Esperar até que todos os nós respondam positivamente
    until check_all_nodes_available "${cassandra_nodes[@]}"; do
        echo "$(date) - Cassandra is unavailable - sleeping"
        sleep 20
    done
    
    echo "Cassandra is up - executing command"
    python3 /etc/cassandra/init_cassandra.py
}

# Função para verificar a disponibilidade de todos os nós
function check_all_nodes_available {
    local nodes=("$@")
    local all_available=true
    
    # Iterar sobre todos os nós
    for node in "${nodes[@]}"; do
        # Verificar se o nó está disponível
        if ! cqlsh --cqlshrc=/etc/cassandra/cassandra.credentials -e "describe keyspaces" "$node" 9042 &> /dev/null; then
            all_available=false
            break
        fi
    done
    
    # Retorna verdadeiro se todos os nós estiverem disponíveis, falso caso contrário
    $all_available
}

# Função para iniciar a simulação de falhas de rede
function start_network_failure_simulation {
    echo "Starting network failure simulation..."
    python3 /app/ycsb-0.18.0/network_failures.py
}

# Esperar que o Cassandra esteja pronto em todos os nós
wait_for_cassandra

# Comandos de carga e execução do YCSB
LOAD_COMMAND="/app/ycsb-0.18.0/bin/ycsb.sh load cassandra-cql -P workloads/workloada -s -P db.properties -p hosts=${CASSANDRA_NODES} -p port=${CASSANDRA_PORT} -P replica.properties"
RUN_COMMAND="/app/ycsb-0.18.0/bin/ycsb.sh run cassandra-cql -P workloads/workloada -s -P db.properties -p hosts=${CASSANDRA_NODES} -p port=${CASSANDRA_PORT} -P replica.properties"

# Timestamp para nomear arquivos de saída
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Executar comando de carga do YCSB e iniciar simulação de falhas de rede após 20 segundos
echo "Iniciando carga YCSB em $TIMESTAMP"
$LOAD_COMMAND > /results/load_$HOSTNAME-$TIMESTAMP.txt &
LOAD_PID=$!
sleep 20
start_network_failure_simulation &
wait $LOAD_PID

# Executar comando de execução do YCSB e iniciar simulação de falhas de rede após 20 segundos
echo "Iniciando execução YCSB em $TIMESTAMP"
$RUN_COMMAND > /results/run_$HOSTNAME-$TIMESTAMP.txt &
RUN_PID=$!
sleep 20
start_network_failure_simulation &
wait $RUN_PID

# Convertendo a saída para JSON
# python3 /app/ycsb-0.18.0/convert_to_json.py /results/load_$HOSTNAME-$TIMESTAMP.txt /results/load_$HOSTNAME-$TIMESTAMP.json
# python3 /app/ycsb-0.18.0/convert_to_json.py /results/run_$HOSTNAME-$TIMESTAMP.txt /results/run_$HOSTNAME-$TIMESTAMP.json

exit
